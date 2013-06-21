Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422840Ab3FUJC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:02:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965496Ab3FUJCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:02:52 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        eabatalov89@gmail.com
Subject: [PATCH 2/2] x86: kvmclock: register per-cpu kvmclock at earliest possible time
Date: Fri, 21 Jun 2013 11:01:21 +0200
Message-Id: <1371805281-21305-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <bug-59521-28872@https.bugzilla.kernel.org/>
References: <bug-59521-28872@https.bugzilla.kernel.org/>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk's in cpu_init() might access per-cpu pv_clock before it's
registered. Which might lead to an incorrect last_value value or
big jumps in it depending on current contents of kvm's hv_clock.

Also ftrace by default uses local clock for time-stamping its
records, which might cause access to not yet registered per-cpu
kvmclock during cpu_init() execution:
   function_trace_call -> trace_function ->
       trace_buffer_lock_reserve -> ring_buffer_lock_reserve ->
           rb_reserve_next_event -> rb_time_stamp ->
               trace_clock_local -> sched_clock ->
                   paravirt_sched_clock ->
                       kvm_clock_read

Fix provides a simplified version of kvm_setup_secondary_clock(),
that could be safely used before cpu_init() and turns off tracing
for its underlying calls to prevent premature access to kvmclock
during its registration. So that any following usage of
sched_clock() would yield correct value.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/kvmclock.c |   11 +++++++++--
 arch/x86/kernel/smpboot.c  |    2 +-
 arch/x86/mm/pageattr.c     |    4 ++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 3dd37eb..4660b59 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -185,13 +185,20 @@ static void kvm_restore_sched_clock_state(void)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-static void __cpuinit kvm_setup_secondary_clock(void)
+static void __cpuinit notrace kvm_setup_secondary_clock(void)
 {
 	/*
 	 * Now that the first cpu already had this clocksource initialized,
 	 * we shouldn't fail.
 	 */
-	WARN_ON(kvm_register_clock("secondary cpu clock"));
+	int cpu = stack_smp_processor_id();
+	int low, high;
+	struct pvclock_vcpu_time_info *src;
+
+	src = &hv_clock[cpu].pvti;
+	low = (int)slow_virt_to_phys(src) | 1;
+	high = ((u64)slow_virt_to_phys(src) >> 32);
+	native_write_msr_safe(msr_kvm_system_time, low, high);
 }
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51..5e2b7cb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -244,8 +244,8 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 * fragile that we want to limit the things done here to the
 	 * most necessary things.
 	 */
-	cpu_init();
 	x86_cpuinit.early_percpu_clock_init();
+	cpu_init();
 	preempt_disable();
 	smp_callin();
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb32480..06cabff 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -330,7 +330,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
  * or when the present bit is not set. Otherwise we would return a
  * pointer to a nonexisting mapping.
  */
-pte_t *lookup_address(unsigned long address, unsigned int *level)
+pte_t notrace *lookup_address(unsigned long address, unsigned int *level)
 {
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
@@ -374,7 +374,7 @@ EXPORT_SYMBOL_GPL(lookup_address);
  * unoptimized should increase the testing coverage for
  * the more obscure platforms.
  */
-phys_addr_t slow_virt_to_phys(void *__virt_addr)
+phys_addr_t notrace slow_virt_to_phys(void *__virt_addr)
 {
 	unsigned long virt_addr = (unsigned long)__virt_addr;
 	phys_addr_t phys_addr;
-- 
1.7.1

