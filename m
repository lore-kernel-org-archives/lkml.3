Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968215Ab3DSKsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:48:36 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14372
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968050Ab3DSKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 10/15] powerpc/85xx: fix 64-bit support for cpu hotplug
Date: Fri, 19 Apr 2013 18:47:43 +0800
Message-ID: <1366368468-29143-10-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Hui Zhao <chenhui.zhao@freescale.com>

* The paca[cpu].cpu_start is used as a signal to indicate if the cpu
  should start. So it should be cleard in .cpu_die().
* The limit memory routine only needs to be ran once at boot time
  by the boot cpu. Prevent other cpus running it again.
* Rearrange the code segment in smp_85xx_kick_cpu() to share codes
  between PPC64 and PPC32 as far as possible.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Andy Fleming <afleming@freescale.com>
---
 arch/powerpc/Kconfig              |    2 +-
 arch/powerpc/kernel/smp.c         |    3 +++
 arch/powerpc/mm/tlb_nohash.c      |    6 ++++--
 arch/powerpc/platforms/85xx/smp.c |   23 +++++++++++------------
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 0ad6e30..aa5794b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -347,7 +347,7 @@ config SWIOTLB
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
 	depends on SMP && HOTPLUG && (PPC_PSERIES || \
-	PPC_PMAC || PPC_POWERNV || PPC_85xx)
+	PPC_PMAC || PPC_POWERNV || FSL_SOC_BOOKE)
 	---help---
 	  Say Y here to be able to disable and re-enable individual
 	  CPUs at runtime on SMP machines.
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 386c7ea..c8aa739 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -401,6 +401,9 @@ void generic_cpu_die(unsigned int cpu)
 		smp_rmb();
 		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
 			platform_cpu_die(cpu);
+#ifdef CONFIG_PPC64
+			paca[cpu].cpu_start = 0;
+#endif
 			return;
 		}
 		msleep(100);
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index 6888cad..de7bf06 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -627,8 +627,10 @@ static void __early_init_mmu(int boot_cpu)
 		num_cams = (mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) / 4;
 		linear_map_top = map_mem_in_cams(linear_map_top, num_cams);
 
-		/* limit memory so we dont have linear faults */
-		memblock_enforce_memory_limit(linear_map_top);
+		if (boot_cpu) {
+			/* limit memory so we dont have linear faults */
+			memblock_enforce_memory_limit(linear_map_top);
+		}
 
 		patch_exception(0x1c0, exc_data_tlb_miss_bolted_book3e);
 		patch_exception(0x1e0, exc_instruction_tlb_miss_bolted_book3e);
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 6eae2e0..74d8cde 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -251,10 +251,6 @@ static int __cpuinit smp_85xx_kick_cpu(int nr)
 		spin_table = phys_to_virt(*cpu_rel_addr);
 
 	local_irq_save(flags);
-#ifdef CONFIG_PPC32
-#ifdef CONFIG_HOTPLUG_CPU
-	/* Corresponding to generic_set_cpu_dead() */
-	generic_set_cpu_up(nr);
 
 	if (system_state == SYSTEM_RUNNING) {
 		/*
@@ -298,12 +294,19 @@ static int __cpuinit smp_85xx_kick_cpu(int nr)
 		/*  clear the acknowledge status */
 		__secondary_hold_acknowledge = -1;
 	}
-#endif
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
@@ -312,18 +315,14 @@ static int __cpuinit smp_85xx_kick_cpu(int nr)
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
+	/* Corresponding to generic_set_cpu_dead() */
+	generic_set_cpu_up(nr);
 	cur_booting_core = hw_cpu;
 
+out:
 	local_irq_restore(flags);
 
 	if (ioremappable)
-- 
1.7.3


