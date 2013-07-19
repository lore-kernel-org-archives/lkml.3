Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965874Ab3GSFaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:30:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965821Ab3GSF1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 62/72] ARM: 7769/1: Cortex-A15: fix erratum 798181 implementation
Date: Thu, 18 Jul 2013 22:26:19 -0700
Message-Id: <20130719052604.108594547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <Marc.Zyngier@arm.com>

commit 0d0752bca1f9a91fb646647aa4abbb21156f316c upstream.

Looking into the active_asids array is not enough, as we also need
to look into the reserved_asids array (they both represent processes
that are currently running).

Also, not holding the ASID allocator lock is racy, as another CPU
could schedule that process and trigger a rollover, making the erratum
workaround miss an IPI.

Exposing this outside of context.c is a little ugly on the side, so
let's define a new entry point that the erratum workaround can call
to obtain the cpumask.

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/mmu_context.h |   10 +++++++++-
 arch/arm/kernel/smp_tlb.c          |   18 ++----------------
 arch/arm/mm/context.c              |   29 ++++++++++++++++++++++++++++-
 3 files changed, 39 insertions(+), 18 deletions(-)

--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -27,7 +27,15 @@ void __check_vmalloc_seq(struct mm_struc
 void check_and_switch_context(struct mm_struct *mm, struct task_struct *tsk);
 #define init_new_context(tsk,mm)	({ atomic64_set(&mm->context.id, 0); 0; })
 
-DECLARE_PER_CPU(atomic64_t, active_asids);
+#ifdef CONFIG_ARM_ERRATA_798181
+void a15_erratum_get_cpumask(int this_cpu, struct mm_struct *mm,
+			     cpumask_t *mask);
+#else  /* !CONFIG_ARM_ERRATA_798181 */
+static inline void a15_erratum_get_cpumask(int this_cpu, struct mm_struct *mm,
+					   cpumask_t *mask)
+{
+}
+#endif /* CONFIG_ARM_ERRATA_798181 */
 
 #else	/* !CONFIG_CPU_HAS_ASID */
 
--- a/arch/arm/kernel/smp_tlb.c
+++ b/arch/arm/kernel/smp_tlb.c
@@ -103,7 +103,7 @@ static void broadcast_tlb_a15_erratum(vo
 
 static void broadcast_tlb_mm_a15_erratum(struct mm_struct *mm)
 {
-	int cpu, this_cpu;
+	int this_cpu;
 	cpumask_t mask = { CPU_BITS_NONE };
 
 	if (!erratum_a15_798181())
@@ -111,21 +111,7 @@ static void broadcast_tlb_mm_a15_erratum
 
 	dummy_flush_tlb_a15_erratum();
 	this_cpu = get_cpu();
-	for_each_online_cpu(cpu) {
-		if (cpu == this_cpu)
-			continue;
-		/*
-		 * We only need to send an IPI if the other CPUs are running
-		 * the same ASID as the one being invalidated. There is no
-		 * need for locking around the active_asids check since the
-		 * switch_mm() function has at least one dmb() (as required by
-		 * this workaround) in case a context switch happens on
-		 * another CPU after the condition below.
-		 */
-		if (atomic64_read(&mm->context.id) ==
-		    atomic64_read(&per_cpu(active_asids, cpu)))
-			cpumask_set_cpu(cpu, &mask);
-	}
+	a15_erratum_get_cpumask(this_cpu, mm, &mask);
 	smp_call_function_many(&mask, ipi_flush_tlb_a15_erratum, NULL, 1);
 	put_cpu();
 }
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -45,10 +45,37 @@ static DEFINE_RAW_SPINLOCK(cpu_asid_lock
 static atomic64_t asid_generation = ATOMIC64_INIT(ASID_FIRST_VERSION);
 static DECLARE_BITMAP(asid_map, NUM_USER_ASIDS);
 
-DEFINE_PER_CPU(atomic64_t, active_asids);
+static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
 static cpumask_t tlb_flush_pending;
 
+#ifdef CONFIG_ARM_ERRATA_798181
+void a15_erratum_get_cpumask(int this_cpu, struct mm_struct *mm,
+			     cpumask_t *mask)
+{
+	int cpu;
+	unsigned long flags;
+	u64 context_id, asid;
+
+	raw_spin_lock_irqsave(&cpu_asid_lock, flags);
+	context_id = mm->context.id.counter;
+	for_each_online_cpu(cpu) {
+		if (cpu == this_cpu)
+			continue;
+		/*
+		 * We only need to send an IPI if the other CPUs are
+		 * running the same ASID as the one being invalidated.
+		 */
+		asid = per_cpu(active_asids, cpu).counter;
+		if (asid == 0)
+			asid = per_cpu(reserved_asids, cpu);
+		if (context_id == asid)
+			cpumask_set_cpu(cpu, mask);
+	}
+	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
+}
+#endif
+
 #ifdef CONFIG_ARM_LPAE
 static void cpu_set_reserved_ttbr0(void)
 {


