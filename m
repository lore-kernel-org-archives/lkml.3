Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaDZMAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 08:00:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDZMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 08:00:37 -0400
X-AuditID: cbfee61b-b7f766d00000646c-03-535b9fe31005
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: introduce help macro ADDRS_PER_PAGE()
Date: Sat, 26 Apr 2014 19:59:52 +0800
Message-id: <004901cf6147$21bed300$653c7900$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9g+YGmX51BZmevSoWzlfC3uhw6gg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd3H86ODDc5O1bG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Pb7gXMBU2iFVf+
	/GNqYOwX7GLk5JAQMJE49/cIO4QtJnHh3nq2LkYuDiGB6YwS87afYARJCAn8YJTY2pMHYrMJ
	qEgs7/jPBGKLCChKbHi/AayZWSBT4l7TDGYQW1jATeLQ3lVgNouAqsTBF22sXYwcHLwClhIb
	FziChHkFBCV+TL7HAtGqJbF5WxMrhC0vsXnNW2aIexQkdpx9zQixSk9i+7TZUDXiEhuP3GKZ
	wCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgsP4mfQOxlUN
	FocYBTgYlXh4d+REBQuxJpYVV+YeYpTgYFYS4Y2dHR0sxJuSWFmVWpQfX1Sak1p8iFGag0VJ
	nPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTHyVMLH4IOXNFXunlM/ciC8cLn+tfd7X9XfyMv0
	nxTD92D91Tf/i5QZpcx0Hk+7fkMoVolHXzG4rOre4ikBgpxeLYezFdU2aM1xXPn9xnn/wqXS
	zJrh+s0vXOo3Rosbl/wK7em0leuptZ0rfNhOciKDQ9llpy9Tv9yU1HXX25D1++zEOUrfbZVY
	ijMSDbWYi4oTATk+I9NfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce help macro ADDRS_PER_PAGE() to get the number of address pointers in
direct node or inode.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c          |    6 ++----
 fs/f2fs/file.c          |    5 +----
 fs/f2fs/recovery.c      |    5 +----
 include/linux/f2fs_fs.h |    3 +++
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 150c12a..6daef54 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -652,8 +652,7 @@ static int get_data_block(struct inode *inode, sector_t iblock,
 		goto put_out;
 	}
 
-	end_offset = IS_INODE(dn.node_page) ?
-			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+	end_offset = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 	bh_result->b_size = (((size_t)1) << blkbits);
 	dn.ofs_in_node++;
 	pgofs++;
@@ -675,8 +674,7 @@ get_next:
 		if (dn.data_blkaddr == NEW_ADDR)
 			goto put_out;
 
-		end_offset = IS_INODE(dn.node_page) ?
-			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+		end_offset = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 	}
 
 	if (maxblocks > (bh_result->b_size >> blkbits)) {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 60e7d54..bb365c9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -288,10 +288,7 @@ int truncate_blocks(struct inode *inode, u64 from)
 		return err;
 	}
 
-	if (IS_INODE(dn.node_page))
-		count = ADDRS_PER_INODE(F2FS_I(inode));
-	else
-		count = ADDRS_PER_BLOCK;
+	count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 
 	count -= dn.ofs_in_node;
 	f2fs_bug_on(count < 0);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 9eb6487..be1e3e8 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -301,10 +301,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 		goto out;
 
 	start = start_bidx_of_node(ofs_of_node(page), fi);
-	if (IS_INODE(page))
-		end = start + ADDRS_PER_INODE(fi);
-	else
-		end = start + ADDRS_PER_BLOCK;
+	end = start + ADDRS_PER_PAGE(page, fi);
 
 	f2fs_lock_op(sbi);
 
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index df53e17..8c03f71 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -146,6 +146,9 @@ struct f2fs_extent {
 #define ADDRS_PER_BLOCK		1018	/* Address Pointers in a Direct Block */
 #define NIDS_PER_BLOCK		1018	/* Node IDs in an Indirect Block */
 
+#define ADDRS_PER_PAGE(page, fi)	\
+	(IS_INODE(page) ? ADDRS_PER_INODE(fi) : ADDRS_PER_BLOCK)
+
 #define	NODE_DIR1_BLOCK		(DEF_ADDRS_PER_INODE + 1)
 #define	NODE_DIR2_BLOCK		(DEF_ADDRS_PER_INODE + 2)
 #define	NODE_IND1_BLOCK		(DEF_ADDRS_PER_INODE + 3)
-- 
1.7.9.5


