Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaE0Nz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:55:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56854 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaE0Nz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:55:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH] mfd: syscon: add child device support
Date: Tue, 27 May 2014 15:55:17 +0200
Message-Id: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
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
 Documentation/devicetree/bindings/mfd/syscon.txt | 11 +++++++++++
 drivers/mfd/syscon.c                             |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
index fe8150b..a7e11d5 100644
--- a/Documentation/devicetree/bindings/mfd/syscon.txt
+++ b/Documentation/devicetree/bindings/mfd/syscon.txt
@@ -9,10 +9,21 @@ using a specific compatible value), interrogate the node (or associated
 OS driver) to determine the location of the registers, and access the
 registers directly.
 
+Optionally, devices that are only controlled through single syscon
+registers or bitfields can also be added as child nodes to the syscon
+device node. These devices can implicitly assume their parent node
+as syscon provider without referencing it explicitly via phandle.
+In this case, the syscon node should have #address-cells = <1> and
+#size-cells = <0> and no ranges property.
+
 Required properties:
 - compatible: Should contain "syscon".
 - reg: the register region can be accessed from syscon
 
+Optional properties:
+- #address-cells: Should be 1.
+- #size-cells: Should be 0.
+
 Examples:
 gpr: iomuxc-gpr@020e0000 {
 	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index dbea55d..1dde475 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -147,6 +147,8 @@ static int syscon_probe(struct platform_device *pdev)
 
 	dev_dbg(dev, "regmap %pR registered\n", res);
 
+	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+
 	return 0;
 }
 
-- 
2.0.0.rc2

