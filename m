Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3FXTjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:39:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:47255 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FXTb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 14/32] tile: delete __cpuinit usage from all tile files
Date: Mon, 24 Jun 2013 15:30:19 -0400
Message-ID: <1372102237-8757-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/tile uses of the __cpuinit macros from
all C files.  Currently tile does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/tile/kernel/irq.c       |  2 +-
 arch/tile/kernel/messaging.c |  2 +-
 arch/tile/kernel/setup.c     | 12 ++++++------
 arch/tile/kernel/smpboot.c   |  8 ++++----
 arch/tile/kernel/time.c      |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 02e6280..3ccf2cd 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -220,7 +220,7 @@ void __init init_IRQ(void)
 	ipi_init();
 }
 
-void __cpuinit setup_irq_regs(void)
+void setup_irq_regs(void)
 {
 	/* Enable interrupt delivery. */
 	unmask_irqs(~0UL);
diff --git a/arch/tile/kernel/messaging.c b/arch/tile/kernel/messaging.c
index 0858ee6..00331af 100644
--- a/arch/tile/kernel/messaging.c
+++ b/arch/tile/kernel/messaging.c
@@ -25,7 +25,7 @@
 /* All messages are stored here */
 static DEFINE_PER_CPU(HV_MsgState, msg_state);
 
-void __cpuinit init_messaging(void)
+void init_messaging(void)
 {
 	/* Allocate storage for messages in kernel space */
 	HV_MsgState *state = &__get_cpu_var(msg_state);
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 68b5426..eceb834 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -58,8 +58,8 @@ struct pglist_data node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
 /* Information on the NUMA nodes that we compute early */
-unsigned long __cpuinitdata node_start_pfn[MAX_NUMNODES];
-unsigned long __cpuinitdata node_end_pfn[MAX_NUMNODES];
+unsigned long node_start_pfn[MAX_NUMNODES];
+unsigned long node_end_pfn[MAX_NUMNODES];
 unsigned long __initdata node_memmap_pfn[MAX_NUMNODES];
 unsigned long __initdata node_percpu_pfn[MAX_NUMNODES];
 unsigned long __initdata node_free_pfn[MAX_NUMNODES];
@@ -84,7 +84,7 @@ unsigned long __initdata boot_pc = (unsigned long)start_kernel;
 
 #ifdef CONFIG_HIGHMEM
 /* Page frame index of end of lowmem on each controller. */
-unsigned long __cpuinitdata node_lowmem_end_pfn[MAX_NUMNODES];
+unsigned long node_lowmem_end_pfn[MAX_NUMNODES];
 
 /* Number of pages that can be mapped into lowmem. */
 static unsigned long __initdata mappable_physpages;
@@ -290,7 +290,7 @@ static void *__init setup_pa_va_mapping(void)
  * This is up to 4 mappings for lowmem, one mapping per memory
  * controller, plus one for our text segment.
  */
-static void __cpuinit store_permanent_mappings(void)
+static void store_permanent_mappings(void)
 {
 	int i;
 
@@ -935,7 +935,7 @@ subsys_initcall(topology_init);
  * So the values we set up here in the hypervisor may be overridden on
  * the boot cpu as arguments are parsed.
  */
-static __cpuinit void init_super_pages(void)
+static void init_super_pages(void)
 {
 #ifdef CONFIG_HUGETLB_SUPER_PAGES
 	int i;
@@ -950,7 +950,7 @@ static __cpuinit void init_super_pages(void)
  *
  * Called from setup_arch() on the boot cpu, or online_secondary().
  */
-void __cpuinit setup_cpu(int boot)
+void setup_cpu(int boot)
 {
 	/* The boot cpu sets up its permanent mappings much earlier. */
 	if (!boot)
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 44bab29..a535655 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -133,14 +133,14 @@ static __init int reset_init_affinity(void)
 }
 late_initcall(reset_init_affinity);
 
-static struct cpumask cpu_started __cpuinitdata;
+static struct cpumask cpu_started;
 
 /*
  * Activate a secondary processor.  Very minimal; don't add anything
  * to this path without knowing what you're doing, since SMP booting
  * is pretty fragile.
  */
-static void __cpuinit start_secondary(void)
+static void start_secondary(void)
 {
 	int cpuid = smp_processor_id();
 
@@ -183,7 +183,7 @@ static void __cpuinit start_secondary(void)
 /*
  * Bring a secondary processor online.
  */
-void __cpuinit online_secondary(void)
+void online_secondary(void)
 {
 	/*
 	 * low-memory mappings have been cleared, flush them from
@@ -210,7 +210,7 @@ void __cpuinit online_secondary(void)
 	cpu_startup_entry(CPUHP_ONLINE);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	/* Wait 5s total for all CPUs for them to come online */
 	static int timeout;
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 5ac397e..7c353d8 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -159,7 +159,7 @@ static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
 	.set_mode = tile_timer_set_mode,
 };
 
-void __cpuinit setup_tile_timer(void)
+void setup_tile_timer(void)
 {
 	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
 
-- 
1.8.1.2

