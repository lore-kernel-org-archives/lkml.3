Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3HTJab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:30:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35516 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3HTJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:26 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 16/19] cpufreq: arm_big_little: remove device tree parsing for cpu nodes
Date: Tue, 20 Aug 2013 10:30:18 +0100
Message-Id: <1376991021-12160-17-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:20.0302 (UTC) FILETIME=[E37BF2E0:01CE9D87]
X-MC-Unique: 113082010302502101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9Uc4R012251

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/arm_big_little_dt.c | 40 +++++++++++++------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index fd9e3ea..480c0bd 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -19,12 +19,11 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/opp.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -34,27 +33,13 @@
 /* get cpu node with valid operating-points */
 static struct device_node *get_cpu_node_with_valid_op(int cpu)
 {
-	struct device_node *np = NULL, *parent;
-	int count = 0;
+	struct device_node *np = of_cpu_device_node_get(cpu);
 
-	parent = of_find_node_by_path("/cpus");
-	if (!parent) {
-		pr_err("failed to find OF /cpus\n");
-		return NULL;
+	if (!of_get_property(np, "operating-points", NULL)) {
+		of_node_put(np);
+		np = NULL;
 	}
 
-	for_each_child_of_node(parent, np) {
-		if (count++ != cpu)
-			continue;
-		if (!of_get_property(np, "operating-points", NULL)) {
-			of_node_put(np);
-			np = NULL;
-		}
-
-		break;
-	}
-
-	of_node_put(parent);
 	return np;
 }
 
@@ -63,11 +48,12 @@ static int dt_init_opp_table(struct device *cpu_dev)
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
 
@@ -79,9 +65,11 @@ static int dt_get_transition_latency(struct device *cpu_dev)
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


