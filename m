Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaF0LYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:24:30 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:16425
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753670AbaF0LY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:24:27 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <Peter.Chen@freescale.com>,
        <gregkh@linuxfoundation.org>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH v2 2/2] usb: chipidea: Add support for zynq usb host and device controller
Date: Fri, 27 Jun 2014 16:53:53 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1403868233-5123-1-git-send-email-punnaia@xilinx.com>
References: <1403868233-5123-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
Message-ID: <fa656d2d-a2a8-4b8d-a29b-e89e4bfced3e@BL2FFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(20776003)(74502001)(88136002)(83322001)(50466002)(62966002)(44976005)(19580395003)(77156001)(19580405001)(53416004)(50986999)(87286001)(31696002)(76176999)(47776003)(4396001)(46102001)(86362001)(107046002)(1496007)(81342001)(76482001)(74316001)(575784001)(81542001)(77096002)(6806004)(87936001)(21056001)(79102001)(33646001)(92726001)(2201001)(85306003)(99396002)(89996001)(48376002)(95666004)(104166001)(50226001)(77982001)(70736001)(85852003)(83072002)(104016002)(80022001)(106466001)(74662001)(102836001)(64706001)(107986001)(2004002)(2101003)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB010;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq soc uses Chipidea/Synopsys usb IP core(CI13612). This patch adds
necessary glue to allow the chipidea driver to work on zynq soc.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v2:
- modified the commit message for better readability
- fixed the dev_err message
---
 drivers/usb/chipidea/Makefile       |    1 +
 drivers/usb/chipidea/ci_hdrc_zynq.c |  115 +++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/chipidea/ci_hdrc_zynq.c

diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
index 2f099c7..b0d6b6f 100644
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -12,6 +12,7 @@ ci_hdrc-$(CONFIG_USB_OTG_FSM)		+= otg_fsm.o
 
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_msm.o
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zevio.o
+obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_zynq.o
 
 # PCI doesn't provide stubs, need to check
 ifneq ($(CONFIG_PCI),)
diff --git a/drivers/usb/chipidea/ci_hdrc_zynq.c b/drivers/usb/chipidea/ci_hdrc_zynq.c
new file mode 100644
index 0000000..5ef2717
--- /dev/null
+++ b/drivers/usb/chipidea/ci_hdrc_zynq.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2014 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/usb/chipidea.h>
+
+#include "ci.h"
+
+#define ZYNQ_USB_DMA_MASK	0xFFFFFFF0
+
+struct ci_hdrc_zynq_data {
+	struct platform_device *ci_pdev;
+	struct clk *clk;
+};
+
+static struct ci_hdrc_platform_data pdata = {
+	.name           = "ci_hdrc_zynq",
+	.capoffset      = DEF_CAPOFFSET,
+	.flags          = CI_HDRC_REQUIRE_TRANSCEIVER
+};
+
+static int ci_hdrc_zynq_probe(struct platform_device *pdev)
+{
+	struct ci_hdrc_zynq_data *data;
+	int ret;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "Failed to allocate ci_hdrc_zynq data!\n");
+		return -ENOMEM;
+	}
+
+	data->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(data->clk)) {
+		dev_err(&pdev->dev,
+			"Failed to get clock, err=%ld\n", PTR_ERR(data->clk));
+		return PTR_ERR(data->clk);
+	}
+
+	ret = clk_prepare_enable(data->clk);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to prepare or enable clock, err=%d\n", ret);
+		return ret;
+	}
+
+	ret = dma_coerce_mask_and_coherent(&pdev->dev, ZYNQ_USB_DMA_MASK);
+	if (ret)
+		goto err_clk;
+
+	data->ci_pdev = ci_hdrc_add_device(&pdev->dev,
+				pdev->resource, pdev->num_resources,
+				&pdata);
+	if (IS_ERR(data->ci_pdev)) {
+		ret = PTR_ERR(data->ci_pdev);
+		dev_err(&pdev->dev,
+			"Can't register ci_hdrc platform device, err=%d\n",
+			ret);
+		goto err_clk;
+	}
+
+	platform_set_drvdata(pdev, data);
+
+	pm_runtime_no_callbacks(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	return 0;
+
+err_clk:
+	clk_disable_unprepare(data->clk);
+	return ret;
+}
+
+static int ci_hdrc_zynq_remove(struct platform_device *pdev)
+{
+	struct ci_hdrc_zynq_data *data = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	ci_hdrc_remove_device(data->ci_pdev);
+	clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static const struct of_device_id ci_hdrc_zynq_dt_ids[] = {
+	{ .compatible = "xlnx,zynq-usb-2.20a" },
+	{},
+};
+
+static struct platform_driver ci_hdrc_zynq_driver = {
+	.probe = ci_hdrc_zynq_probe,
+	.remove = ci_hdrc_zynq_remove,
+	.driver = {
+		.name = "zynq_usb",
+		.owner = THIS_MODULE,
+		.of_match_table = ci_hdrc_zynq_dt_ids,
+	 },
+};
+
+module_platform_driver(ci_hdrc_zynq_driver);
+
+MODULE_ALIAS("platform:zynq_usb");
+MODULE_DESCRIPTION("CI HDRC ZYNQ USB binding");
+MODULE_AUTHOR("Xilinx Inc");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4


