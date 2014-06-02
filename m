Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFBSFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:05:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:56150 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaFBSFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:05:54 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Cc: Jan Kara <jack@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] inotify: bug 77111 - fix reusage of watch descriptors
Date: Mon,  2 Jun 2014 20:03:42 +0200
Message-Id: <1401732222-7707-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0.rc2
X-Provags-ID: V03:K0:WYKnqQDPwLsqUeXbPfzT8UyX1ZeeWMl2d853+A9QfJhFTaoz27Y
 prZO8m6vCA5jIRCBFDGoVPWBGZo9nhLWubrZ1Kswup14qOwOekrzYRiVlEGAr7o+Cj5M6o5
 jJvjl8AckZFVH124VTtvJoXzz+wEaHxOMs29fHFQC1LNG7RkwMZhUi7RtplYelg5QDlAM3z
 ve5xb+lb09svT5nRP+TWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the patch inotify watch descriptors may be reused by
inotify_add_watch before all events for the previous usage
of the watch descriptor have been read.

With the patch watch descriptors are removed from the idr only
after the IN_IGNORED event has been read.

The sequence of some static routines is rearranged.

The significant change moving the call of
inotify_remove_from_idr form inotify_ignored_and_remove_idr to
to copy_event_to_user and renaming inotify_ignored_and_remove_idr
to inotify_ignored.

cf.
https://bugzilla.kernel.org/show_bug.cgi?id=77111

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/inotify/inotify.h          |   4 +-
 fs/notify/inotify/inotify_fsnotify.c |   2 +-
 fs/notify/inotify/inotify_user.c     | 257 ++++++++++++++++++-----------------
 3 files changed, 135 insertions(+), 128 deletions(-)

diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index ed855ef..596c513 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -20,8 +20,8 @@ static inline struct inotify_event_info *INOTIFY_E(struct fsnotify_event *fse)
 	return container_of(fse, struct inotify_event_info, fse);
 }
 
-extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
-					   struct fsnotify_group *group);
+extern void inotify_ignored(struct fsnotify_mark *fsn_mark,
+			    struct fsnotify_group *group);
 extern int inotify_handle_event(struct fsnotify_group *group,
 				struct inode *inode,
 				struct fsnotify_mark *inode_mark,
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 43ab1e1..68729dd 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -122,7 +122,7 @@ int inotify_handle_event(struct fsnotify_group *group,
 
 static void inotify_freeing_mark(struct fsnotify_mark *fsn_mark, struct fsnotify_group *group)
 {
-	inotify_ignored_and_remove_idr(fsn_mark, group);
+	inotify_ignored(fsn_mark, group);
 }
 
 /*
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 78a2ca3..7a354b0 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -164,115 +164,6 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	return event;
 }
 
-/*
- * Copy an event to user space, returning how much we copied.
- *
- * We already checked that the event size is smaller than the
- * buffer we had in "get_one_event()" above.
- */
-static ssize_t copy_event_to_user(struct fsnotify_group *group,
-				  struct fsnotify_event *fsn_event,
-				  char __user *buf)
-{
-	struct inotify_event inotify_event;
-	struct inotify_event_info *event;
-	size_t event_size = sizeof(struct inotify_event);
-	size_t name_len;
-	size_t pad_name_len;
-
-	pr_debug("%s: group=%p event=%p\n", __func__, group, fsn_event);
-
-	event = INOTIFY_E(fsn_event);
-	name_len = event->name_len;
-	/*
-	 * round up name length so it is a multiple of event_size
-	 * plus an extra byte for the terminating '\0'.
-	 */
-	pad_name_len = round_event_name_len(fsn_event);
-	inotify_event.len = pad_name_len;
-	inotify_event.mask = inotify_mask_to_arg(fsn_event->mask);
-	inotify_event.wd = event->wd;
-	inotify_event.cookie = event->sync_cookie;
-
-	/* send the main event */
-	if (copy_to_user(buf, &inotify_event, event_size))
-		return -EFAULT;
-
-	buf += event_size;
-
-	/*
-	 * fsnotify only stores the pathname, so here we have to send the pathname
-	 * and then pad that pathname out to a multiple of sizeof(inotify_event)
-	 * with zeros.
-	 */
-	if (pad_name_len) {
-		/* copy the path name */
-		if (copy_to_user(buf, event->name, name_len))
-			return -EFAULT;
-		buf += name_len;
-
-		/* fill userspace with 0's */
-		if (clear_user(buf, pad_name_len - name_len))
-			return -EFAULT;
-		event_size += pad_name_len;
-	}
-
-	return event_size;
-}
-
-static ssize_t inotify_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *pos)
-{
-	struct fsnotify_group *group;
-	struct fsnotify_event *kevent;
-	char __user *start;
-	int ret;
-	DEFINE_WAIT(wait);
-
-	start = buf;
-	group = file->private_data;
-
-	while (1) {
-		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
-
-		mutex_lock(&group->notification_mutex);
-		kevent = get_one_event(group, count);
-		mutex_unlock(&group->notification_mutex);
-
-		pr_debug("%s: group=%p kevent=%p\n", __func__, group, kevent);
-
-		if (kevent) {
-			ret = PTR_ERR(kevent);
-			if (IS_ERR(kevent))
-				break;
-			ret = copy_event_to_user(group, kevent, buf);
-			fsnotify_destroy_event(group, kevent);
-			if (ret < 0)
-				break;
-			buf += ret;
-			count -= ret;
-			continue;
-		}
-
-		ret = -EAGAIN;
-		if (file->f_flags & O_NONBLOCK)
-			break;
-		ret = -ERESTARTSYS;
-		if (signal_pending(current))
-			break;
-
-		if (start != buf)
-			break;
-
-		schedule();
-	}
-
-	finish_wait(&group->notification_waitq, &wait);
-	if (start != buf && ret != -EFAULT)
-		ret = buf - start;
-	return ret;
-}
-
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
@@ -315,18 +206,6 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static const struct file_operations inotify_fops = {
-	.show_fdinfo	= inotify_show_fdinfo,
-	.poll		= inotify_poll,
-	.read		= inotify_read,
-	.fasync		= fsnotify_fasync,
-	.release	= inotify_release,
-	.unlocked_ioctl	= inotify_ioctl,
-	.compat_ioctl	= inotify_ioctl,
-	.llseek		= noop_llseek,
-};
-
-
 /*
  * find_inode - resolve a user-given path to a specific inode
  */
@@ -488,8 +367,8 @@ out:
 /*
  * Send IN_IGNORED for this wd, remove this wd from the idr.
  */
-void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
-				    struct fsnotify_group *group)
+void inotify_ignored(struct fsnotify_mark *fsn_mark,
+		     struct fsnotify_group *group)
 {
 	struct inotify_inode_mark *i_mark;
 
@@ -498,8 +377,6 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 			     NULL, FSNOTIFY_EVENT_NONE, NULL, 0);
 
 	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
-	/* remove this mark from the idr */
-	inotify_remove_from_idr(group, i_mark);
 
 	atomic_dec(&group->inotify_data.user->inotify_watches);
 }
@@ -665,6 +542,136 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 	return group;
 }
 
+/*
+ * Copy an event to user space, returning how much we copied.
+ *
+ * We already checked that the event size is smaller than the
+ * buffer we had in "get_one_event()" above.
+ */
+static ssize_t copy_event_to_user(struct fsnotify_group *group,
+				  struct fsnotify_event *fsn_event,
+				  char __user *buf)
+{
+	struct inotify_event inotify_event;
+	struct inotify_event_info *event;
+	struct inotify_inode_mark *found_i_mark = NULL;
+	size_t event_size = sizeof(struct inotify_event);
+	size_t name_len;
+	size_t pad_name_len;
+
+	pr_debug("%s: group=%p event=%p\n", __func__, group, fsn_event);
+
+	event = INOTIFY_E(fsn_event);
+	name_len = event->name_len;
+	/*
+	 * round up name length so it is a multiple of event_size
+	 * plus an extra byte for the terminating '\0'.
+	 */
+	pad_name_len = round_event_name_len(fsn_event);
+	inotify_event.len = pad_name_len;
+	inotify_event.mask = inotify_mask_to_arg(fsn_event->mask);
+	inotify_event.wd = event->wd;
+	inotify_event.cookie = event->sync_cookie;
+
+	/* send the main event */
+	if (copy_to_user(buf, &inotify_event, event_size))
+		return -EFAULT;
+
+	if (inotify_event.mask & IN_IGNORED) {
+		found_i_mark = inotify_idr_find(group, inotify_event.wd);
+		if (found_i_mark) {
+			/* remove this mark from the idr */
+			inotify_remove_from_idr(group, found_i_mark);
+			/* match ref taken by inotify_idr_find */
+			fsnotify_put_mark(&found_i_mark->fsn_mark);
+		}
+	}
+
+	buf += event_size;
+
+	/*
+	 * fsnotify only stores the pathname, so here we have to send the pathname
+	 * and then pad that pathname out to a multiple of sizeof(inotify_event)
+	 * with zeros.
+	 */
+	if (pad_name_len) {
+		/* copy the path name */
+		if (copy_to_user(buf, event->name, name_len))
+			return -EFAULT;
+		buf += name_len;
+
+		/* fill userspace with 0's */
+		if (clear_user(buf, pad_name_len - name_len))
+			return -EFAULT;
+		event_size += pad_name_len;
+	}
+
+	return event_size;
+}
+
+static ssize_t inotify_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *pos)
+{
+	struct fsnotify_group *group;
+	struct fsnotify_event *kevent;
+	char __user *start;
+	int ret;
+	DEFINE_WAIT(wait);
+
+	start = buf;
+	group = file->private_data;
+
+	while (1) {
+		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&group->notification_mutex);
+		kevent = get_one_event(group, count);
+		mutex_unlock(&group->notification_mutex);
+
+		pr_debug("%s: group=%p kevent=%p\n", __func__, group, kevent);
+
+		if (kevent) {
+			ret = PTR_ERR(kevent);
+			if (IS_ERR(kevent))
+				break;
+			ret = copy_event_to_user(group, kevent, buf);
+			fsnotify_destroy_event(group, kevent);
+			if (ret < 0)
+				break;
+			buf += ret;
+			count -= ret;
+			continue;
+		}
+
+		ret = -EAGAIN;
+		if (file->f_flags & O_NONBLOCK)
+			break;
+		ret = -ERESTARTSYS;
+		if (signal_pending(current))
+			break;
+
+		if (start != buf)
+			break;
+
+		schedule();
+	}
+
+	finish_wait(&group->notification_waitq, &wait);
+	if (start != buf && ret != -EFAULT)
+		ret = buf - start;
+	return ret;
+}
+
+static const struct file_operations inotify_fops = {
+	.show_fdinfo	= inotify_show_fdinfo,
+	.poll		= inotify_poll,
+	.read		= inotify_read,
+	.fasync		= fsnotify_fasync,
+	.release	= inotify_release,
+	.unlocked_ioctl	= inotify_ioctl,
+	.compat_ioctl	= inotify_ioctl,
+	.llseek		= noop_llseek,
+};
 
 /* inotify syscalls */
 SYSCALL_DEFINE1(inotify_init1, int, flags)
-- 
2.0.0.rc2

