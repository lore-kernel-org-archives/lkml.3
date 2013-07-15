Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3GOKXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:23:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41510 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3GOKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:27 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 08/11] cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
Date: Mon, 15 Jul 2013 11:22:09 +0100
Message-Id: <1373883732-26303-9-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:24.0909 (UTC) FILETIME=[330623D0:01CE8145]
X-MC-Unique: 113071511222512601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FANqR3007638

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/highbank-cpufreq.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index b61b5a3..794123f 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -69,23 +69,17 @@ static int hb_cpufreq_driver_init(void)
 	if (!of_machine_is_compatible("calxeda,highbank"))
 		return -ENODEV;
 
-	for_each_child_of_node(of_find_node_by_path("/cpus"), np)
-		if (of_get_property(np, "operating-points", NULL))
-			break;
-
-	if (!np) {
-		pr_err("failed to find highbank cpufreq node\n");
-		return -ENOENT;
-	}
-
 	cpu_dev = get_cpu_device(0);
 	if (!cpu_dev) {
 		pr_err("failed to get highbank cpufreq device\n");
-		ret = -ENODEV;
-		goto out_put_node;
+		return -ENODEV;
 	}
 
-	cpu_dev->of_node = np;
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		pr_err("failed to find highbank cpufreq node\n");
+		return -ENOENT;
+	}
 
 	cpu_clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
-- 
1.8.1.2


