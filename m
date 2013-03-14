Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3CNKiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3CNKiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 77/88] Btrfs: fix panic when recovering tree log
Date: Thu, 14 Mar 2013 10:36:10 +0000
Message-Id: <1363257381-15900-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit b0175117b9376a69978bbe80af26fb95dddbd53e upstream.

A user reported a BUG_ON(ret) that occured during tree log replay.  Ret was
-EAGAIN, so what I think happened is that we removed an extent that covered
a bitmap entry and an extent entry.  We remove the part from the bitmap and
return -EAGAIN and then search for the next piece we want to remove, which
happens to be an entire extent entry, so we just free the sucker and return.
The problem is ret is still set to -EAGAIN so we trip the BUG_ON().  The
user used btrfs-zero-log so I'm not 100% sure this is what happened so I've
added a WARN_ON() to catch the other possibility.  Thanks,

Reported-by: Jan Steffens <jan.steffens@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/free-space-cache.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6c4e2ba..c6ae3f4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1876,11 +1876,13 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *info;
-	int ret = 0;
+	int ret;
+	bool re_search = false;
 
 	spin_lock(&ctl->tree_lock);
 
 again:
+	ret = 0;
 	if (!bytes)
 		goto out_lock;
 
@@ -1893,17 +1895,17 @@ again:
 		info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
 					  1, 0);
 		if (!info) {
-			/* the tree logging code might be calling us before we
-			 * have fully loaded the free space rbtree for this
-			 * block group.  So it is possible the entry won't
-			 * be in the rbtree yet at all.  The caching code
-			 * will make sure not to put it in the rbtree if
-			 * the logging code has pinned it.
+			/*
+			 * If we found a partial bit of our free space in a
+			 * bitmap but then couldn't find the other part this may
+			 * be a problem, so WARN about it.
 			 */
+			WARN_ON(re_search);
 			goto out_lock;
 		}
 	}
 
+	re_search = false;
 	if (!info->bitmap) {
 		unlink_free_space(ctl, info);
 		if (offset == info->offset) {
@@ -1949,8 +1951,10 @@ again:
 	}
 
 	ret = remove_from_bitmap(ctl, info, &offset, &bytes);
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN) {
+		re_search = true;
 		goto again;
+	}
 	BUG_ON(ret); /* logic error */
 out_lock:
 	spin_unlock(&ctl->tree_lock);
-- 
1.8.1.2

