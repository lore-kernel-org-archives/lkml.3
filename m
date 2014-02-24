Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaBXJbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:31:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbaBXJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:31:15 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, eparis@parisplace.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] fsnotify: Allocate overflow events with proper type
Date: Mon, 24 Feb 2014 10:31:07 +0100
Message-Id: <1393234267-22937-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393234267-22937-1-git-send-email-jack@suse.cz>
References: <1393234267-22937-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7053aee26a35 "fsnotify: do not share events between notification
groups" used overflow event statically allocated in a group with the
size of the generic notification event. This causes problems because
some code looks at type specific parts of event structure and gets
confused by a random data it sees there and causes crashes.

Fix the problem by allocating overflow event with type corresponding to
the group type so code cannot get confused.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 13 +++++++++++++
 fs/notify/group.c                  |  8 +++++++-
 fs/notify/inotify/inotify_user.c   | 12 ++++++++++++
 fs/notify/notification.c           |  4 ++--
 include/linux/fsnotify_backend.h   |  2 +-
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b6175fa11bf8..287a22c04149 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -698,6 +698,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	struct fsnotify_group *group;
 	int f_flags, fd;
 	struct user_struct *user;
+	struct fanotify_event_info *oevent;
 
 	pr_debug("%s: flags=%d event_f_flags=%d\n",
 		__func__, flags, event_f_flags);
@@ -730,8 +731,20 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	group->fanotify_data.user = user;
 	atomic_inc(&user->fanotify_listeners);
 
+	oevent = kmem_cache_alloc(fanotify_event_cachep, GFP_KERNEL);
+	if (unlikely(!oevent)) {
+		fd = -ENOMEM;
+		goto out_destroy_group;
+	}
+	group->overflow_event = &oevent->fse;
+	fsnotify_init_event(group->overflow_event, NULL, FS_Q_OVERFLOW);
+	oevent->tgid = get_pid(task_tgid(current));
+	oevent->path.mnt = NULL;
+	oevent->path.dentry = NULL;
+
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	oevent->response = 0;
 	mutex_init(&group->fanotify_data.access_mutex);
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
diff --git a/fs/notify/group.c b/fs/notify/group.c
index ee674fe2cec7..ad1995980456 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -55,6 +55,13 @@ void fsnotify_destroy_group(struct fsnotify_group *group)
 	/* clear the notification queue of all events */
 	fsnotify_flush_notify(group);
 
+	/*
+	 * Destroy overflow event (we cannot use fsnotify_destroy_event() as
+	 * that deliberately ignores overflow events.
+	 */
+	if (group->overflow_event)
+		group->ops->free_event(group->overflow_event);
+
 	fsnotify_put_group(group);
 }
 
@@ -99,7 +106,6 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	INIT_LIST_HEAD(&group->marks_list);
 
 	group->ops = ops;
-	fsnotify_init_event(&group->overflow_event, NULL, FS_Q_OVERFLOW);
 
 	return group;
 }
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 497395c8274b..99528618d382 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -633,11 +633,23 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
 static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 {
 	struct fsnotify_group *group;
+	struct inotify_event_info *oevent;
 
 	group = fsnotify_alloc_group(&inotify_fsnotify_ops);
 	if (IS_ERR(group))
 		return group;
 
+	oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
+	if (unlikely(!oevent)) {
+		fsnotify_destroy_group(group);
+		return ERR_PTR(-ENOMEM);
+	}
+	group->overflow_event = &oevent->fse;
+	fsnotify_init_event(group->overflow_event, NULL, FS_Q_OVERFLOW);
+	oevent->wd = -1;
+	oevent->sync_cookie = 0;
+	oevent->name_len = 0;
+
 	group->max_events = max_events;
 
 	spin_lock_init(&group->inotify_data.idr_lock);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 6a4ba17c0395..1e58402171a5 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -98,11 +98,11 @@ int fsnotify_add_notify_event(struct fsnotify_group *group,
 	if (group->q_len >= group->max_events) {
 		ret = 2;
 		/* Queue overflow event only if it isn't already queued */
-		if (!list_empty(&group->overflow_event.list)) {
+		if (!list_empty(&group->overflow_event->list)) {
 			mutex_unlock(&group->notification_mutex);
 			return ret;
 		}
-		event = &group->overflow_event;
+		event = group->overflow_event;
 		goto queue;
 	}
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3d286ff49ab0..99644e18544a 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -160,7 +160,7 @@ struct fsnotify_group {
 
 	struct fasync_struct *fsn_fa;    /* async notification */
 
-	struct fsnotify_event overflow_event;	/* Event we queue when the
+	struct fsnotify_event *overflow_event;	/* Event we queue when the
 						 * notification list is too
 						 * full */
 
-- 
1.8.1.4

