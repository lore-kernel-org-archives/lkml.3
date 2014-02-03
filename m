Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaBCCXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 21:23:52 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47876 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBCCXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 21:23:22 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH 3/3] epoll: add read()/write()/ioctl() operations
Date: Sun,  2 Feb 2014 18:17:12 -0800
Message-Id: <1391393832-8754-4-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eventpoll implementation is largely interface-agnostic, aside from the
userspace structure format and epoll_ctl(). Particularly as each field of the
structure is handled independently, replacing usage of epoll_event internally
was straighforward and clarifies the code some. As for epoll_ctl(), its
functionality was moved into the new ep_eventpoll_write() function, and
epoll_ctl() just hands off its work to it. The ep_eventpoll_read() function is
very similar to epoll_wait(), which remains independent but shares the vast
majority of code for minimal redundancy. Finally, ep_eventpoll_ioctl() is a
simple interface to configure a default timeout for read() operations on the
given eventpoll.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..7f0ce59 100644
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
@@ -216,6 +219,9 @@ struct eventpoll {
 
 	struct file *file;
 
+	/* Default timeout */
+	int timeout;
+
 	/* used to optimize loop detection check */
 	int visited;
 	struct list_head visited_list_link;
@@ -251,6 +257,13 @@ struct ep_send_events_data {
 	struct epoll_event __user *events;
 };
 
+/* ep_scan_ready_list() callback data for ep_send_epes() */
+struct ep_send_epes_data
+{
+	int max;
+	struct epoll __user *epes;
+};
+
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
@@ -795,9 +808,9 @@ static int ep_eventpoll_release(struct inode *inode, struct file *file)
 
 static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
 {
-	pt->_key = epi->event.events;
+	pt->_key = epi->events;
 
-	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->events;
 }
 
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
@@ -881,8 +894,8 @@ static int ep_show_fdinfo(struct seq_file *m, struct file *f)
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
 
 		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
-				 epi->ffd.fd, epi->event.events,
-				 (long long)epi->event.data);
+				 epi->ffd.fd, epi->events,
+				 (long long)epi->ident);
 		if (ret)
 			break;
 	}
@@ -892,6 +905,15 @@ static int ep_show_fdinfo(struct seq_file *m, struct file *f)
 }
 #endif
 
+static ssize_t ep_eventpoll_write(struct file *file, const char __user *buf,
+				  size_t bufsz, loff_t *pos);
+
+static ssize_t ep_eventpoll_read(struct file *file, char __user *buf,
+				 size_t bufsz, loff_t *pos);
+
+static long ep_eventpoll_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg);
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 #ifdef CONFIG_PROC_FS
@@ -899,6 +921,9 @@ static const struct file_operations eventpoll_fops = {
 #endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,
+	.read		= ep_eventpoll_read,
+	.write		= ep_eventpoll_write,
+	.unlocked_ioctl	= ep_eventpoll_ioctl,
 	.llseek		= noop_llseek,
 };
 
@@ -1025,7 +1050,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * EPOLLONESHOT bit that disables the descriptor when an event is received,
 	 * until the next EPOLL_CTL_MOD will be issued.
 	 */
-	if (!(epi->event.events & ~EP_PRIVATE_BITS))
+	if (!(epi->events & ~EP_PRIVATE_BITS))
 		goto out_unlock;
 
 	/*
@@ -1034,7 +1059,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * callback. We need to be able to handle both cases here, hence the
 	 * test for "key" != NULL before the event match test.
 	 */
-	if (key && !((unsigned long) key & epi->event.events))
+	if (key && !((unsigned long) key & epi->events))
 		goto out_unlock;
 
 	/*
@@ -1264,7 +1289,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 /*
  * Must be called with "mtx" held.
  */
-static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
+static int ep_insert(struct eventpoll *ep, long long ident, int events,
 		     struct file *tfile, int fd, int full_check)
 {
 	int error, revents, pwake = 0;
@@ -1285,10 +1310,11 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
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
@@ -1338,7 +1364,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/* If the file is already "ready" we drop it inside the ready list */
-	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
+	if ((revents & events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
 		ep_pm_stay_awake(epi);
 
@@ -1392,7 +1418,7 @@ error_create_wakeup_source:
  * Modify the interest event mask by dropping an event if the new mask
  * has a match in the current file status. Must be called with "mtx" held.
  */
-static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_event *event)
+static int ep_modify(struct eventpoll *ep, struct epitem *epi, long long ident, int events)
 {
 	int pwake = 0;
 	unsigned int revents;
@@ -1405,9 +1431,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
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
@@ -1444,7 +1470,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * If the item is "hot" and it is not registered inside the ready
 	 * list, push it inside.
 	 */
-	if (revents & event->events) {
+	if (revents & events) {
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
@@ -1516,16 +1542,16 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 		 */
 		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
-			    __put_user(epi->event.data, &uevent->data)) {
+			    __put_user(epi->ident, &uevent->data)) {
 				list_add(&epi->rdllink, head);
 				ep_pm_stay_awake(epi);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
 			uevent++;
-			if (epi->event.events & EPOLLONESHOT)
-				epi->event.events &= EP_PRIVATE_BITS;
-			else if (!(epi->event.events & EPOLLET)) {
+			if (epi->events & EPOLLONESHOT)
+				epi->events &= EP_PRIVATE_BITS;
+			else if (!(epi->events & EPOLLET)) {
 				/*
 				 * If this file has been added with Level
 				 * Trigger mode, we need to insert back inside
@@ -1546,17 +1572,103 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	return eventcnt;
 }
 
-static int ep_send_events(struct eventpoll *ep,
-			  struct epoll_event __user *events, int maxevents)
+static int ep_send_events(struct eventpoll *ep, void __user *buf, size_t bufsz)
 {
 	struct ep_send_events_data esed;
 
-	esed.maxevents = maxevents;
-	esed.events = events;
+	esed.maxevents = bufsz / sizeof(struct epoll_event);
+	esed.events = buf;
 
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
 }
 
+/*
+ * Mostly biolerplate code from ep_send_events_proc(), but much cleaner to put
+ * in a separate function.
+ */
+static int ep_send_epes_proc(struct eventpoll *ep, struct list_head *head,
+			     void *priv)
+{
+	struct ep_send_epes_data *esed = priv;
+	unsigned int revents, i;
+	struct epitem *epi;
+	struct wakeup_source *ws;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
+
+	/*
+	 * We can loop without lock because we are passed a task private list.
+	 * Items cannot vanish during the loop because ep_scan_ready_list() is
+	 * holding "mtx" during this call.
+	 */
+	for (i = 0; !list_empty(head) && i < esed->max; ++i) {
+		epi = list_first_entry(head, struct epitem, rdllink);
+
+		/*
+		 * Activate ep->ws before deactivating epi->ws to prevent
+		 * triggering auto-suspend here (in case we reactive epi->ws
+		 * below).
+		 *
+		 * This could be rearranged to delay the deactivation of epi->ws
+		 * instead, but then epi->ws would temporarily be out of sync
+		 * with ep_is_linked().
+		 */
+		ws = ep_wakeup_source(epi);
+		if (ws) {
+			if (ws->active)
+				__pm_stay_awake(ep->ws);
+			__pm_relax(ws);
+		}
+
+		list_del_init(&epi->rdllink);
+
+		revents = ep_item_poll(epi, &pt);
+
+		/*
+		 * If the event mask intersect the caller-requested one,
+		 * deliver the event to userspace. Again, ep_scan_ready_list()
+		 * is holding "mtx", so no operations coming from userspace
+		 * can change the item.
+		 */
+		if (revents) {
+			if (__put_user(revents, &esed->epes[i].ep_events) ||
+			    __put_user(epi->ident, &esed->epes[i].ep_ident) ||
+			    __put_user(epi->ffd.fd, &esed->epes[i].ep_fildes)) {
+				list_add(&epi->rdllink, head);
+				ep_pm_stay_awake(epi);
+				return i ? i : -EFAULT;
+			}
+			if (epi->events & EPOLLONESHOT)
+				epi->events &= EP_PRIVATE_BITS;
+			else if (!(epi->events & EPOLLET)) {
+				/*
+				 * If this file has been added with Level
+				 * Trigger mode, we need to insert back inside
+				 * the ready list, so that the next call to
+				 * epoll_wait() will check again the events
+				 * availability. At this point, no one can insert
+				 * into ep->rdllist besides us. The epoll_ctl()
+				 * callers are locked out by
+				 * ep_scan_ready_list() holding "mtx" and the
+				 * poll callback will queue them in ep->ovflist.
+				 */
+				list_add_tail(&epi->rdllink, &ep->rdllist);
+				ep_pm_stay_awake(epi);
+			}
+		}
+	}
+
+	return i;
+}
+
+static int ep_send_epes(struct eventpoll *ep, void __user *buf, size_t bufsz)
+{
+	struct ep_send_epes_data esed = { .max = bufsz / sizeof(struct epoll),
+					  .epes = buf };
+	return ep_scan_ready_list(ep, ep_send_epes_proc, &esed, 0, false);
+}
+
 static inline struct timespec ep_set_mstimeout(long ms)
 {
 	struct timespec now, ts = {
@@ -1581,12 +1693,14 @@ static inline struct timespec ep_set_mstimeout(long ms)
  *           while if the @timeout is less than zero, the function will block
  *           until at least one event has been retrieved (or an error
  *           occurred).
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
@@ -1658,7 +1772,7 @@ check_events:
 	 * more luck.
 	 */
 	if (!res && eavail &&
-	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
+	    !(res = sender(ep, buffer, length)) && !timed_out)
 		goto fetch_events;
 
 	return res;
@@ -1761,6 +1875,213 @@ static void clear_tfile_check_list(void)
 	INIT_LIST_HEAD(&tfile_check_list);
 }
 
+/**
+ *
+ * ep_eventpoll_write - Create, remove, or modify events to poll for. The epoll
+ *			file distinguishes between events by file descriptor,
+ *			but it will also store a user-defined identifier along
+ *			with it. To modify an existing event, simply set
+ *			->ep_fildes to the target file desciptor and set
+ *			->ep_ident and ->ep_events to whatever values you wish
+ *			to change them to. To remove an event, set ->ep_fildes
+ *			to the relevant file descriptor and clear ->ep_events.
+ *
+ * @file: The epoll file being acted upon.
+ * @buf: Array of 'struct epoll' entries, to be inserted, modified, or removed
+ *	 from the epoll file depending on their contents.
+ * @bufsz: Number of 'struct epoll' entries in buffer times the size of the
+ *	   structure.
+ * @pos: Ignored, epoll files behave like character devices.
+ *
+ * Returns: The number of bytes from the userspace buffer successfully processed,
+ *	    always a multiple of sizeof(struct epoll), or an error code if the
+ *	    buffer is ill-aligned or inaccessible (nothing will have been
+ *	    processed).
+ */
+static ssize_t ep_eventpoll_write(struct file *file, const char __user *buf,
+				  size_t bufsz, loff_t *pos)
+{
+	struct eventpoll *ep = file->private_data, *tep = NULL;
+	struct epitem *epi;
+	struct file *target;
+	const struct epoll __user *epes = (const struct epoll __user *)buf;
+	struct epoll epe;
+	bool full_check = false;
+	size_t num = bufsz / sizeof(struct epoll); /* Ignore any excess */
+	int i;
+
+	if (!access_ok(VERIFY_READ, buf, bufsz))
+		return -EFAULT;
+
+	for (i = 0; i < num; ++i) {
+
+		if (copy_from_user(&epe, &epes[i], sizeof(struct epoll)))
+			goto out;
+
+		target = fget(epe.ep_fildes);
+		if (target < 0)
+			goto out;
+
+		/* The target file descriptor must support poll */
+		if (!target->f_op || !target->f_op->poll)
+			goto out_fput;
+
+		/* Check if EPOLLWAKEUP is allowed */
+		if ((epe.ep_events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+			epe.ep_events &= ~EPOLLWAKEUP;
+
+		/* We do not permit adding an epoll file descriptor inside itself. */
+		if (target == file)
+			goto out_fput;
+
+		mutex_lock_nested(&ep->mtx, 0);
+
+		/* Try to lookup the file inside our RB tree */
+		epi = ep_find(ep, target, epe.ep_fildes);
+
+		/*
+		 * When we insert an epoll file descriptor, inside another epoll
+		 * file descriptor, there is the chance of creating closed loops,
+		 * which are better handled here, than in more critical paths.
+		 * While we are checking for loops we also determine the list of
+		 * files reachable and hang them on the tfile_check_list, so we
+		 * can check that we haven't created too many possible wakeup
+		 * paths.
+		 *
+		 * We do not need to take the global 'epumutex' to ep_insert()
+		 * when the epoll file descriptor is attaching directly to a
+		 * wakeup source, unless the epoll file descriptor is nested.
+		 * The purpose of taking the 'epmutex' on add is to prevent
+		 * complex toplogies such as loops and deep wakeup paths from
+		 * forming in parallel through multiple ep_insert() operations.
+		 */
+
+		if (epe.ep_events && !epi) {
+			/* add this epoll entry */
+			if (!list_empty(&file->f_ep_links) ||
+							is_file_epoll(target)) {
+				full_check = true;
+				mutex_unlock(&ep->mtx);
+				mutex_lock(&epmutex);
+				if (is_file_epoll(target) &&
+						ep_loop_check(ep, target) != 0) {
+					clear_tfile_check_list();
+					goto out_fput;
+				} else if (!is_file_epoll(target)) {
+					list_add(&target->f_tfile_llink,
+							&tfile_check_list);
+				}
+				mutex_lock_nested(&ep->mtx, 0);
+				if (is_file_epoll(target)) {
+					tep = target->private_data;
+					mutex_lock_nested(&tep->mtx, 1);
+				}
+			}
+			epe.ep_events |= POLLERR | POLLHUP;
+			if (ep_insert(ep, epe.ep_ident, epe.ep_events, target,
+				      epe.ep_fildes, full_check))
+				goto out_unlock;
+			if (full_check)
+				clear_tfile_check_list();
+		} else if (epe.ep_events && epi) {
+			/* modify this epoll entry */
+			epe.ep_events |= POLLERR | POLLHUP;
+			if (ep_modify(ep, epi, epe.ep_ident, epe.ep_events))
+				goto out_unlock;
+		} else if (!epe.ep_events && epi) {
+			/* delete this epoll entry */
+			if (is_file_epoll(target)) {
+				tep = target->private_data;
+				mutex_lock_nested(&tep->mtx, 1);
+			}
+			if (is_file_epoll(target))
+				mutex_lock_nested(&tep->mtx, 1);
+			if (ep_remove(ep, epi))
+				goto out_unlock;
+		}
+
+		if (tep)
+			mutex_unlock(&tep->mtx);
+		tep = NULL;
+		mutex_unlock(&ep->mtx);
+		if (full_check)
+			mutex_unlock(&epmutex);
+		fput(target);
+	}
+	goto out;
+
+out_unlock:
+	if (tep)
+		mutex_unlock(&tep->mtx);
+	mutex_unlock(&ep->mtx);
+	if (full_check)
+		mutex_unlock(&epmutex);
+out_fput:
+	fput(target);
+out:
+	return i * sizeof(struct epoll);
+}
+
+/**
+ *
+ * ep_eventpoll_read - Read triggered events from an epoll file, delivered to
+ *		       userspace in 'struct epoll' packets. At most, as many
+ *		       events that wholly fit within the buffer are returned,
+ *		       with less being returned if the read times out.
+ *
+ * @file: The epoll file to retrieve events from.
+ * @buf: Preallocated buffer into which the kernel will store epoll entries.
+ * @bufsz: Size of buffer, which ought to be in multiples of the epoll entry
+ *	   structure. If not, the kernel will store as many structs as will
+ *	   wholly fit within the provided buffer, not exceeding EP_MAX_EVENTS.
+ * @pos: Ignored, epoll behaves like a character device.
+ *
+ * Returns: The number of triggered epoll entries multiplied by the size of the
+ *	    epoll entry structure.
+ */
+ssize_t ep_eventpoll_read(struct file *file, char __user *buf, size_t bufsz,
+			  loff_t *pos)
+{
+	struct eventpoll *ep = file->private_data;
+	int tmp;
+
+	/* The event buffer must be of a reasonable size */
+	if (bufsz / sizeof(struct epoll) == 0 ||
+	    bufsz / sizeof(struct epoll) > EP_MAX_EVENTS)
+		return -EINVAL;
+
+	/* Verify that the area passed by the user is writeable */
+	if (!access_ok(VERIFY_WRITE, buf, bufsz))
+		return -EFAULT;
+
+	/* Time to fish for events ... */
+	tmp = ep_poll(file->private_data, buf, bufsz, ep->timeout,
+		      ep_send_epes);
+	return tmp < 0 ? tmp : (ssize_t)tmp * sizeof(struct epoll);
+}
+
+/*
+ * ep_eventpoll_ioctl - configure an eventpoll's behavior.
+ *
+ * @cmd: An EPIOC_* control command.
+ * @arg: A pointer whose type depends on @cmd (usually int).
+ *
+ * Returns: 0 on success or an errno code.
+ */
+static long ep_eventpoll_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	struct eventpoll *ep = file->private_data;
+	switch (cmd) {
+	case EPIOC_GETTIMEOUT:
+		return put_user(ep->timeout, (int __user *)arg);
+	case EPIOC_SETTIMEOUT:
+		return get_user(ep->timeout, (int __user *)arg);
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * Open an eventpoll file descriptor.
  */
@@ -1775,6 +2096,8 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 
 	if (flags & ~EPOLL_CLOEXEC)
 		return -EINVAL;
+	flags |= O_RDWR;
+
 	/*
 	 * Create the internal data structure ("struct eventpoll").
 	 */
@@ -1785,19 +2108,19 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
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
 	}
 	ep->file = file;
 	fd_install(fd, file);
+	ep->timeout = -1; /* infinite (i.e., no) timeout by default */
 	return fd;
 
 out_free_fd:
@@ -1823,137 +2146,27 @@ SYSCALL_DEFINE1(epoll_create, int, size)
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
+	struct epoll epe = { .ep_fildes = fd };
+	struct file *file = fget(epfd);
+	int err;
 
-	/*
-	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
-	 * above, we can be sure to be able to use the item looked up by
-	 * ep_find() till we release the mutex.
-	 */
-	epi = ep_find(ep, tf.file, fd);
+	err = -EBADF;
+	if (!file || !is_file_epoll(file))
+		goto out;
 
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
-
-	fdput(tf);
-error_fput:
-	fdput(f);
-error_return:
-
-	return error;
+	err = -EFAULT;
+	if (ep_op_has_event(op) &&
+			(get_user(epe.ep_events, (int *)&event->events) ||
+			 get_user(epe.ep_ident, (long long *)&event->data)))
+		goto out;
+
+	err = ep_eventpoll_write(file, (const char *)&epe,
+				 sizeof(struct epoll), NULL);
+	if (!err)
+		err = -EBADF;
+out:
+	fput(file);
+	return err < 0 ? err : 0;
 }
 
 /*
@@ -1995,7 +2208,8 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 	ep = f.file->private_data;
 
 	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	error = ep_poll(ep, events, maxevents * sizeof(struct epoll_event),
+			timeout, ep_send_events);
 
 error_fput:
 	fdput(f);
