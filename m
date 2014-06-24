Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaFXN7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:59:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27654 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaFXN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:48 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e7-53a983d953b7
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 2/6] ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
Date: Tue, 24 Jun 2014 15:57:11 +0200
Message-id: <1403618235-19353-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xq7o3m1cGGyzeIWbRu+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfuslusn/GaxWLVrj+MDuweO2fdZffYvKTeo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDI+f1rEUjBFteJA8yTWBsYrsl2MnBwSAiYSDw9MZYSwxSQu3FvPBmILCSxl
	lJjWKtnFyAVk9zFJzJnQwAKSYBNQk/jc8AisSERAVeJz2wJ2EJtZ4AmjxKynbiC2sICfxNYL
	y5lBbBagmhmvT4H18go4SVydd4MJYpmcRO+2N2A1nALOEjvbt7FCLHaS+H+yiWkCI+8CRoZV
	jKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGB9GUH4+JjVocYBTgYlXh4L+xaESzEmlhWXJl7
	iFGCg1lJhPdGzcpgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwpH2s5s/doyzy2jmnUP7tVbsGu
	Z5rPVCX7Jm9c9NvI5GYVH/PXJ6kLJy/lYn3wc/OlAyZnUve9+ryTq/CidM/DS/IHw5zPzqzy
	UvrYXfVO79HtBZbXaq7GVDQsSWu82JBct6pI//4PJvtnsz+oXWrJ4j0aaKuhWmikb6DTLe3w
	2/yo3QXz285KLMUZiYZazEXFiQDU3a0bAgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPU topology is specified in device tree, cpu_logical_map() does
not return core ID anymore, but rather full MPIDR value. This breaks
existing calculation of PMU register offsets on Exynos SoCs.

This patch fixes the problem by adjusting the code to use only core ID
bits of the value returned by cpu_logical_map() to allow CPU topology to
be specified in device tree on Exynos SoCs.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c | 10 ++++++----
 arch/arm/mach-exynos/platsmp.c | 34 +++++++++++++++++++---------------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 69fa483..5644dac 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -40,11 +40,13 @@ static inline void cpu_leave_lowpower(void)
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
+	u32 mpidr = cpu_logical_map(cpu);
+	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+
 	for (;;) {
 
-		/* make cpu1 to be turned off at next WFI command */
-		if (cpu == 1)
-			exynos_cpu_power_down(cpu);
+		/* Turn the CPU off on next WFI instruction. */
+		exynos_cpu_power_down(core_id);
 
 		/*
 		 * here's the WFI
@@ -54,7 +56,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 		    :
 		    : "memory", "cc");
 
-		if (pen_release == cpu_logical_map(cpu)) {
+		if (pen_release == core_id) {
 			/*
 			 * OK, proper wakeup, we're done
 			 */
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 1c8d31e..50b9aad 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -90,7 +90,8 @@ static void exynos_secondary_init(unsigned int cpu)
 static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
-	unsigned long phys_cpu = cpu_logical_map(cpu);
+	u32 mpidr = cpu_logical_map(cpu);
+	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 	int ret = -ENOSYS;
 
 	/*
@@ -104,17 +105,18 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 * the holding pen - release it, then wait for it to flag
 	 * that it has been released by resetting pen_release.
 	 *
-	 * Note that "pen_release" is the hardware CPU ID, whereas
+	 * Note that "pen_release" is the hardware CPU core ID, whereas
 	 * "cpu" is Linux's internal ID.
 	 */
-	write_pen_release(phys_cpu);
+	write_pen_release(core_id);
 
-	if (!exynos_cpu_power_state(cpu)) {
-		exynos_cpu_power_up(cpu);
+	if (!exynos_cpu_power_state(core_id)) {
+		exynos_cpu_power_up(core_id);
 		timeout = 10;
 
 		/* wait max 10 ms until cpu1 is on */
-		while (exynos_cpu_power_state(cpu) != S5P_CORE_LOCAL_PWR_EN) {
+		while (exynos_cpu_power_state(core_id)
+		       != S5P_CORE_LOCAL_PWR_EN) {
 			if (timeout-- == 0)
 				break;
 
@@ -145,20 +147,20 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		 * Try to set boot address using firmware first
 		 * and fall back to boot register if it fails.
 		 */
-		ret = call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr);
+		ret = call_firmware_op(set_cpu_boot_addr, core_id, boot_addr);
 		if (ret && ret != -ENOSYS)
 			goto fail;
 		if (ret == -ENOSYS) {
-			void __iomem *boot_reg = cpu_boot_reg(phys_cpu);
+			void __iomem *boot_reg = cpu_boot_reg(core_id);
 
 			if (IS_ERR(boot_reg)) {
 				ret = PTR_ERR(boot_reg);
 				goto fail;
 			}
-			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+			__raw_writel(boot_addr, cpu_boot_reg(core_id));
 		}
 
-		call_firmware_op(cpu_boot, phys_cpu);
+		call_firmware_op(cpu_boot, core_id);
 
 		arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 
@@ -227,22 +229,24 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 	 * boot register if it fails.
 	 */
 	for (i = 1; i < max_cpus; ++i) {
-		unsigned long phys_cpu;
 		unsigned long boot_addr;
+		u32 mpidr;
+		u32 core_id;
 		int ret;
 
-		phys_cpu = cpu_logical_map(i);
+		mpidr = cpu_logical_map(i);
+		core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 		boot_addr = virt_to_phys(exynos4_secondary_startup);
 
-		ret = call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr);
+		ret = call_firmware_op(set_cpu_boot_addr, core_id, boot_addr);
 		if (ret && ret != -ENOSYS)
 			break;
 		if (ret == -ENOSYS) {
-			void __iomem *boot_reg = cpu_boot_reg(phys_cpu);
+			void __iomem *boot_reg = cpu_boot_reg(core_id);
 
 			if (IS_ERR(boot_reg))
 				break;
-			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
+			__raw_writel(boot_addr, cpu_boot_reg(core_id));
 		}
 	}
 }
-- 
1.9.3

