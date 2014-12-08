Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaLHG5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:57:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:65502 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaLHG5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:57:13 -0500
X-AuditID: cbfee61a-f79c06d000004e71-95-54854bc6f2ad
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/4] f2fs: fix to enable readahead for SSA/CP blocks
Date: Mon, 08 Dec 2014 14:56:19 +0800
Message-id: <001801d012b4$2ffb5c80$8ff21580$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdASn2rEoJHZ8HQzTHqJiO6FtAk15w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd1j3q0hBjffmltc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	y2dPZC/4zFNx6ucH1gbGiVxdjJwcEgImEm+mXmCGsMUkLtxbz9bFyMUhJLCIUeJyy1RWCOcH
	o8SMo/9YQarYBFQklnf8ZwKxRQS8JCbtP8ECYjMLZErca5oBNklYwE9i/5MONhCbRUBVorVv
	LWMXIwcHr4ClxI4XfCBhXgFBiR+T70G1akls3tbECmHLS2xe8xbqIAWJHWdfM0Ks0pOYM7+D
	GaJGXGLjkVssExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnBwP5PawbiyweIQowAHoxIP74IHLSFCrIllxZW5hxglOJiVRHg97VtDhHhTEiurUovy44tK
	c1KLDzFKc7AoifPeuJkbIiSQnliSmp2aWpBaBJNl4uCUamDksuro6buk65e17J3G65QHyyrS
	YjVSL7IEaRamXrwtcOOGnelN+frEyDTxcOcS5emznScWNN+cOfH/d00FZ+kZlyPSf0/R6jpc
	I6sjtybk4/77Px+Kfq8vijtnnNTn5y61Mebgvu8cRe5nLRuLJuwSZ/34pHLp/LRJm3L2vkpn
	5/M4URl7qViJpTgj0VCLuag4EQAj+l/MagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.We use zero as upper boundary value for ra SSA/CP blocks, we will skip
readahead as verification failure with max number, it causes low performance.
2.Low boundary value is not accurate for SSA/CP/POR region verification, so
these values need to be redefined.

This patch fixes above issues.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 20a917b..c32ed7c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -95,8 +95,9 @@ static inline block_t get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 	case META_SIT:
 		return SIT_BLK_CNT(sbi);
 	case META_SSA:
+		return MAIN_BLKADDR(sbi);
 	case META_CP:
-		return 0;
+		return SM_I(sbi)->sit_info->sit_base_addr;
 	case META_POR:
 		return MAX_BLKADDR(sbi);
 	default:
@@ -141,11 +142,23 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 			prev_blk_addr = blk_addr;
 			break;
 		case META_SSA:
+			if (unlikely(blkno >= max_blks))
+				goto out;
+			if (unlikely(blkno < SM_I(sbi)->ssa_blkaddr))
+				goto out;
+			blk_addr = blkno;
+			break;
 		case META_CP:
+			if (unlikely(blkno >= max_blks))
+				goto out;
+			if (unlikely(blkno < __start_cp_addr(sbi)))
+				goto out;
+			blk_addr = blkno;
+			break;
 		case META_POR:
 			if (unlikely(blkno >= max_blks))
 				goto out;
-			if (unlikely(blkno < SEG0_BLKADDR(sbi)))
+			if (unlikely(blkno < MAIN_BLKADDR(sbi)))
 				goto out;
 			blk_addr = blkno;
 			break;
-- 
2.1.2


