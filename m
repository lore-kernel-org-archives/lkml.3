Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaI2Oji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:39:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47115 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaI2OjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:39:02 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v1 2/4] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 29 Sep 2014 17:38:17 +0300
Message-ID: <1412001499-19369-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com>
References: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches Keystone 2 PM code to use Generic PM domains
instead of PM clock domains because of the lack of DT support
for the last.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/power/ti,keystone-gpc.txt  |  31 ++++++
 arch/arm/mach-keystone/Kconfig                     |   1 +
 arch/arm/mach-keystone/pm_domain.c                 | 115 ++++++++++++++-------
 3 files changed, 110 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/ti,keystone-gpc.txt

diff --git a/Documentation/devicetree/bindings/power/ti,keystone-gpc.txt b/Documentation/devicetree/bindings/power/ti,keystone-gpc.txt
new file mode 100644
index 0000000..43af1fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/ti,keystone-gpc.txt
@@ -0,0 +1,31 @@
+* TI Keystone 2 Generic PM Controller
+
+The TI Keystone 2 Generic PM Controller is responsible for Clock gating
+for each controlled IP module.
+
+Required properties:
+- compatible: Should be "ti,keystone-gpc"
+- #power-domain-cells: Should be 0, see below:
+
+The gpc node is a power-controller as documented by the generic power domain
+bindings in Documentation/devicetree/bindings/power/power_domain.txt.
+
+Example:
+
+	pm_controller: pm-controller {
+		compatible = "ti,keystone-gpc";
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
+		power-domains = <&pm_controller>;
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
index ca79dda..3eb5257 100644
--- a/arch/arm/mach-keystone/pm_domain.c
+++ b/arch/arm/mach-keystone/pm_domain.c
@@ -12,69 +12,110 @@
  * version 2, as published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
-#include <linux/pm_runtime.h>
 #include <linux/pm_clock.h>
+#include <linux/pm_domain.h>
 #include <linux/platform_device.h>
-#include <linux/clk-provider.h>
 #include <linux/of.h>
 
-#ifdef CONFIG_PM_RUNTIME
-static int keystone_pm_runtime_suspend(struct device *dev)
+#ifdef CONFIG_PM_GENERIC_DOMAINS
+
+struct keystone_domain {
+	struct generic_pm_domain base;
+	struct device	*dev;
+};
+
+void keystone_pm_domain_attach_dev(struct device *dev)
 {
+	struct clk *clk;
 	int ret;
+	int i = 0;
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	ret = pm_generic_runtime_suspend(dev);
-	if (ret)
-		return ret;
-
-	ret = pm_clk_suspend(dev);
+	ret = pm_clk_create(dev);
 	if (ret) {
-		pm_generic_runtime_resume(dev);
-		return ret;
+		dev_err(dev, "pm_clk_create failed %d\n", ret);
+		return;
+	};
+
+	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+		ret = pm_clk_add_clk(dev, clk);
+		if (ret) {
+			dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
+			goto clk_err;
+		};
 	}
 
-	return 0;
+	if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
+		ret = pm_clk_resume(dev);
+		if (ret) {
+			dev_err(dev, "pm_clk_resume failed %d\n", ret);
+			goto clk_err;
+		};
+	}
+	return;
+
+clk_err:
+	pm_clk_destroy(dev);
 }
 
-static int keystone_pm_runtime_resume(struct device *dev)
+void keystone_pm_domain_detach_dev(struct device *dev)
 {
 	dev_dbg(dev, "%s\n", __func__);
-
-	pm_clk_resume(dev);
-
-	return pm_generic_runtime_resume(dev);
+	pm_clk_destroy(dev);
 }
-#endif
 
-static struct dev_pm_domain keystone_pm_domain = {
-	.ops = {
-		SET_RUNTIME_PM_OPS(keystone_pm_runtime_suspend,
-				   keystone_pm_runtime_resume, NULL)
-		USE_PLATFORM_PM_SLEEP_OPS
+static const struct keystone_domain keystone_domain = {
+	.base = {
+		.name = "keystone",
+		.attach_dev = keystone_pm_domain_attach_dev,
+		.detach_dev = keystone_pm_domain_detach_dev,
+		.dev_ops = {
+			.stop = pm_clk_suspend,
+			.start = pm_clk_resume,
+		},
+		.power_off_latency_ns = 25000,
+		.power_on_latency_ns = 2000000,
 	},
 };
 
-static struct pm_clk_notifier_block platform_domain_notifier = {
-	.pm_domain = &keystone_pm_domain,
+static int keystone_pm_domain_probe(struct platform_device *pdev)
+{
+	struct keystone_domain *domain;
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
+	pm_genpd_init(&domain->base, NULL, false);
+	return of_genpd_add_provider_simple(pdev->dev.of_node, &domain->base);
+}
+
+static struct of_device_id keystone_pm_domain_dt_ids[] = {
+	{ .compatible = "ti,keystone-gpc" },
+	{ }
 };
 
-static struct of_device_id of_keystone_table[] = {
-	{.compatible = "ti,keystone"},
-	{ /* end of list */ },
+static struct platform_driver keystone_pm_domain_driver = {
+	.driver = {
+		.name = "ti,keystone-gpc",
+		.owner = THIS_MODULE,
+		.of_match_table = keystone_pm_domain_dt_ids,
+	},
+	.probe = keystone_pm_domain_probe,
 };
 
 int __init keystone_pm_runtime_init(void)
 {
-	struct device_node *np;
-
-	np = of_find_matching_node(NULL, of_keystone_table);
-	if (!np)
-		return 0;
-
-	pm_clk_add_notifier(&platform_bus_type, &platform_domain_notifier);
-
-	return 0;
+	return platform_driver_register(&keystone_pm_domain_driver);
 }
+#else
+int __init keystone_pm_runtime_init(void) { return 0; }
+#endif /* CONFIG_PM_GENERIC_DOMAINS */
-- 
1.9.1

