Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3JVKOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:14:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:52872 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3JVKO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:14:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/4] dma: cppi41: use cppi41_pop_desc() where possible
Date: Tue, 22 Oct 2013 12:14:04 +0200
Message-Id: <1382436846-9057-3-git-send-email-bigeasy@linutronix.de>
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

Use cppi41_pop_desc() when appropriate instead of open-coding the same
functionality again. That makes the code more readable. The function has
to be moved some lines up for this change.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/cppi41.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index e53292d..42d1c58 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -266,6 +266,15 @@ static u32 pd_trans_len(u32 val)
 	return val & ((1 << (DESC_LENGTH_BITS_NUM + 1)) - 1);
 }
 
+static u32 cppi41_pop_desc(struct cppi41_dd *cdd, unsigned queue_num)
+{
+	u32 desc;
+
+	desc = cppi_readl(cdd->qmgr_mem + QMGR_QUEUE_D(queue_num));
+	desc &= ~0x1f;
+	return desc;
+}
+
 static irqreturn_t cppi41_irq(int irq, void *data)
 {
 	struct cppi41_dd *cdd = data;
@@ -303,8 +312,7 @@ static irqreturn_t cppi41_irq(int irq, void *data)
 			q_num = __fls(val);
 			val &= ~(1 << q_num);
 			q_num += 32 * i;
-			desc = cppi_readl(cdd->qmgr_mem + QMGR_QUEUE_D(q_num));
-			desc &= ~0x1f;
+			desc = cppi41_pop_desc(cdd, q_num);
 			c = desc_to_chan(cdd, desc);
 			if (WARN_ON(!c)) {
 				pr_err("%s() q %d desc %08x\n", __func__,
@@ -520,15 +528,6 @@ static void cppi41_compute_td_desc(struct cppi41_desc *d)
 	d->pd0 = DESC_TYPE_TEARD << DESC_TYPE;
 }
 
-static u32 cppi41_pop_desc(struct cppi41_dd *cdd, unsigned queue_num)
-{
-	u32 desc;
-
-	desc = cppi_readl(cdd->qmgr_mem + QMGR_QUEUE_D(queue_num));
-	desc &= ~0x1f;
-	return desc;
-}
-
 static int cppi41_tear_down_chan(struct cppi41_channel *c)
 {
 	struct cppi41_dd *cdd = c->cdd;
@@ -612,7 +611,7 @@ static int cppi41_tear_down_chan(struct cppi41_channel *c)
 
 	WARN_ON(!c->td_retry);
 	if (!c->td_desc_seen) {
-		desc_phys = cppi_readl(cdd->qmgr_mem + QMGR_QUEUE_D(c->q_num));
+		desc_phys = cppi41_pop_desc(cdd, c->q_num);
 		WARN_ON(!desc_phys);
 	}
 
-- 
1.8.4.rc3

