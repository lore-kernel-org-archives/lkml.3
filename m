Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3GQOIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:08:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56060 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3GQOGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:06:47 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH v2 12/15] cpufreq: arm_big_little: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:21 +0100
Message-Id: <1374069984-20567-13-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:43.0524 (UTC) FILETIME=[DDCF5040:01CE82F6]
X-MC-Unique: 113071715064511001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE8NL5026345

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
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


