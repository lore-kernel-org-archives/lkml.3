Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbbAFQh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:37:56 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47987 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbbAFQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:53 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 6/9] coresight-etm3x: Fixing suspend/wake modes
Date: Tue,  6 Jan 2015 09:37:10 -0700
Message-Id: <1420562233-2015-7-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This patch makes sure power is managed properly during power state
transitions.  Checks are introduced to make sure HW access functions
aren't called uselessly to avoid wasting power and accessing
blocks that may be powered down.

Lastly the CPU_ONLINE state has been removed from the cpu callback
as it wasn't useful anymore.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/coresight-etm.h   |  4 ++--
 drivers/coresight/coresight-etm3x.c | 48 ++++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/coresight/coresight-etm.h b/drivers/coresight/coresight-etm.h
index 501c5fac8a45..a0e30ca2e32d 100644
--- a/drivers/coresight/coresight-etm.h
+++ b/drivers/coresight/coresight-etm.h
@@ -148,7 +148,7 @@
  * @arch:	ETM/PTM version number.
  * @use_cpu14:	true if management registers need to be accessed via CP14.
  * @enable:	is this ETM/PTM currently tracing.
- * @sticky_enable: true if ETM base configuration has been done.
+ * @suspended:	is the CPU associated to the ETM/PTM suspended?
  * @boot_enable:true if we should start tracing at boot time.
  * @os_unlock:	true if access to management registers is allowed.
  * @nr_addr_cmp:Number of pairs of address comparators as found in ETMCCR.
@@ -200,7 +200,7 @@ struct etm_drvdata {
 	u8				arch;
 	bool				use_cp14;
 	bool				enable;
-	bool				sticky_enable;
+	bool				suspended;
 	bool				boot_enable;
 	bool				os_unlock;
 	u8				nr_addr_cmp;
diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
index 7df9ffc51501..e09c3ef76d16 100644
--- a/drivers/coresight/coresight-etm3x.c
+++ b/drivers/coresight/coresight-etm3x.c
@@ -254,6 +254,12 @@ static void etm_enable_hw(void *info)
 	u32 etmcr;
 	struct etm_drvdata *drvdata = info;
 
+	if (clk_prepare_enable(drvdata->clk)) {
+		dev_dbg(drvdata->dev, "cpu: %d can't enable hw\n",
+			drvdata->cpu);
+		return;
+	}
+
 	pm_runtime_get_sync(drvdata->dev);
 	CS_UNLOCK(drvdata->base);
 
@@ -314,6 +320,8 @@ static void etm_enable_hw(void *info)
 	etm_clr_prog(drvdata);
 	CS_LOCK(drvdata->base);
 
+	drvdata->suspended = false;
+
 	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
 }
 
@@ -355,14 +363,12 @@ out:
 static int etm_enable(struct coresight_device *csdev)
 {
 	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-	int ret;
-
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		goto err_clk;
+	int ret = 0;
 
 	spin_lock(&drvdata->spinlock);
 
+	if (drvdata->enable)
+		goto out;
 	/*
 	 * Configure the ETM only if the CPU is online.  If it isn't online
 	 * hw configuration will take place when 'CPU_STARTING' is received
@@ -372,20 +378,17 @@ static int etm_enable(struct coresight_device *csdev)
 		ret = smp_call_function_single(drvdata->cpu,
 					       etm_enable_hw, drvdata, 1);
 		if (ret)
-			goto err;
+			goto out;
 	}
 
 	drvdata->enable = true;
-	drvdata->sticky_enable = true;
-
 	spin_unlock(&drvdata->spinlock);
 
 	dev_info(drvdata->dev, "ETM tracing enabled\n");
 	return 0;
-err:
+out:
 	spin_unlock(&drvdata->spinlock);
 	clk_disable_unprepare(drvdata->clk);
-err_clk:
 	return ret;
 }
 
@@ -397,6 +400,9 @@ static void etm_disable_hw(void *info)
 	CS_UNLOCK(drvdata->base);
 	etm_set_prog(drvdata);
 
+	if (!drvdata->enable)
+		return;
+
 	/* Program trace enable to low by using always false event */
 	etm_writel(drvdata, ETM_HARD_WIRE_RES_A | ETM_EVENT_NOT_A, ETMTEEVR);
 
@@ -409,6 +415,9 @@ static void etm_disable_hw(void *info)
 	etm_set_pwrdwn(drvdata);
 	CS_LOCK(drvdata->base);
 	pm_runtime_put_sync(drvdata->dev);
+	clk_disable_unprepare(drvdata->clk);
+
+	drvdata->suspended = true;
 
 	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
 }
@@ -426,18 +435,20 @@ static void etm_disable(struct coresight_device *csdev)
 	get_online_cpus();
 	spin_lock(&drvdata->spinlock);
 
+	if (!drvdata->enable)
+		goto out;
 	/*
 	 * Executing etm_disable_hw on the cpu whose ETM is being disabled
 	 * ensures that register writes occur when cpu is powered.
 	 */
-	smp_call_function_single(drvdata->cpu, etm_disable_hw, drvdata, 1);
+	if (!drvdata->suspended)
+		smp_call_function_single(drvdata->cpu,
+					 etm_disable_hw, drvdata, 1);
 	drvdata->enable = false;
-
+out:
 	spin_unlock(&drvdata->spinlock);
 	put_online_cpus();
 
-	clk_disable_unprepare(drvdata->clk);
-
 	dev_info(drvdata->dev, "ETM tracing disabled\n");
 }
 
@@ -1674,14 +1685,7 @@ static int etm_cpu_callback(struct notifier_block *nfb, unsigned long action,
 			etm_enable_hw(etmdrvdata[cpu]);
 		spin_unlock(&etmdrvdata[cpu]->spinlock);
 		break;
-
-	case CPU_ONLINE:
-		if (etmdrvdata[cpu]->boot_enable &&
-		    !etmdrvdata[cpu]->sticky_enable)
-			coresight_enable(etmdrvdata[cpu]->csdev);
-		break;
-
-	case CPU_DYING:
+	case CPU_DEAD:
 		spin_lock(&etmdrvdata[cpu]->spinlock);
 		if (etmdrvdata[cpu]->enable)
 			etm_disable_hw(etmdrvdata[cpu]);
-- 
1.9.1

