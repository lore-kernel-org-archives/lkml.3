Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3HFLyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:54:10 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:55337 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab3HFLyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:54:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Date: Tue,  6 Aug 2013 14:53:11 +0300
Message-Id: <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/usb/msm-ssusb.txt          |   39 +++++
 drivers/usb/dwc3/Kconfig                           |    8 +
 drivers/usb/dwc3/Makefile                          |    1 +
 drivers/usb/dwc3/dwc3-msm.c                        |  175 ++++++++++++++++++++
 4 files changed, 223 insertions(+)
 create mode 100644 drivers/usb/dwc3/dwc3-msm.c

diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
index 550b496..313ae0d 100644
--- a/Documentation/devicetree/bindings/usb/msm-ssusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
@@ -22,6 +22,23 @@ Required "supply-name" examples are:
 	"v1p8" : 1.8v supply for SS-PHY
 	"vddcx" : vdd supply for SS-PHY digital circuit operation
 
+Required properties :
+- compatible : should be "qcom,dwc-usb3-msm"
+- reg : offset and length of the register set in the memory map
+	offset and length of the TCSR register for routing USB
+	signals to either picoPHY0 or picoPHY1.
+- clocks = <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>, <&usb30_sleep_cxc>, <&usb30_mock_utmi_cxc>;
+- clock-names = "core_clk", "iface_clk", "sleep_clk", "utmi_clk";
+
+Optional properties :
+- gdsc-supply : phandle to the globally distributed switch controller
+  regulator node to the USB controller.
+
+Sub nodes:
+- Sub node for "DWC3- USB3 controller".
+  This sub node is required property for device node. The properties of this subnode
+  are specified in dwc3.txt.
+
 Example device nodes:
 
 	dwc3_usb2: phy@f92f8800 {
@@ -47,3 +64,25 @@ Example device nodes:
 		vddcx-supply = <&supply>;
 		v1p8-supply = <&supply>;
 	};
+
+	usb@fd4ab000 {
+		compatible = "qcom,dwc-usb3-msm";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0xfd4ab000 0x4>;
+
+		clocks = <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>, <&usb30_sleep_cxc>, <&usb30_mock_utmi_cxc>;
+		clock-names = "core_clk", "iface_clk", "sleep_clk", "utmi_clk";
+
+		gdsc-supply = <&supply>;
+		ranges;
+
+		dwc3@f9200000 {
+			compatible = "snps,dwc3";
+			reg = <0xf9200000 0xcd00>;
+			interrupts = <0 131 0>;
+			interrupt-names = "irq";
+			usb-phy = <&dwc3_usb2>, <&dwc3_usb3>;
+			tx-fifo-resize;
+		};
+	};
diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 3e225d5..e2032c4 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -70,6 +70,14 @@ config USB_DWC3_PCI
 	  One such PCIe-based platform is Synopsys' PCIe HAPS model of
 	  this IP.
 
+config USB_DWC3_MSM
+	tristate "Qualcomm MSM/APQ Platforms"
+	default USB_DWC3
+	select USB_MSM_DWC3_PHYS
+	help
+	  Recent Qualcomm SoCs ship with one DesignWare Core USB3 IP inside,
+	  say 'Y' or 'M' if you have one such device.
+
 comment "Debugging features"
 
 config USB_DWC3_DEBUG
diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index dd17601..5226681 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -32,3 +32,4 @@ endif
 obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
 obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
 obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
+obj-$(CONFIG_USB_DWC3_MSM)		+= dwc3-msm.o
diff --git a/drivers/usb/dwc3/dwc3-msm.c b/drivers/usb/dwc3/dwc3-msm.c
new file mode 100644
index 0000000..e509abc
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-msm.c
@@ -0,0 +1,175 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#undef CONFIG_REGULATOR
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/usb/phy.h>
+
+struct dwc3_msm {
+	struct device		*dev;
+	void __iomem		*base;
+
+	struct clk		*core_clk;
+	struct clk		*iface_clk;
+	struct clk		*sleep_clk;
+	struct clk		*utmi_clk;
+
+	struct regulator	*gdsc;
+};
+
+static int dwc3_msm_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct dwc3_msm *mdwc;
+	struct resource *res;
+	void __iomem *tcsr;
+	int ret = 0;
+
+	dev_info(&pdev->dev, "MSM DWC3\n");
+
+	mdwc = devm_kzalloc(&pdev->dev, sizeof(*mdwc), GFP_KERNEL);
+	if (!mdwc) {
+		dev_err(&pdev->dev, "not enough memory\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, mdwc);
+	mdwc->dev = &pdev->dev;
+
+	mdwc->gdsc = devm_regulator_get(mdwc->dev, "gbsc");
+
+	mdwc->core_clk = devm_clk_get(&pdev->dev, "core_clk");
+	if (IS_ERR(mdwc->core_clk)) {
+		dev_err(&pdev->dev, "failed to get core_clk\n");
+		return PTR_ERR(mdwc->core_clk);
+	}
+
+	mdwc->iface_clk = devm_clk_get(&pdev->dev, "iface_clk");
+	if (IS_ERR(mdwc->iface_clk)) {
+		dev_err(&pdev->dev, "failed to get iface_clk\n");
+		return PTR_ERR(mdwc->iface_clk);
+	}
+
+	mdwc->sleep_clk = devm_clk_get(&pdev->dev, "sleep_clk");
+	if (IS_ERR(mdwc->sleep_clk)) {
+		dev_err(&pdev->dev, "failed to get sleep_clk\n");
+		return  PTR_ERR(mdwc->sleep_clk);
+	}
+
+	mdwc->utmi_clk = devm_clk_get(&pdev->dev, "utmi_clk");
+	if (IS_ERR(mdwc->utmi_clk)) {
+		dev_err(&pdev->dev, "failed to get utmi_clk\n");
+		return  PTR_ERR(mdwc->utmi_clk);
+	}
+
+	if (!IS_ERR(mdwc->gdsc)) {
+		ret = regulator_enable(mdwc->gdsc);
+		if (ret)
+			dev_err(mdwc->dev, "unable to enable usb3 gdsc\n");
+	}
+
+	/*
+	 * DWC3 Core requires its CORE CLK (aka master / bus clk) to
+	 * run at 125Mhz in SSUSB mode and >60MHZ for HSUSB mode.
+	 */
+	clk_set_rate(mdwc->core_clk, 125000000);
+	clk_prepare_enable(mdwc->core_clk);
+	clk_prepare_enable(mdwc->iface_clk);
+	clk_prepare_enable(mdwc->sleep_clk);
+	clk_prepare_enable(mdwc->utmi_clk);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	tcsr = devm_ioremap_resource(&pdev->dev, res);
+	if (!tcsr) {
+		dev_dbg(&pdev->dev, "tcsr ioremap failed\n");
+	} else {
+		/* TODO: This has to be revised */
+
+		/* Enable USB3 on the primary USB port. */
+		writel_relaxed(0x1, tcsr);
+		/*
+		 * Ensure that TCSR write is completed before
+		 * USB registers initialization.
+		 */
+		mb();
+	}
+
+	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add create dwc3 core\n");
+		goto dis_clks;
+	}
+
+	return 0;
+
+dis_clks:
+	clk_disable_unprepare(mdwc->utmi_clk);
+	clk_disable_unprepare(mdwc->sleep_clk);
+	clk_disable_unprepare(mdwc->iface_clk);
+	clk_disable_unprepare(mdwc->core_clk);
+	if (!IS_ERR(mdwc->gdsc)) {
+		ret = regulator_disable(mdwc->gdsc);
+		if (ret)
+			dev_err(mdwc->dev, "cannot disable usb3 gdsc\n");
+	}
+
+	return ret;
+}
+
+static int dwc3_msm_remove(struct platform_device *pdev)
+{
+	struct dwc3_msm	*mdwc = platform_get_drvdata(pdev);
+	int ret;
+
+	clk_disable_unprepare(mdwc->utmi_clk);
+	clk_disable_unprepare(mdwc->sleep_clk);
+	clk_disable_unprepare(mdwc->iface_clk);
+	clk_disable_unprepare(mdwc->core_clk);
+
+	if (!IS_ERR(mdwc->gdsc)) {
+		ret = regulator_disable(mdwc->gdsc);
+		if (ret)
+			dev_err(mdwc->dev, "cannot disable usb3 gdsc\n");
+	}
+
+	return 0;
+}
+
+static const struct of_device_id of_dwc3_matach[] = {
+	{
+		.compatible = "qcom,dwc-usb3-msm",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_dwc3_matach);
+
+static struct platform_driver dwc3_msm_driver = {
+	.probe		= dwc3_msm_probe,
+	.remove		= dwc3_msm_remove,
+	.driver		= {
+		.name	= "msm-dwc3",
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_dwc3_matach,
+	},
+};
+
+module_platform_driver(dwc3_msm_driver);
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("DesignWare USB3 MSM Glue Layer");
-- 
1.7.9.5

