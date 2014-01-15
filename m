Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaAORki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:40:38 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:6143 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500AbaAORke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:40:34 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2014 12:40:34 EST
Date: Wed, 15 Jan 2014 19:35:08 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <tigran@aivazian.fsnet.co.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] bfs: Fix sanity checks for empty files
Message-ID: <20140115173507.GA3300@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mount fails if file system image has empty files because of sanity
check while reading superblock. For empty files disk offset to end of
file (i_eoffset) is cpu_to_le32(-1). Sanity check comparison, which
compares disk offset with file system size isn't valid for this value
and hence is ignored with this patch.

Steps to reproduce:

$  dd if=/dev/zero of=bfs-image count=204800
$  mkfs.bfs bfs-image
$  mkdir bfs-mount-point
$  sudo mount -t bfs -o loop bfs-image bfs-mount-point/
$  cd bfs-mount-point/
$  sudo touch a
$  cd ..
$  sudo umount bfs-mount-point/
$  sudo mount -t bfs -o loop bfs-image bfs-mount-point/
mount: /dev/loop0: can't read superblock

$  dmesg
[25526.689580] BFS-fs: bfs_fill_super(): Inode 0x00000003 corrupted

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 fs/bfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 8defc6b..d69c464 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -420,7 +420,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 		if (i_sblock > info->si_blocks ||
 			i_eblock > info->si_blocks ||
 			i_sblock > i_eblock ||
-			i_eoff > s_size ||
+			(i_eoff != le32_to_cpu(-1) && i_eoff > s_size) ||
 			i_sblock * BFS_BSIZE > i_eoff) {
 
 			printf("Inode 0x%08x corrupted\n", i);
-- 
1.7.11.7
