Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3ETRLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:11:50 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1048 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755462Ab3ETRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:11:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14897
From: Lars-Peter Clausen <lars@metafoo.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] unicore: dma: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 19:11:26 +0200
Message-Id: <1369069886-2071-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() expects the same pointer that was passed to request_irq(), otherwise
the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/unicore32/kernel/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
index ed2d4d7..07f1b06 100644
--- a/arch/unicore32/kernel/dma.c
+++ b/arch/unicore32/kernel/dma.c
@@ -172,7 +172,7 @@ int __init puv3_init_dma(void)
 	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
 	if (ret) {
 		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
-		free_irq(IRQ_DMA, "DMA");
+		free_irq(IRQ_DMA, NULL);
 		return ret;
 	}
 
-- 
1.8.0

