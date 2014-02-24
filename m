Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBXJbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:31:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaBXJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:31:15 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, eparis@parisplace.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] fsnotify: Fix detection whether overflow event is queued
Date: Mon, 24 Feb 2014 10:31:05 +0100
Message-Id: <1393234267-22937-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393234267-22937-1-git-send-email-jack@suse.cz>
References: <1393234267-22937-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we didn't initialize event's list head when we removed it from
the event list. Thus a detection whether overflow event is already
queued wasn't working. Fix it by always initializing the list head when
deleting event from a list.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/notification.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 18b3c4427dca..6bec2f4918f9 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -132,7 +132,11 @@ struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group
 
 	event = list_first_entry(&group->notification_list,
 				 struct fsnotify_event, list);
-	list_del(&event->list);
+	/*
+	 * We need to init list head for the case of overflow event so that
+	 * check in fsnotify_add_notify_events() works
+	 */
+	list_del_init(&event->list);
 	group->q_len--;
 
 	return event;
-- 
1.8.1.4

