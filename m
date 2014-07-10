Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaGJVnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:43:24 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17537 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGJVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:43:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 14:32:25 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL clocksource
Date: Fri, 11 Jul 2014 00:42:37 +0300
Message-ID: <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
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
 .../bindings/clock/nvidia,tegra124-dfll.txt        | 86 ++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
new file mode 100644
index 0000000..cf89802
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
@@ -0,0 +1,86 @@
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
+- vdd_cpu-supply: Regulator for the CPU voltage rail that the DFLL
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
+- nvidia,pmic-i2c-address: I2C address of the PMIC that controls the VDD_CPU
+  voltage.
+- nvidia,i2c-10-bit-addresses: Boolean, whether to use 10-bit I2C addressing.
+- nvidia,pmic-i2c-voltage-register: Register of the PMIC that controls the
+  VDD_CPU voltage.
+- nvidia,i2c-fs-rate: I2C transfer rate, if using FS mode.
+- nvidia,pmic-voltage-table: Array of 2-tuples.  Each entry should have the
+  form <register-value voltage-in-uV>, indicating the register value that
+  needs to be programmed to the PMIC for changing the VDD_CPU voltage to
+  the specified voltage. The table must be in ascending order by the voltage.
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
+        vdd_cpu-supply = <&vdd_cpu>;
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
+        nvidia,pmic-i2c-address = <0x40>;
+        nvidia,pmic-i2c-voltage-register = <0x00>;
+        nvidia,pmic-voltage-table =
+                <0x1e 700000>,
+                <0x1f 710000>,
+                  /* etc... */
+                <0x63 1390000>,
+                <0x64 1400000>;
+};
-- 
1.8.1.5

