Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3JKLrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:47:46 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:58636 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab3JKLrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:47:42 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: stern@rowland.harvard.edu
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        davidb@codeaurora.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 2/2] USB: ehci-msm: Add device tree support and binding information
Date: Fri, 11 Oct 2013 14:46:10 +0300
Message-Id: <1381491970-22896-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381491970-22896-1-git-send-email-iivanov@mm-sol.com>
References: <1381491970-22896-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Allows MSM EHCI controller to be specified via device tree.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |   17 +++++++++++++++++
 drivers/usb/host/ehci-msm.c                        |   15 +++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/msm-hsusb.txt

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
new file mode 100644
index 0000000..5ea26c6
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -0,0 +1,17 @@
+MSM SoC HSUSB controllers
+
+EHCI
+
+Required properties:
+- compatible:	Should contain "qcom,ehci-host"
+- regs:			offset and length of the register set in the memory map
+- usb-phy:		phandle for the PHY device
+
+Example EHCI controller device node:
+
+	ehci: ehci@f9a55000 {
+		compatible = "qcom,ehci-host";
+		reg = <0xf9a55000 0x400>;
+		usb-phy = <&usb_otg>;
+	};
+
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 1bc9355..f341651 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -108,10 +108,14 @@ static int ehci_msm_probe(struct platform_device *pdev)
 	 * powering up VBUS, mapping of registers address space and power
 	 * management.
 	 */
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (pdev->dev.of_node)
+		phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
+	else
+		phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+
 	if (IS_ERR(phy)) {
 		dev_err(&pdev->dev, "unable to find transceiver\n");
-		ret = -ENODEV;
+		ret = -EPROBE_DEFER;
 		goto put_hcd;
 	}
 
@@ -187,12 +191,19 @@ static const struct dev_pm_ops ehci_msm_dev_pm_ops = {
 	.resume          = ehci_msm_pm_resume,
 };
 
+static struct of_device_id msm_ehci_dt_match[] = {
+	{ .compatible = "qcom,ehci-host", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, msm_ehci_dt_match);
+
 static struct platform_driver ehci_msm_driver = {
 	.probe	= ehci_msm_probe,
 	.remove	= ehci_msm_remove,
 	.driver = {
 		   .name = "msm_hsusb_host",
 		   .pm = &ehci_msm_dev_pm_ops,
+		   .of_match_table = msm_ehci_dt_match,
 	},
 };
 
-- 
1.7.9.5

