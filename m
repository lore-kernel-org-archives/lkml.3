Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaIEPG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:06:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31897 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaIEPGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:06:25 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-62-5409d16f83ed
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH] dma: pl330: add Power Management support
Date: Fri, 05 Sep 2014 17:06:02 +0200
Message-id: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7r5FzlDDM528VtsnLGe1eL1v+ks
	FtOnXmC0WD31L5D7wtDibNMbdoslk+ezWlzeNYfNYu2Ru+wW715GWLzs28/iwO2xeM9LJo8l
	bw6xenx8eovFo2/LKkaPz5vkPPZ+/s0SwBbFZZOSmpNZllqkb5fAldGz6CNTwX+TijPr/7A2
	MD7X7mLk5JAQMJE49+gjC4QtJnHh3nq2LkYuDiGBpYwS7xc0skI4fUwS/298ZwKpYhMwlti8
	fAlYlYhAK5PExXXTWUAcZoGjjBLTe9+CVQkL2Er0tS5mBrFZBFQluh5B2LwC7hILHmxmgtgn
	J3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNbXHYxLj1kdYhTgYFTi
	4e3Q5AwRYk0sK67MPcQowcGsJMJruxsoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVGb95vu8rur
	eS4W/TolFj7nkvqidNbq+0s9tty0dU2OPZDJPK29x41Rpt5Y1ZjH5PfU6tYyt37TPx8PfJBa
	1pBxYMtp29mVrt1pt6//1uNv0lBj+OWxK2HSkr9RL6+5HVmZUMXSWaBqeqhx2U6LW/82Scv4
	T3zYqzCBk285f2/u+dz0GObMGiWW4oxEQy3mouJEAFqk1/UKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds both normal PM suspend/resume support and runtime PM
support to pl330 DMA engine driver.

The runtime power management for pl330 DMA driver allows gating of AMBA
clock (PDMA) in FSYS clock domain, when the device is not processing any
requests. This is necessary to enter W-AFTR low power mode on Exynos3250.

The patch is based on previous work of Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com>.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/dma/pl330.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 66e89f04504c..bdc6ff8ee2bf 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -27,6 +27,7 @@
 #include <linux/of.h>
 #include <linux/of_dma.h>
 #include <linux/err.h>
+#include <linux/pm_runtime.h>
 
 #include "dmaengine.h"
 #define PL330_MAX_CHAN		8
@@ -1966,6 +1967,7 @@ static void pl330_tasklet(unsigned long data)
 	struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
 	struct dma_pl330_desc *desc, *_dt;
 	unsigned long flags;
+	bool power_down = false;
 
 	spin_lock_irqsave(&pch->lock, flags);
 
@@ -1980,10 +1982,17 @@ static void pl330_tasklet(unsigned long data)
 	/* Try to submit a req imm. next to the last completed cookie */
 	fill_queue(pch);
 
-	/* Make sure the PL330 Channel thread is active */
-	spin_lock(&pch->thread->dmac->lock);
-	_start(pch->thread);
-	spin_unlock(&pch->thread->dmac->lock);
+	if (list_empty(&pch->work_list)) {
+		spin_lock(&pch->thread->dmac->lock);
+		_stop(pch->thread);
+		spin_unlock(&pch->thread->dmac->lock);
+		power_down = true;
+	} else {
+		/* Make sure the PL330 Channel thread is active */
+		spin_lock(&pch->thread->dmac->lock);
+		_start(pch->thread);
+		spin_unlock(&pch->thread->dmac->lock);
+	}
 
 	while (!list_empty(&pch->completed_list)) {
 		dma_async_tx_callback callback;
@@ -1998,6 +2007,12 @@ static void pl330_tasklet(unsigned long data)
 		if (pch->cyclic) {
 			desc->status = PREP;
 			list_move_tail(&desc->node, &pch->work_list);
+			if (power_down) {
+				spin_lock(&pch->thread->dmac->lock);
+				_start(pch->thread);
+				spin_unlock(&pch->thread->dmac->lock);
+				power_down = false;
+			}
 		} else {
 			desc->status = FREE;
 			list_move_tail(&desc->node, &pch->dmac->desc_pool);
@@ -2012,6 +2027,10 @@ static void pl330_tasklet(unsigned long data)
 		}
 	}
 	spin_unlock_irqrestore(&pch->lock, flags);
+
+	/* If work list empty, power down */
+	if (power_down)
+		pm_runtime_put(pch->dmac->ddma.dev);
 }
 
 bool pl330_filter(struct dma_chan *chan, void *param)
@@ -2077,10 +2096,12 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 	unsigned long flags;
 	struct pl330_dmac *pl330 = pch->dmac;
 	struct dma_slave_config *slave_config;
+	bool power_down = false;
 	LIST_HEAD(list);
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
+		pm_runtime_get_sync(pl330->ddma.dev);
 		spin_lock_irqsave(&pch->lock, flags);
 
 		spin_lock(&pl330->lock);
@@ -2107,10 +2128,18 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 			dma_cookie_complete(&desc->txd);
 		}
 
+		if (!list_empty(&pch->work_list))
+			power_down = true;
+
 		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
 		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
 		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
 		spin_unlock_irqrestore(&pch->lock, flags);
+		pm_runtime_put(pl330->ddma.dev);
+
+		/* If work list empty, power down */
+		if (power_down)
+			pm_runtime_put(pl330->ddma.dev);
 		break;
 	case DMA_SLAVE_CONFIG:
 		slave_config = (struct dma_slave_config *)arg;
@@ -2146,6 +2175,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 
 	tasklet_kill(&pch->task);
 
+	pm_runtime_get_sync(pch->dmac->ddma.dev);
 	spin_lock_irqsave(&pch->lock, flags);
 
 	pl330_release_channel(pch->thread);
@@ -2155,6 +2185,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
 
 	spin_unlock_irqrestore(&pch->lock, flags);
+	pm_runtime_put(pch->dmac->ddma.dev);
 }
 
 static enum dma_status
@@ -2168,11 +2199,23 @@ static void pl330_issue_pending(struct dma_chan *chan)
 {
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	unsigned long flags;
+	bool power_up;
 
 	spin_lock_irqsave(&pch->lock, flags);
+	power_up = list_empty(&pch->work_list);
 	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
 	spin_unlock_irqrestore(&pch->lock, flags);
 
+	if (power_up) {
+		/*
+		 * Warn on nothing pending. This may break our pm_runtime
+		 * usage counter as it is updated on work_list emptiness
+		 * status.
+		 */
+		WARN_ON(list_empty(&pch->work_list));
+		pm_runtime_get_sync(pch->dmac->ddma.dev);
+	}
+
 	pl330_tasklet((unsigned long)pch);
 }
 
@@ -2205,6 +2248,7 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
 
 	cookie = dma_cookie_assign(&last->txd);
 	list_add_tail(&last->node, &pch->submitted_list);
+
 	spin_unlock_irqrestore(&pch->lock, flags);
 
 	return cookie;
@@ -2593,6 +2637,28 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int pl330_suspend(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+
+	if (!pm_runtime_suspended(dev))
+		amba_pclk_disable(pcdev);
+	return 0;
+}
+
+static int pl330_resume(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+
+	if (!pm_runtime_suspended(dev))
+		return amba_pclk_enable(pcdev);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
+
 static int
 pl330_probe(struct amba_device *adev, const struct amba_id *id)
 {
@@ -2746,6 +2812,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
 		pcfg->num_peri, pcfg->num_events);
 
+	pm_runtime_put_noidle(&adev->dev);
 	return 0;
 probe_err3:
 	/* Idle the DMAC */
@@ -2772,6 +2839,8 @@ static int pl330_remove(struct amba_device *adev)
 	struct pl330_dmac *pl330 = amba_get_drvdata(adev);
 	struct dma_pl330_chan *pch, *_p;
 
+	pm_runtime_get_noresume(pl330->ddma.dev);
+
 	if (adev->dev.of_node)
 		of_dma_controller_free(adev->dev.of_node);
 
@@ -2810,6 +2879,7 @@ static struct amba_driver pl330_driver = {
 	.drv = {
 		.owner = THIS_MODULE,
 		.name = "dma-pl330",
+		.pm = &pl330_pm,
 	},
 	.id_table = pl330_ids,
 	.probe = pl330_probe,
-- 
1.9.1

