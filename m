Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968243Ab3DSKsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:48:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:21109
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968139Ab3DSKsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 14/15] powerpc/smp: add cpu hotplug support for e6500
Date: Fri, 19 Apr 2013 18:47:47 +0800
Message-ID: <1366368468-29143-14-git-send-email-chenhui.zhao@freescale.com>
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

* Only if two threads of one core are offline, the core can
  enter PH20 state.
* Clear PH20 bits before core reset, or core will not restart.
* Introduced a variable l2cache_type in the struce cpu_spec to
  indentify the type of L2 cache.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Andy Fleming <afleming@freescale.com>
---
 arch/powerpc/include/asm/cputable.h |   10 ++++++++
 arch/powerpc/kernel/cputable.c      |    5 ++++
 arch/powerpc/platforms/85xx/smp.c   |   40 +++++++++++++++++++++++++++++-----
 3 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index f326444..3715def 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -33,6 +33,13 @@ enum powerpc_pmc_type {
 	PPC_PMC_G4 = 3,
 };
 
+enum powerpc_l2cache_type {
+	PPC_L2_CACHE_DEFAULT = 0,
+	PPC_L2_CACHE_CORE    = 1, /* L2 cache used exclusively by one core */
+	PPC_L2_CACHE_CLUSTER = 2, /* L2 cache shared by a core cluster */
+	PPC_L2_CACHE_SOC     = 3, /* L2 cache shared by all cores */
+};
+
 struct pt_regs;
 
 extern int machine_check_generic(struct pt_regs *regs);
@@ -58,6 +65,9 @@ struct cpu_spec {
 	unsigned int	icache_bsize;
 	unsigned int	dcache_bsize;
 
+	/* L2 cache type */
+	enum powerpc_l2cache_type l2cache_type;
+
 	/* number of performance monitor counters */
 	unsigned int	num_pmcs;
 	enum powerpc_pmc_type pmc_type;
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index cc39139..a7329c1 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -2004,6 +2004,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_setup		= __setup_cpu_e500v1,
 		.machine_check		= machine_check_e500,
 		.platform		= "ppc8540",
+		.l2cache_type		= PPC_L2_CACHE_SOC,
 	},
 	{	/* e500v2 */
 		.pvr_mask		= 0xffff0000,
@@ -2023,6 +2024,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_setup		= __setup_cpu_e500v2,
 		.machine_check		= machine_check_e500,
 		.platform		= "ppc8548",
+		.l2cache_type		= PPC_L2_CACHE_SOC,
 	},
 	{	/* e500mc */
 		.pvr_mask		= 0xffff0000,
@@ -2040,6 +2042,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_setup		= __setup_cpu_e500mc,
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce500mc",
+		.l2cache_type		= PPC_L2_CACHE_CORE,
 	},
 #endif /* CONFIG_PPC32 */
 	{	/* e5500 */
@@ -2061,6 +2064,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 #endif
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce5500",
+		.l2cache_type		= PPC_L2_CACHE_CORE,
 	},
 	{	/* e6500 */
 		.pvr_mask		= 0xffff0000,
@@ -2082,6 +2086,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 #endif
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce6500",
+		.l2cache_type		= PPC_L2_CACHE_CLUSTER,
 	},
 #ifdef CONFIG_PPC32
 	{	/* default match */
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 5f3eee3..a8b4df7 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -166,13 +166,31 @@ static void core_reset_erratum(int hw_cpu)
 {
 #ifdef CONFIG_PPC_E500MC
 	struct ccsr_rcpm __iomem *rcpm = guts_regs;
+	struct ccsr_rcpm_v2 __iomem *rcpm_v2 = guts_regs;
 
-	clrbits32(&rcpm->cnapcr, 1 << hw_cpu);
+	if (rcpmv2)
+		setbits32(&rcpm_v2->pcph20clrr,
+			1 << cpu_core_index_of_thread(hw_cpu));
+	else
+		clrbits32(&rcpm->cnapcr, 1 << hw_cpu);
 #endif
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 #ifdef CONFIG_PPC_E500MC
+static inline bool is_core_down(unsigned int thread)
+{
+	cpumask_t thd_mask;
+
+	if (!smt_capable())
+		return true;
+
+	cpumask_shift_left(&thd_mask, &threads_core_mask,
+			cpu_core_index_of_thread(thread) * threads_per_core);
+
+	return !cpumask_intersects(&thd_mask, cpu_online_mask);
+}
+
 static void __cpuinit smp_85xx_mach_cpu_die(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -183,8 +201,11 @@ static void __cpuinit smp_85xx_mach_cpu_die(void)
 
 	mtspr(SPRN_TCR, 0);
 
-	__flush_disable_L1();
-	disable_backside_L2_cache();
+	if (is_core_down(cpu))
+		__flush_disable_L1();
+
+	if (cur_cpu_spec->l2cache_type == PPC_L2_CACHE_CORE)
+		disable_backside_L2_cache();
 
 	generic_set_cpu_dead(cpu);
 
@@ -195,9 +216,16 @@ void platform_cpu_die(unsigned int cpu)
 {
 	unsigned int hw_cpu = get_hard_smp_processor_id(cpu);
 	struct ccsr_rcpm __iomem *rcpm = guts_regs;
-
-	/* Core Nap Operation */
-	setbits32(&rcpm->cnapcr, 1 << hw_cpu);
+	struct ccsr_rcpm_v2 __iomem *rcpm_v2 = guts_regs;
+
+	if (rcpmv2 && is_core_down(cpu)) {
+		/* enter PH20 status */
+		setbits32(&rcpm_v2->pcph20setr,
+			1 << cpu_core_index_of_thread(hw_cpu));
+	} else if (!rcpmv2) {
+		/* Core Nap Operation */
+		setbits32(&rcpm->cnapcr, 1 << hw_cpu);
+	}
 }
 #else
 /* for e500v1 and e500v2 */
-- 
1.7.3


