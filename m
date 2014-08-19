Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaHSDjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:39:42 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:35842 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaHSDjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:39:39 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 23:39:37 EDT
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 19 Aug 2014 06:34:06 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        devicetree@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 01/15] clk: tegra: Add binding for the Tegra124 DFLL clocksource
Date: Tue, 19 Aug 2014 06:33:11 +0300
Message-Id: <1408419205-10048-2-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

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

