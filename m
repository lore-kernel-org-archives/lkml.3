Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab3DOHFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:05:38 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61293 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab3DOHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:05:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: ARM big LITTLE: put DT nodes after using them
Date: Mon, 15 Apr 2013 12:35:24 +0530
Message-Id: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT nodes should be put using of_node_put() to balance their usage counts. This
is not done properly in ARM's big LITTLE driver. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Rafael,

These are fixes for 3.10

 drivers/cpufreq/arm_big_little_dt.c | 43 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index 452ff46..44be311 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -31,22 +31,28 @@
 
 static int dt_init_opp_table(struct device *cpu_dev)
 {
-	struct device_node *np = NULL;
+	struct device_node *np, *parent;
 	int count = 0, ret;
 
-	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+	parent = of_find_node_by_path("/cpus");
+	if (!parent) {
+		pr_err("failed to find OF /cpus\n");
+		return -ENOENT;
+	}
+
+	for_each_child_of_node(parent, np) {
 		if (count++ != cpu_dev->id)
 			continue;
-		if (!of_get_property(np, "operating-points", NULL))
-			return -ENODATA;
-
-		cpu_dev->of_node = np;
-
-		ret = of_init_opp_table(cpu_dev);
-		if (ret)
-			return ret;
-
-		return 0;
+		if (!of_get_property(np, "operating-points", NULL)) {
+			ret = -ENODATA;
+		} else {
+			cpu_dev->of_node = np;
+			ret = of_init_opp_table(cpu_dev);
+		}
+		of_node_put(np);
+		of_node_put(parent);
+
+		return ret;
 	}
 
 	return -ENODEV;
@@ -54,15 +60,24 @@ static int dt_init_opp_table(struct device *cpu_dev)
 
 static int dt_get_transition_latency(struct device *cpu_dev)
 {
-	struct device_node *np = NULL;
+	struct device_node *np, *parent;
 	u32 transition_latency = CPUFREQ_ETERNAL;
 	int count = 0;
 
-	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+	parent = of_find_node_by_path("/cpus");
+	if (!parent) {
+		pr_err("failed to find OF /cpus\n");
+		return -ENOENT;
+	}
+
+	for_each_child_of_node(parent, np) {
 		if (count++ != cpu_dev->id)
 			continue;
 
 		of_property_read_u32(np, "clock-latency", &transition_latency);
+		of_node_put(np);
+		of_node_put(parent);
+
 		return 0;
 	}
 
-- 
1.7.12.rc2.18.g61b472e

