Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3CKPOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:14:12 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38395 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3CKPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:14:10 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: cpufreq@vger.kernel.org
Cc: rjw@sisk.pl, jason@lakedaemon.net, andrew@lunn.ch,
        daniel.lezcano@linaro.org, len.brown@intel.com, rob.lee@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH v2] kirkwood: fix coccicheck warnings
Date: Mon, 11 Mar 2013 17:14:02 +0200
Message-Id: <1363014842-11659-1-git-send-email-silviupopescu1990@gmail.com>
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
 2 files changed, 6 insertions(+), 8 deletions(-)

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
-- 
1.7.9.5

