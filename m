Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3EVAOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:14:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25150 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3EVAOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:14:45 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-6d-519c0df3991f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: reuse the locked dnode page and its inode
Date: Wed, 22 May 2013 09:13:31 +0900
Message-id: <1369181612-15777-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ93PvHMCDV4+1rW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PFhO/MBY80Kja9
	n8jcwHhUqYuRk0NCwETiwJ4vrBC2mMSFe+vZuhi5OIQEljFKNMzvYoYp6t74gwUisYhR4sqB
	xVBVbUwSJ++AVHFwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgLuEhsWjyfFaSe
	RUBV4uQFFZAwr4C7xJNHz1gglulKrP7/nB2kV0LgPpvE7eNf2UASLAICEt8mH2IB6ZUQkJXY
	dADqOEmJgytusExgFFzAyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIyQEe3cw3j5gfYgx
	GWjcRGYp0eR8YAjnlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoHRrzHRbG/mQ4ZWo7rdcafvyNdlzHuwqui66mTtC3WHll/jdXfkv7eDMTbhxBTZ
	v+1iB3jUL9RdulO8UO7+pKJKQf1MpkT96UIPlwoszH+0dkHMhiqFvcWz66evb3d4yW61oEZg
	7e1pycr2G+46eixPWdiaI7B33ZI2htxfN367SttsW9vjnnVDiaU4I9FQi7moOBEAWH8wnFcC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3PvHMCDV580bC4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjxYTvzAWPNCo2vZ/I3MB4VKmLkZNDQsBEonvjDxYIW0ziwr31bF2MXBxC
	AosYJa4cWAzltDFJnLzTxdzFyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0HmySsICL
	xKbF81lB6lkEVCVOXlABCfMKuEs8efQMapmuxOr/z9knMHIvYGRYxSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREc4M+kdzCuarA4xCjAwajEw/ugdnagEGtiWXFl7iFGCQ5mJRFew2tAId6U
	xMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucDoy+vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLp
	iSWp2ampBalFMFuYODilGhiXxpluiBKeabrzCN8/EWd13ZX7Nazi9m981Ne/MVbYf5Py7MBD
	OQuuhe0o8uESvbjH2j+4aIaD967bRQYcF7yWetxXef5vjdTstKht/+1FLxeIfr1yxJJfWcdX
	9KOQgY9S6mme/GjTnhcsqwTi36W9dGnctWPLqpnNk0q8FiQonj+hKvcj/L4SS3FGoqEWc1Fx
	IgDA80U+tAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following deadlock bug during the recovery.

INFO: task mount:1322 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mount           D ffffffff81125870     0  1322   1266 0x00000000
 ffff8801207e39d8 0000000000000046 ffff88012ab1dee0 0000000000000046
 ffff8801207e3a08 ffff880115903f40 ffff8801207e3fd8 ffff8801207e3fd8
 ffff8801207e3fd8 ffff880115903f40 ffff8801207e39d8 ffff88012fc94520
Call Trace:
[<ffffffff81125870>] ? __lock_page+0x70/0x70
[<ffffffff816a92d9>] schedule+0x29/0x70
[<ffffffff816a93af>] io_schedule+0x8f/0xd0
[<ffffffff8112587e>] sleep_on_page+0xe/0x20
[<ffffffff816a649a>] __wait_on_bit_lock+0x5a/0xc0
[<ffffffff81125867>] __lock_page+0x67/0x70
[<ffffffff8106c7b0>] ? autoremove_wake_function+0x40/0x40
[<ffffffff81126857>] find_lock_page+0x67/0x80
[<ffffffff8112698f>] find_or_create_page+0x3f/0xb0
[<ffffffffa03901a8>] ? sync_inode_page+0xa8/0xd0 [f2fs]
[<ffffffffa038fdf7>] get_node_page+0x67/0x180 [f2fs]
[<ffffffffa039818b>] recover_fsync_data+0xacb/0xff0 [f2fs]
[<ffffffff816aaa1e>] ? _raw_spin_unlock+0x3e/0x40
[<ffffffffa0389634>] f2fs_fill_super+0x7d4/0x850 [f2fs]
[<ffffffff81184cf9>] mount_bdev+0x1c9/0x210
[<ffffffffa0388e60>] ? validate_superblock+0x180/0x180 [f2fs]
[<ffffffffa0387635>] f2fs_mount+0x15/0x20 [f2fs]
[<ffffffff81185a13>] mount_fs+0x43/0x1b0
[<ffffffff81145ba0>] ? __alloc_percpu+0x10/0x20
[<ffffffff811a0796>] vfs_kern_mount+0x76/0x120
[<ffffffff811a2cb7>] do_mount+0x237/0xa10
[<ffffffff81140b9b>] ? strndup_user+0x5b/0x80
[<ffffffff811a3520>] SyS_mount+0x90/0xe0
[<ffffffff816b3502>] system_call_fastpath+0x16/0x1b

The bug is triggered when check_index_in_prev_nodes tries to get the direct
node page by calling get_node_page.
At this point, if the direct node page is already locked by get_dnode_of_data,
its caller, we got a deadlock condition.

This patch adds additional condition check for the reuse of locked direct node
pages prior to the get_node_page call.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h     |  1 +
 fs/f2fs/file.c     |  2 +-
 fs/f2fs/recovery.c | 26 +++++++++++++++++++++-----
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6594ce1..7b05029 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -900,6 +900,7 @@ void truncate_data_blocks(struct dnode_of_data *);
 void f2fs_truncate(struct inode *);
 int f2fs_setattr(struct dentry *, struct iattr *);
 int truncate_hole(struct inode *, pgoff_t, pgoff_t);
+int truncate_data_blocks_range(struct dnode_of_data *, int);
 long f2fs_ioctl(struct file *, unsigned int, unsigned long);
 long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 316bcfe..deefd25 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -168,7 +168,7 @@ static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
+int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 {
 	int nr_free = 0, ofs = dn->ofs_in_node;
 	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 5148d90..eceb665 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -189,14 +189,14 @@ static void destroy_fsync_dnodes(struct f2fs_sb_info *sbi,
 }
 
 static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
-						block_t blkaddr)
+			block_t blkaddr, struct dnode_of_data *dn)
 {
 	struct seg_entry *sentry;
 	unsigned int segno = GET_SEGNO(sbi, blkaddr);
 	unsigned short blkoff = GET_SEGOFF_FROM_SEG0(sbi, blkaddr) &
 					(sbi->blocks_per_seg - 1);
 	struct f2fs_summary sum;
-	nid_t ino;
+	nid_t ino, nid;
 	void *kaddr;
 	struct inode *inode;
 	struct page *node_page;
@@ -224,10 +224,26 @@ static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 		f2fs_put_page(sum_page, 1);
 	}
 
+	/* Use the locked dnode page and inode */
+	nid = le32_to_cpu(sum.nid);
+	if (dn->inode->i_ino == nid) {
+		struct dnode_of_data tdn = *dn;
+		tdn.nid = nid;
+		tdn.node_page = dn->inode_page;
+		tdn.ofs_in_node = sum.ofs_in_node;
+		truncate_data_blocks_range(&tdn, 1);
+		return;
+	} else if (dn->nid == nid) {
+		struct dnode_of_data tdn = *dn;
+		tdn.ofs_in_node = sum.ofs_in_node;
+		truncate_data_blocks_range(&tdn, 1);
+		return;
+	}
+
 	/* Get the node page */
-	node_page = get_node_page(sbi, le32_to_cpu(sum.nid));
+	node_page = get_node_page(sbi, nid);
 	bidx = start_bidx_of_node(ofs_of_node(node_page)) +
-				le16_to_cpu(sum.ofs_in_node);
+					le16_to_cpu(sum.ofs_in_node);
 	ino = ino_of_node(node_page);
 	f2fs_put_page(node_page, 1);
 
@@ -285,7 +301,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 			}
 
 			/* Check the previous node page having this index */
-			check_index_in_prev_nodes(sbi, dest);
+			check_index_in_prev_nodes(sbi, dest, &dn);
 
 			set_summary(&sum, dn.nid, dn.ofs_in_node, ni.version);
 
-- 
1.8.1.3.566.gaa39828

