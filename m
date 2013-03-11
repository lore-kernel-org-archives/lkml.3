Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3CKXFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:05:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38149 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:05:38 -0400
From: Nishanth Menon <nm@ti.com>
To: cpufreq <cpufreq@vger.kernel.org>
Cc: Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 1/2] cpufreq: cpufreq-cpu0: support for clock which are not in DT yet.
Date: Mon, 11 Mar 2013 18:05:29 -0500
Message-Id: <1363043130-30270-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363043130-30270-1-git-send-email-nm@ti.com>
References: <1363043130-30270-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On certain SoCs like variants of OMAP, the clock conversion to DT
is not complete. In short, the ability to:
cpus {
    cpu@0 {
	clocks = <&cpuclk 0>;
    };
 };
is not possible. However, the clock node is registered.
Allow for clk names to be provided as string so as to be used when needed.
Example (for OMAP3630):
cpus {
    cpu@0 {
	clock-name = "cpufreq_ck";
    };
 };

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-omap@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |    3 +++
 drivers/cpufreq/cpufreq-cpu0.c                     |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index 4416ccc..f180963 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -12,6 +12,9 @@ Required properties:
   for details
 
 Optional properties:
+- clock-name: If the clock is not converted to device tree, then describe
+  the clock name as a string. This may also be replaced with clocks=<&cpuclk>
+  cpu clocks has already been converted to device tree.
 - clock-latency: Specify the possible maximum transition latency for clock,
   in unit of nanoseconds.
 - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4e5b7fb..28223c9 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -180,6 +180,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 {
 	struct device_node *np;
 	int ret;
+	const char *clk_name = NULL;
 
 	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
 		if (of_get_property(np, "operating-points", NULL))
@@ -194,7 +195,10 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	cpu_dev = &pdev->dev;
 	cpu_dev->of_node = np;
 
-	cpu_clk = devm_clk_get(cpu_dev, NULL);
+	/* If clocks are not in DT yet, allow to define it part of CPU node */
+	of_property_read_string(np, "clock-name", &clk_name);
+
+	cpu_clk = devm_clk_get(cpu_dev, clk_name);
 	if (IS_ERR(cpu_clk)) {
 		ret = PTR_ERR(cpu_clk);
 		pr_err("failed to get cpu0 clock: %d\n", ret);
-- 
1.7.9.5

