Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3GOKWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:22:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41636 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3GOKW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:29 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 07/11] cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
Date: Mon, 15 Jul 2013 11:22:08 +0100
Message-Id: <1373883732-26303-8-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:24.0081 (UTC) FILETIME=[3287CC10:01CE8145]
X-MC-Unique: 113071511222713501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FAN57r007626

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/cpufreq-cpu0.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ad1fde2..5b05c26 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -174,29 +174,17 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
 
 static int cpu0_cpufreq_probe(struct platform_device *pdev)
 {
-	struct device_node *np, *parent;
+	struct device_node *np;
 	int ret;
 
-	parent = of_find_node_by_path("/cpus");
-	if (!parent) {
-		pr_err("failed to find OF /cpus\n");
-		return -ENOENT;
-	}
-
-	for_each_child_of_node(parent, np) {
-		if (of_get_property(np, "operating-points", NULL))
-			break;
-	}
+	cpu_dev = &pdev->dev;
 
+	np = of_node_get(cpu_dev->of_node);
 	if (!np) {
 		pr_err("failed to find cpu0 node\n");
-		ret = -ENOENT;
-		goto out_put_parent;
+		return -ENOENT;
 	}
 
-	cpu_dev = &pdev->dev;
-	cpu_dev->of_node = np;
-
 	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
 	if (IS_ERR(cpu_reg)) {
 		/*
@@ -269,15 +257,12 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	of_node_put(np);
-	of_node_put(parent);
 	return 0;
 
 out_free_table:
 	opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_put_node:
 	of_node_put(np);
-out_put_parent:
-	of_node_put(parent);
 	return ret;
 }
 
-- 
1.8.1.2


