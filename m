Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaIYPGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:06:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57561 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbaIYPG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:06:29 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        <ben.dooks@codethink.co.uk>, <laurent.pinchart@ideasonboard.com>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 2/4] ARM: keystone: pm: switch to use generic pm domains
Date: Thu, 25 Sep 2014 18:05:35 +0300
Message-ID: <1411657537-25238-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
References: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches Keystone 2 PM code to use Generic PM domains
instead of PM  clock domains because of the lack of DT support
for the last.

Keystone 2 PM domain should be specified per device for which
Runtime PM has to be enabled and handles the list of functional clocks
to enable/disable device.

Example:
 qmss_domain: qmss_pm_controller {
	compatible = "ti,keystone-pm-controller";
	clocks = <&chipclk13>;
	#power-domain-cells = <0>;
 };

 qmss: qmss@2a40000 {
	compatible = "ti,keystone-navigator-qmss";
	...
	power-domains = <&qmss_domain>;

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/power/ti,keystone-gpc.txt  |  37 +++++++
 arch/arm/mach-keystone/Kconfig                     |   1 +
 arch/arm/mach-keystone/pm_domain.c                 | 123 ++++++++++++++++++++-
 3 files changed, 158 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/ti,keystone-gpc.txt

diff --git a/Documentation/devicetree/bindings/power/ti,keystone-gpc.txt b/Documentation/devicetree/bindings/power/ti,keystone-gpc.txt
new file mode 100644
index 0000000..adf63fb
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/ti,keystone-gpc.txt
@@ -0,0 +1,37 @@
+* TI Keystone 2 Generic PM Controller
+
+The TI Keystone 2 Generic PM Controller is responsible for Clock gating
+for each controlled IP module.
+
+Required properties:
+- compatible: Should be "ti,keystone-gpc"
+- clocks: Clock's phandles to devices in the power domain that need
+	to be enabled during domain power-up/down.
+- #power-domain-cells: Should be 0, see below:
+
+The gpc node is a power-controller as documented by the generic power domain
+bindings in Documentation/devicetree/bindings/power/power_domain.txt.
+
+The IP module is allowed to reuse clocks controlled by its power domain
+controller for internal proposes (get current clock rate for example).
+
+Example:
+
+	netcp_domain: netcp_pm_controller {
+		compatible = "ti,keystone-pm-controller";
+		clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
+		#power-domain-cells = <0>;
+	};
+
+	netcp: netcp@2090000 {
+		reg = <0x2620110 0x8>;
+		reg-names = "efuse";
+		...
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		power-domains = <&netcp_domain>;
+
+		clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
+		dma-coherent;
+	}
diff --git a/arch/arm/mach-keystone/Kconfig b/arch/arm/mach-keystone/Kconfig
index e571084..0132bde 100644
--- a/arch/arm/mach-keystone/Kconfig
+++ b/arch/arm/mach-keystone/Kconfig
@@ -9,6 +9,7 @@ config ARCH_KEYSTONE
 	select COMMON_CLK_KEYSTONE
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ZONE_DMA if ARM_LPAE
+	select PM_GENERIC_DOMAINS if PM
 	help
 	  Support for boards based on the Texas Instruments Keystone family of
 	  SoCs.
diff --git a/arch/arm/mach-keystone/pm_domain.c b/arch/arm/mach-keystone/pm_domain.c
index ca79dda..3cf6696 100644
--- a/arch/arm/mach-keystone/pm_domain.c
+++ b/arch/arm/mach-keystone/pm_domain.c
@@ -12,14 +12,17 @@
  * version 2, as published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/init.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_clock.h>
+#include <linux/pm_domain.h>
 #include <linux/platform_device.h>
-#include <linux/clk-provider.h>
 #include <linux/of.h>
 
 #ifdef CONFIG_PM_RUNTIME
+
 static int keystone_pm_runtime_suspend(struct device *dev)
 {
 	int ret;
@@ -66,6 +69,118 @@ static struct of_device_id of_keystone_table[] = {
 	{ /* end of list */ },
 };
 
+#ifdef CONFIG_PM_GENERIC_DOMAINS
+
+struct keystone_domain {
+	struct generic_pm_domain base;
+	struct device	*dev;
+};
+
+static int keystone_pm_domain_power_off(struct generic_pm_domain *genpd)
+{
+	int ret;
+	struct keystone_domain *dm = container_of(genpd,
+						  struct keystone_domain,
+						  base);
+
+	/* Enable reset clocks for all devices in the PU domain */
+	ret = pm_clk_suspend(dm->dev);
+	if (ret)
+		dev_err(dm->dev, "can't turn off clocks %d\n", ret);
+
+	return ret;
+}
+
+static int keystone_pm_domain_power_on(struct generic_pm_domain *genpd)
+{
+	int ret;
+	struct keystone_domain *dm = container_of(genpd,
+						  struct keystone_domain,
+						  base);
+
+	/* Disable reset clocks for all devices in the PU domain */
+	ret = pm_clk_resume(dm->dev);
+	if (ret)
+		dev_err(dm->dev, "can't turn on clocks %d\n", ret);
+
+	return ret;
+}
+
+static const struct keystone_domain keystone_domain = {
+	.base = {
+		.name = "keystone",
+		.power_off = keystone_pm_domain_power_off,
+		.power_on = keystone_pm_domain_power_on,
+		.power_off_latency_ns = 25000,
+		.power_on_latency_ns = 2000000,
+	},
+};
+
+static int keystone_pm_domain_probe(struct platform_device *pdev)
+{
+	struct clk *clk;
+	bool is_off;
+	int i = 0;
+	struct keystone_domain *domain;
+	int ret = 0;
+
+	domain = devm_kzalloc(&pdev->dev,
+			      sizeof(struct keystone_domain), GFP_KERNEL);
+	if (!domain)
+		return -ENOMEM;
+
+	domain->base = keystone_domain.base;
+	domain->base.of_node = pdev->dev.of_node;
+	domain->dev = &pdev->dev;
+
+	ret = pm_clk_create(&pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "pm_clk_create failed %d\n", ret);
+		return ret;
+	};
+
+	while ((clk = of_clk_get(pdev->dev.of_node, i++)) && !IS_ERR(clk)) {
+		ret = pm_clk_add_clk(&pdev->dev, clk);
+		if (ret) {
+			dev_err(&pdev->dev, "pm_clk_add_clk failed %d\n", ret);
+			goto clk_err;
+		};
+	}
+
+	is_off = IS_ENABLED(CONFIG_PM_RUNTIME);
+	if (is_off)
+		keystone_pm_domain_power_off(&domain->base);
+
+	pm_genpd_init(&domain->base, NULL, is_off);
+	return of_genpd_add_provider_simple(pdev->dev.of_node, &domain->base);
+
+clk_err:
+	pm_clk_destroy(&pdev->dev);
+	return ret;
+}
+
+static struct of_device_id keystone_pm_domain_dt_ids[] = {
+	{ .compatible = "ti,keystone-gpc" },
+	{ }
+};
+
+static struct platform_driver keystone_pm_domain_driver = {
+	.driver = {
+		.name = "ti,keystone-gpc",
+		.owner = THIS_MODULE,
+		.of_match_table = keystone_pm_domain_dt_ids,
+	},
+	.probe = keystone_pm_domain_probe,
+};
+
+static int __init keystone_pm_domain_init(void)
+{
+	return platform_driver_register(&keystone_pm_domain_driver);
+}
+#else
+static int __init keystone_pm_domain_init(void) { return 0; }
+#endif /* CONFIG_PM_GENERIC_DOMAINS */
+
 int __init keystone_pm_runtime_init(void)
 {
 	struct device_node *np;
@@ -74,7 +189,9 @@ int __init keystone_pm_runtime_init(void)
 	if (!np)
 		return 0;
 
-	pm_clk_add_notifier(&platform_bus_type, &platform_domain_notifier);
+	/* TODO: remove clock_ops code
+	 * pm_clk_add_notifier(&platform_bus_type, &platform_domain_notifier);
+	 */
 
-	return 0;
+	return keystone_pm_domain_init();
 }
-- 
1.9.1

