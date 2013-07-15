Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3GOKWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:22:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41807 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3GOKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:32 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 11/11] cpufreq: arm_big_little: remove device tree parsing for cpu nodes
Date: Mon, 15 Jul 2013 11:22:12 +0100
Message-Id: <1373883732-26303-12-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:27.0424 (UTC) FILETIME=[3485E600:01CE8145]
X-MC-Unique: 113071511223002501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FAMnbA007622

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/arm_big_little_dt.c | 39 ++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index fd9e3ea..d2648d1 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -34,27 +34,19 @@
 /* get cpu node with valid operating-points */
 static struct device_node *get_cpu_node_with_valid_op(int cpu)
 {
-	struct device_node *np = NULL, *parent;
-	int count = 0;
+	struct device *cpu_dev = get_cpu_device(cpu);
+	struct device_node *np;
 
-	parent = of_find_node_by_path("/cpus");
-	if (!parent) {
-		pr_err("failed to find OF /cpus\n");
+	if (!cpu_dev) {
+		pr_err("failed to get cpu device\n");
 		return NULL;
 	}
-
-	for_each_child_of_node(parent, np) {
-		if (count++ != cpu)
-			continue;
-		if (!of_get_property(np, "operating-points", NULL)) {
-			of_node_put(np);
-			np = NULL;
-		}
-
-		break;
+	np = of_node_get(cpu_dev->of_node);
+	if (!of_get_property(np, "operating-points", NULL)) {
+		of_node_put(np);
+		np = NULL;
 	}
 
-	of_node_put(parent);
 	return np;
 }
 
@@ -63,11 +55,12 @@ static int dt_init_opp_table(struct device *cpu_dev)
 	struct device_node *np;
 	int ret;
 
-	np = get_cpu_node_with_valid_op(cpu_dev->id);
-	if (!np)
-		return -ENODATA;
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		pr_err("failed to find cpu%d node\n", cpu_dev->id);
+		return -ENOENT;
+	}
 
-	cpu_dev->of_node = np;
 	ret = of_init_opp_table(cpu_dev);
 	of_node_put(np);
 
@@ -79,9 +72,11 @@ static int dt_get_transition_latency(struct device *cpu_dev)
 	struct device_node *np;
 	u32 transition_latency = CPUFREQ_ETERNAL;
 
-	np = get_cpu_node_with_valid_op(cpu_dev->id);
-	if (!np)
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		pr_info("Failed to find cpu node. Use CPUFREQ_ETERNAL transition latency\n");
 		return CPUFREQ_ETERNAL;
+	}
 
 	of_property_read_u32(np, "clock-latency", &transition_latency);
 	of_node_put(np);
-- 
1.8.1.2


