Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab3BFTzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:55:12 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:65499 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030262Ab3BFTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:13 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Subject: [PATCH 68/77] inotify: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:40 -0800
Message-Id: <1360179649-22465-69-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Note that the adhoc cyclic id allocation is buggy.  If wraparound
happens, the previous code with idr_get_new_above() may segfault and
the converted code will trigger WARN and return -EINVAL.  Even if it's
fixed to wrap to zero, the code will be prone to unnecessary -ENOSPC
failures after the first wraparound.  We probably need to implement
proper cyclic support in idr.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
---
 fs/notify/inotify/inotify_user.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 228a2c2..8f8099c 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -364,22 +364,20 @@ static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
 {
 	int ret;
 
-	do {
-		if (unlikely(!idr_pre_get(idr, GFP_KERNEL)))
-			return -ENOMEM;
+	idr_preload(GFP_KERNEL);
+	spin_lock(idr_lock);
 
-		spin_lock(idr_lock);
-		ret = idr_get_new_above(idr, i_mark, *last_wd + 1,
-					&i_mark->wd);
+	ret = idr_alloc(idr, i_mark, *last_wd + 1, 0, GFP_NOWAIT);
+	if (ret >= 0) {
 		/* we added the mark to the idr, take a reference */
-		if (!ret) {
-			*last_wd = i_mark->wd;
-			fsnotify_get_mark(&i_mark->fsn_mark);
-		}
-		spin_unlock(idr_lock);
-	} while (ret == -EAGAIN);
+		i_mark->wd = ret;
+		*last_wd = i_mark->wd;
+		fsnotify_get_mark(&i_mark->fsn_mark);
+	}
 
-	return ret;
+	spin_unlock(idr_lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group *group,
-- 
1.8.1

