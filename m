Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaERIhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 04:37:42 -0400
Received: from mout.gmx.net ([212.227.15.18]:50320 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbaERIhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 04:37:39 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] fanotify: handling of errors when reading events
Date: Sun, 18 May 2014 10:37:16 +0200
Message-Id: <1400402236-18556-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0.rc2
X-Provags-ID: V03:K0:k315+W5f+5a+oLzQgAMwN2Q/Ad8uHAUr1YyypEr+DjmoWFXU3+v
 xAVVVTCFf1mlKf9Z5Vl1swpyaLPuhBRkNEOQF2u7gTiUgaVn6zBxXPkk+Z9DkZaohL6G7Yn
 c6omyJA5tlE1ooy7g/JTNDw5f5fH1uWXZ7vK0f8VGpXgd0jxks8CIctSoE3ozNZ5Ll10/+S
 5LyUkLkTC+uoQcRRRqQhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading from the fanotify file descriptor read() calls
fanotify_read().
fanotify_read will copies events available into the user buffer
until either the fanotify event queue is empty or the user buffer
is full.

If an error occurs for the first event copied, fanotify_read
returns an error code.
If an error code occurs for the second or any further event copied
fanotify_read returns the concatenated length of all events
successfully copied.

In the second case the userland has no chance to determine that an
error has occured. This error has been described in the fanotify.7
manpage.

Jan Kara suggested in
https://lkml.org/lkml/2014/4/24/182
to change the logic to a peek-check-pop sequence.

This logic is implementd with the appended patch:

If an event is successfully copied to user space, it is removed from the queue.
If an error occurs for the first event read, the event is removed form the
queue and and the error code is returned.
If an error occurs for the second or a later event read, the event is left on
the queue and the length of the prior events is returned to the user.
A later call to fanotify_read will see this event as first
event and will provide the error to the user.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 56 +++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9163a6e..da8e235 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -38,7 +38,7 @@ struct kmem_cache *fanotify_perm_event_cachep __read_mostly;
  *
  * Called with the group->notification_mutex held.
  */
-static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
+static struct fsnotify_event *peek_one_event(struct fsnotify_group *group,
 					    size_t count)
 {
 	BUG_ON(!mutex_is_locked(&group->notification_mutex));
@@ -51,9 +51,28 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	if (FAN_EVENT_METADATA_LEN > count)
 		return ERR_PTR(-EINVAL);
 
+	return fsnotify_peek_notify_event(group);
+}
+
+/*
+ * Remove fsnotify notification event from queue.
+ * Returns -EINVAL if queue is empty.
+ *
+ * Called with the group->notification_mutex held.
+ */
+static int pop_one_event(struct fsnotify_group *group)
+{
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+
+	pr_debug("%s: group=%p\n", __func__, group);
+
+	if (fsnotify_notify_queue_is_empty(group))
+		return -EINVAL;
+
 	/* held the notification_mutex the whole time, so this is the
 	 * same event we peeked above */
-	return fsnotify_remove_notify_event(group);
+	fsnotify_remove_notify_event(group);
+	return 0;
 }
 
 static int create_fd(struct fsnotify_group *group,
@@ -257,15 +276,24 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
 
 		mutex_lock(&group->notification_mutex);
-		kevent = get_one_event(group, count);
-		mutex_unlock(&group->notification_mutex);
+		kevent = peek_one_event(group, count);
 
+		/*
+		 * There is not enough space left in the user buffer.
+		 * The event will be left on the queue to be fetched by a later
+		 * call to fanotify_read.
+		 */
 		if (IS_ERR(kevent)) {
+			mutex_unlock(&group->notification_mutex);
 			ret = PTR_ERR(kevent);
 			break;
 		}
 
+		/*
+		 * The queue is empty.
+		 */
 		if (!kevent) {
+			mutex_unlock(&group->notification_mutex);
 			ret = -EAGAIN;
 			if (file->f_flags & O_NONBLOCK)
 				break;
@@ -280,7 +308,27 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 			continue;
 		}
 
+		/*
+		 * An event was successfully peeked from the queue.
+		 * Copy it to user space.
+		 */
 		ret = copy_event_to_user(group, kevent, buf);
+
+		/*
+		 * If an event was successfully copied to user space, it can be
+		 * removed from the queue.
+		 * If an error occured for the first event read, the error code
+		 * can be returned. The event has to be removed from the queue.
+		 * If an error occured for the second or a later event read,
+		 * the event will be left on the queue and the length of the
+		 * prior events will be returned to the user.
+		 * A later call to fanotify_read will see this event as first
+		 * event and will provide the error to the user.
+		 */
+		if (ret >= 0 || start == buf)
+			pop_one_event(group);
+		mutex_unlock(&group->notification_mutex);
+
 		/*
 		 * Permission events get queued to wait for response.  Other
 		 * events can be destroyed now.
-- 
2.0.0.rc0

