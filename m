Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaIVUKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:10:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59566 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaIVUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:09:57 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>
Cc: Kumar Gala <galak@codeaurora.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 2/2] ata: qcom: Add device tree bindings information
Date: Mon, 22 Sep 2014 15:09:46 -0500
Message-Id: <1411416586-18320-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1411416586-18320-1-git-send-email-galak@codeaurora.org>
References: <1411416586-18320-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding for Qualcomm AHCI SATA controller and specifically
the sata controller on the IPQ806x family of SoCs.

We can utilize the "generic-ahci" platform driver with the addition of the
sata phy to enable SATA support on Qualcomm SoCs with AHCI controllers.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
v5:
* Moved to using "generic-ahci" binding support and assigned-clocks
  so we can use upstream generic ahci support w/o a special driver.
  Updated binding spec to reflect that.

v4:
* Added simple PM ops implementation
* Added setting of pmalive clk

v3:
* Added comment about suspend/resume not supported
* Fixup ahci_platform_init_host for upstream change to interface
* cleanup error handling of rxoob clk, moved to devm_clk_get/put

v2:
* Fixed MODULE_LICENSE to be GPL v2

 .../devicetree/bindings/ata/qcom-sata.txt          | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/qcom-sata.txt

diff --git a/Documentation/devicetree/bindings/ata/qcom-sata.txt b/Documentation/devicetree/bindings/ata/qcom-sata.txt
new file mode 100644
index 0000000..094de91
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/qcom-sata.txt
@@ -0,0 +1,48 @@
+* Qualcomm AHCI SATA Controller
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+Each SATA controller should have its own node.
+
+Required properties:
+- compatible		: compatible list, must contain "generic-ahci"
+- interrupts		: <interrupt mapping for SATA IRQ>
+- reg			: <registers mapping>
+- phys			: Must contain exactly one entry as specified
+			  in phy-bindings.txt
+- phy-names		: Must be "sata-phy"
+
+Required properties for "qcom,ipq806x-ahci" compatible:
+- clocks		: Must contain an entry for each entry in clock-names.
+- clock-names		: Shall be:
+				"slave_iface" - Fabric port AHB clock for SATA
+				"iface" - AHB clock
+				"core" - core clock
+				"rxoob" - RX out-of-band clock
+				"pmalive" - Power Module Alive clock
+- assigned-clocks	: Shall be:
+				SATA_RXOOB_CLK
+				SATA_PMALIVE_CLK
+- assigned-clock-rates	: Shall be:
+				100Mhz (100000000) for SATA_RXOOB_CLK
+				100Mhz (100000000) for SATA_PMALIVE_CLK
+
+Example:
+	sata@29000000 {
+		compatible = "qcom,ipq806x-ahci", "generic-ahci";
+		reg = <0x29000000 0x180>;
+
+		interrupts = <0 209 0x0>;
+
+		clocks = <&gcc SFAB_SATA_S_H_CLK>,
+			 <&gcc SATA_H_CLK>,
+			 <&gcc SATA_A_CLK>,
+			 <&gcc SATA_RXOOB_CLK>,
+			 <&gcc SATA_PMALIVE_CLK>;
+		clock-names = "slave_iface", "iface", "core",
+				"rxoob", "pmalive";
+		assigned-clocks = <&gcc SATA_RXOOB_CLK>, <&gcc SATA_PMALIVE_CLK>;
+		assigned-clock-rates = <100000000>, <100000000>;
+
+		phys = <&sata_phy>;
+		phy-names = "sata-phy";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

