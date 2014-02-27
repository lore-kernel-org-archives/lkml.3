Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaB0LN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:13:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63476 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaB0LNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:13:16 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-ce-530f1dca9956
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: readahead contiguous SSA blocks for f2fs_gc
Date: Thu, 27 Feb 2014 19:12:24 +0800
Message-id: <001201cf33ac$e5d61dc0$b1825940$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8zqjIUZfosFyv9TvevVZWgSCxGJA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd1TsvzBBvcfmFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH7ZQNzwULBipYd
	j5kbGLfwdjFyckgImEjc+NnICGGLSVy4t56ti5GLQ0hgOqNEx5kDUM4PRon9szazgFSxCahI
	LO/4zwRiiwgoSmx4v4EdxGYWyJSY83oyK4gtLOAr0Xn+OFg9i4CqxIyps5hBbF4BS4nZa2aw
	Q9iCEj8m32OB6NWSWL/zOBOELS+xec1bZoiLFCR2nH3NCLFLT+LjyXlQ9eISG4/cYpnAKDAL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCQ/mZ9A7GVQ0WhxgF
	OBiVeHh/6PIFC7EmlhVX5h5ilOBgVhLhXc/EHyzEm5JYWZValB9fVJqTWnyIUZqDRUmc92Cr
	daCQQHpiSWp2ampBahFMlomDU6qBMeRk3tr7JwXmzep6af6wsdW4wP1NI9MVr1TT7Q+ft0Y9
	WLjvdHp9xs8/xrmrJlzKneD+Wd9s8mcFidlf9aeLHCl+wZj/USnx0qxfgRJTZny9p+5zvqfZ
	LKv52IZg+98OOvFdRysuBZ3tlGw9lKtXuXJi6xHDozVhHPsqV6nm116/4iBcn5y6VomlOCPR
	UIu5qDgRAIdhRsZhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are multi segments in one section, we will read those SSA blocks which
have contiguous address one by one in f2fs_gc. It may lost performance, let's
read ahead SSA blocks by merge multi read request.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |    6 ++++--
 fs/f2fs/f2fs.h       |    5 +++--
 fs/f2fs/gc.c         |    5 +++++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 757b77b..c8516ee 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -82,6 +82,7 @@ inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 		return NM_I(sbi)->max_nid / NAT_ENTRY_PER_BLOCK;
 	case META_SIT:
 		return SIT_BLK_CNT(sbi);
+	case META_SSA:
 	case META_CP:
 		return 0;
 	default:
@@ -90,7 +91,7 @@ inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 }
 
 /*
- * Readahead CP/NAT/SIT pages
+ * Readahead CP/NAT/SIT/SSA pages
  */
 int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
 {
@@ -125,8 +126,9 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
 				goto out;
 			prev_blk_addr = blk_addr;
 			break;
+		case META_SSA:
 		case META_CP:
-			/* get cp block addr */
+			/* get ssa/cp block addr */
 			blk_addr = blkno;
 			break;
 		default:
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4beedcc..cc0b27f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -89,12 +89,13 @@ enum {
 };
 
 /*
- * For CP/NAT/SIT readahead
+ * For CP/NAT/SIT/SSA readahead
  */
 enum {
 	META_CP,
 	META_NAT,
-	META_SIT
+	META_SIT,
+	META_SSA
 };
 
 /* for the list of orphan inodes */
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b161db4..d94acbc 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -708,6 +708,11 @@ gc_more:
 		goto stop;
 	ret = 0;
 
+	/* readahead multi ssa blocks those have contiguous address */
+	if (sbi->segs_per_sec > 1)
+		ra_meta_pages(sbi, GET_SUM_BLOCK(sbi, segno), sbi->segs_per_sec,
+								META_SSA);
+
 	for (i = 0; i < sbi->segs_per_sec; i++)
 		do_garbage_collect(sbi, segno + i, &ilist, gc_type);
 
-- 
1.7.9.5

