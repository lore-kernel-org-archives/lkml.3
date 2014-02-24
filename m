Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaBXJbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:31:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbaBXJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:31:15 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, eparis@parisplace.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] fanotify: Handle overflow in case of permission events
Date: Mon, 24 Feb 2014 10:31:06 +0100
Message-Id: <1393234267-22937-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393234267-22937-1-git-send-email-jack@suse.cz>
References: <1393234267-22937-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the event queue overflows when we are handling permission event, we
will never get response from userspace. So we must avoid waiting for it.
Change fsnotify_add_notify_event() to return whether overflow has
happened so that we can detect it in fanotify_handle_event() and act
accordingly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/fanotify/fanotify.c |  6 ++++--
 fs/notify/notification.c      | 14 ++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 0e792f5e3147..7564a070e6e8 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -192,10 +192,12 @@ static int fanotify_handle_event(struct fsnotify_group *group,
 
 	ret = fsnotify_add_notify_event(group, fsn_event, fanotify_merge);
 	if (ret) {
-		BUG_ON(mask & FAN_ALL_PERM_EVENTS);
+		/* Permission events shouldn't be merged */
+		BUG_ON(ret == 1 && mask & FAN_ALL_PERM_EVENTS);
 		/* Our event wasn't used in the end. Free it. */
 		fsnotify_destroy_event(group, fsn_event);
-		ret = 0;
+
+		return 0;
 	}
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 6bec2f4918f9..6a4ba17c0395 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -80,7 +80,8 @@ void fsnotify_destroy_event(struct fsnotify_group *group,
 /*
  * Add an event to the group notification queue.  The group can later pull this
  * event off the queue to deal with.  The function returns 0 if the event was
- * added to the queue, 1 if the event was merged with some other queued event.
+ * added to the queue, 1 if the event was merged with some other queued event,
+ * 2 if the queue of events has overflown.
  */
 int fsnotify_add_notify_event(struct fsnotify_group *group,
 			      struct fsnotify_event *event,
@@ -95,10 +96,14 @@ int fsnotify_add_notify_event(struct fsnotify_group *group,
 	mutex_lock(&group->notification_mutex);
 
 	if (group->q_len >= group->max_events) {
+		ret = 2;
 		/* Queue overflow event only if it isn't already queued */
-		if (list_empty(&group->overflow_event.list))
-			event = &group->overflow_event;
-		ret = 1;
+		if (!list_empty(&group->overflow_event.list)) {
+			mutex_unlock(&group->notification_mutex);
+			return ret;
+		}
+		event = &group->overflow_event;
+		goto queue;
 	}
 
 	if (!list_empty(list) && merge) {
@@ -109,6 +114,7 @@ int fsnotify_add_notify_event(struct fsnotify_group *group,
 		}
 	}
 
+queue:
 	group->q_len++;
 	list_add_tail(&event->list, list);
 	mutex_unlock(&group->notification_mutex);
-- 
1.8.1.4

