Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaG2NZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:25:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaG2NZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:25:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fsnotify: don't put user context if it was never assigned
Date: Tue, 29 Jul 2014 09:25:14 -0400
Message-Id: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some failure paths we may attempt to free user context even
if it wasn't assigned yet. This will cause a NULL ptr deref
and a kernel BUG.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 43ab1e1..9c8187e 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -165,8 +165,10 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
 	/* ideally the idr is empty and we won't hit the BUG in the callback */
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_destroy(&group->inotify_data.idr);
-	atomic_dec(&group->inotify_data.user->inotify_devs);
-	free_uid(group->inotify_data.user);
+	if (group->inotify_data.user) {
+		atomic_dec(&group->inotify_data.user->inotify_devs);
+		free_uid(group->inotify_data.user);
+	}
 }
 
 static void inotify_free_event(struct fsnotify_event *fsn_event)
-- 
1.7.10.4

