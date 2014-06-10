Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaFJUan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:30:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaFJTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miao Xie <miaox@cn.fujitsu.com>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/160] Btrfs: fix inode caching vs tree log
Date: Tue, 10 Jun 2014 12:45:28 -0700
Message-Id: <1402429600-20477-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Xie <miaox@cn.fujitsu.com>

commit 1c70d8fb4dfa95bee491816b2a6767b5ca1080e7 upstream.

Currently, with inode cache enabled, we will reuse its inode id immediately
after unlinking file, we may hit something like following:

|->iput inode
|->return inode id into inode cache
|->create dir,fsync
|->power off

An easy way to reproduce this problem is:

mkfs.btrfs -f /dev/sdb
mount /dev/sdb /mnt -o inode_cache,commit=100
dd if=/dev/zero of=/mnt/data bs=1M count=10 oflag=sync
inode_id=`ls -i /mnt/data | awk '{print $1}'`
rm -f /mnt/data

i=1
while [ 1 ]
do
        mkdir /mnt/dir_$i
        test1=`stat /mnt/dir_$i | grep Inode: | awk '{print $4}'`
        if [ $test1 -eq $inode_id ]
        then
		dd if=/dev/zero of=/mnt/dir_$i/data bs=1M count=1 oflag=sync
		echo b > /proc/sysrq-trigger
	fi
	sleep 1
        i=$(($i+1))
done

mount /dev/sdb /mnt
umount /dev/sdb
btrfs check /dev/sdb

We fix this problem by adding unlinked inode's id into pinned tree,
and we can not reuse them until committing transaction.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
[ kamal: backport to 3.13: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/inode-map.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ab485e5..bac4511 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -205,24 +205,14 @@ again:
 
 void btrfs_return_ino(struct btrfs_root *root, u64 objectid)
 {
-	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	struct btrfs_free_space_ctl *pinned = root->free_ino_pinned;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
 		return;
-
 again:
 	if (root->cached == BTRFS_CACHE_FINISHED) {
-		__btrfs_add_free_space(ctl, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 	} else {
-		/*
-		 * If we are in the process of caching free ino chunks,
-		 * to avoid adding the same inode number to the free_ino
-		 * tree twice due to cross transaction, we'll leave it
-		 * in the pinned tree until a transaction is committed
-		 * or the caching work is done.
-		 */
-
 		mutex_lock(&root->fs_commit_mutex);
 		spin_lock(&root->cache_lock);
 		if (root->cached == BTRFS_CACHE_FINISHED) {
@@ -234,11 +224,7 @@ again:
 
 		start_caching(root);
 
-		if (objectid <= root->cache_progress ||
-		    objectid >= root->highest_objectid)
-			__btrfs_add_free_space(ctl, objectid, 1);
-		else
-			__btrfs_add_free_space(pinned, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 
 		mutex_unlock(&root->fs_commit_mutex);
 	}
-- 
1.9.1

