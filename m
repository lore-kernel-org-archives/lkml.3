Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaIJKId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:08:33 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58947 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaIJKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:08:31 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: rockchip: add basic smp support for rk3288
Date: Wed, 10 Sep 2014 18:05:53 +0800
Message-Id: <1410343554-8383-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410343554-8383-1-git-send-email-kever.yang@rock-chips.com>
References: <1410343554-8383-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

basic rk3288 smp support

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 arch/arm/mach-rockchip/core.h    |  1 +
 arch/arm/mach-rockchip/platsmp.c | 60 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-rockchip/core.h b/arch/arm/mach-rockchip/core.h
index 39bca96..b2ade69 100644
--- a/arch/arm/mach-rockchip/core.h
+++ b/arch/arm/mach-rockchip/core.h
@@ -18,3 +18,4 @@ extern char rockchip_secondary_trampoline_end;
 
 extern unsigned long rockchip_boot_fn;
 extern void rockchip_secondary_startup(void);
+extern void secondary_startup(void);
diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index 189684f..fcd33fd 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -77,6 +77,12 @@ static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
 	/* start the core */
 	pmu_set_power_domain(0 + cpu, true);
 
+	/* wait for cpu 1~3 bootup and run into wfe state */
+	udelay(10);
+	writel(virt_to_phys(secondary_startup), sram_base_addr + 8);
+	writel(0xDEADBEAF, sram_base_addr + 4);
+	dsb_sev();
+
 	return 0;
 }
 
@@ -125,7 +131,7 @@ static int __init rockchip_smp_prepare_sram(struct device_node *node)
 	return 0;
 }
 
-static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
+static void __init rk3066_smp_prepare_cpus(unsigned int max_cpus)
 {
 	struct device_node *node;
 	unsigned int i;
@@ -194,12 +200,58 @@ static void rockchip_cpu_die(unsigned int cpu)
 }
 #endif
 
-static struct smp_operations rockchip_smp_ops __initdata = {
-	.smp_prepare_cpus	= rockchip_smp_prepare_cpus,
+static void __init rk3288_smp_prepare_cpus(unsigned int max_cpus)
+{
+	struct device_node *node;
+	unsigned int i;
+
+	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-smp-sram");
+	if (!node) {
+		pr_err("%s: could not find sram dt node\n", __func__);
+		return;
+	}
+
+	sram_base_addr = of_iomap(node, 0);
+	if (!sram_base_addr) {
+		pr_err("%s: could not map pmu registers\n", __func__);
+		return;
+	}
+
+	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3288-pmu");
+	if (!node) {
+		pr_err("%s: could not find pmu dt node\n", __func__);
+		return;
+	}
+
+	pmu_base_addr = of_iomap(node, 0);
+	if (!pmu_base_addr) {
+		pr_err("%s: could not map pmu registers\n", __func__);
+		return;
+	}
+
+	ncores = 4;
+
+	/* Make sure that all cores except the first are really off */
+	for (i = 1; i < ncores; i++)
+		pmu_set_power_domain(0 + i, false);
+}
+
+static struct smp_operations rockchip3066_smp_ops __initdata = {
+	.smp_prepare_cpus	= rk3066_smp_prepare_cpus,
+	.smp_boot_secondary	= rockchip_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_kill		= rockchip_cpu_kill,
+	.cpu_die		= rockchip_cpu_die,
+#endif
+};
+CPU_METHOD_OF_DECLARE(rk3066_smp, "rockchip,rk3066-smp", &rockchip3066_smp_ops);
+
+static struct smp_operations rockchip3288_smp_ops __initdata = {
+	.smp_prepare_cpus	= rk3288_smp_prepare_cpus,
 	.smp_boot_secondary	= rockchip_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_kill		= rockchip_cpu_kill,
 	.cpu_die		= rockchip_cpu_die,
 #endif
 };
-CPU_METHOD_OF_DECLARE(rk3066_smp, "rockchip,rk3066-smp", &rockchip_smp_ops);
+CPU_METHOD_OF_DECLARE(rk3288_smp, "rockchip,rk3288-smp", &rockchip3288_smp_ops);
-- 
1.9.1

