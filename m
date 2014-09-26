Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaIZKSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:18:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbaIZJqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/142] bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address
Date: Fri, 26 Sep 2014 11:44:54 +0200
Message-Id: <8364fe4a19f74838be10123c8a85cd836b4a3b35.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/bfa/bfa_ioc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 90814fe85ac1..d5b3f66f0ebd 100644
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
2.1.0

