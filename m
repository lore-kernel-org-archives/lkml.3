Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3B1Eul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:50:41 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54773 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3B1Eug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:50:36 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, Mike Turquette <mturquette@ti.com>
Subject: [PATCH 5/5] HACK: omap: opp: add fake 400MHz OPP to bypass MPU
Date: Wed, 27 Feb 2013 20:49:29 -0800
Message-Id: <1362026969-11457-6-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Turquette <mturquette@ti.com>

The following is another silly patch which was done to test calling
clk_set_parent from within a call to clk_set_rate.  It may make your
board burst into flames or otherwise void various warrantees.

This patch introduces a 400MHz OPP for the MPU, which happens to
correspond to the bypass clk rate on the 4430 Panda board and 4460 Panda
ES board, both using a 38.4MHz SYS_CLK oscillator rate.

One may test this by using the cpufreq-userspace governor and executing:
echo 400000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed

On Panda ES validation can be done via:
$ find /debug/clk/ -iname "dpll_mpu_ck"
/debug/clk/virt_38400000_ck/sys_clkin_ck/dpll_mpu_ck
$ echo 400000 > scaling_setspeed
$ find /debug/clk/ -iname "dpll_mpu_ck"
/debug/clk/virt_38400000_ck/sys_clkin_ck/dpll_core_ck/dpll_core_x2_ck/dpll_core_m5x2_ck/div_mpu_hs_clk/dpll_mpu_ck
$ cat /proc/cpuinfo
...
BogoMIPS        : 794.26
...
$ cat /sys/class/regulator/regulator.3/microvolts
1200000

Not-signed-off-by: Mike Turquette <mturquette@ti.com>
---
 arch/arm/mach-omap2/opp4xxx_data.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/mach-omap2/opp4xxx_data.c b/arch/arm/mach-omap2/opp4xxx_data.c
index d470b72..c7bccf7 100644
--- a/arch/arm/mach-omap2/opp4xxx_data.c
+++ b/arch/arm/mach-omap2/opp4xxx_data.c
@@ -67,6 +67,15 @@ struct omap_volt_data omap443x_vdd_core_volt_data[] = {
 static struct omap_opp_def __initdata omap443x_opp_def_list[] = {
 	/* MPU OPP1 - OPP50 */
 	OPP_INITIALIZER("mpu", true, 300000000, OMAP4430_VDD_MPU_OPP50_UV),
+	/*
+	 * MPU OPP1.5 - 400MHz - completely FAKE - not endorsed by TI
+	 *
+	 * DPLL_MPU is in Low Power Bypass driven by DPLL_CORE.  After
+	 * transitioning to this OPP you can see the migration in debugfs:
+	 * /d/clk/virt_38400000_ck/sys_clkin_ck/dpll_mpu_ck to
+	 * /d/.../dpll_core_ck/dpll_core_x2_ck/dpll_core_m5x2_ck/div_mpu_hs_clk
+	 */
+	OPP_INITIALIZER("mpu", true, 400000000, 1100000),
 	/* MPU OPP2 - OPP100 */
 	OPP_INITIALIZER("mpu", true, 600000000, OMAP4430_VDD_MPU_OPP100_UV),
 	/* MPU OPP3 - OPP-Turbo */
@@ -126,6 +135,15 @@ struct omap_volt_data omap446x_vdd_core_volt_data[] = {
 static struct omap_opp_def __initdata omap446x_opp_def_list[] = {
 	/* MPU OPP1 - OPP50 */
 	OPP_INITIALIZER("mpu", true, 350000000, OMAP4460_VDD_MPU_OPP50_UV),
+	/*
+	 * MPU OPP1.5 - 400MHz - completely FAKE - not endorsed by TI
+	 *
+	 * DPLL_MPU is in Low Power Bypass driven by DPLL_CORE.  After
+	 * transitioning to this OPP you can see the migration in debugfs:
+	 * /d/clk/virt_38400000_ck/sys_clkin_ck/dpll_mpu_ck to
+	 * /d/.../dpll_core_ck/dpll_core_x2_ck/dpll_core_m5x2_ck/div_mpu_hs_clk
+	 */
+	OPP_INITIALIZER("mpu", true, 400000000, 1100000),
 	/* MPU OPP2 - OPP100 */
 	OPP_INITIALIZER("mpu", true, 700000000, OMAP4460_VDD_MPU_OPP100_UV),
 	/* MPU OPP3 - OPP-Turbo */
-- 
1.7.10.4

