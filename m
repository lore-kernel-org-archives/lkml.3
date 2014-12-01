Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaLAQZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:25:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLAQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:25:47 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rob Herring <robh+dt@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Flora Fu <flora.fu@mediatek.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH RESEND v2] mfd: syscon: add child device support
Date: Mon,  1 Dec 2014 17:25:38 +0100
Message-Id: <1417451138-13583-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For devices which have a complete register for themselves, it is possible to
place them next to the syscon device with overlapping reg ranges. The same is
not possible for devices which only occupy bitfields in registers shared with
other users.
For devices that are completely controlled by bitfields in the syscon address
range, such as multiplexers or voltage regulators, allow to put child devices
into the syscon device node.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Reworded binding documentation to allow #size-cells = <1>, which is useful
   for syscon children that are controlled through a (possibly shared) register
   range.
---
 Documentation/devicetree/bindings/mfd/syscon.txt | 13 +++++++++++++
 drivers/mfd/syscon.c                             |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
index fe8150b..0c6b497 100644
--- a/Documentation/devicetree/bindings/mfd/syscon.txt
+++ b/Documentation/devicetree/bindings/mfd/syscon.txt
@@ -9,12 +9,25 @@ using a specific compatible value), interrogate the node (or associated
 OS driver) to determine the location of the registers, and access the
 registers directly.
 
+Optionally, devices that are controlled exclusively through syscon registers,
+or even bitfields in shared syscon registers, can also be added as child nodes
+to the syscon device node. These devices can implicitly assume their parent
+node is a syscon provider without referencing it explicitly via phandle.
+In this case, the syscon node should have #address-cells = <1> and
+#size-cells = <0> or <1> and no ranges property.
+
 Required properties:
 - compatible: Should contain "syscon".
 - reg: the register region can be accessed from syscon
 
+Optional properties:
+- #address-cells: Should be 1.
+- #size-cells: Should be 0 or 1.
+
 Examples:
 gpr: iomuxc-gpr@020e0000 {
+	#address-cells = <1>;
+	#size-cells = <0>;
 	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
 	reg = <0x020e0000 0x38>;
 };
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index ca15878..38da178 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -155,6 +155,9 @@ static int syscon_probe(struct platform_device *pdev)
 
 	dev_dbg(dev, "regmap %pR registered\n", res);
 
+	if (!of_device_is_compatible(pdev->dev.of_node, "simple-bus"))
+		of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+
 	return 0;
 }
 
-- 
2.1.1

