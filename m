Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaCGE6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:58:34 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:38190
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbaCGE6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:58:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH 4/9] powerpc/85xx: support CPU hotplug for e500mc and e5500
Date: Fri, 7 Mar 2014 12:58:00 +0800
Message-ID: <1394168285-32275-4-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemented CPU hotplug on e500mc and e5500. On e5500 both 32-bit and
64-bit modes can work. Used some callback functions implemented in RCPM
driver.

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
 arch/powerpc/Kconfig              |    2 +-
 arch/powerpc/kernel/smp.c         |    6 ++-
 arch/powerpc/mm/tlb_nohash.c      |    6 ++-
 arch/powerpc/platforms/85xx/smp.c |   94 ++++++++++++++++++++++++++++++-------
 4 files changed, 87 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a5e5d2e..05f6323 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -362,7 +362,7 @@ config SWIOTLB
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
 	depends on SMP && (PPC_PSERIES || \
-	PPC_PMAC || PPC_POWERNV || (PPC_85xx && !PPC_E500MC))
+	PPC_PMAC || PPC_POWERNV || FSL_SOC_BOOKE)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index ac2621a..f3f4401 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -405,8 +405,12 @@ void generic_cpu_die(unsigned int cpu)
 
 	for (i = 0; i < 100; i++) {
 		smp_rmb();
-		if (per_cpu(cpu_state, cpu) == CPU_DEAD)
+		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
+#ifdef CONFIG_PPC64
+			paca[cpu].cpu_start = 0;
+#endif
 			return;
+		}
 		msleep(100);
 	}
 	printk(KERN_ERR "CPU%d didn't die...\n", cpu);
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index b37a58e..d24e06c 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -648,8 +648,10 @@ static void __early_init_mmu(int boot_cpu)
 		num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
 		linear_map_top = map_mem_in_cams(linear_map_top, num_cams);
 
-		/* limit memory so we dont have linear faults */
-		memblock_enforce_memory_limit(linear_map_top);
+		if (boot_cpu) {
+			/* limit memory so we dont have linear faults */
+			memblock_enforce_memory_limit(linear_map_top);
+		}
 
 		if (book3e_htw_mode == PPC_HTW_NONE) {
 			patch_exception(0x1c0, exc_data_tlb_miss_bolted_book3e);
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 2e5911e..0047883 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -19,6 +19,7 @@
 #include <linux/kexec.h>
 #include <linux/highmem.h>
 #include <linux/cpu.h>
+#include <linux/smp.h>
 
 #include <asm/machdep.h>
 #include <asm/pgtable.h>
@@ -46,6 +47,17 @@ static u64 timebase;
 static int tb_req;
 static int tb_valid;
 
+#ifdef CONFIG_PPC_E500MC
+/* specify the cpu PM state when cpu dies, PH15/NAP is the default */
+int qoriq_cpu_die_state = E500_PM_PH15;
+#endif
+
+#ifdef CONFIG_PPC_E500MC
+static void mpc85xx_timebase_freeze(int freeze)
+{
+	qoriq_pm_ops->freeze_time_base(freeze);
+}
+#else
 static void mpc85xx_timebase_freeze(int freeze)
 {
 	uint32_t mask;
@@ -58,6 +70,7 @@ static void mpc85xx_timebase_freeze(int freeze)
 
 	in_be32(&guts->devdisr);
 }
+#endif
 
 static void mpc85xx_give_timebase(void)
 {
@@ -125,6 +138,34 @@ static void mpc85xx_take_timebase(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+#ifdef CONFIG_PPC_E500MC
+static void qoriq_cpu_die(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	local_irq_disable();
+#ifdef CONFIG_PPC64
+	__hard_irq_disable();
+#endif
+	idle_task_exit();
+
+	if (qoriq_pm_ops->irq_mask)
+		qoriq_pm_ops->irq_mask(cpu);
+
+	mtspr(SPRN_TCR, 0);
+	mtspr(SPRN_TSR, mfspr(SPRN_TSR));
+
+	generic_set_cpu_dead(cpu);
+
+	if (cur_cpu_spec && cur_cpu_spec->cpu_flush_caches)
+		cur_cpu_spec->cpu_flush_caches();
+
+	qoriq_pm_ops->cpu_enter_state(cpu, qoriq_cpu_die_state);
+
+	while (1)
+		;
+}
+#else
 static void smp_85xx_mach_cpu_die(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -155,6 +196,7 @@ static void smp_85xx_mach_cpu_die(void)
 		;
 }
 #endif
+#endif
 
 static inline void flush_spin_table(void *spin_table)
 {
@@ -208,11 +250,8 @@ static int smp_85xx_kick_cpu(int nr)
 		spin_table = phys_to_virt(*cpu_rel_addr);
 
 	local_irq_save(flags);
-#ifdef CONFIG_PPC32
-#ifdef CONFIG_HOTPLUG_CPU
-	/* Corresponding to generic_set_cpu_dead() */
-	generic_set_cpu_up(nr);
 
+#ifdef CONFIG_HOTPLUG_CPU
 	if (system_state == SYSTEM_RUNNING) {
 		/*
 		 * To keep it compatible with old boot program which uses
@@ -225,6 +264,12 @@ static int smp_85xx_kick_cpu(int nr)
 		out_be32(&spin_table->addr_l, 0);
 		flush_spin_table(spin_table);
 
+#ifdef CONFIG_PPC_E500MC
+		/* Due to an erratum, wake the core before reset. */
+		if (qoriq_pm_ops && qoriq_pm_ops->cpu_exit_state)
+			qoriq_pm_ops->cpu_exit_state(nr, qoriq_cpu_die_state);
+#endif
+
 		/*
 		 * We don't set the BPTR register here since it already points
 		 * to the boot page properly.
@@ -247,13 +292,30 @@ static int smp_85xx_kick_cpu(int nr)
 
 		/*  clear the acknowledge status */
 		__secondary_hold_acknowledge = -1;
+
+#ifdef CONFIG_PPC_E500MC
+		if (qoriq_pm_ops->irq_unmask)
+			qoriq_pm_ops->irq_unmask(nr);
+#endif
 	}
+
+	/* Corresponding to generic_set_cpu_dead() */
+	generic_set_cpu_up(nr);
 #endif
+
 	flush_spin_table(spin_table);
 	out_be32(&spin_table->pir, hw_cpu);
+#ifdef CONFIG_PPC32
 	out_be32(&spin_table->addr_l, __pa(__early_start));
+#else
+	out_be32(&spin_table->addr_h,
+		__pa(*(u64 *)generic_secondary_smp_init) >> 32);
+	out_be32(&spin_table->addr_l,
+		__pa(*(u64 *)generic_secondary_smp_init) & 0xffffffff);
+#endif
 	flush_spin_table(spin_table);
 
+#ifdef CONFIG_PPC32
 	/* Wait a bit for the CPU to ack. */
 	if (!spin_event_timeout(__secondary_hold_acknowledge == hw_cpu,
 					10000, 100)) {
@@ -262,17 +324,10 @@ static int smp_85xx_kick_cpu(int nr)
 		ret = -ENOENT;
 		goto out;
 	}
-out:
 #else
 	smp_generic_kick_cpu(nr);
-
-	flush_spin_table(spin_table);
-	out_be32(&spin_table->pir, hw_cpu);
-	out_be64((u64 *)(&spin_table->addr_h),
-	  __pa((u64)*((unsigned long long *)generic_secondary_smp_init)));
-	flush_spin_table(spin_table);
 #endif
-
+out:
 	local_irq_restore(flags);
 
 	if (ioremappable)
@@ -445,13 +500,18 @@ void __init mpc85xx_smp_init(void)
 								__func__);
 			return;
 		}
-		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
-		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
-#ifdef CONFIG_HOTPLUG_CPU
-		ppc_md.cpu_die = smp_85xx_mach_cpu_die;
-#endif
 	}
 
+	smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
+	smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
+
+#ifdef CONFIG_HOTPLUG_CPU
+#ifdef CONFIG_PPC_E500MC
+	ppc_md.cpu_die = qoriq_cpu_die;
+#else
+	ppc_md.cpu_die = smp_85xx_mach_cpu_die;
+#endif
+#endif
 	smp_ops = &smp_85xx_ops;
 
 #ifdef CONFIG_KEXEC
-- 
1.7.3


