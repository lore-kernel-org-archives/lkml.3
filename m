Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbaF3RbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:31:17 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:52075 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaF3RbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:31:15 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: pjk1939@linux.vnet.ibm.com
Cc: josh.h.morris@us.ibm.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH] rsxx: fix discard with length smaller than hw blksize
Date: Mon, 30 Jun 2014 14:31:07 -0300
Message-Id: <1404149467-17856-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063017-2194-0000-0000-00000940C81E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the discard length is not a multiple of RSXX_HW_BLK_SIZE, the
discard code will get into an infinite loop, even discarding data it is
not supposed to. This will also hang the system.

This can be reproduced by doing an ioctl BLKDISCARD to /dev/rsxx0 with
range from 0 to 1024.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---
 drivers/block/rsxx/dma.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index cf8cd29..d105a4a 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -708,7 +708,9 @@ int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 	if (bio->bi_rw & REQ_DISCARD) {
 		bv_len = bio->bi_iter.bi_size;
 
-		while (bv_len > 0) {
+		if (bv_len < RSXX_HW_BLK_SIZE)
+			bio_endio(bio, 0);
+		while (bv_len >= RSXX_HW_BLK_SIZE) {
 			tgt   = rsxx_get_dma_tgt(card, addr8);
 			laddr = rsxx_addr8_to_laddr(addr8, card);
 
-- 
1.7.1

