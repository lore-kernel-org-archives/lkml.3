Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaIXQqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:46:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:49437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaIXQqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749219"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: [PATCH 02/27] dmaengine: ste_dma: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:44:52 +0530
Message-Id: <1411575342-31048-3-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/ste_dma40.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5fe5933..621b941 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1442,8 +1442,7 @@ static int d40_pause(struct d40_chan *d40c)
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
-	pm_runtime_put_autosuspend(d40c->base->dev);
+	pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1463,8 +1462,7 @@ static int d40_resume(struct d40_chan *d40c)
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
-	pm_runtime_put_autosuspend(d40c->base->dev);
+	pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1565,8 +1563,7 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
 
-			pm_runtime_mark_last_busy(d40c->base->dev);
-			pm_runtime_put_autosuspend(d40c->base->dev);
+			pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 		}
 
 		d40_desc_remove(d40d);
@@ -2045,18 +2042,15 @@ static int d40_free_dma(struct d40_chan *d40c)
 	else
 		d40c->base->lookup_phy_chans[phy->num] = NULL;
 
-	if (d40c->busy) {
-		pm_runtime_mark_last_busy(d40c->base->dev);
-		pm_runtime_put_autosuspend(d40c->base->dev);
-	}
+	if (d40c->busy)
+		pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 
 	d40c->busy = false;
 	d40c->phy_chan = NULL;
 	d40c->configured = false;
 out:
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
-	pm_runtime_put_autosuspend(d40c->base->dev);
+	pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 	return res;
 }
 
@@ -2457,8 +2451,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
 fail:
-	pm_runtime_mark_last_busy(d40c->base->dev);
-	pm_runtime_put_autosuspend(d40c->base->dev);
+	pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
 }
@@ -2618,12 +2611,9 @@ static void d40_terminate_all(struct dma_chan *chan)
 		chan_err(d40c, "Failed to stop channel\n");
 
 	d40_term_all(d40c);
-	pm_runtime_mark_last_busy(d40c->base->dev);
-	pm_runtime_put_autosuspend(d40c->base->dev);
-	if (d40c->busy) {
-		pm_runtime_mark_last_busy(d40c->base->dev);
-		pm_runtime_put_autosuspend(d40c->base->dev);
-	}
+	pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
+	if (d40c->busy)
+		pm_runtime_last_busy_and_autosuspend(d40c->base->dev);
 	d40c->busy = false;
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
-- 
1.7.0.4

