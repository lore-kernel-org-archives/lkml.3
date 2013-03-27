Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3C0NS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:18:57 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:61842 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3C0NSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:18:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Subject: [PATCH v1 5/6] inotify: convert inotify_add_to_idr to use idr_alloc_cyclic
Date: Wed, 27 Mar 2013 09:18:07 -0400
Message-Id: <1364390288-30968-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
---
 fs/notify/inotify/inotify_user.c | 10 +++-------
 include/linux/fsnotify_backend.h |  1 -
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index e0f7c12..6940434 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -359,7 +359,6 @@ static int inotify_find_inode(const char __user *dirname, struct path *path, uns
 }
 
 static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
-			      int *last_wd,
 			      struct inotify_inode_mark *i_mark)
 {
 	int ret;
@@ -367,11 +366,10 @@ static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
 	idr_preload(GFP_KERNEL);
 	spin_lock(idr_lock);
 
-	ret = idr_alloc(idr, i_mark, *last_wd + 1, 0, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(idr, i_mark, 0, 0, GFP_NOWAIT);
 	if (ret >= 0) {
 		/* we added the mark to the idr, take a reference */
 		i_mark->wd = ret;
-		*last_wd = i_mark->wd;
 		fsnotify_get_mark(&i_mark->fsn_mark);
 	}
 
@@ -638,8 +636,7 @@ static int inotify_new_watch(struct fsnotify_group *group,
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
-	ret = inotify_add_to_idr(idr, idr_lock, &group->inotify_data.last_wd,
-				 tmp_i_mark);
+	ret = inotify_add_to_idr(idr, idr_lock, tmp_i_mark);
 	if (ret)
 		goto out_err;
 
@@ -696,8 +693,7 @@ static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 	group->max_events = max_events;
 
 	spin_lock_init(&group->inotify_data.idr_lock);
-	idr_init(&group->inotify_data.idr);
-	group->inotify_data.last_wd = 0;
+	idr_init_cyclic(&group->inotify_data.idr, 0);
 	group->inotify_data.user = get_current_user();
 
 	if (atomic_inc_return(&group->inotify_data.user->inotify_devs) >
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index d5b0910..4b2ee8d 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -157,7 +157,6 @@ struct fsnotify_group {
 		struct inotify_group_private_data {
 			spinlock_t	idr_lock;
 			struct idr      idr;
-			u32             last_wd;
 			struct user_struct      *user;
 		} inotify_data;
 #endif
-- 
1.7.11.7

