Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaEPMvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:51:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49590 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Mason" <clm@fb.com>,
        "Wang Shilong" <wangsl.fnst@cn.fujitsu.com>,
        "Miao Xie" <miaox@cn.fujitsu.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.403076712@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 23/34] Btrfs: fix inode caching vs tree log
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/inode-map.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -207,24 +207,14 @@ again:
 
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
@@ -236,11 +226,7 @@ again:
 
 		start_caching(root);
 
-		if (objectid <= root->cache_progress ||
-		    objectid >= root->highest_objectid)
-			__btrfs_add_free_space(ctl, objectid, 1);
-		else
-			__btrfs_add_free_space(pinned, objectid, 1);
+		__btrfs_add_free_space(pinned, objectid, 1);
 
 		mutex_unlock(&root->fs_commit_mutex);
 	}

