Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaCCLNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:13:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbaCCLMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:12:35 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] fanotify: Convert access_mutex to spinlock
Date: Mon,  3 Mar 2014 12:12:21 +0100
Message-Id: <1393845143-28007-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393845143-28007-1-git-send-email-jack@suse.cz>
References: <1393845143-28007-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

access_mutex is used only to guard operations on access_list. There's no
need for sleeping within this lock so just make a spinlock out of it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify_user.c | 14 +++++++-------
 include/linux/fsnotify_backend.h   |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 517732dedee2..e0379d725cd9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -134,7 +134,7 @@ static struct fanotify_perm_event_info *dequeue_event(
 {
 	struct fanotify_perm_event_info *event, *return_e = NULL;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
+	spin_lock(&group->fanotify_data.access_lock);
 	list_for_each_entry(event, &group->fanotify_data.access_list,
 			    fae.fse.list) {
 		if (event->fd != fd)
@@ -144,7 +144,7 @@ static struct fanotify_perm_event_info *dequeue_event(
 		return_e = event;
 		break;
 	}
-	mutex_unlock(&group->fanotify_data.access_mutex);
+	spin_unlock(&group->fanotify_data.access_lock);
 
 	pr_debug("%s: found return_re=%p\n", __func__, return_e);
 
@@ -210,10 +210,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (event->mask & FAN_ALL_PERM_EVENTS) {
 		FANOTIFY_PE(event)->fd = fd;
-		mutex_lock(&group->fanotify_data.access_mutex);
+		spin_lock(&group->fanotify_data.access_lock);
 		list_add_tail(&event->fae.fse.list,
 			      &group->fanotify_data.access_list);
-		mutex_unlock(&group->fanotify_data.access_mutex);
+		spin_unlock(&group->fanotify_data.access_lock);
 	}
 #endif
 
@@ -343,7 +343,7 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_perm_event_info *event, *next;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
+	spin_lock(&group->fanotify_data.access_lock);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
 
@@ -355,7 +355,7 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 		list_del_init(&event->fae.fse.list);
 		event->response = FAN_ALLOW;
 	}
-	mutex_unlock(&group->fanotify_data.access_mutex);
+	spin_unlock(&group->fanotify_data.access_lock);
 
 	wake_up(&group->fanotify_data.access_waitq);
 #endif
@@ -697,7 +697,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	mutex_init(&group->fanotify_data.access_mutex);
+	spin_lock_init(&group->fanotify_data.access_lock);
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
 	atomic_set(&group->fanotify_data.bypass_perm, 0);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 64cf3ef50696..fc7718c6bd3e 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -178,7 +178,7 @@ struct fsnotify_group {
 		struct fanotify_group_private_data {
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 			/* allows a group to block waiting for a userspace response */
-			struct mutex access_mutex;
+			spinlock_t access_lock;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
 			atomic_t bypass_perm;
-- 
1.8.1.4

