Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaILJx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:53:59 -0400
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:20811
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbaILJxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:53:16 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 2/3] power: reset: imx-snvs-poweroff: add power off driver for i.mx6
Date: Fri, 12 Sep 2014 16:48:58 +0800
Message-ID: <1410511739-31122-3-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410511739-31122-1-git-send-email-b38343@freescale.com>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(44976005)(6806004)(83072002)(26826002)(79102001)(102836001)(62966002)(74502001)(104016003)(88136002)(104166001)(64706001)(89996001)(84676001)(74662001)(68736004)(92566001)(87936001)(50986999)(99396002)(19580395003)(77982001)(19580405001)(47776003)(2201001)(4396001)(107046002)(80022001)(85852003)(50226001)(46102001)(48376002)(76176999)(87286001)(20776003)(31966008)(50466002)(97736003)(105606002)(229853001)(106466001)(92726001)(81542001)(36756003)(83322001)(95666004)(85306004)(77156001)(81342001)(76482001)(33646002)(21056001)(90102001)(230783001)(93916002)(921003)(1121002)(2004002)(2101003)(42262002)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB338;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB338;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple power off driver for i.mx6.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/power/reset/Kconfig             |  6 +++
 drivers/power/reset/Makefile            |  1 +
 drivers/power/reset/imx-snvs-poweroff.c | 69 +++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)
 create mode 100644 drivers/power/reset/imx-snvs-poweroff.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index ca41523..c48d9ba 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -45,6 +45,12 @@ config POWER_RESET_HISI
 	help
 	  Reboot support for Hisilicon boards.
 
+config POWER_RESET_IMX
+	bool "IMX6 power-off driver"
+	depends on POWER_RESET && SOC_IMX6
+	help
+	  Power off support for i.mx6 boards.
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
index 0000000..55603ba
--- /dev/null
+++ b/drivers/power/reset/imx-snvs-poweroff.c
@@ -0,0 +1,69 @@
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
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+
+#include <asm/system_misc.h>
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
+		return -EIO;
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
1.9.1

