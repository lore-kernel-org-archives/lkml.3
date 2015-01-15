Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbbAOVCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:02:50 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:15792 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbbAOVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:02:45 -0500
To: akpm@linux-foundation.org, famz@redhat.com
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <f0053e978dfddd6fa9a5c72c69d9353d219fc4b9.1421337657.git.jbaron@akamai.com>
In-Reply-To: <cover.1421337657.git.jbaron@akamai.com>
References: <cover.1421337657.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [RFC PATCH 5/5] epoll: introduce epoll connected components (remove the epmutex)
Date: Thu, 15 Jan 2015 21:02:44 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently use the global'epmutex' in the epoll code to serialize when
files are being closed (and we need to remove them from epoll) and
in certain cases when we are doing epoll_ctl(EPOLL_CTL_ADD). The
requirements for epoll_ctl(EPOLL_CTL_ADD) are that we don't create an
epoll topology with loops or with too many wakeup paths. We need
the global 'epmutex' on the add path to both prevent loops and
excessive wakeup path from forming in parallel, as well as to prevent
the underlying 'struct file' from going away from us while we
are traversing the epoll topologies.

The idea of this patch is to eliminate the global 'epmutex' by keeping
track of connected epoll components and only serialize operations
within the connected component when necessary. Thus, we introduce a
reference counted data structure, 'struct ep_cc', which is pointed
to by each file in an epoll connected component via the file->f_ep_cc
pointer. As part of epoll_create(), we allocate a new 'struct ep_cc'
and point the epoll file at it. Regular files, or non-epoll files,
do not allocate a 'struct ep_cc' when they are created, since if they
are going to be used with epoll they are going to be merged with
at least one epoll file which already has an associated 'struct ep_cc'.

Thus, over time we merge connected components together as they are
added together via epoll_ctl(EPOLL_CTL_ADD). We do not decouple components
during epoll_ctl(EPOLL_CTL_DEL) in part due to the extra complexity
of determining if the graph is truly separated and because we do not
think this will add much extra value in practice. That is, its unlikely
for files to be added and removed from unrelated epoll sets. In any case,
we in theory can do no worse than the current scheme by ending up having
merged all epoll files together (thus, essentially reverting to a single
global lock). However, we do remove files from a connected component when
they are closed, but do not try and separate them into separate connected
components.

I've done a bit of performance evaluation on a dual socket, 10 core, hyper
threading enabled box: Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. For the
simple epfdN->epfdN->pipefdN topology case where each thread has its
own unique files and is doing EPOLL_CTL_ADD and EPOLL_CTL_DEL on the pipefd,
I see an almost 300% improvement. This is obviously a very contrived case,
but shows the motivation for this patch.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c            | 325 ++++++++++++++++++++++++++++++++++++++--------
 include/linux/eventpoll.h |  52 +++++---
 include/linux/fs.h        |   3 +
 3 files changed, 311 insertions(+), 69 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8fb23f4..8db5d96 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -47,7 +47,7 @@
  * LOCKING:
  * There are three level of locking required by epoll :
  *
- * 1) epmutex (mutex)
+ * 1) ep_cc->cc_mtx (mutex)
  * 2) ep->mtx (mutex)
  * 3) ep->lock (spinlock)
  *
@@ -60,17 +60,22 @@
  * user space) we could end up sleeping due a copy_to_user(), so
  * we need a lock that will allow us to sleep. This lock is a
  * mutex (ep->mtx). It is acquired during the event transfer loop,
- * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
- * Then we also need a global mutex to serialize eventpoll_release_file()
- * and ep_free().
- * This mutex is acquired by ep_free() during the epoll file
- * cleanup path and it is also acquired by eventpoll_release_file()
- * if a file has been pushed inside an epoll set and it is then
- * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
- * It is also acquired when inserting an epoll fd onto another epoll
+ * during epoll_ctl(EPOLL_CTL_DEL, EPOLL_CTL_ADD) and during
+ * eventpoll_release_file(). Then we also have a mutex that covers
+ * 'connected components'. That is every file descriptor that is part
+ * of epoll, both 'source' files and epoll files, have a file->f_ep_cc
+ * that points to a connected component, that serializes operations
+ * for those files. This obviates the need for a global mutex since
+ * we know how the epoll graph is connected. The connected component
+ * mutex is required to serialize eventpoll_release_file(), ep_free(),
+ * and is also taken during EPOLL_CTL_ADD to prevent loops and overly
+ * complex wakeup paths. This mutex is acquired by ep_free() during
+ * the epoll file cleanup path and it is also acquired by
+ * eventpoll_release_file() if a file has been pushed inside an epoll
+ * set. It is also acquired when inserting an epoll fd onto another epoll
  * fd. We do this so that we walk the epoll tree and ensure that this
  * insertion does not create a cycle of epoll file descriptors, which
- * could lead to deadlock. We need a global mutex to prevent two
+ * could lead to deadlock. We need a per-component mutex to prevent two
  * simultaneous inserts (A into B and B into A) from racing and
  * constructing a cycle without either insert observing that it is
  * going to.
@@ -83,12 +88,9 @@
  * order to communicate this nesting to lockdep, when walking a tree
  * of epoll file descriptors, we use the current recursion depth as
  * the lockdep subkey.
- * It is possible to drop the "ep->mtx" and to use the global
- * mutex "epmutex" (together with "ep->lock") to have it working,
+ * It is possible to drop the "ep->mtx" and to use the per-component
+ * mutex (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
- * Events that require holding "epmutex" are very rare, while for
- * normal operations the epoll private "ep->mtx" will guarantee
- * a better scalability.
  */
 
 /* Epoll private bits inside the event mask */
@@ -265,11 +267,6 @@ struct loop_check_arg {
 /* Maximum number of epoll watched descriptors, per user */
 static long max_user_watches __read_mostly;
 
-/*
- * This mutex is used to serialize ep_free() and eventpoll_release_file().
- */
-static DEFINE_MUTEX(epmutex);
-
 /* Slab cache used to allocate "struct epitem" */
 static struct kmem_cache *epi_cache __read_mostly;
 
@@ -299,7 +296,7 @@ struct ctl_table epoll_table[] = {
 
 static const struct file_operations eventpoll_fops;
 
-static inline int is_file_epoll(struct file *f)
+int is_file_epoll(struct file *f)
 {
 	return f->f_op == &eventpoll_fops;
 }
@@ -362,6 +359,175 @@ static inline int ep_events_available(struct eventpoll *ep)
 	return !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
 }
 
+static void cc_rcu_free(struct rcu_head *head)
+{
+	struct ep_cc *cc = container_of(head, struct ep_cc, rcu);
+
+	kfree(cc);
+}
+
+static void put_cc(struct ep_cc *cc)
+{
+	if (atomic_dec_and_test(&cc->refcount))
+		call_rcu(&cc->rcu, cc_rcu_free);
+}
+
+/**
+ * lock_and_get_cc - Obtains a reference and lock on the 'connected components'
+ *                   for the file(s) supplied. When called by CTL_ADD we modify
+ *                   the file->f_ep_cc (the pointer to the connected component)
+ *                   if its file->f_ep_cc is NULL. This applies to 'event
+ *                   sources' not epoll files. In affect, this makes the 'event
+ *                   source' file part of epoll file's connected comoponent that
+ *                   it is being added to. Note that we do not 'undo' this
+ *                   operation, since its assumed to be a rare that the add
+ *                   fails and if the connected component is larger than is
+ *                   strictly necessary its ok.
+ *
+ * @sfile: 'source' file
+ * @tfile: 'target' file, although NULL if called on file put paths
+ * @res: updates the struct ep_cc_lock_res in the callers frame which needs
+ *       to be supplied to unlock_and_put_cc() and merge_cc()
+ */
+static void lock_and_get_cc(struct file *sfile, struct file *tfile,
+			    struct ep_cc_lock_res *res)
+{
+	struct ep_cc *cc_a, *cc_b;
+	bool init;
+
+	memset(res, 0, sizeof(struct ep_cc_lock_res));
+retry:
+	init = false;
+	if (!tfile) {
+		rcu_read_lock();
+		cc_a = rcu_dereference(sfile->f_ep_cc);
+		if (!atomic_inc_not_zero(&cc_a->refcount)) {
+			rcu_read_unlock();
+			cpu_relax();
+			goto retry;
+		}
+		rcu_read_unlock();
+		mutex_lock(&cc_a->cc_mtx);
+		if (cc_a != ACCESS_ONCE(sfile->f_ep_cc)) {
+			mutex_unlock(&cc_a->cc_mtx);
+			put_cc(cc_a);
+			cpu_relax();
+			goto retry;
+		}
+		res->cc_a = cc_a;
+		res->init = init;
+		return;
+	}
+	rcu_read_lock();
+	cc_a = rcu_dereference(sfile->f_ep_cc);
+	if (!atomic_inc_not_zero(&cc_a->refcount)) {
+		rcu_read_unlock();
+		cpu_relax();
+		goto retry;
+	}
+	cc_b = rcu_dereference(tfile->f_ep_cc);
+	if (cc_b == NULL) {
+		cc_b = cc_a;
+		init = true;
+	}
+	if ((cc_a != cc_b) && !atomic_inc_not_zero(&cc_b->refcount)) {
+		rcu_read_unlock();
+		put_cc(cc_a);
+		cpu_relax();
+		goto retry;
+	}
+	rcu_read_unlock();
+	if (cc_a == cc_b) {
+		mutex_lock(&cc_a->cc_mtx);
+		if (init) {
+			if (!(cmpxchg(&tfile->f_ep_cc, NULL, cc_a) == NULL)) {
+				mutex_unlock(&cc_a->cc_mtx);
+				put_cc(cc_a);
+				cpu_relax();
+				goto retry;
+			}
+		}
+	} else {
+		if (cc_a < cc_b) {
+			mutex_lock_nested(&cc_a->cc_mtx, 0);
+			mutex_lock_nested(&cc_b->cc_mtx, 1);
+		} else {
+			mutex_lock_nested(&cc_b->cc_mtx, 0);
+			mutex_lock_nested(&cc_a->cc_mtx, 1);
+		}
+	}
+	if ((cc_a != ACCESS_ONCE(sfile->f_ep_cc)) || ((cc_a != cc_b) &&
+				(cc_b != ACCESS_ONCE(tfile->f_ep_cc)))) {
+		if (init)
+			rcu_assign_pointer(tfile->f_ep_cc, NULL);
+		mutex_unlock(&cc_a->cc_mtx);
+		put_cc(cc_a);
+		if (cc_a != cc_b) {
+			mutex_unlock(&cc_b->cc_mtx);
+			put_cc(cc_b);
+		}
+		cpu_relax();
+		goto retry;
+	}
+	res->cc_a = cc_a;
+	res->cc_b = (cc_a != cc_b) ? cc_b : NULL;
+	res->init = init;
+}
+
+/**
+ * unlock_and_put_cc - undo a previous lock_and_get_cc() operation
+ *
+ * @lock_res: result from previous lock_and_get_cc()
+ */
+static void unlock_and_put_cc(struct ep_cc_lock_res *lock_res)
+{
+	mutex_unlock(&lock_res->cc_a->cc_mtx);
+	put_cc(lock_res->cc_a);
+	if (lock_res->cc_b) {
+		mutex_unlock(&lock_res->cc_b->cc_mtx);
+		put_cc(lock_res->cc_b);
+	}
+}
+
+/**
+ * merge_cc - merge 2 components in the add pth. Must be proceeded by a call
+ *            to lock_and_get_cc()
+ *
+ * @lock_res: result from previous lock_and_get_cc()
+ * @tfile: target file descriptor
+ */
+static void merge_cc(struct ep_cc_lock_res *lock_res, struct file *tfile)
+{
+	struct ep_cc *smaller_cc, *larger_cc;
+	struct file *elem, *tmp;
+	int smaller_length;
+
+	if (lock_res->init) {
+		lock_res->cc_a->length += 1;
+		atomic_inc(&lock_res->cc_a->refcount);
+		list_add(&tfile->f_ep_cc_link, &lock_res->cc_a->cc_list);
+		return;
+	}
+	/*
+	 * If cc_b is NULL then cc_a == cc_b and nothing to update as they are
+	 * already merged
+	 */
+	if (!lock_res->cc_b)
+		return;
+	larger_cc = lock_res->cc_a;
+	smaller_cc = lock_res->cc_b;
+	if (smaller_cc->length > larger_cc->length)
+		swap(smaller_cc, larger_cc);
+	list_for_each_entry_safe(elem, tmp, &smaller_cc->cc_list, f_ep_cc_link)
+		rcu_assign_pointer(elem->f_ep_cc, larger_cc);
+	list_splice_tail(&smaller_cc->cc_list, &larger_cc->cc_list);
+	smaller_length = smaller_cc->length;
+	atomic_add(smaller_length, &larger_cc->refcount);
+	atomic_sub(smaller_length, &smaller_cc->refcount);
+	larger_cc->length += smaller_length;
+	smaller_cc->length -= smaller_length;
+}
+
 #define ep_call_nested(ncalls, max_nests, nproc, priv, cookie, ctx) \
 	_ep_call_nested(ncalls, max_nests, nproc, priv, cookie, ctx, 1)
 
@@ -726,6 +892,7 @@ static void ep_free(struct eventpoll *ep)
 {
 	struct rb_node *rbp;
 	struct epitem *epi;
+	struct ep_cc_lock_res res;
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
@@ -739,7 +906,9 @@ static void ep_free(struct eventpoll *ep)
 	 * anymore. The only hit might come from eventpoll_release_file() but
 	 * holding "epmutex" is sufficient here.
 	 */
-	mutex_lock(&epmutex);
+	/* only NULL if fail during ep_create */
+	if (ep->file)
+		lock_and_get_cc(ep->file, NULL, &res);
 
 	/*
 	 * Walks through the whole tree by unregistering poll callbacks.
@@ -767,7 +936,12 @@ static void ep_free(struct eventpoll *ep)
 	}
 	mutex_unlock(&ep->mtx);
 
-	mutex_unlock(&epmutex);
+	if (ep->file) {
+		list_del_init(&ep->file->f_ep_cc_link);
+		ep->file->f_ep_cc->length--;
+		unlock_and_put_cc(&res);
+		put_cc(ep->file->f_ep_cc);
+	}
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
 	wakeup_source_unregister(ep->ws);
@@ -892,6 +1066,7 @@ void eventpoll_release_file(struct file *file)
 {
 	struct eventpoll *ep;
 	struct epitem *epi, *next;
+	struct ep_cc_lock_res res;
 
 	/*
 	 * We don't want to get "file->f_lock" because it is not
@@ -906,14 +1081,36 @@ void eventpoll_release_file(struct file *file)
 	 *
 	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
-	mutex_lock(&epmutex);
+	lock_and_get_cc(file, NULL, &res);
 	list_for_each_entry_safe(epi, next, &file->f_ep_links, fllink) {
 		ep = epi->ep;
 		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
-	mutex_unlock(&epmutex);
+	if (!is_file_epoll(file)) {
+		list_del_init(&file->f_ep_cc_link);
+		file->f_ep_cc->length--;
+	}
+	unlock_and_put_cc(&res);
+	if (!is_file_epoll(file))
+		put_cc(file->f_ep_cc);
+}
+
+static int cc_alloc(struct ep_cc **ccp)
+{
+	struct ep_cc *cc;
+
+	cc = kzalloc(sizeof(*cc), GFP_KERNEL);
+	if (unlikely(!cc))
+		return -ENOMEM;
+	mutex_init(&cc->cc_mtx);
+	INIT_LIST_HEAD(&cc->cc_list);
+	cc->length = 1;
+	atomic_set(&cc->refcount, 1);
+	*ccp = cc;
+
+	return 0;
 }
 
 static int ep_alloc(struct eventpoll **pep)
@@ -1248,7 +1445,8 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		     struct file *tfile, int fd, int full_check,
-		     struct list_head *loop_check_list)
+		     struct list_head *loop_check_list,
+		     struct ep_cc_lock_res *lock_res)
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
@@ -1290,6 +1488,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
+
 	revents = ep_item_poll(epi, &epq.pt);
 
 	/*
@@ -1760,6 +1959,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
 	int error, fd;
 	struct eventpoll *ep = NULL;
+	struct ep_cc *cc = NULL;
 	struct file *file;
 
 	/* Check the EPOLL_* constant for consistency.  */
@@ -1773,6 +1973,11 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	error = ep_alloc(&ep);
 	if (error < 0)
 		return error;
+
+	error = cc_alloc(&cc);
+	if (error < 0)
+		goto out_free_ep;
+
 	/*
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
@@ -1780,7 +1985,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	fd = get_unused_fd_flags(O_RDWR | (flags & O_CLOEXEC));
 	if (fd < 0) {
 		error = fd;
-		goto out_free_ep;
+		goto out_free_cc;
 	}
 	file = anon_inode_getfile("[eventpoll]", &eventpoll_fops, ep,
 				 O_RDWR | (flags & O_CLOEXEC));
@@ -1789,11 +1994,15 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 		goto out_free_fd;
 	}
 	ep->file = file;
+	ep->file->f_ep_cc = cc;
+	list_add(&ep->file->f_ep_cc_link, &cc->cc_list);
 	fd_install(fd, file);
 	return fd;
 
 out_free_fd:
 	put_unused_fd(fd);
+out_free_cc:
+	kfree(cc);
 out_free_ep:
 	ep_free(ep);
 	return error;
@@ -1822,6 +2031,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	struct epitem *epi;
 	struct epoll_event epds;
 	struct eventpoll *tep = NULL;
+	struct ep_cc_lock_res lock_res;
 	LIST_HEAD(loop_check_list);
 
 	error = -EFAULT;
@@ -1878,30 +2088,38 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * deep wakeup paths from forming in parallel through multiple
 	 * EPOLL_CTL_ADD operations.
 	 */
-	mutex_lock_nested(&ep->mtx, 0);
 	if (op == EPOLL_CTL_ADD) {
-		if (!list_empty(&f.file->f_ep_links) ||
-						is_file_epoll(tf.file)) {
-			full_check = 1;
-			mutex_unlock(&ep->mtx);
-			mutex_lock(&epmutex);
-			if (is_file_epoll(tf.file)) {
-				error = -ELOOP;
-				if (ep_loop_check(ep, tf.file,
-						  &loop_check_list) != 0) {
-					clear_tfile_list(&loop_check_list);
-					goto error_tgt_fput;
-				}
-			} else
-				list_add(&tf.file->f_tfile_llink,
-							&loop_check_list);
-			mutex_lock_nested(&ep->mtx, 0);
-			if (is_file_epoll(tf.file)) {
-				tep = tf.file->private_data;
-				mutex_lock_nested(&tep->mtx, 1);
+		lock_and_get_cc(f.file, tf.file, &lock_res);
+		if (is_file_epoll(tf.file)) {
+			error = -ELOOP;
+			if (ep_loop_check(ep, tf.file, &loop_check_list) != 0) {
+				clear_tfile_list(&loop_check_list);
+				unlock_and_put_cc(&lock_res);
+				goto error_tgt_fput;
 			}
+			full_check = 1;
+		} else if (!list_empty(&f.file->f_ep_links)) {
+			full_check = 1;
+			list_add(&tf.file->f_tfile_llink, &loop_check_list);
 		}
-	}
+		mutex_lock_nested(&ep->mtx, 0);
+		if (is_file_epoll(tf.file)) {
+			tep = tf.file->private_data;
+			mutex_lock_nested(&tep->mtx, 1);
+		}
+		merge_cc(&lock_res, tf.file);
+		if (!full_check) {
+			/*
+			 * hold the component mutex as short as possible.
+			 * Even if we error past this point and don't actually
+			 * add the link, its ok since it just means we'll have
+			 * a larger connected component than is stricly
+			 * necessary and that's not the common path.
+			 */
+			unlock_and_put_cc(&lock_res);
+		}
+	} else
+		mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
@@ -1916,11 +2134,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
 			error = ep_insert(ep, &epds, tf.file, fd, full_check,
-					  &loop_check_list);
+					  &loop_check_list, &lock_res);
 		} else
 			error = -EEXIST;
-		if (full_check)
-			clear_tfile_list(&loop_check_list);
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -1939,11 +2155,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	if (tep != NULL)
 		mutex_unlock(&tep->mtx);
 	mutex_unlock(&ep->mtx);
+	if ((op == EPOLL_CTL_ADD) && full_check) {
+		clear_tfile_list(&loop_check_list);
+		unlock_and_put_cc(&lock_res);
+	}
 
 error_tgt_fput:
-	if (full_check)
-		mutex_unlock(&epmutex);
-
 	fdput(tf);
 error_fput:
 	fdput(f);
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 6daf6d4..73225f7 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -22,16 +22,40 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+struct ep_cc {
+	/* guards the component - replaces the old global 'epmutex' */
+	struct mutex cc_mtx;
+
+	/* list of ep's that are part of this component */
+	struct list_head cc_list;
+
+	/* list length */
+	unsigned int length;
+
+	/* refcount */
+	atomic_t refcount;
+
+	/* rcu call back point */
+	struct rcu_head rcu;
+};
+
+struct ep_cc_lock_res {
+	struct ep_cc *cc_a, *cc_b;
+	bool init;
+};
+
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
 {
 	INIT_LIST_HEAD(&file->f_ep_links);
 	INIT_LIST_HEAD(&file->f_tfile_llink);
+	INIT_LIST_HEAD(&file->f_ep_cc_link);
+	file->f_ep_cc = NULL;
 }
 
-
 /* Used to release the epoll bits inside the "struct file" */
 void eventpoll_release_file(struct file *file);
+int is_file_epoll(struct file *f);
 
 /*
  * This is called from inside fs/file_table.c:__fput() to unlink files
@@ -41,23 +65,21 @@ void eventpoll_release_file(struct file *file);
  */
 static inline void eventpoll_release(struct file *file)
 {
-
 	/*
-	 * Fast check to avoid the get/release of the semaphore. Since
-	 * we're doing this outside the semaphore lock, it might return
-	 * false negatives, but we don't care. It'll help in 99.99% of cases
-	 * to avoid the semaphore lock. False positives simply cannot happen
-	 * because the file in on the way to be removed and nobody ( but
-	 * eventpoll ) has still a reference to this file.
+	 * If a 'regular' file (non-epoll) is part of a connected component
+	 * then we have to make sure to drop its reference count on the
+	 * connected component via eventpoll_release_file(). For epoll files
+	 * we will drop the reference in ep_free, so we only need to call
+	 * eventpoll_release_file() if the epoll file has back links. The
+	 * smp_mb__after_atomic() is to ensure that although we are ordered
+	 * here against the last operation on file (since we're the last
+	 * reference), we want to make sure the reads below don't move up.
+	 * So this is after the atomic_dec() from the fput().
 	 */
-	if (likely(list_empty(&file->f_ep_links)))
+	smp_mb__after_atomic();
+	if (!file->f_ep_cc || (is_file_epoll(file) &&
+				list_empty(&file->f_ep_links)))
 		return;
-
-	/*
-	 * The file is being closed while it is still linked to an epoll
-	 * descriptor. We need to handle this by correctly unlinking it
-	 * from its containers.
-	 */
 	eventpoll_release_file(file);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f90c028..94e292a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -835,6 +835,9 @@ struct file {
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
 	struct list_head	f_ep_links;
 	struct list_head	f_tfile_llink;
+	/* connected component */
+	struct list_head	f_ep_cc_link;
+	struct ep_cc __rcu	*f_ep_cc;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
 } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
-- 
1.8.2.rc2

