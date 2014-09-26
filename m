Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaIZDxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:53:25 -0400
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:49563
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753350AbaIZDwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:52:45 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <LW@KARO-electronics.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 2/3] power: reset: imx-snvs-poweroff: add power off driver for i.mx6
Date: Fri, 26 Sep 2014 11:59:06 +0800
Message-ID: <1411703947-31956-3-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411703947-31956-1-git-send-email-b38343@freescale.com>
References: <1411703947-31956-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(20776003)(85306004)(97736003)(47776003)(102836001)(64706001)(21056001)(33646002)(84676001)(79102003)(99396003)(77982003)(46102003)(74662003)(74502003)(81542003)(81342003)(80022003)(76176999)(50986999)(36756003)(95666004)(10300001)(81156004)(106466001)(120916001)(90102001)(230783001)(105606002)(76482002)(2201001)(69596002)(85852003)(68736004)(92726001)(83072002)(4396001)(50226001)(50466002)(48376002)(89996001)(6806004)(104166001)(87286001)(77156001)(229853001)(104016003)(107046002)(31966008)(83322001)(19580405001)(19580395003)(87936001)(88136002)(44976005)(93916002)(92566001)(62966002)(921003)(1121002)(83996005)(2101003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB343;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB343;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver register pm_power_off with snvs power off function. If
your boards NOT use PMIC_ON_REQ to turn on/off external pmic, or use
other pin to do, please disable the driver in dts, otherwise, your
pm_power_off maybe overwrote by this driver.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 .../bindings/power_supply/imx-snvs-poweroff.txt    |   23 +++++++
 drivers/power/reset/Kconfig                        |    9 +++
 drivers/power/reset/Makefile                       |    1 +
 drivers/power/reset/imx-snvs-poweroff.c            |   66 ++++++++++++++++++++
 4 files changed, 99 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
 create mode 100644 drivers/power/reset/imx-snvs-poweroff.c

diff --git a/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
new file mode 100644
index 0000000..dc7c9ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
@@ -0,0 +1,23 @@
+i.mx6 Poweroff Driver
+
+SNVS_LPCR in SNVS module can power off the whole system by pull
+PMIC_ON_REQ low if PMIC_ON_REQ is connected with external PMIC.
+If you don't want to use PMIC_ON_REQ as power on/off control,
+please set status='disabled' to disable this driver.
+
+Required Properties:
+-compatible: "fsl,sec-v4.0-poweroff"
+-reg: Specifies the physical address of the SNVS_LPCR register
+
+Example:
+	snvs@020cc000 {
+		compatible = "fsl,sec-v4.0-mon", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0x020cc000 0x4000>;
+		.....
+		snvs_poweroff: snvs-poweroff@38 {
+			compatible = "fsl,sec-v4.0-poweroff";
+			reg = <0x38 0x4>;
+		};
+	}
diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index ca41523..b26c547 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -45,6 +45,15 @@ config POWER_RESET_HISI
 	help
 	  Reboot support for Hisilicon boards.
 
+config POWER_RESET_IMX
+	bool "IMX6 power-off driver"
+	depends on POWER_RESET && SOC_IMX6
+	help
+	  This driver support power off external PMIC by PMIC_ON_REQ on i.mx6
+	  boards.If you want to use other pin to control external power,please
+	  say N here or disable in dts to make sure pm_power_off never be
+	  overwrote wrongly by this driver.
+
 config POWER_RESET_MSM
 	bool "Qualcomm MSM power-off driver"
 	depends on POWER_RESET && ARCH_QCOM
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index a42e70e..2524daf 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
 obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
 obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
+obj-$(CONFIG_POWER_RESET_IMX) += imx-snvs-poweroff.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
diff --git a/drivers/power/reset/imx-snvs-poweroff.c b/drivers/power/reset/imx-snvs-poweroff.c
new file mode 100644
index 0000000..ad6ce50
--- /dev/null
+++ b/drivers/power/reset/imx-snvs-poweroff.c
@@ -0,0 +1,66 @@
+/* Power off driver for i.mx6
+ * Copyright (c) 2014, FREESCALE CORPORATION.  All rights reserved.
+ *
+ * based on msm-poweroff.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+
+static void __iomem *snvs_base;
+
+static void do_imx_poweroff(void)
+{
+	u32 value = readl(snvs_base);
+
+	/* set TOP and DP_EN bit */
+	writel(value | 0x60, snvs_base);
+}
+
+static int imx_poweroff_probe(struct platform_device *pdev)
+{
+	snvs_base = of_iomap(pdev->dev.of_node, 0);
+	if (!snvs_base) {
+		dev_err(&pdev->dev, "failed to get memory\n");
+		return -ENODEV;
+	}
+
+	pm_power_off = do_imx_poweroff;
+	return 0;
+}
+
+static const struct of_device_id of_imx_poweroff_match[] = {
+	{ .compatible = "fsl,sec-v4.0-poweroff", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_imx_poweroff_match);
+
+static struct platform_driver imx_poweroff_driver = {
+	.probe = imx_poweroff_probe,
+	.driver = {
+		.name = "imx-snvs-poweroff",
+		.of_match_table = of_match_ptr(of_imx_poweroff_match),
+	},
+};
+
+static int __init imx_poweroff_init(void)
+{
+	return platform_driver_register(&imx_poweroff_driver);
+}
+device_initcall(imx_poweroff_init);
-- 
1.7.9.5

