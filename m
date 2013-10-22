Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3JVKO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:14:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:52868 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3JVKO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:14:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/4] dma: cppi41: restore more registers
Date: Tue, 22 Oct 2013 12:14:03 +0200
Message-Id: <1382436846-9057-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382436846-9057-1-git-send-email-bigeasy@linutronix.de>
References: <1382436846-9057-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

With active users over suspend/resume cycles, it turns out that
more registers, in particular DMA_TDFDQ and RXHPCRA0, have to be
restored on resume.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/cppi41.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 167c022..e53292d 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -141,6 +141,9 @@ struct cppi41_dd {
 	const struct chan_queues *queues_rx;
 	const struct chan_queues *queues_tx;
 	struct chan_queues td_queue;
+
+	/* context for suspend/resume */
+	unsigned int dma_tdfdq;
 };
 
 #define FIST_COMPLETION_QUEUE	93
@@ -1050,6 +1053,7 @@ static int cppi41_suspend(struct device *dev)
 {
 	struct cppi41_dd *cdd = dev_get_drvdata(dev);
 
+	cdd->dma_tdfdq = cppi_readl(cdd->ctrl_mem + DMA_TDFDQ);
 	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
 	disable_sched(cdd);
 
@@ -1059,12 +1063,23 @@ static int cppi41_suspend(struct device *dev)
 static int cppi41_resume(struct device *dev)
 {
 	struct cppi41_dd *cdd = dev_get_drvdata(dev);
+	struct cppi41_channel *c;
 	int i;
 
 	for (i = 0; i < DESCS_AREAS; i++)
 		cppi_writel(cdd->descs_phys, cdd->qmgr_mem + QMGR_MEMBASE(i));
 
+	list_for_each_entry(c, &cdd->ddev.channels, chan.device_node)
+		if (!c->is_tx)
+			cppi_writel(c->q_num, c->gcr_reg + RXHPCRA0);
+
 	init_sched(cdd);
+
+	cppi_writel(cdd->dma_tdfdq, cdd->ctrl_mem + DMA_TDFDQ);
+	cppi_writel(cdd->scratch_phys, cdd->qmgr_mem + QMGR_LRAM0_BASE);
+	cppi_writel(QMGR_SCRATCH_SIZE, cdd->qmgr_mem + QMGR_LRAM_SIZE);
+	cppi_writel(0, cdd->qmgr_mem + QMGR_LRAM1_BASE);
+
 	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
 
 	return 0;
-- 
1.8.4.rc3

