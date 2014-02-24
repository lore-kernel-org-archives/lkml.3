Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaBXBoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:44:08 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34012 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBXBoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:44:04 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH for-next 3/4] epoll: struct epoll support
Date: Sun, 23 Feb 2014 17:42:41 -0800
Message-Id: <1393206162-18151-4-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables the internal eventpoll mechanism to be agnostic to the userspace
structure in use while also providing a way for additional structure
support to be introduced as needed. At the moment, struct epoll is the
only new structure added, for the purpose of the new syscall epoll().

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..c3251d5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -168,8 +168,11 @@ struct epitem {
 	/* wakeup_source used when EPOLLWAKEUP is set */
 	struct wakeup_source __rcu *ws;
 
-	/* The structure that describe the interested events and the source fd */
-	struct epoll_event event;
+	/* Interested events */
+	int events;
+
+	/* The userspace identifier for this entry */
+	long long ident;
 };
 
 /*
@@ -246,9 +249,13 @@ struct ep_pqueue {
 };
 
 /* Used by the ep_send_events() function as callback private data */
-struct ep_send_events_data {
-	int maxevents;
-	struct epoll_event __user *events;
+struct ep_send_data {
+	union {
+		struct epoll_event __user *uevent;
+		struct epoll __user *uentry;
+	};
+	unsigned int max;
+	enum { EPOLL_EVENT, EPOLL_ENTRY } api;
 };
 
 /*
@@ -795,9 +802,9 @@ static int ep_eventpoll_release(struct inode *inode, struct file *file)
 
 static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
 {
-	pt->_key = epi->event.events;
+	pt->_key = epi->events;
 
-	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->events;
 }
 
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
@@ -881,8 +888,8 @@ static int ep_show_fdinfo(struct seq_file *m, struct file *f)
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
 
 		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
-				 epi->ffd.fd, epi->event.events,
-				 (long long)epi->event.data);
+				 epi->ffd.fd, epi->events,
+				 (long long)epi->ident);
 		if (ret)
 			break;
 	}
@@ -1025,7 +1032,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * EPOLLONESHOT bit that disables the descriptor when an event is received,
 	 * until the next EPOLL_CTL_MOD will be issued.
 	 */
-	if (!(epi->event.events & ~EP_PRIVATE_BITS))
+	if (!(epi->events & ~EP_PRIVATE_BITS))
 		goto out_unlock;
 
 	/*
@@ -1034,7 +1041,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * callback. We need to be able to handle both cases here, hence the
 	 * test for "key" != NULL before the event match test.
 	 */
-	if (key && !((unsigned long) key & epi->event.events))
+	if (key && !((unsigned long) key & epi->events))
 		goto out_unlock;
 
 	/*
@@ -1264,7 +1271,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 /*
  * Must be called with "mtx" held.
  */
-static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
+static int ep_insert(struct eventpoll *ep, long long ident, int events,
 		     struct file *tfile, int fd, int full_check)
 {
 	int error, revents, pwake = 0;
@@ -1285,10 +1292,11 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	INIT_LIST_HEAD(&epi->pwqlist);
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
-	epi->event = *event;
+	epi->ident = ident;
+	epi->events = events;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
-	if (epi->event.events & EPOLLWAKEUP) {
+	if (epi->events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
 			goto error_create_wakeup_source;
@@ -1338,7 +1346,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/* If the file is already "ready" we drop it inside the ready list */
-	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
+	if ((revents & events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
 		ep_pm_stay_awake(epi);
 
@@ -1392,7 +1400,8 @@ error_create_wakeup_source:
  * Modify the interest event mask by dropping an event if the new mask
  * has a match in the current file status. Must be called with "mtx" held.
  */
-static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_event *event)
+static int ep_modify(struct eventpoll *ep, struct epitem *epi, long long ident,
+		     int events)
 {
 	int pwake = 0;
 	unsigned int revents;
@@ -1405,9 +1414,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * otherwise we might miss an event that happens between the
 	 * f_op->poll() call and the new event set registering.
 	 */
-	epi->event.events = event->events; /* need barrier below */
-	epi->event.data = event->data; /* protected by mtx */
-	if (epi->event.events & EPOLLWAKEUP) {
+	epi->events = events; /* need barrier below */
+	epi->ident = ident; /* protected by mtx */
+	if (epi->events & EPOLLWAKEUP) {
 		if (!ep_has_wakeup_source(epi))
 			ep_create_wakeup_source(epi);
 	} else if (ep_has_wakeup_source(epi)) {
@@ -1444,7 +1453,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * If the item is "hot" and it is not registered inside the ready
 	 * list, push it inside.
 	 */
-	if (revents & event->events) {
+	if (revents & events) {
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
@@ -1466,14 +1475,12 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	return 0;
 }
 
-static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
-			       void *priv)
+static int ep_send_proc(struct eventpoll *ep, struct list_head *head, void *priv)
 {
-	struct ep_send_events_data *esed = priv;
-	int eventcnt;
+	struct ep_send_data *esd = priv;
+	int i;
 	unsigned int revents;
 	struct epitem *epi;
-	struct epoll_event __user *uevent;
 	struct wakeup_source *ws;
 	poll_table pt;
 
@@ -1484,8 +1491,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	 * Items cannot vanish during the loop because ep_scan_ready_list() is
 	 * holding "mtx" during this call.
 	 */
-	for (eventcnt = 0, uevent = esed->events;
-	     !list_empty(head) && eventcnt < esed->maxevents;) {
+	for (i = 0; !list_empty(head) && i < esd->max; ++i) {
 		epi = list_first_entry(head, struct epitem, rdllink);
 
 		/*
@@ -1508,53 +1514,72 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		revents = ep_item_poll(epi, &pt);
 
+		if (!revents)
+			continue;
+
 		/*
 		 * If the event mask intersect the caller-requested one,
 		 * deliver the event to userspace. Again, ep_scan_ready_list()
 		 * is holding "mtx", so no operations coming from userspace
 		 * can change the item.
 		 */
-		if (revents) {
-			if (__put_user(revents, &uevent->events) ||
-			    __put_user(epi->event.data, &uevent->data)) {
-				list_add(&epi->rdllink, head);
-				ep_pm_stay_awake(epi);
-				return eventcnt ? eventcnt : -EFAULT;
-			}
-			eventcnt++;
-			uevent++;
-			if (epi->event.events & EPOLLONESHOT)
-				epi->event.events &= EP_PRIVATE_BITS;
-			else if (!(epi->event.events & EPOLLET)) {
-				/*
-				 * If this file has been added with Level
-				 * Trigger mode, we need to insert back inside
-				 * the ready list, so that the next call to
-				 * epoll_wait() will check again the events
-				 * availability. At this point, no one can insert
-				 * into ep->rdllist besides us. The epoll_ctl()
-				 * callers are locked out by
-				 * ep_scan_ready_list() holding "mtx" and the
-				 * poll callback will queue them in ep->ovflist.
-				 */
-				list_add_tail(&epi->rdllink, &ep->rdllist);
-				ep_pm_stay_awake(epi);
-			}
+		if (esd->api == EPOLL_ENTRY &&
+			(__put_user(epi->ffd.fd, &esd->uentry[i].ep_fildes) ||
+			 __put_user(revents, &esd->uentry[i].ep_events) ||
+			 __put_user(epi->ident, &esd->uentry[i].ep_ident))) {
+
+			list_add(&epi->rdllink, head);
+			ep_pm_stay_awake(epi);
+			return i ? i : -EFAULT;
+		} else if (esd->api == EPOLL_EVENT &&
+			(__put_user(revents, &esd->uevent[i].events) ||
+			 __put_user(epi->ident, &esd->uevent[i].data))) {
+
+			list_add(&epi->rdllink, head);
+			ep_pm_stay_awake(epi);
+			return i ? i : -EFAULT;
+		} else {
+			return -EINVAL;
+		}
+
+		if (epi->events & EPOLLONESHOT)
+			epi->events &= EP_PRIVATE_BITS;
+		else if (!(epi->events & EPOLLET)) {
+			/*
+			 * If this file has been added with Level
+			 * Trigger mode, we need to insert back inside
+			 * the ready list, so that the next call to
+			 * epoll_wait() will check again the events
+			 * availability. At this point, no one can insert
+			 * into ep->rdllist besides us. The epoll_ctl()
+			 * callers are locked out by
+			 * ep_scan_ready_list() holding "mtx" and the
+			 * poll callback will queue them in ep->ovflist.
+			 */
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+			ep_pm_stay_awake(epi);
 		}
 	}
 
-	return eventcnt;
+	return i;
 }
 
-static int ep_send_events(struct eventpoll *ep,
-			  struct epoll_event __user *events, int maxevents)
+static int ep_send_events(struct eventpoll *ep, void __user *buf, size_t len)
 {
-	struct ep_send_events_data esed;
+	struct ep_send_data esd = { .uevent = buf,
+				    .max = len / sizeof(struct epoll_event),
+				    .api = EPOLL_ENTRY };
 
-	esed.maxevents = maxevents;
-	esed.events = events;
+	return ep_scan_ready_list(ep, ep_send_proc, &esd, 0, false);
+}
+
+static int ep_send_entries(struct eventpoll *ep, void __user *buf, size_t len)
+{
+	struct ep_send_data esd = { .uentry = buf,
+				    .max = len / sizeof(struct epoll),
+				    .api = EPOLL_ENTRY };
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
+	return ep_scan_ready_list(ep, ep_send_proc, &esd, 0, false);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
@@ -1573,20 +1598,23 @@ static inline struct timespec ep_set_mstimeout(long ms)
  *           event buffer.
  *
  * @ep: Pointer to the eventpoll context.
- * @events: Pointer to the userspace buffer where the ready events should be
+ * @buffer: Pointer to the userspace buffer where the ready events should be
  *          stored.
- * @maxevents: Size (in terms of number of events) of the caller event buffer.
+ * @length: Size of the caller event buffer.
  * @timeout: Maximum timeout for the ready events fetch operation, in
  *           milliseconds. If the @timeout is zero, the function will not block,
  *           while if the @timeout is less than zero, the function will block
  *           until at least one event has been retrieved (or an error
- *           occurred).
+ *           occurred). Flags set on the eventpoll itself, e.g., EPOLL_MONOTIME
+ *	     and EPOLL_REALTIME, may affect the exact behavior of timeouts.
+ * @sender: Function to call to send ready events to userspace.
  *
  * Returns: Returns the number of ready events which have been fetched, or an
  *          error code, in case of error.
  */
-static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
-		   int maxevents, long timeout)
+static int ep_poll(struct eventpoll *ep, void __user *buffer, size_t length,
+		   long timeout, int (*sender)(struct eventpoll *,
+					       void __user *, size_t))
 {
 	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
@@ -1658,7 +1686,7 @@ check_events:
 	 * more luck.
 	 */
 	if (!res && eavail &&
-	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
+	    !(res = sender(ep, buffer, length)) && !timed_out)
 		goto fetch_events;
 
 	return res;
@@ -1761,6 +1789,142 @@ static void clear_tfile_check_list(void)
 	INIT_LIST_HEAD(&tfile_check_list);
 }
 
+/**
+ *
+ * ep_control - Create, remove, or modify events to poll for. The eventpoll
+ *	        distinguishes between eventpoll entries by file descriptor,
+ *	        but it will also store a user-defined identifier along
+ *	        with it. To modify an existing event, simply set
+ *	        ->ep_fildes to the target file desciptor and set
+ *	        ->ep_ident and ->ep_events to whatever values you wish
+ *	        to change them to. To remove an event, set ->ep_fildes
+ *	        to the relevant file descriptor and clear ->ep_events.
+ *
+ * @ep: The eventpoll being acted upon.
+ * @fd: File descriptor of eventpoll entry.
+ * @io: Pointer to I/O events this triggering this eventpoll entry. Resulting
+ *      event mask written back (cleared on error).
+ * @id: Userspace identifier of this eventpoll entry (meaningless to kernel).
+ * @op: EPOLL_CTL_* operation (optional, set to zero to ignore).
+ *
+ * Returns: Zero if successful or an error code.
+ */
+static int ep_control(struct eventpoll *ep, int fd, int *io, long long id,
+		      int op)
+{
+	struct file *target = fget(fd);
+	struct eventpoll *tep = NULL;
+	struct epitem *epi;
+	bool full_check = false;
+	int err;
+
+	err = -EBADF;
+	if (!target)
+		goto out;
+
+	/* The target file descriptor must support poll */
+	err = -EINVAL;
+	if (!target->f_op || !target->f_op->poll)
+		goto out_fput;
+
+	/* Check if EPOLLWAKEUP is allowed */
+	if ((*io & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+		*io &= ~EPOLLWAKEUP;
+
+	/* We do not permit adding an epoll file descriptor inside itself. */
+	if (target == ep->file)
+		goto out_fput;
+
+	mutex_lock_nested(&ep->mtx, 0);
+
+	/* Try to lookup the file inside our RB tree */
+	epi = ep_find(ep, target, fd);
+
+	err = -EEXIST;
+	if (epi && op == EPOLL_CTL_ADD)
+		goto out_fput;
+	err = -ENOENT;
+	if (!epi && (op == EPOLL_CTL_MOD || op == EPOLL_CTL_DEL))
+		goto out_fput;
+
+	if (ep_op_has_event(op))
+		*io |= POLLERR | POLLHUP;
+
+	/*
+	 * When we insert an epoll file descriptor, inside another epoll
+	 * file descriptor, there is the chance of creating closed loops,
+	 * which are better handled here, than in more critical paths.
+	 * While we are checking for loops we also determine the list of
+	 * files reachable and hang them on the tfile_check_list, so we
+	 * can check that we haven't created too many possible wakeup
+	 * paths.
+	 *
+	 * We do not need to take the global 'epumutex' to ep_insert()
+	 * when the epoll file descriptor is attaching directly to a
+	 * wakeup source, unless the epoll file descriptor is nested.
+	 * The purpose of taking the 'epmutex' on add is to prevent
+	 * complex toplogies such as loops and deep wakeup paths from
+	 * forming in parallel through multiple ep_insert() operations.
+	 */
+
+	if (*io && !epi) {
+		/* add this eventpoll entry */
+		err = -ENOENT; /* clearly this entry does not exist */
+		if (op && op != EPOLL_CTL_ADD)
+			goto out_fput;
+		if (!list_empty(&ep->file->f_ep_links) ||
+							is_file_epoll(target)) {
+			full_check = true;
+			mutex_unlock(&ep->mtx);
+			mutex_lock(&epmutex);
+			if (is_file_epoll(target) &&
+					ep_loop_check(ep, target) != 0) {
+				clear_tfile_check_list();
+				goto out_fput;
+			} else if (!is_file_epoll(target)) {
+				list_add(&target->f_tfile_llink,
+						&tfile_check_list);
+			}
+			mutex_lock_nested(&ep->mtx, 0);
+			if (is_file_epoll(target)) {
+				tep = target->private_data;
+				mutex_lock_nested(&tep->mtx, 1);
+			}
+		}
+		*io |= POLLERR | POLLHUP;
+		err = ep_insert(ep, id, *io, target, fd, full_check);
+		if (full_check)
+			clear_tfile_check_list();
+	} else if (*io && epi) {
+		/* modify this eventpoll entry */
+		if (op && op != EPOLL_CTL_MOD)
+			goto out_fput;
+		*io |= POLLERR | POLLHUP;
+		err = ep_modify(ep, epi, id, *io);
+	} else if (!(*io) && epi) {
+		/* delete this eventpoll entry */
+		if (is_file_epoll(target)) {
+			tep = target->private_data;
+			mutex_lock_nested(&tep->mtx, 1);
+		}
+		if (is_file_epoll(target))
+			mutex_lock_nested(&tep->mtx, 1);
+		err = ep_remove(ep, epi);
+	}
+
+	mutex_unlock(&ep->mtx);
+	if (tep)
+		mutex_unlock(&tep->mtx);
+out_fput:
+	if (full_check)
+		mutex_unlock(&epmutex);
+	fput(target);
+out:
+	if (err)
+		*io = 0; /* nothing can trigger a nonexistant entry */
+	return err;
+}
+
 /*
  * Open an eventpoll file descriptor.
  */
@@ -1775,6 +1939,8 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 
 	if (flags & ~EPOLL_CLOEXEC)
 		return -EINVAL;
+	flags |= O_RDWR;
+
 	/*
 	 * Create the internal data structure ("struct eventpoll").
 	 */
@@ -1785,13 +1951,12 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = get_unused_fd_flags(O_RDWR | (flags & O_CLOEXEC));
+	fd = get_unused_fd_flags(flags);
 	if (fd < 0) {
 		error = fd;
 		goto out_free_ep;
 	}
-	file = anon_inode_getfile("[eventpoll]", &eventpoll_fops, ep,
-				 O_RDWR | (flags & O_CLOEXEC));
+	file = anon_inode_getfile("[eventpoll]", &eventpoll_fops, ep, flags);
 	if (IS_ERR(file)) {
 		error = PTR_ERR(file);
 		goto out_free_fd;
@@ -1823,137 +2048,23 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
-	int error;
-	int full_check = 0;
-	struct fd f, tf;
-	struct eventpoll *ep;
-	struct epitem *epi;
-	struct epoll_event epds;
-	struct eventpoll *tep = NULL;
-
-	error = -EFAULT;
-	if (ep_op_has_event(op) &&
-	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
-		goto error_return;
-
-	error = -EBADF;
-	f = fdget(epfd);
-	if (!f.file)
-		goto error_return;
-
-	/* Get the "struct file *" for the target file */
-	tf = fdget(fd);
-	if (!tf.file)
-		goto error_fput;
-
-	/* The target file descriptor must support poll */
-	error = -EPERM;
-	if (!tf.file->f_op->poll)
-		goto error_tgt_fput;
-
-	/* Check if EPOLLWAKEUP is allowed */
-	ep_take_care_of_epollwakeup(&epds);
-
-	/*
-	 * We have to check that the file structure underneath the file descriptor
-	 * the user passed to us _is_ an eventpoll file. And also we do not permit
-	 * adding an epoll file descriptor inside itself.
-	 */
-	error = -EINVAL;
-	if (f.file == tf.file || !is_file_epoll(f.file))
-		goto error_tgt_fput;
-
-	/*
-	 * At this point it is safe to assume that the "private_data" contains
-	 * our own data structure.
-	 */
-	ep = f.file->private_data;
-
-	/*
-	 * When we insert an epoll file descriptor, inside another epoll file
-	 * descriptor, there is the change of creating closed loops, which are
-	 * better be handled here, than in more critical paths. While we are
-	 * checking for loops we also determine the list of files reachable
-	 * and hang them on the tfile_check_list, so we can check that we
-	 * haven't created too many possible wakeup paths.
-	 *
-	 * We do not need to take the global 'epumutex' on EPOLL_CTL_ADD when
-	 * the epoll file descriptor is attaching directly to a wakeup source,
-	 * unless the epoll file descriptor is nested. The purpose of taking the
-	 * 'epmutex' on add is to prevent complex toplogies such as loops and
-	 * deep wakeup paths from forming in parallel through multiple
-	 * EPOLL_CTL_ADD operations.
-	 */
-	mutex_lock_nested(&ep->mtx, 0);
-	if (op == EPOLL_CTL_ADD) {
-		if (!list_empty(&f.file->f_ep_links) ||
-						is_file_epoll(tf.file)) {
-			full_check = 1;
-			mutex_unlock(&ep->mtx);
-			mutex_lock(&epmutex);
-			if (is_file_epoll(tf.file)) {
-				error = -ELOOP;
-				if (ep_loop_check(ep, tf.file) != 0) {
-					clear_tfile_check_list();
-					goto error_tgt_fput;
-				}
-			} else
-				list_add(&tf.file->f_tfile_llink,
-							&tfile_check_list);
-			mutex_lock_nested(&ep->mtx, 0);
-			if (is_file_epoll(tf.file)) {
-				tep = tf.file->private_data;
-				mutex_lock_nested(&tep->mtx, 1);
-			}
-		}
-	}
-
-	/*
-	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
-	 * above, we can be sure to be able to use the item looked up by
-	 * ep_find() till we release the mutex.
-	 */
-	epi = ep_find(ep, tf.file, fd);
+	struct file *file = fget(epfd);
+	long long id = 0;
+	int io = 0;
+	int err;
 
-	error = -EINVAL;
-	switch (op) {
-	case EPOLL_CTL_ADD:
-		if (!epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_insert(ep, &epds, tf.file, fd, full_check);
-		} else
-			error = -EEXIST;
-		if (full_check)
-			clear_tfile_check_list();
-		break;
-	case EPOLL_CTL_DEL:
-		if (epi)
-			error = ep_remove(ep, epi);
-		else
-			error = -ENOENT;
-		break;
-	case EPOLL_CTL_MOD:
-		if (epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_modify(ep, epi, &epds);
-		} else
-			error = -ENOENT;
-		break;
-	}
-	if (tep != NULL)
-		mutex_unlock(&tep->mtx);
-	mutex_unlock(&ep->mtx);
-
-error_tgt_fput:
-	if (full_check)
-		mutex_unlock(&epmutex);
+	if (!file || !is_file_epoll(file))
+		return -EBADF;
 
-	fdput(tf);
-error_fput:
-	fdput(f);
-error_return:
+	err = -EFAULT;
+	if (ep_op_has_event(op) && (get_user(io, (int *)&event->events) ||
+				    get_user(id, (long long *)&event->data)))
+		goto out;
 
-	return error;
+	err = ep_control(file->private_data, fd, &io, id, op);
+out:
+	fput(file);
+	return err;
 }
 
 /*
@@ -1995,7 +2106,8 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 	ep = f.file->private_data;
 
 	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	error = ep_poll(ep, events, maxevents * sizeof(struct epoll_event),
+			timeout, ep_send_events);
 
 error_fput:
 	fdput(f);
