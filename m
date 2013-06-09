Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3FIMlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 08:41:44 -0400
Received: from mout.gmx.net ([212.227.17.21]:58165 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab3FIMlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 08:41:07 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18ADaASqeIAfdylLVwFB2cOscgO57ckHW8813zHUf
	13Yqd080oHO4ZZ
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 4/5] inotify: fix race when adding a new watch
Date: Sun,  9 Jun 2013 14:40:45 +0200
Message-Id: <1370781646-10496-5-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In inotify_new_watch() the number of watches for a group is compared against
the max number of allowed watches and increased afterwards.
The check and incrementation is not done atomically, so it is possible for
multiple concurrent threads to pass the check and increment the number of marks
above the allowed max.
This patch uses an inotify groups mark_lock to ensure that both check and
incrementation are done atomic.
Furthermore we dont have to worry about the race that allows a concurrent
thread to add a watch just after inotify_update_existing_watch() returned with
-ENOENT anymore, since this is also synchronized by the groups mark mutex now.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/inotify/inotify_user.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index e0f7c12..14d7786 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -644,7 +644,8 @@ static int inotify_new_watch(struct fsnotify_group *group,
 		goto out_err;
 
 	/* we are on the idr, now get on the inode */
-	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, NULL, 0);
+	ret = fsnotify_add_mark_locked(&tmp_i_mark->fsn_mark, group, inode,
+				       NULL, 0);
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
@@ -668,19 +669,13 @@ static int inotify_update_watch(struct fsnotify_group *group, struct inode *inod
 {
 	int ret = 0;
 
-retry:
+	mutex_lock(&group->mark_mutex);
 	/* try to update and existing watch with the new arg */
 	ret = inotify_update_existing_watch(group, inode, arg);
 	/* no mark present, try to add a new one */
 	if (ret == -ENOENT)
 		ret = inotify_new_watch(group, inode, arg);
-	/*
-	 * inotify_new_watch could race with another thread which did an
-	 * inotify_new_watch between the update_existing and the add watch
-	 * here, go back and try to update an existing mark again.
-	 */
-	if (ret == -EEXIST)
-		goto retry;
+	mutex_unlock(&group->mark_mutex);
 
 	return ret;
 }
-- 
1.7.9.5

