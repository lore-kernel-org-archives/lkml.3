Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaALGyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 01:54:49 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38232 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaALGyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 01:54:46 -0500
Date: Sat, 11 Jan 2014 22:54:15 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH mmotm/next] fanotify: fix corruption preventing startup
Message-ID: <alpine.LSU.2.11.1401112245290.4960@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of my machines couldn't boot mmotm with fanotify enabled:
0x40000020 was being or'ed into a group's notification_waitq next
pointer, with sad results.  It comes from an over-simplification in
fanotify_merge(): test_event isn't NULL when the loop finds no merge.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Fixes fsnotify-do-not-share-events-between-notification-groups.patch

 fs/notify/fanotify/fanotify.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- mmotm/fs/notify/fanotify/fanotify.c	2014-01-10 18:25:01.700448941 -0800
+++ linux/fs/notify/fanotify/fanotify.c	2014-01-11 22:15:31.580961010 -0800
@@ -37,16 +37,19 @@ static bool should_merge(struct fsnotify
 static struct fsnotify_event *fanotify_merge(struct list_head *list,
 					     struct fsnotify_event *event)
 {
-	struct fsnotify_event *test_event = NULL;
+	struct fsnotify_event *test_event;
+	bool do_merge = false;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 
 	list_for_each_entry_reverse(test_event, list, list) {
-		if (should_merge(test_event, event))
+		if (should_merge(test_event, event)) {
+			do_merge = true;
 			break;
+		}
 	}
 
-	if (!test_event)
+	if (!do_merge)
 		return NULL;
 
 	test_event->mask |= event->mask;
