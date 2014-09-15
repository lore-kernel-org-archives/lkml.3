Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbaIOVPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:15:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaIOT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Douglas Leeder <douglas.leeder@sophos.com>,
        Heinrich Schuchard <xypron.glpk@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 025/158] fanotify: fix double free of pending permission events
Date: Mon, 15 Sep 2014 12:24:24 -0700
Message-Id: <20140915192543.637686895@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 5838d4442bd5971687b72221736222637e03140d upstream.

Commit 85816794240b ("fanotify: Fix use after free for permission
events") introduced a double free issue for permission events which are
pending in group's notification queue while group is being destroyed.
These events are freed from fanotify_handle_event() but they are not
removed from groups notification queue and thus they get freed again
from fsnotify_flush_notify().

Fix the problem by removing permission events from notification queue
before freeing them if we skip processing access response.  Also expand
comments in fanotify_release() to explain group shutdown in detail.

Fixes: 85816794240b9659e66e4d9b0df7c6e814e5f603
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Douglas Leeder <douglas.leeder@sophos.com>
Tested-by: Douglas Leeder <douglas.leeder@sophos.com>
Reported-by: Heinrich Schuchard <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify.c      |    9 ++++++++-
 fs/notify/fanotify/fanotify_user.c |   12 ++++++++++++
 fs/notify/notification.c           |   18 +++++++++++++++++-
 include/linux/fsnotify_backend.h   |    2 ++
 4 files changed, 39 insertions(+), 2 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -70,8 +70,15 @@ static int fanotify_get_response(struct
 	wait_event(group->fanotify_data.access_waitq, event->response ||
 				atomic_read(&group->fanotify_data.bypass_perm));
 
-	if (!event->response) /* bypass_perm set */
+	if (!event->response) {	/* bypass_perm set */
+		/*
+		 * Event was canceled because group is being destroyed. Remove
+		 * it from group's event list because we are responsible for
+		 * freeing the permission event.
+		 */
+		fsnotify_remove_event(group, &event->fae.fse);
 		return 0;
+	}
 
 	/* userspace responded, convert to something usable */
 	switch (event->response) {
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -359,6 +359,11 @@ static int fanotify_release(struct inode
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_perm_event_info *event, *next;
 
+	/*
+	 * There may be still new events arriving in the notification queue
+	 * but since userspace cannot use fanotify fd anymore, no event can
+	 * enter or leave access_list by now.
+	 */
 	spin_lock(&group->fanotify_data.access_lock);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
@@ -373,6 +378,13 @@ static int fanotify_release(struct inode
 	}
 	spin_unlock(&group->fanotify_data.access_lock);
 
+	/*
+	 * Since bypass_perm is set, newly queued events will not wait for
+	 * access response. Wake up the already sleeping ones now.
+	 * synchronize_srcu() in fsnotify_destroy_group() will wait for all
+	 * processes sleeping in fanotify_handle_event() waiting for access
+	 * response and thus also for all permission events to be freed.
+	 */
 	wake_up(&group->fanotify_data.access_waitq);
 #endif
 
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -73,7 +73,8 @@ void fsnotify_destroy_event(struct fsnot
 	/* Overflow events are per-group and we don't want to free them */
 	if (!event || event->mask == FS_Q_OVERFLOW)
 		return;
-
+	/* If the event is still queued, we have a problem... */
+	WARN_ON(!list_empty(&event->list));
 	group->ops->free_event(event);
 }
 
@@ -125,6 +126,21 @@ queue:
 }
 
 /*
+ * Remove @event from group's notification queue. It is the responsibility of
+ * the caller to destroy the event.
+ */
+void fsnotify_remove_event(struct fsnotify_group *group,
+			   struct fsnotify_event *event)
+{
+	mutex_lock(&group->notification_mutex);
+	if (!list_empty(&event->list)) {
+		list_del_init(&event->list);
+		group->q_len--;
+	}
+	mutex_unlock(&group->notification_mutex);
+}
+
+/*
  * Remove and return the first event from the notification list.  It is the
  * responsibility of the caller to destroy the obtained event
  */
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -326,6 +326,8 @@ extern int fsnotify_add_notify_event(str
 				     struct fsnotify_event *event,
 				     int (*merge)(struct list_head *,
 						  struct fsnotify_event *));
+/* Remove passed event from groups notification queue */
+extern void fsnotify_remove_event(struct fsnotify_group *group, struct fsnotify_event *event);
 /* true if the group notification queue is empty */
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */


