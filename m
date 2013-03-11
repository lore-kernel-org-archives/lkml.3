Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3CKHf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:35:26 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51354 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3CKHfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:35:24 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: cpufreq@vger.kernel.org
Cc: rjw@sisk.pl, rui.zhang@intel.com, andrew@lunn.ch, jason@lakedaemon.net,
        rob.lee@linaro.org, len.brown@intel.com, khilman@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] kirkwood: fix coccicheck warnings
Date: Mon, 11 Mar 2013 09:35:19 +0200
Message-Id: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/cpufreq/kirkwood-cpufreq.c |    8 +++-----
 drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
 drivers/thermal/kirkwood_thermal.c |    8 +++-----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 0e83e3c..6052476 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -175,11 +175,9 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Cannot get memory resource\n");
 		return -ENODEV;
 	}
-	priv.base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv.base) {
-		dev_err(&pdev->dev, "Cannot ioremap\n");
-		return -EADDRNOTAVAIL;
-	}
+	priv.base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv.base))
+		return PTR_ERR(priv.base);
 
 	np = of_find_node_by_path("/cpus/cpu@0");
 	if (!np)
diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
index 670aa1e..53aad73 100644
--- a/drivers/cpuidle/cpuidle-kirkwood.c
+++ b/drivers/cpuidle/cpuidle-kirkwood.c
@@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -EINVAL;
 
-	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ddr_operation_base)
-		return -EADDRNOTAVAIL;
+	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ddr_operation_base))
+		return PTR_ERR(ddr_operation_base);
 
 	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
 	device->state_count = KIRKWOOD_MAX_STATES;
diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
index 65cb4f0..e5500ed 100644
--- a/drivers/thermal/kirkwood_thermal.c
+++ b/drivers/thermal/kirkwood_thermal.c
@@ -85,11 +85,9 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->sensor = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv->sensor) {
-		dev_err(&pdev->dev, "Failed to request_ioremap memory\n");
-		return -EADDRNOTAVAIL;
-	}
+	priv->sensor = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->sensor))
+		return PTR_ERR(priv->sensor);
 
 	thermal = thermal_zone_device_register("kirkwood_thermal", 0, 0,
 					       priv, &ops, NULL, 0, 0);
-- 
1.7.9.5

