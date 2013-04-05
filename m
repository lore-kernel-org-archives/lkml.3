Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161118Ab3DEEWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:22:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57677 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3DEEWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:22:01 -0400
From: Nishanth Menon <nm@ti.com>
To: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] cpufreq: cpufreq-cpu0: defer probe when regulator is not ready
Date: Thu, 4 Apr 2013 23:21:48 -0500
Message-ID: <1365135708-23886-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365135708-23886-1-git-send-email-nm@ti.com>
References: <1365135708-23886-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_get will now return -EPROBE_DEFER when the cpu0-supply
node is present, but the regulator is not yet registered.

It is possible for this to occur when the regulator registration
by itself might be defered due to some dependent interface not
yet instantiated. For example: an regulator which uses I2C and GPIO
might need both systems available before proceeding, in this case,
the regulator might defer it's registration.

However, the cpufreq-cpu0 driver assumes that any un-successful return
result is equivalent of failure.

When the regulator_get returns failure other than -EPROBE_DEFER, it
makes sense to assume that supply node is not present and proceed
with the assumption that only clock control is necessary in the
platform.

With this change, we can now handle the following conditions:
a) cpu0-supply binding is not present, regulator_get will return
appropriate error result, resulting in cpufreq-cpu0 driver controlling
just the clock.
b) cpu0-supply binding is present, regulator_get returns -EPROBE_DEFER,
we retry resulting in cpufreq-cpu0 driver registering later once the
regulator is available.
c) cpu0-supply binding is present, regulator_get returns -EPROBE_DEFER,
however, regulator never registers, we retry until cpufreq-cpu0
driver fails to register pointing at device tree information bug.
However, in this case, the fact that cpufreq-cpu0 operates with clock
only when the DT binding clearly indicates need of a supply is a bug of
it's own.
d) cpu0-supply gets an regulator at probe - cpufreq-cpu0 driver controls
both the clock and regulator

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4e5b7fb..55fec7c 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -194,6 +194,20 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	cpu_dev = &pdev->dev;
 	cpu_dev->of_node = np;
 
+	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
+	if (IS_ERR(cpu_reg)) {
+		/*
+		 * If cpu0 regulator supply node is present, but regulator is
+		 * not yet registered, we should try defering probe.
+		 */
+		if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
+			dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
+			return -EPROBE_DEFER;
+		}
+		pr_err("failed to get cpu0 regulator: %ld\n", PTR_ERR(cpu_reg));
+		cpu_reg = NULL;
+	}
+
 	cpu_clk = devm_clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
 		ret = PTR_ERR(cpu_clk);
@@ -201,12 +215,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_put_node;
 	}
 
-	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
-	if (IS_ERR(cpu_reg)) {
-		pr_warn("failed to get cpu0 regulator\n");
-		cpu_reg = NULL;
-	}
-
 	ret = of_init_opp_table(cpu_dev);
 	if (ret) {
 		pr_err("failed to init OPP table: %d\n", ret);
-- 
1.7.9.5

