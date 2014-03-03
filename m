Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaCCLNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:13:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaCCLMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:12:36 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] fanotify: Move unrelated handling from copy_event_to_user()
Date: Mon,  3 Mar 2014 12:12:23 +0100
Message-Id: <1393845143-28007-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393845143-28007-1-git-send-email-jack@suse.cz>
References: <1393845143-28007-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move code moving event structure to access_list from
copy_event_to_user() to fanotify_read() where it is more logical (so
that we can immediately see in the main loop that we either move the
event to a different list or free it). Also move special error handling
for permission events from copy_event_to_user() to the main loop to have
it in one place with error handling for normal events.  This makes
copy_event_to_user() really only copy the event to user without any side
effects.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 68a06a7b5659..4e565c814309 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -199,7 +199,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 
 	ret = fill_event_metadata(group, &fanotify_event_metadata, event, &f);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	fd = fanotify_event_metadata.fd;
 	ret = -EFAULT;
@@ -208,13 +208,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 		goto out_close_fd;
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
+	if (event->mask & FAN_ALL_PERM_EVENTS)
 		FANOTIFY_PE(event)->fd = fd;
-		spin_lock(&group->fanotify_data.access_lock);
-		list_add_tail(&event->fae.fse.list,
-			      &group->fanotify_data.access_list);
-		spin_unlock(&group->fanotify_data.access_lock);
-	}
 #endif
 
 	if (fd != FAN_NOFD)
@@ -226,13 +221,6 @@ out_close_fd:
 		put_unused_fd(fd);
 		fput(f);
 	}
-out:
-#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		FANOTIFY_PE(event)->response = FAN_DENY;
-		wake_up(&group->fanotify_data.access_waitq);
-	}
-#endif
 	return ret;
 }
 
@@ -297,10 +285,23 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
 		 * Permission events get queued to wait for response.  Other
 		 * events can be destroyed now.
 		 */
-		if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+		if (!(kevent->mask & FAN_ALL_PERM_EVENTS)) {
 			fsnotify_destroy_event(group, kevent);
-		if (ret < 0)
-			break;
+			if (ret < 0)
+				break;
+		} else {
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+			if (ret < 0) {
+				FANOTIFY_PE(kevent)->response = FAN_DENY;
+				wake_up(&group->fanotify_data.access_waitq);
+				break;
+			}
+			spin_lock(&group->fanotify_data.access_lock);
+			list_add_tail(&kevent->list,
+				      &group->fanotify_data.access_list);
+			spin_unlock(&group->fanotify_data.access_lock);
+#endif
+		}
 		buf += ret;
 		count -= ret;
 	}
-- 
1.8.1.4

