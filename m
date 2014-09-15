Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbaIOXRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:17:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50508 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbaIOWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 093/187] bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address
Date: Mon, 15 Sep 2014 15:08:23 -0700
Message-Id: <1410818997-9432-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 03a6c3ff3282ee9fa893089304d951e0be93a144 upstream.

bfa_swap_words() shifts its argument (assumed to be 64-bit) by 32 bits
each way.  In two places the argument type is dma_addr_t, which may be
32-bit, in which case the effect of the bit shift is undefined:

drivers/scsi/bfa/bfa_fcpim.c: In function 'bfa_ioim_send_ioreq':
drivers/scsi/bfa/bfa_fcpim.c:2497:4: warning: left shift count >= width of type [enabled by default]
    addr = bfa_sgaddr_le(sg_dma_address(sg));
    ^
drivers/scsi/bfa/bfa_fcpim.c:2497:4: warning: right shift count >= width of type [enabled by default]
drivers/scsi/bfa/bfa_fcpim.c:2509:4: warning: left shift count >= width of type [enabled by default]
    addr = bfa_sgaddr_le(sg_dma_address(sg));
    ^
drivers/scsi/bfa/bfa_fcpim.c:2509:4: warning: right shift count >= width of type [enabled by default]

Avoid this by adding casts to u64 in bfa_swap_words().

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Fixes: f16a17507b09 ('[SCSI] bfa: remove all OS wrappers')
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/bfa/bfa_ioc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 90814fe..d5b3f66 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -72,7 +72,7 @@ struct bfa_sge_s {
 } while (0)
 
 #define bfa_swap_words(_x)  (	\
-	((_x) << 32) | ((_x) >> 32))
+	((u64)(_x) << 32) | ((u64)(_x) >> 32))
 
 #ifdef __BIG_ENDIAN
 #define bfa_sge_to_be(_x)
-- 
1.9.1

