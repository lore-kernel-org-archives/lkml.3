Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3HPWWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:22:15 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52680 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3HPWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:22:11 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 3/4] ARM: tegra: Call of_platform_populate() early
Date: Fri, 16 Aug 2013 22:39:22 +0200
Message-Id: <1376685563-1053-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376685563-1053-1-git-send-email-treding@nvidia.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new early device registration functionality it is now possible
to register devices much earlier in the boot process. Move the call to
of_platform_populate() from tegra_dt_init() to tegra_dt_init_irq() and
allow drivers that require to be run early to access the struct device
associated with a device node.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-tegra/common.c | 33 +++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/tegra.c  | 32 --------------------------------
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..24dc09b 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -25,6 +25,9 @@
 #include <linux/reboot.h>
 #include <linux/irqchip.h>
 #include <linux/clk-provider.h>
+#include <linux/sys_soc.h>
+#include <linux/slab.h>
+#include <linux/of_platform.h>
 
 #include <asm/hardware/cache-l2x0.h>
 
@@ -61,6 +64,36 @@ u32 tegra_uart_config[4] = {
 #ifdef CONFIG_OF
 void __init tegra_dt_init_irq(void)
 {
+	struct soc_device_attribute *soc_dev_attr;
+	struct soc_device *soc_dev;
+	struct device *parent = NULL;
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		goto out;
+
+	soc_dev_attr->family = kasprintf(GFP_KERNEL, "Tegra");
+	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", tegra_revision);
+	soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "%d", tegra_chip_id);
+
+	soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR(soc_dev)) {
+		kfree(soc_dev_attr->family);
+		kfree(soc_dev_attr->revision);
+		kfree(soc_dev_attr->soc_id);
+		kfree(soc_dev_attr);
+		goto out;
+	}
+
+	parent = soc_device_to_device(soc_dev);
+
+	/*
+	 * Finished with the static registrations now; fill in the missing
+	 * devices
+	 */
+out:
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);
+
 	of_clk_init(NULL);
 	tegra_pmc_init();
 	tegra_init_irq();
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 5b86055..9abb71e 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -27,11 +27,9 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_fdt.h>
-#include <linux/of_platform.h>
 #include <linux/pda_power.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <linux/sys_soc.h>
 #include <linux/usb/tegra_usb_phy.h>
 #include <linux/clk/tegra.h>
 
@@ -47,37 +45,7 @@
 
 static void __init tegra_dt_init(void)
 {
-	struct soc_device_attribute *soc_dev_attr;
-	struct soc_device *soc_dev;
-	struct device *parent = NULL;
-
 	tegra_clocks_apply_init_table();
-
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
-	if (!soc_dev_attr)
-		goto out;
-
-	soc_dev_attr->family = kasprintf(GFP_KERNEL, "Tegra");
-	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", tegra_revision);
-	soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "%d", tegra_chip_id);
-
-	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev)) {
-		kfree(soc_dev_attr->family);
-		kfree(soc_dev_attr->revision);
-		kfree(soc_dev_attr->soc_id);
-		kfree(soc_dev_attr);
-		goto out;
-	}
-
-	parent = soc_device_to_device(soc_dev);
-
-	/*
-	 * Finished with the static registrations now; fill in the missing
-	 * devices
-	 */
-out:
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);
 }
 
 static void __init paz00_init(void)
-- 
1.8.3.4

