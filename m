Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaKLOeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:34:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60986 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaKLOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:32:38 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-a7-54636f8490d7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v11 4/6] dmaengine: pl330: Add runtime Power Management support
Date: Wed, 12 Nov 2014 15:32:26 +0100
Message-id: <1415802748-30530-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xq7ot+ckhBrM+i1psnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CV0XxwLkvBCcOKic1zWBoY
	D2l2MXJySAiYSHRMf88EYYtJXLi3nq2LkYtDSGApo8TFmU+ZIJw+Joljj7oZQarYBIwlNi9f
	AlYlItDOLNG3biobSIJZYBGTRNNURRBbWMBfouvxWWYQm0VAVWLpmtPsIDavgLvE9Tk3GSHW
	yUmcPDaZFcTmFPCQ+LLtL9gcIaCaM5cPskxg5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85
	P3cTIyTQv+xgXHzM6hCjAAejEg9vBU9yiBBrYllxZe4hRgkOZiUR3l05QCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2M02dw3fOed2Dr5vqSwmc1P3Z+ibWy+tYieGJblUkwT/9EE5u3ctONWu6x
	f0z9Wfo5oeSiruKayP+P581elizTcju2Mz2toF43yir/7j2mlVaHTi1Lfi/Mun+iDj/H9JQ9
	8o5n1vLuecXTGuyrtVnnq6tC3Y+m52tvehmzrHnjOE/pJLOhQ0GaEktxRqKhFnNRcSIAaraX
	oFICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime PM support to pl330 DMA engine driver.

The runtime power management for pl330 DMA driver allows gating of AMBA
clock (PDMA) in FSYS clock domain, when the device is not processing any
requests. This is necessary to enter low power modes on Exynos SoCs
(e.g. LPA on Exynos4x12 or W-AFTR on Exynos3250).

Runtime PM resuming of the device may happen in atomic context (during
call device_issue_pending()) so pm_runtime_irq_safe() is used. This will
lead only to disabling/enabling of the clock but this is sufficient for
gating the clock and for reducing energy usage.

Driver uses runtime PM callbacks from amba/bus.c driver only.

Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/pl330.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 83e2257c324a..c3bd3584f261 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -27,6 +27,7 @@
 #include <linux/of.h>
 #include <linux/of_dma.h>
 #include <linux/err.h>
+#include <linux/pm_runtime.h>
 
 #include "dmaengine.h"
 #define PL330_MAX_CHAN		8
@@ -265,6 +266,9 @@ static unsigned cmd_line;
 
 #define NR_DEFAULT_DESC	16
 
+/* Delay for runtime PM autosuspend, ms */
+#define PL330_AUTOSUSPEND_DELAY 20
+
 /* Populated by the PL330 core driver for DMA API driver's info */
 struct pl330_config {
 	u32	periph_id;
@@ -1958,6 +1962,7 @@ static void pl330_tasklet(unsigned long data)
 	struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
 	struct dma_pl330_desc *desc, *_dt;
 	unsigned long flags;
+	bool power_down = false;
 
 	spin_lock_irqsave(&pch->lock, flags);
 
@@ -1972,10 +1977,17 @@ static void pl330_tasklet(unsigned long data)
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
@@ -1990,6 +2002,12 @@ static void pl330_tasklet(unsigned long data)
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
@@ -2004,6 +2022,12 @@ static void pl330_tasklet(unsigned long data)
 		}
 	}
 	spin_unlock_irqrestore(&pch->lock, flags);
+
+	/* If work list empty, power down */
+	if (power_down) {
+		pm_runtime_mark_last_busy(pch->dmac->ddma.dev);
+		pm_runtime_put_autosuspend(pch->dmac->ddma.dev);
+	}
 }
 
 bool pl330_filter(struct dma_chan *chan, void *param)
@@ -2073,6 +2097,7 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
+		pm_runtime_get_sync(pl330->ddma.dev);
 		spin_lock_irqsave(&pch->lock, flags);
 
 		spin_lock(&pl330->lock);
@@ -2099,10 +2124,15 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 			dma_cookie_complete(&desc->txd);
 		}
 
+		if (!list_empty(&pch->work_list))
+			pm_runtime_put(pl330->ddma.dev);
+
 		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
 		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
 		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
 		spin_unlock_irqrestore(&pch->lock, flags);
+		pm_runtime_mark_last_busy(pl330->ddma.dev);
+		pm_runtime_put_autosuspend(pl330->ddma.dev);
 		break;
 	case DMA_SLAVE_CONFIG:
 		slave_config = (struct dma_slave_config *)arg;
@@ -2138,6 +2168,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 
 	tasklet_kill(&pch->task);
 
+	pm_runtime_get_sync(pch->dmac->ddma.dev);
 	spin_lock_irqsave(&pch->lock, flags);
 
 	pl330_release_channel(pch->thread);
@@ -2147,6 +2178,8 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
 
 	spin_unlock_irqrestore(&pch->lock, flags);
+	pm_runtime_mark_last_busy(pch->dmac->ddma.dev);
+	pm_runtime_put_autosuspend(pch->dmac->ddma.dev);
 }
 
 static enum dma_status
@@ -2162,6 +2195,15 @@ static void pl330_issue_pending(struct dma_chan *chan)
 	unsigned long flags;
 
 	spin_lock_irqsave(&pch->lock, flags);
+	if (list_empty(&pch->work_list)) {
+		/*
+		 * Warn on nothing pending. Empty submitted_list may
+		 * break our pm_runtime usage counter as it is
+		 * updated on work_list emptiness status.
+		 */
+		WARN_ON(list_empty(&pch->submitted_list));
+		pm_runtime_get_sync(pch->dmac->ddma.dev);
+	}
 	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
 	spin_unlock_irqrestore(&pch->lock, flags);
 
@@ -2739,6 +2781,12 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
 		pcfg->num_peri, pcfg->num_events);
 
+	pm_runtime_irq_safe(&adev->dev);
+	pm_runtime_use_autosuspend(&adev->dev);
+	pm_runtime_set_autosuspend_delay(&adev->dev, PL330_AUTOSUSPEND_DELAY);
+	pm_runtime_mark_last_busy(&adev->dev);
+	pm_runtime_put_autosuspend(&adev->dev);
+
 	return 0;
 probe_err3:
 	/* Idle the DMAC */
@@ -2765,6 +2813,8 @@ static int pl330_remove(struct amba_device *adev)
 	struct pl330_dmac *pl330 = amba_get_drvdata(adev);
 	struct dma_pl330_chan *pch, *_p;
 
+	pm_runtime_get_noresume(pl330->ddma.dev);
+
 	if (adev->dev.of_node)
 		of_dma_controller_free(adev->dev.of_node);
 
-- 
1.9.1

