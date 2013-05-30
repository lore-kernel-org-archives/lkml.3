Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935527Ab3E3QWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:22:44 -0400
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1134 "EHLO
	smtp-out-015.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934904Ab3E3QWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:22:10 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 26279
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 2/6] MIPS: jz4740: Acquire and enable DMA controller clock
Date: Thu, 30 May 2013 18:25:01 +0200
Message-Id: <1369931105-28065-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369931105-28065-1-git-send-email-lars@metafoo.de>
References: <1369931105-28065-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten ter Huurne <maarten@treewalker.org>

Previously, it was assumed that the DMA controller clock is not gated
when the kernel starts running. While that is the power-on state, it is
safer to not rely on that.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
---
No changes since v1
---
 arch/mips/jz4740/dma.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/mips/jz4740/dma.c b/arch/mips/jz4740/dma.c
index 317ec6f..0e34b97 100644
--- a/arch/mips/jz4740/dma.c
+++ b/arch/mips/jz4740/dma.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/clk.h>
 #include <linux/interrupt.h>
 
 #include <linux/dma-mapping.h>
@@ -268,6 +269,7 @@ static irqreturn_t jz4740_dma_irq(int irq, void *dev_id)
 
 static int jz4740_dma_init(void)
 {
+	struct clk *clk;
 	unsigned int ret;
 
 	jz4740_dma_base = ioremap(JZ4740_DMAC_BASE_ADDR, 0x400);
@@ -277,11 +279,29 @@ static int jz4740_dma_init(void)
 
 	spin_lock_init(&jz4740_dma_lock);
 
-	ret = request_irq(JZ4740_IRQ_DMAC, jz4740_dma_irq, 0, "DMA", NULL);
+	clk = clk_get(NULL, "dma");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		printk(KERN_ERR "JZ4740 DMA: Failed to request clock: %d\n",
+				ret);
+		goto err_iounmap;
+	}
 
-	if (ret)
+	ret = request_irq(JZ4740_IRQ_DMAC, jz4740_dma_irq, 0, "DMA", NULL);
+	if (ret) {
 		printk(KERN_ERR "JZ4740 DMA: Failed to request irq: %d\n", ret);
+		goto err_clkput;
+	}
+
+	clk_prepare_enable(clk);
+
+	return 0;
+
+err_clkput:
+	clk_put(clk);
 
+err_iounmap:
+	iounmap(jz4740_dma_base);
 	return ret;
 }
 arch_initcall(jz4740_dma_init);
-- 
1.8.2.1

