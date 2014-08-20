Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaHTVFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:05:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17815 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaHTVFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:05:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Aug 2014 13:55:26 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        <devicetree@vger.kernel.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v4 01/16] clk: tegra: Add binding for the Tegra124 DFLL clocksource
Date: Thu, 21 Aug 2014 00:04:29 +0300
Message-ID: <1408568684-11016-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
References: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DFLL is the main clocksource for the fast CPU cluster on Tegra124
and also provides automatic CPU rail voltage scaling as well. The DFLL
is a separate IP block from the usual Tegra124 clock-and-reset
controller, so it gets its own node in the device tree.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 .../bindings/clock/nvidia,tegra124-dfll.txt        | 69 ++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
new file mode 100644
index 0000000..54c62ac
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
@@ -0,0 +1,69 @@
+NVIDIA Tegra124 DFLL FCPU clocksource
+
+This binding uses the common clock binding:
+Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+The DFLL IP block on Tegra is a root clocksource designed for clocking
+the fast CPU cluster. It consists of a free-running voltage controlled
+oscillator connected to the CPU voltage rail (VDD_CPU), and a closed loop
+control module that will automatically adjust the VDD_CPU voltage by
+communicating with an off-chip PMIC either via an I2C bus or via PWM signals.
+
+Required properties:
+- compatible : should be "nvidia,tegra124-dfll-fcpu"
+- reg : Defines the following set of registers, in the order listed:
+        - registers for the DFLL control logic.
+        - registers for the I2C output logic.
+        - registers for the integrated I2C master controller.
+        - look-up table RAM for voltage register values.
+- interrupts: Should contain the DFLL block interrupt.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - soc: Clock source for the DFLL control logic.
+  - ref: The closed loop reference clock
+  - i2c: Clock source for the integrated I2C master.
+- #clock-cells: Must be 0.
+- clock-output-names: Name of the clock output.
+- vdd-cpu-supply: Regulator for the CPU voltage rail that the DFLL
+  hardware will start controlling.
+
+Required properties for the control loop parameters:
+- nvidia,sample-rate: Sample rate of the DFLL control loop.
+- nvidia,droop-ctrl: See the register CL_DVFS_DROOP_CTRL in the TRM.
+- nvidia,force-mode: See the field DFLL_PARAMS_FORCE_MODE in the TRM.
+- nvidia,cf: Numeric value, see the field DFLL_PARAMS_CF_PARAM in the TRM.
+- nvidia,ci: Numeric value, see the field DFLL_PARAMS_CI_PARAM in the TRM.
+- nvidia,cg: Numeric value, see the field DFLL_PARAMS_CG_PARAM in the TRM.
+- nvidia,cg-scale: Boolean value, see the field DFLL_PARAMS_CG_SCALE in the TRM.
+
+Required properties for I2C mode:
+- nvidia,i2c-fs-rate: I2C transfer rate, if using FS mode.
+
+Example:
+
+dfll@0,70110000 {
+        compatible = "nvidia,tegra124-dfll";
+        reg = <0 0x70110000 0 0x100>, /* DFLL control */
+              <0 0x70110000 0 0x100>, /* I2C output control */
+              <0 0x70110100 0 0x100>, /* Integrated I2C controller */
+              <0 0x70110200 0 0x100>; /* Look-up table RAM */
+        interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&tegra_car TEGRA124_CLK_DFLL_SOC>,
+                 <&tegra_car TEGRA124_CLK_DFLL_REF>,
+                 <&tegra_car TEGRA124_CLK_I2C5>;
+        clock-names = "soc", "ref", "i2c";
+        #clock-cells = <0>;
+        clock-output-names = "dfllCPU_out";
+        vdd-cpu-supply = <&vdd_cpu>;
+        status = "okay";
+
+        nvidia,sample-rate = <12500>;
+        nvidia,droop-ctrl = <0x00000f00>;
+        nvidia,force-mode = <1>;
+        nvidia,cf = <10>;
+        nvidia,ci = <0>;
+        nvidia,cg = <2>;
+
+        nvidia,i2c-fs-rate = <400000>;
+};
-- 
1.8.1.5

