Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbbAFQhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:37:46 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60784 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbbAFQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:42 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 2/9] coresight-etb: Adding runtime PM awareness
Date: Tue,  6 Jan 2015 09:37:06 -0700
Message-Id: <1420562233-2015-3-git-send-email-mathieu.poirier@linaro.org>
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
 drivers/coresight/coresight-etb10.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/coresight/coresight-etb10.c b/drivers/coresight/coresight-etb10.c
index c922d4aded8a..71fd6cdba21c 100644
--- a/drivers/coresight/coresight-etb10.c
+++ b/drivers/coresight/coresight-etb10.c
@@ -26,6 +26,7 @@
 #include <linux/seq_file.h>
 #include <linux/coresight.h>
 #include <linux/amba/bus.h>
+#include <linux/pm_runtime.h>
 
 #include "coresight-priv.h"
 
@@ -92,17 +93,11 @@ struct etb_drvdata {
 
 static unsigned int etb_get_buffer_depth(struct etb_drvdata *drvdata)
 {
-	int ret;
 	u32 depth = 0;
 
-	ret = clk_prepare_enable(drvdata->clk);
-	if (ret)
-		return ret;
-
 	/* RO registers don't need locking */
 	depth = readl_relaxed(drvdata->base + ETB_RAM_DEPTH_REG);
 
-	clk_disable_unprepare(drvdata->clk);
 	return depth;
 }
 
@@ -144,6 +139,7 @@ static int etb_enable(struct coresight_device *csdev)
 	if (ret)
 		return ret;
 
+	pm_runtime_get_sync(drvdata->dev);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	etb_enable_hw(drvdata);
 	drvdata->enable = true;
@@ -250,8 +246,9 @@ static void etb_disable(struct coresight_device *csdev)
 	etb_disable_hw(drvdata);
 	etb_dump_hw(drvdata);
 	drvdata->enable = false;
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
 
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(drvdata->dev);
 	clk_disable_unprepare(drvdata->clk);
 
 	dev_info(drvdata->dev, "ETB disabled\n");
@@ -266,10 +263,16 @@ static const struct coresight_ops etb_cs_ops = {
 	.sink_ops	= &etb_sink_ops,
 };
 
-static void etb_dump(struct etb_drvdata *drvdata)
+static int etb_dump(struct etb_drvdata *drvdata)
 {
+	int ret;
 	unsigned long flags;
 
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	pm_runtime_get_sync(drvdata->dev);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	if (drvdata->enable) {
 		etb_disable_hw(drvdata);
@@ -277,8 +280,11 @@ static void etb_dump(struct etb_drvdata *drvdata)
 		etb_enable_hw(drvdata);
 	}
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	pm_runtime_put_sync(drvdata->dev);
+	clk_disable_unprepare(drvdata->clk);
 
 	dev_info(drvdata->dev, "ETB dumped\n");
+	return 0;
 }
 
 static int etb_open(struct inode *inode, struct file *file)
@@ -296,11 +302,14 @@ static int etb_open(struct inode *inode, struct file *file)
 static ssize_t etb_read(struct file *file, char __user *data,
 				size_t len, loff_t *ppos)
 {
+	int ret;
 	u32 depth;
 	struct etb_drvdata *drvdata = container_of(file->private_data,
 						   struct etb_drvdata, miscdev);
 
-	etb_dump(drvdata);
+	ret = etb_dump(drvdata);
+	if (ret)
+		return ret;
 
 	depth = drvdata->buffer_depth;
 	if (*ppos + len > depth * 4)
@@ -349,6 +358,7 @@ static ssize_t status_show(struct device *dev,
 	if (ret)
 		goto out;
 
+	pm_runtime_get_sync(dev);
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	CS_UNLOCK(drvdata->base);
 
@@ -363,7 +373,7 @@ static ssize_t status_show(struct device *dev,
 
 	CS_LOCK(drvdata->base);
 	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-
+	pm_runtime_put_sync(dev);
 	clk_disable_unprepare(drvdata->clk);
 
 	return sprintf(buf,
@@ -486,6 +496,9 @@ static int etb_probe(struct amba_device *adev, const struct amba_id *id)
 	if (ret)
 		goto err_misc_register;
 
+	pm_runtime_set_suspended(dev);
+	pm_runtime_put_noidle(dev);
+
 	dev_info(dev, "ETB initialized\n");
 	return 0;
 
-- 
1.9.1

