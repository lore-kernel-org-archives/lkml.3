Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab3JOKO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:14:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52214 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab3JOKOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:14:16 -0400
Date: Tue, 15 Oct 2013 12:14:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131015101404.GD10651@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014203549.GY227855@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 04:35:49PM -0400, Don Zickus wrote:

> This gave more stable numbers such that I could now narrow things down.
> While there are a few places that are causing latencies, for now I focused on
> the longest one first.  It seems to be 'copy_user_from_nmi'
> 
> intel_pmu_handle_irq ->
> 	intel_pmu_drain_pebs_nhm ->
> 		__intel_pmu_drain_pebs_nhm ->
> 			__intel_pmu_pebs_event ->
> 				intel_pmu_pebs_fixup_ip ->
> 					copy_from_user_nmi
> 
> In intel_pmu_pebs_fixup_ip(), if the while-loop goes over 50, the sum of
> all the copy_from_user_nmi latencies seems to go over 1,000,000 cycles
> (there are some cases where only 10 iterations are needed to go that high
> too, but in generall over 50 or so).  At this point copy_user_from_nmi
> seems to account for over 90% of the nmi latency.

What does the below do? It appears the perf userspace lost the ability
to display the MISC_EXACT_IP percentage so I've no clue if it actually
works or not.

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 43 ++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 32e9ed81cd00..3978e72a1c9f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -722,6 +722,8 @@ void intel_pmu_pebs_disable_all(void)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 }
 
+static DEFINE_PER_CPU(u8 [PAGE_SIZE], insn_page);
+
 static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -729,6 +731,8 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
+	int size, bytes;
+	void *kaddr;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -763,29 +767,44 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		return 1;
 	}
 
+refill:
+	if (kernel_ip(ip)) {
+		u8 *buf = &__get_cpu_var(insn_page[0]);
+		size = PAGE_SIZE - ((unsigned long)to & (PAGE_SIZE-1));
+		if (size < MAX_INSN_SIZE) {
+			/*
+			 * If we're going to have to touch two pages; just copy
+			 * as much as we can hold.
+			 */
+			size = PAGE_SIZE;
+		}
+		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
+		if (bytes != size)
+			return 0;
+
+		kaddr = buf;
+	} else {
+		size = INT_MAX;
+		kaddr = (void *)to;
+	}
+
 	do {
 		struct insn insn;
-		u8 buf[MAX_INSN_SIZE];
-		void *kaddr;
-
-		old_to = to;
-		if (!kernel_ip(ip)) {
-			int bytes, size = MAX_INSN_SIZE;
 
-			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
-			if (bytes != size)
-				return 0;
+		if (size < MAX_INSN_SIZE)
+			goto refill;
 
-			kaddr = buf;
-		} else
-			kaddr = (void *)to;
+		old_to = to;
 
 #ifdef CONFIG_X86_64
 		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
 #endif
 		insn_init(&insn, kaddr, is_64bit);
 		insn_get_length(&insn);
+
 		to += insn.length;
+		kaddr += insn.length;
+		size -= insn.length;
 	} while (to < ip);
 
 	if (to == ip) {
