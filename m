Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3LWQYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:24:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39697 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab3LWQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:10 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 15/18] ARM: vexpress: Simplify SMP operations for DT-powered system
Date: Mon, 23 Dec 2013 16:23:47 +0000
Message-Id: <1387815830-8794-16-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:08.0056 (UTC) FILETIME=[679D4F80:01CEFFFB]
X-MC-Unique: 113122316240821901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGOemC026595

As all cores must be properly described in the Device Tree,
there is no point in getting their numbers from SCU on
A5/A9 platforms. This significantly simplifies the code,
removing the need for flat-tree scanning and early static
mapping.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/mach-vexpress/core.h    |   3 +-
 arch/arm/mach-vexpress/platsmp.c | 158 ++++++++++-----------------------------
 arch/arm/mach-vexpress/v2m.c     |   6 +-
 3 files changed, 41 insertions(+), 126 deletions(-)

diff --git a/arch/arm/mach-vexpress/core.h b/arch/arm/mach-vexpress/core.h
index bde4374..152fad9 100644
--- a/arch/arm/mach-vexpress/core.h
+++ b/arch/arm/mach-vexpress/core.h
@@ -4,10 +4,9 @@
 /* Tile's peripherals static mappings should start here */
 #define V2T_PERIPH 0xf8200000
 
-void vexpress_dt_smp_map_io(void);
-
 bool vexpress_smp_init_ops(void);
 
 extern struct smp_operations	vexpress_smp_ops;
+extern struct smp_operations	vexpress_smp_dt_ops;
 
 extern void vexpress_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 12a8751..a1f3804 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -12,8 +12,7 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 #include <linux/io.h>
-#include <linux/of.h>
-#include <linux/of_fdt.h>
+#include <linux/of_address.h>
 #include <linux/vexpress.h>
 
 #include <asm/mcpm.h>
@@ -26,125 +25,13 @@
 
 #include "core.h"
 
-#if defined(CONFIG_OF)
-
-static enum {
-	GENERIC_SCU,
-	CORTEX_A9_SCU,
-} vexpress_dt_scu __initdata = GENERIC_SCU;
-
-static struct map_desc vexpress_dt_cortex_a9_scu_map __initdata = {
-	.virtual	= V2T_PERIPH,
-	/* .pfn	set in vexpress_dt_init_cortex_a9_scu() */
-	.length		= SZ_128,
-	.type		= MT_DEVICE,
-};
-
-static void *vexpress_dt_cortex_a9_scu_base __initdata;
-
-const static char *vexpress_dt_cortex_a9_match[] __initconst = {
-	"arm,cortex-a5-scu",
-	"arm,cortex-a9-scu",
-	NULL
-};
-
-static int __init vexpress_dt_find_scu(unsigned long node,
-		const char *uname, int depth, void *data)
-{
-	if (of_flat_dt_match(node, vexpress_dt_cortex_a9_match)) {
-		phys_addr_t phys_addr;
-		__be32 *reg = of_get_flat_dt_prop(node, "reg", NULL);
-
-		if (WARN_ON(!reg))
-			return -EINVAL;
-
-		phys_addr = be32_to_cpup(reg);
-		vexpress_dt_scu = CORTEX_A9_SCU;
-
-		vexpress_dt_cortex_a9_scu_map.pfn = __phys_to_pfn(phys_addr);
-		iotable_init(&vexpress_dt_cortex_a9_scu_map, 1);
-		vexpress_dt_cortex_a9_scu_base = ioremap(phys_addr, SZ_256);
-		if (WARN_ON(!vexpress_dt_cortex_a9_scu_base))
-			return -EFAULT;
-	}
-
-	return 0;
-}
-
-void __init vexpress_dt_smp_map_io(void)
-{
-	if (initial_boot_params)
-		WARN_ON(of_scan_flat_dt(vexpress_dt_find_scu, NULL));
-}
-
-static void __init vexpress_dt_smp_init_cpus(void)
-{
-	int ncores = 0, i;
-
-	switch (vexpress_dt_scu) {
-	case GENERIC_SCU:
-		return;
-	case CORTEX_A9_SCU:
-		ncores = scu_get_core_count(vexpress_dt_cortex_a9_scu_base);
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	if (ncores < 2)
-		return;
-
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-				ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; ++i)
-		set_cpu_possible(i, true);
-}
-
-static void __init vexpress_dt_smp_prepare_cpus(unsigned int max_cpus)
-{
-
-	switch (vexpress_dt_scu) {
-	case GENERIC_SCU:
-		break;
-	case CORTEX_A9_SCU:
-		scu_enable(vexpress_dt_cortex_a9_scu_base);
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-}
-
-#else
-
-static void __init vexpress_dt_smp_init_cpus(void)
-{
-	WARN_ON(1);
-}
-
-void __init vexpress_dt_smp_prepare_cpus(unsigned int max_cpus)
-{
-	WARN_ON(1);
-}
-
-#endif
-
 /*
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
 static void __init vexpress_smp_init_cpus(void)
 {
-	if (ct_desc)
-		ct_desc->init_cpu_map();
-	else
-		vexpress_dt_smp_init_cpus();
-
+	ct_desc->init_cpu_map();
 }
 
 static void __init vexpress_smp_prepare_cpus(unsigned int max_cpus)
@@ -153,10 +40,7 @@ static void __init vexpress_smp_prepare_cpus(unsigned int max_cpus)
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	if (ct_desc)
-		ct_desc->smp_enable(max_cpus);
-	else
-		vexpress_dt_smp_prepare_cpus(max_cpus);
+	ct_desc->smp_enable(max_cpus);
 
 	/*
 	 * Write the address of secondary startup into the
@@ -194,3 +78,39 @@ bool __init vexpress_smp_init_ops(void)
 #endif
 	return false;
 }
+
+#if defined(CONFIG_OF)
+
+static const struct of_device_id vexpress_smp_dt_scu_match[] __initconst = {
+	{ .compatible = "arm,cortex-a5-scu", },
+	{ .compatible = "arm,cortex-a9-scu", },
+	{}
+};
+
+static void __init vexpress_smp_dt_prepare_cpus(unsigned int max_cpus)
+{
+	struct device_node *scu = of_find_matching_node(NULL,
+			vexpress_smp_dt_scu_match);
+
+	if (scu)
+		scu_enable(of_iomap(scu, 0));
+
+	/*
+	 * Write the address of secondary startup into the
+	 * system-wide flags register. The boot monitor waits
+	 * until it receives a soft interrupt, and then the
+	 * secondary CPU branches to this address.
+	 */
+	vexpress_flags_set(virt_to_phys(versatile_secondary_startup));
+}
+
+struct smp_operations __initdata vexpress_smp_dt_ops = {
+	.smp_prepare_cpus	= vexpress_smp_dt_prepare_cpus,
+	.smp_secondary_init	= versatile_secondary_init,
+	.smp_boot_secondary	= versatile_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= vexpress_cpu_die,
+#endif
+};
+
+#endif
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 8e0e872..746d35d 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -399,10 +399,6 @@ void __init v2m_dt_map_io(void)
 		iotable_init(&v2m_rs1_io_desc, 1);
 	else
 		iotable_init(v2m_io_desc, ARRAY_SIZE(v2m_io_desc));
-
-#if defined(CONFIG_SMP)
-	vexpress_dt_smp_map_io();
-#endif
 }
 
 void __init v2m_dt_init_early(void)
@@ -441,7 +437,7 @@ static const char * const v2m_dt_match[] __initconst = {
 
 DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.dt_compat	= v2m_dt_match,
-	.smp		= smp_ops(vexpress_smp_ops),
+	.smp		= smp_ops(vexpress_smp_dt_ops),
 	.smp_init	= smp_init_ops(vexpress_smp_init_ops),
 	.map_io		= v2m_dt_map_io,
 	.init_early	= v2m_dt_init_early,
-- 
1.8.3.2


