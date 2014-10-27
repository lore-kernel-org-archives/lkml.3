Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaJ0FZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:25:26 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:37710 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751852AbaJ0FZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:25:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:4321:4605:5007:6261:10004:10848:11026:11233:11473:11658:11914:12438:12517:12519:12555:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fly60_4b99c577c640b
X-Filterd-Recvd-Size: 2837
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Cc: linux-nvme@lists.infradead.org
Subject: [PATCH 01/11] block: nvme-scsi: Fix probable mask then right shift defects
Date: Sun, 26 Oct 2014 22:24:57 -0700
Message-Id: <8cd08200f7cc1d1a7562d61f22a0758ec7ca182a.1414387334.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Precedence of & and >> is not the same and is not left to right.
shift has higher precedence and should be done after the mask.

Add parentheses around the mask.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/nvme-scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index a4cd6d6..529ee54 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -1972,8 +1972,8 @@ static inline void nvme_trans_get_io_cdb10(u8 *cmd,
 {
 	cdb_info->fua = GET_U8_FROM_CDB(cmd, IO_10_CDB_FUA_OFFSET) &
 					IO_CDB_FUA_MASK;
-	cdb_info->prot_info = GET_U8_FROM_CDB(cmd, IO_10_CDB_WP_OFFSET) &
-					IO_CDB_WP_MASK >> IO_CDB_WP_SHIFT;
+	cdb_info->prot_info = (GET_U8_FROM_CDB(cmd, IO_10_CDB_WP_OFFSET) &
+			       IO_CDB_WP_MASK) >> IO_CDB_WP_SHIFT;
 	cdb_info->lba = GET_U32_FROM_CDB(cmd, IO_10_CDB_LBA_OFFSET);
 	cdb_info->xfer_len = GET_U16_FROM_CDB(cmd, IO_10_CDB_TX_LEN_OFFSET);
 }
@@ -1983,8 +1983,8 @@ static inline void nvme_trans_get_io_cdb12(u8 *cmd,
 {
 	cdb_info->fua = GET_U8_FROM_CDB(cmd, IO_12_CDB_FUA_OFFSET) &
 					IO_CDB_FUA_MASK;
-	cdb_info->prot_info = GET_U8_FROM_CDB(cmd, IO_12_CDB_WP_OFFSET) &
-					IO_CDB_WP_MASK >> IO_CDB_WP_SHIFT;
+	cdb_info->prot_info = (GET_U8_FROM_CDB(cmd, IO_12_CDB_WP_OFFSET) &
+			       IO_CDB_WP_MASK) >> IO_CDB_WP_SHIFT;
 	cdb_info->lba = GET_U32_FROM_CDB(cmd, IO_12_CDB_LBA_OFFSET);
 	cdb_info->xfer_len = GET_U32_FROM_CDB(cmd, IO_12_CDB_TX_LEN_OFFSET);
 }
@@ -1994,8 +1994,8 @@ static inline void nvme_trans_get_io_cdb16(u8 *cmd,
 {
 	cdb_info->fua = GET_U8_FROM_CDB(cmd, IO_16_CDB_FUA_OFFSET) &
 					IO_CDB_FUA_MASK;
-	cdb_info->prot_info = GET_U8_FROM_CDB(cmd, IO_16_CDB_WP_OFFSET) &
-					IO_CDB_WP_MASK >> IO_CDB_WP_SHIFT;
+	cdb_info->prot_info = (GET_U8_FROM_CDB(cmd, IO_16_CDB_WP_OFFSET) &
+			       IO_CDB_WP_MASK) >> IO_CDB_WP_SHIFT;
 	cdb_info->lba = GET_U64_FROM_CDB(cmd, IO_16_CDB_LBA_OFFSET);
 	cdb_info->xfer_len = GET_U32_FROM_CDB(cmd, IO_16_CDB_TX_LEN_OFFSET);
 }
-- 
2.1.2

