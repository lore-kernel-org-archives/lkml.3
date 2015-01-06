Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbbAFQhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:37:42 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46206 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbbAFQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:41 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 1/9] coresight-etm3x: Adding runtime PM awareness
Date: Tue,  6 Jan 2015 09:37:05 -0700
Message-Id: <1420562233-2015-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Using the runtime API whenever HW access is required.  As
such and by associating a coresight component to a power
domain in the device tree, faults associated to accessing
unpowered devices are mitigated.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/coresight-etm3x.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
index d9e3ed6aa857..7df9ffc51501 100644
--- a/drivers/coresight/coresight-etm3x.c
+++ b/drivers/coresight/coresight-etm3x.c
@@ -30,6 +30,7 @@
 #include <linux/amba/bus.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 #include <asm/sections.h>
 
 #include "coresight-etm.h"
@@ -148,7 +149,8 @@ static void etm_clr_pwrup(struct etm_drvdata *drvdata)
  * method where we have to account for CP14 configurations.
 
  * Return: 0 as soon as the bit has taken the desired state or -EAGAIN if
- * TIMEOUT_US has elapsed, which ever happens first.
+ * TIMEOUT_US has elapsed, which ever happens first.  The power is assumed to be
+ * switched on by the caller.
  */
 
 static int coresight_timeout_etm(struct etm_drvdata *drvdata, u32 offset,
@@ -181,7 +183,6 @@ static int coresight_timeout_etm(struct etm_drvdata *drvdata, u32 offset,
 	return -EAGAIN;
 }
 
-
 static void etm_set_prog(struct etm_drvdata *drvdata)
 {
 	u32 etmcr;
@@ -253,6 +254,7 @@ static void etm_enable_hw(void *info)
 	u32 etmcr;
 	struct etm_drvdata *drvdata = info;
 
+	pm_runtime_get_sync(drvdata->dev);
 	CS_UNLOCK(drvdata->base);
 
 	/* Turn engine on */
@@ -320,6 +322,7 @@ static int etm_trace_id_simple(struct etm_drvdata *drvdata)
 	if (!drvdata->enable)
 		return drvdata->traceid;
 
+	/* Assuming caller has switched on power */
 	return (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
 }
 
@@ -335,6 +338,7 @@ static int etm_trace_id(struct coresight_device *csdev)
 	if (clk_prepare_enable(drvdata->clk))
 		goto out;
 
+	pm_runtime_get_sync(drvdata->dev);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	CS_UNLOCK(drvdata->base);
@@ -342,6 +346,7 @@ static int etm_trace_id(struct coresight_device *csdev)
 	CS_LOCK(drvdata->base);
 
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(drvdata->dev);
 	clk_disable_unprepare(drvdata->clk);
 out:
 	return trace_id;
@@ -403,6 +408,7 @@ static void etm_disable_hw(void *info)
 
 	etm_set_pwrdwn(drvdata);
 	CS_LOCK(drvdata->base);
+	pm_runtime_put_sync(drvdata->dev);
 
 	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
 }
@@ -488,6 +494,7 @@ static ssize_t etmsr_show(struct device *dev,
 	if (ret)
 		return ret;
 
+	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	CS_UNLOCK(drvdata->base);
 
@@ -495,6 +502,7 @@ static ssize_t etmsr_show(struct device *dev,
 
 	CS_LOCK(drvdata->base);
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(dev->parent);
 	clk_disable_unprepare(drvdata->clk);
 
 	return sprintf(buf, "%#lx\n", val);
@@ -1330,6 +1338,7 @@ static ssize_t seq_curr_state_show(struct device *dev,
 	if (ret)
 		return ret;
 
+	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	CS_UNLOCK(drvdata->base);
@@ -1337,6 +1346,7 @@ static ssize_t seq_curr_state_show(struct device *dev,
 	CS_LOCK(drvdata->base);
 
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(dev->parent);
 	clk_disable_unprepare(drvdata->clk);
 out:
 	return sprintf(buf, "%#lx\n", val);
@@ -1525,6 +1535,7 @@ static ssize_t status_show(struct device *dev,
 	if (ret)
 		return ret;
 
+	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
 	CS_UNLOCK(drvdata->base);
@@ -1550,6 +1561,7 @@ static ssize_t status_show(struct device *dev,
 	CS_LOCK(drvdata->base);
 
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(dev->parent);
 	clk_disable_unprepare(drvdata->clk);
 
 	return ret;
@@ -1572,6 +1584,7 @@ static ssize_t traceid_show(struct device *dev,
 	if (ret)
 		return ret;
 
+	pm_runtime_get_sync(dev->parent);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	CS_UNLOCK(drvdata->base);
 
@@ -1579,6 +1592,7 @@ static ssize_t traceid_show(struct device *dev,
 
 	CS_LOCK(drvdata->base);
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(dev->parent);
 	clk_disable_unprepare(drvdata->clk);
 out:
 	return sprintf(buf, "%#lx\n", val);
@@ -1860,6 +1874,9 @@ static int etm_probe(struct amba_device *adev, const struct amba_id *id)
 	if (boot_enable) {
 		coresight_enable(drvdata->csdev);
 		drvdata->boot_enable = true;
+	} else {
+		pm_runtime_set_suspended(dev);
+		pm_runtime_put_noidle(dev);
 	}
 
 	return 0;
-- 
1.9.1

