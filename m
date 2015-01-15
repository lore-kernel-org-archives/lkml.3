Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbbAOVCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:02:44 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:35376 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbbAOVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:02:41 -0500
To: akpm@linux-foundation.org, famz@redhat.com
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <53b322375a6f6d0cdabb440a0c1c3d2436a2b4fb.1421337657.git.jbaron@akamai.com>
In-Reply-To: <cover.1421337657.git.jbaron@akamai.com>
References: <cover.1421337657.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [RFC PATCH 4/5] epoll: Allow topology checks to be parallelized
Date: Thu, 15 Jan 2015 21:02:40 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ep_loop_check() (which checks for loops) and the reverse_path_check()
(which prevents excessively deep wakeup paths), functions currently make
use of a number of global variables, since they are always called under the
global 'epmutex'. In preparation, for removing the 'epmutex', we make use
of per-instance data structures, such that these topology checks can safely
be made in parallel. In addition, we make use of the ep_call_nested_nolock(),
which avoids the nested_calls->lock. This is safe here, since we are already
holding the 'epmutex' across all of these calls.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 148 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 76 insertions(+), 72 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d0a021a..8fb23f4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -251,6 +251,14 @@ struct ep_send_events_data {
 	struct epoll_event __user *events;
 };
 
+struct loop_check_arg {
+	struct file *file;
+	struct nested_calls *loop_check_ncalls;
+	struct list_head *visited_list;
+	struct list_head *loop_check_list;
+	u16 *path_count_arr;
+};
+
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
@@ -262,24 +270,12 @@ static long max_user_watches __read_mostly;
  */
 static DEFINE_MUTEX(epmutex);
 
-/* Used to check for epoll file descriptor inclusion loops */
-static struct nested_calls poll_loop_ncalls;
-
 /* Slab cache used to allocate "struct epitem" */
 static struct kmem_cache *epi_cache __read_mostly;
 
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
-/* Visited nodes during ep_loop_check(), so we can unset them when we finish */
-static LIST_HEAD(visited_list);
-
-/*
- * List of files with newly added links, where we may need to limit the number
- * of emanating paths. Protected by the epmutex.
- */
-static LIST_HEAD(tfile_check_list);
-
 #ifdef CONFIG_SYSCTL
 
 #include <linux/sysctl.h>
@@ -353,13 +349,6 @@ static inline int ep_op_has_event(int op)
 	return op != EPOLL_CTL_DEL;
 }
 
-/* Initialize the poll safe wake up structure */
-static void ep_nested_calls_init(struct nested_calls *ncalls)
-{
-	INIT_LIST_HEAD(&ncalls->tasks_call_list);
-	spin_lock_init(&ncalls->lock);
-}
-
 /**
  * ep_events_available - Checks if ready events might be available.
  *
@@ -477,6 +466,13 @@ out_unlock:
 
 static struct nested_calls poll_safewake_ncalls;
 
+/* Initialize the poll safe wake up structure */
+static void ep_nested_calls_init(struct nested_calls *ncalls)
+{
+	INIT_LIST_HEAD(&ncalls->tasks_call_list);
+	spin_lock_init(&ncalls->lock);
+}
+
 static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
 {
 	unsigned long flags;
@@ -1111,9 +1107,6 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
 	rb_insert_color(&epi->rbn, &ep->rbr);
 }
 
-
-
-#define PATH_ARR_SIZE 5
 /*
  * These are the number paths of length 1 to 5, that we are allowing to emanate
  * from a single file of interest. For example, we allow 1000 paths of length
@@ -1125,32 +1118,26 @@ static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
  * path limits are enforced during an EPOLL_CTL_ADD operation, since a modify
  * and delete can't add additional paths. Protected by the epmutex.
  */
-static const int path_limits[PATH_ARR_SIZE] = { 1000, 500, 100, 50, 10 };
-static int path_count[PATH_ARR_SIZE];
+static const u16 path_limits[EP_MAX_NESTS] = { 500, 100, 50, 10 };
 
-static int path_count_inc(int nests)
+static int path_count_inc(int nests, u16 *path_count_arr)
 {
+	BUG_ON(nests < 0 || nests >= EP_MAX_NESTS);
+
 	/* Allow an arbitrary number of depth 1 paths */
 	if (nests == 0)
 		return 0;
 
-	if (++path_count[nests] > path_limits[nests])
+	if (++path_count_arr[nests - 1] > path_limits[nests - 1])
 		return -1;
 	return 0;
 }
 
-static void path_count_init(void)
-{
-	int i;
-
-	for (i = 0; i < PATH_ARR_SIZE; i++)
-		path_count[i] = 0;
-}
-
 static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
 {
 	int error = 0;
-	struct file *file = priv;
+	struct loop_check_arg *args = priv;
+	struct file *file = args->file;
 	struct file *child_file;
 	struct epitem *epi;
 
@@ -1160,15 +1147,18 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
 		child_file = epi->ep->file;
 		if (is_file_epoll(child_file)) {
 			if (list_empty(&child_file->f_ep_links)) {
-				if (path_count_inc(call_nests)) {
+				if (path_count_inc(call_nests,
+							args->path_count_arr)) {
 					error = -1;
 					break;
 				}
 			} else {
-				error = ep_call_nested(&poll_loop_ncalls,
+				args->file = child_file;
+				error = ep_call_nested_nolock(
+							args->loop_check_ncalls,
 							EP_MAX_NESTS,
 							reverse_path_check_proc,
-							child_file, child_file,
+							args, child_file,
 							current);
 			}
 			if (error != 0)
@@ -1192,17 +1182,24 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
  * Returns: Returns zero if the proposed links don't create too many paths,
  *	    -1 otherwise.
  */
-static int reverse_path_check(void)
+static int reverse_path_check(struct list_head *loop_check_list)
 {
 	int error = 0;
 	struct file *current_file;
-
+	struct nested_calls reverse_loop_ncalls;
+	struct loop_check_arg args;
+	u16 path_count[EP_MAX_NESTS];
+
+	args.loop_check_ncalls = &reverse_loop_ncalls;
+	INIT_LIST_HEAD(&reverse_loop_ncalls.tasks_call_list);
+	memset(path_count, 0, sizeof(path_count));
+	args.path_count_arr = path_count;
 	/* let's call this for all tfiles */
-	list_for_each_entry(current_file, &tfile_check_list, f_tfile_llink) {
-		path_count_init();
-		error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
-					reverse_path_check_proc, current_file,
-					current_file, current);
+	list_for_each_entry(current_file, loop_check_list, f_tfile_llink) {
+		args.file = current_file;
+		error = ep_call_nested_nolock(&reverse_loop_ncalls,
+					EP_MAX_NESTS, reverse_path_check_proc,
+					&args, current_file, current);
 		if (error)
 			break;
 	}
@@ -1250,7 +1247,8 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
-		     struct file *tfile, int fd, int full_check)
+		     struct file *tfile, int fd, int full_check,
+		     struct list_head *loop_check_list)
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
@@ -1316,7 +1314,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* now check if we've created too many backpaths */
 	error = -EINVAL;
-	if (full_check && reverse_path_check())
+	if (full_check && reverse_path_check(loop_check_list))
 		goto error_remove_epi;
 
 	/* We have to drop the new item inside our item list to keep track of it */
@@ -1667,7 +1665,8 @@ check_events:
 static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 {
 	int error = 0;
-	struct file *file = priv;
+	struct loop_check_arg *args = priv;
+	struct file *file = args->file;
 	struct eventpoll *ep = file->private_data;
 	struct eventpoll *ep_tovisit;
 	struct rb_node *rbp;
@@ -1675,15 +1674,16 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 
 	mutex_lock_nested(&ep->mtx, call_nests + 1);
 	ep->visited = 1;
-	list_add(&ep->visited_list_link, &visited_list);
+	list_add(&ep->visited_list_link, args->visited_list);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		if (unlikely(is_file_epoll(epi->ffd.file))) {
 			ep_tovisit = epi->ffd.file->private_data;
 			if (ep_tovisit->visited)
 				continue;
-			error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
-					ep_loop_check_proc, epi->ffd.file,
+			args->file = epi->ffd.file;
+			error = ep_call_nested_nolock(args->loop_check_ncalls,
+					EP_MAX_NESTS, ep_loop_check_proc, args,
 					ep_tovisit, current);
 			if (error != 0)
 				break;
@@ -1698,7 +1698,7 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 			 */
 			if (list_empty(&epi->ffd.file->f_tfile_llink))
 				list_add(&epi->ffd.file->f_tfile_llink,
-					 &tfile_check_list);
+					 args->loop_check_list);
 		}
 	}
 	mutex_unlock(&ep->mtx);
@@ -1717,13 +1717,22 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
  * Returns: Returns zero if adding the epoll @file inside current epoll
  *          structure @ep does not violate the constraints, or -1 otherwise.
  */
-static int ep_loop_check(struct eventpoll *ep, struct file *file)
+static int ep_loop_check(struct eventpoll *ep, struct file *file,
+			 struct list_head *loop_check_list)
 {
 	int ret;
 	struct eventpoll *ep_cur, *ep_next;
-
-	ret = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
-			      ep_loop_check_proc, file, ep, current);
+	struct nested_calls loop_check_ncalls;
+	struct loop_check_arg args;
+	LIST_HEAD(visited_list);
+
+	args.file = file;
+	args.visited_list = &visited_list;
+	args.loop_check_list = loop_check_list;
+	args.loop_check_ncalls = &loop_check_ncalls;
+	INIT_LIST_HEAD(&loop_check_ncalls.tasks_call_list);
+	ret = ep_call_nested_nolock(&loop_check_ncalls, EP_MAX_NESTS,
+			     ep_loop_check_proc, &args, ep, current);
 	/* clear visited list */
 	list_for_each_entry_safe(ep_cur, ep_next, &visited_list,
 							visited_list_link) {
@@ -1733,17 +1742,15 @@ static int ep_loop_check(struct eventpoll *ep, struct file *file)
 	return ret;
 }
 
-static void clear_tfile_check_list(void)
+static void clear_tfile_list(struct list_head *loop_check_list)
 {
 	struct file *file;
 
-	/* first clear the tfile_check_list */
-	while (!list_empty(&tfile_check_list)) {
-		file = list_first_entry(&tfile_check_list, struct file,
+	while (!list_empty(loop_check_list)) {
+		file = list_first_entry(loop_check_list, struct file,
 					f_tfile_llink);
 		list_del_init(&file->f_tfile_llink);
 	}
-	INIT_LIST_HEAD(&tfile_check_list);
 }
 
 /*
@@ -1815,6 +1822,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	struct epitem *epi;
 	struct epoll_event epds;
 	struct eventpoll *tep = NULL;
+	LIST_HEAD(loop_check_list);
 
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
@@ -1879,13 +1887,14 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			mutex_lock(&epmutex);
 			if (is_file_epoll(tf.file)) {
 				error = -ELOOP;
-				if (ep_loop_check(ep, tf.file) != 0) {
-					clear_tfile_check_list();
+				if (ep_loop_check(ep, tf.file,
+						  &loop_check_list) != 0) {
+					clear_tfile_list(&loop_check_list);
 					goto error_tgt_fput;
 				}
 			} else
 				list_add(&tf.file->f_tfile_llink,
-							&tfile_check_list);
+							&loop_check_list);
 			mutex_lock_nested(&ep->mtx, 0);
 			if (is_file_epoll(tf.file)) {
 				tep = tf.file->private_data;
@@ -1906,11 +1915,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
-			error = ep_insert(ep, &epds, tf.file, fd, full_check);
+			error = ep_insert(ep, &epds, tf.file, fd, full_check,
+					  &loop_check_list);
 		} else
 			error = -EEXIST;
 		if (full_check)
-			clear_tfile_check_list();
+			clear_tfile_list(&loop_check_list);
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -2090,12 +2100,6 @@ static int __init eventpoll_init(void)
 		EP_ITEM_COST;
 	BUG_ON(max_user_watches < 0);
 
-	/*
-	 * Initialize the structure used to perform epoll file descriptor
-	 * inclusion loops checks.
-	 */
-	ep_nested_calls_init(&poll_loop_ncalls);
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
-- 
1.8.2.rc2

