Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaJJWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:25:56 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43045 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaJJWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:25:29 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: rockchip: fix up rk3288 smp cpu hotplug
Date: Fri, 10 Oct 2014 15:25:14 -0700
Message-Id: <1412979915-19746-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412979915-19746-1-git-send-email-kever.yang@rock-chips.com>
References: <1412979915-19746-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix up the problem we met in rk3288 smp cpu hotplug.
It is a known issue for the CA12/CA17 MPCore multiprocessor that the active
processors might be stalled when the individual processor is powered down,
we can avoid this prolbem by softreset the processor before power it down.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---

 arch/arm/mach-rockchip/platsmp.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index d1f858e..5c08262 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -22,6 +22,8 @@
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
 
+#include <linux/reset.h>
+#include <linux/cpu.h>
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
 #include <asm/smp_scu.h>
@@ -53,11 +55,47 @@ static int pmu_power_domain_is_on(int pd)
 	return !(val & BIT(pd));
 }
 
+struct reset_control *rockchip_get_core_reset(int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
+	struct device_node *np;
+
+	/* The cpu device is only available after the initial core bringup */
+	if (dev)
+		np = dev->of_node;
+	else
+		np = of_get_cpu_node(cpu, 0);
+
+	return of_reset_control_get(np, NULL);
+}
+
 static int pmu_set_power_domain(int pd, bool on)
 {
 	u32 val = (on) ? 0 : BIT(pd);
 	int ret;
 
+	/*
+	 * We need to soft reset the cpu when we turn off the cpu power domain,
+	 * or else the active processors might be stalled when the individual
+	 * processor is powered down.
+	 */
+	if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
+		struct reset_control *rstc = rockchip_get_core_reset(pd);
+
+		if (IS_ERR(rstc)) {
+			pr_err("%s: could not get reset control for core %d\n",
+			       __func__, pd);
+			return PTR_ERR(rstc);
+		}
+
+		if (on)
+			reset_control_deassert(rstc);
+		else
+			reset_control_assert(rstc);
+
+		reset_control_put(rstc);
+	}
+
 	ret = regmap_update_bits(pmu, PMU_PWRDN_CON, BIT(pd), val);
 	if (ret < 0) {
 		pr_err("%s: could not update power domain\n", __func__);
-- 
1.9.1

