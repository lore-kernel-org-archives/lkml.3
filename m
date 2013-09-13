Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3IMKJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:09:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46474 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3IMKJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:09:08 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a4-5232e41ce9f2
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev][PATCH] f2fs: limit nr_iovecs in bio_alloc
Date: Fri, 13 Sep 2013 18:07:23 +0800
Message-id: <000001ceb069$318a87a0$949f96e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6waPsDdXPbpm7rQgm95m9sPsaA5A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQV3ZJ0ZBBjMcLK7v+stkcWmRu8We
	vSdZLC7vmsNm0brwPLMDq8fuBZ+ZPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj5Y+jLAVv
	+Ct+7TFpYFzD3cXIySEhYCJxuukLG4QtJnHh3nogm4tDSGA6o8S965MYQRJCAj8YJVp31IPY
	bAIqEss7/jOBFIkIdDBKLD1+hwUkwSygL3Go7RCYLSxgKzH7+ydmEJtFQFXi/eY17CA2r4Cl
	RPfGThYIW1Dix+R7UL0aEv2LNrBB2PISm9e8ZYa4SEFix9nXYEeICOhJ7LhyjhmiRlxi45Fb
	LBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwQD+T3sG4
	qsHiEKMAB6MSD29HjFGQEGtiWXFl7iFGCQ5mJRHeWXeBQrwpiZVVqUX58UWlOanFhxilOViU
	xHkPtloHCgmkJ5akZqemFqQWwWSZODilGhgzDstKFxx999949aKaVy/SU64ouJxK2jlL+57B
	/qdLHqhus/htmxzwaunsiUd6rpxhZL80X+/kgaUV/ROYLs56yiC3cPILw1PlpalyVwq6PMya
	rZ92mC5QXDUtKY1RzvRZo+3xeZqsV97s66wrOdbjEH50P4vV9OU5kyPbHB5XV13ebaj61jZS
	iaU4I9FQi7moOBEAKiyU62QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add macro MAX_BIO_BLOCKS to limit value of npages in
f2fs_bio_alloc,
it can avoid to return NULL in bio_alloc caused by npages is larger than
UIO_MAXIOV.

Signed-off-by: Yu Chao <chao2.yu@samsung.com>
 ---
 fs/f2fs/segment.c |    4 +++-
 fs/f2fs/segment.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 09af9c7..bd79bbe 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -657,6 +657,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi,
struct page *page,
                                block_t blk_addr, enum page_type type)
 {
        struct block_device *bdev = sbi->sb->s_bdev;
+       int bio_blocks;
 
        verify_block_addr(sbi, blk_addr);
 
@@ -676,7 +677,8 @@ retry:
                        goto retry;
                }
 
-               sbi->bio[type] = f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
+               bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
+               sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
                sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi,
blk_addr);
                sbi->bio[type]->bi_private = priv;
                /*
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bdd10ea..9cc95eb 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/blkdev.h>
+#include <linux/uio.h>
 
 /* constant macro */
 #define NULL_SEGNO                     ((unsigned int)(~0))
@@ -90,6 +91,8 @@
        (blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
 #define SECTOR_TO_BLOCK(sbi, sectors)                                  \
        (sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
+#define MAX_BIO_BLOCK(max_hw_blocks)                                   \
+       (min((int)max_hw_blocks, UIO_MAXIOV))
 
 /* during checkpoint, bio_private is used to synchronize the last bio */
 struct bio_private {
---

