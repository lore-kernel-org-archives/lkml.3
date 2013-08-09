Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967597Ab3HIGVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:21:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17606 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967286Ab3HIGVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:21:04 -0400
X-AuditID: cbfee68f-b7f436d000000f81-16-52048a4daedd
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: fix inconsistency between xattr node blocks and its
 inode
Date: Fri, 09 Aug 2013 15:20:29 +0900
Message-id: <1376029230-303-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1376029230-303-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1376029230-303-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ13fLpYgg78ztCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyni0rYGpYJdgxcPD
	j5gbGOfzdTFyckgImEiseXKcGcIWk7hwbz1bFyMXh5DAMkaJqSe+scIUne97DpWYzijx5MkE
	VginjUniQftkxi5GDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCAJYYEwib0r28DW
	sQioSnT8WcwK0ssr4Cqx77o/xDJdiUUnDoIt5hRwk3jzdwKYLQRU0nXpG9hMCYHfbBIPl6+F
	miMg8W3yIRaQORICshKbDkB9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn
	525ihIRs/w7GuwesDzEmA42byCwlmpwPDPm8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTAWH7r4ePJTrcbO3SXfpjjLTumSzti6jbldu2jBnu9G
	B9S/auz0yD793Xa5jla4EMe8WOn/XntPtnVn6bQIuKdUHN32I+3XDNk+iZeM7bXrTF6dP6W4
	Z/41za5znUcfniqpn8d8JlDA4djGeZuMjvIvEfJ/mD+F8et+X2n/6qft/UUbH9ffen9SiaU4
	I9FQi7moOBEAML4JH28CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV3fLpYgg60H1Cyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4tK2BqWCXYMXDw4+YGxjn83UxcnJICJhInO97zgZhi0lcuLceyObiEBKY
	zijx5MkEVginjUniQftkxi5GDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCAJYYEw
	ib0r25hBbBYBVYmOP4tZQXp5BVwl9l33h1imK7HoxEFWEJtTwE3izd8JYLYQUEnXpW+MExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjohnUjsYVzZYHGIU4GBU4uFV3M4cJMSa
	WFZcmXuIUYKDWUmE90UWUIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgdGaVxJvaGxiZmRp
	ZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M53Y0bt28oXC1gvSflyLJDrnO
	S458n7lko57v5Y0nbm6c96lGRPiIQ9iR1rVdb3fbymZ0eOgf/MyS6uYp7XNe8v3ym9/ivlza
	seJn97f2LSsmTO+8csWl5I9tqvf+7tZrvDsFph3aOrnshYC5c+6Buw9Z2gzTp3/9VHF9yZPi
	1t26sftVC7sD1iixFGckGmoxFxUnAgA4Yd/4zAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously xattr node blocks are stored to the COLD_NODE log, which means that
our roll-forward mechanism doesn't recover the xattr node blocks at all.
Only the direct node blocks in the WARM_NODE log can be recovered.

So, let's resolve the issue simply by conducting checkpoint during fsync when a
file has a modified xattr node block.

This approach is able to degrade the performance, but normally the checkpoint
overhead is shown at the initial fsync call after the xattr entry changes.
Once the checkpoint is done, no additional overhead would be occurred.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  | 1 +
 fs/f2fs/file.c  | 3 +++
 fs/f2fs/xattr.c | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index eb8c45b..c1c9670 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -181,6 +181,7 @@ struct f2fs_inode_info {
 	f2fs_hash_t chash;		/* hash value of given file name */
 	unsigned int clevel;		/* maximum level of given file name */
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
+	unsigned long long xattr_ver;	/* cp version of xattr modification */
 	struct extent_info ext;		/* in-memory extent cache entry */
 };
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c2deb27..49a414d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -161,6 +161,9 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		need_cp = true;
 	else if (!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino))
 		need_cp = true;
+	else if (F2FS_I(inode)->xattr_ver ==
+			le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver))
+		need_cp = true;
 
 	if (need_cp) {
 		nid_t pino;
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 3ab07ec..0f6d2a1 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -486,6 +486,10 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		inode->i_ctime = CURRENT_TIME;
 		clear_inode_flag(fi, FI_ACL_MODE);
 	}
+
+	/* store checkpoint version for conducting checkpoint during fsync */
+	fi->xattr_ver = le64_to_cpu(F2FS_CKPT(sbi)->checkpoint_ver);
+
 	if (ipage)
 		update_inode(inode, ipage);
 	else
-- 
1.8.3.1.437.g0dbd812

