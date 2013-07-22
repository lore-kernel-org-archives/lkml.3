Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3GVLfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:35:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36592 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab3GVLcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:32:45 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 09/16] cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
Date: Mon, 22 Jul 2013 12:32:20 +0100
Message-Id: <1374492747-13879-10-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:32:42.0640 (UTC) FILETIME=[2DE11100:01CE86CF]
X-MC-Unique: 113072212324314401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBZdKF009677

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
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


