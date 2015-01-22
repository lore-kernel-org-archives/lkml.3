Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbAVPrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:47:07 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37189 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbbAVPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:50 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Carlo Caione <carlo@caione.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH v9 2/5] mfd: AXP20x: Add bindings documentation
Date: Thu, 22 Jan 2015 23:39:04 +0800
Message-Id: <1421941147-9682-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421941147-9682-1-git-send-email-wens@csie.org>
References: <1421941147-9682-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlo Caione <carlo@caione.org>

Bindings documentation for the AXP20x driver. In this file also
sub-nodes are documented.

Signed-off-by: Carlo Caione <carlo@caione.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
[wens@csie.org: clarify interrupt source for the axp PMIC]
[wens@csie.org: explain dcdc-workmode in detail and trim lines to 80 chars]
[wens@csie.org: make regulator supplies optional if using unregulated input]
[wens@csie.org: use cubieboard2 regulator nodes as example]
[wens@csie.org: change dcdc-workmode to dcdc-workmode-pwm boolean property]
[wens@csie.org: use clock-frequency for dcdc regulator work frequency]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/mfd/axp20x.txt | 102 +++++++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/axp20x.txt

diff --git a/Documentation/devicetree/bindings/mfd/axp20x.txt b/Documentation/devicetree/bindings/mfd/axp20x.txt
new file mode 100644
index 000000000000..c3c80db242c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/axp20x.txt
@@ -0,0 +1,102 @@
+AXP202/AXP209 device tree bindings
+
+The axp20x family current members :
+axp202 (X-Powers)
+axp209 (X-Powers)
+
+Required properties:
+- compatible: "x-powers,axp202" or "x-powers,axp209"
+- reg: The I2C slave address for the AXP chip
+- interrupt-parent: The parent interrupt controller
+- interrupts: SoC NMI / GPIO interrupt connected to the PMIC's IRQ pin
+- interrupt-controller: axp20x has its own internal IRQs
+- #interrupt-cells: Should be set to 1
+- regulators: A node that houses a sub-node for each regulator. The regulators
+	      are bound using their name as listed here: dcdc2, dcdc3, ldo1,
+	      ldo2, ldo3, ldo4, ldo5.  The bindings details of individual
+	      regulator device can be found in:
+	      Documentation/devicetree/bindings/regulator/regulator.txt with
+	      the exception of x-powers,dcdc-freq. Regulators not used should
+	      still be listed for completeness and that the regulator subsystem
+	      properly registers them.
+
+Optional properties:
+- regulator supplies - may be omitted if inputs are unregulated, such as using
+		       the IPSOUT output from the PMIC
+  - acin-supply: The input supply for LDO1
+  - vin2-supply: The input supply for DCDC2
+  - vin3-supply: The input supply for DCDC3
+  - ldo24in-supply: The input supply for LDO2, LDO4
+  - ldo3in-supply: The input supply for LDO3
+  - ldo5in-supply: The input supply for LDO5
+
+Optional properties for regulators node:
+- clock-frequency: defines the work frequency of DC-DC regulators
+		   (range: 750kHz - 1875kHz). Default: 1.5MHz
+
+Optional properties for DCDC regulators:
+- x-powers,dcdc-workmode-pwm: Force the DCDC regulators to run in PWM mode
+			      The DCDC regulators rormally work in a mixed
+			      PWM/PFM mode, using PFM under light loads and
+			      switching to PWM for heavier loads. Forcing
+			      PWM mode trades efficiency under light loads
+			      for lower output noise. This probably makes
+			      sense for HiFi audio related applications that
+			      aren't battery constrained.
+
+Example:
+
+axp209: pmic@34 {
+	compatible = "x-powers,axp209";
+	reg = <0x34>;
+	interrupt-parent = <&nmi_intc>;
+	interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+	interrupt-controller;
+	#interrupt-cells = <1>;
+
+	regulators {
+		clock-frequency = <1500000>;
+
+		vdd_cpu: dcdc2 {
+			regulator-always-on;
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <1450000>;
+			regulator-name = "vdd-cpu";
+		};
+
+		vdd_int_dll: dcdc3 {
+			regulator-always-on;
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <1400000>;
+			regulator-name = "vdd-int-dll";
+		};
+
+		vdd_rtc: ldo1 {
+			regulator-always-on;
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1400000>;
+			regulator-name = "vdd-rtc";
+		};
+
+		avcc: ldo2 {
+			regulator-always-on;
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-name = "avcc";
+		};
+
+		ldo3 {
+			/* unused */
+		};
+
+		csi1_io_2v8: ldo4 {
+			/* output on extension headers */
+			regulator-name = "csi1-io-2v8";
+		};
+
+		ldo5 {
+			/* unused */
+		};
+	};
+};
+
-- 
2.1.4

