Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab3JQQvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:51:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab3JQQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:50:58 -0400
Date: Thu, 17 Oct 2013 09:50:06 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9536c8d2da8059b00775bd9c5a84816b608cf6f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <20131016105755.GX10651@twins.programming.kicks-ass.net>
References: <20131016105755.GX10651@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Optimize intel_pmu_pebs_fixup_ip()
Git-Commit-ID: 9536c8d2da8059b00775bd9c5a84816b608cf6f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 09:50:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9536c8d2da8059b00775bd9c5a84816b608cf6f4
Gitweb:     http://git.kernel.org/tip/9536c8d2da8059b00775bd9c5a84816b608cf6f4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 15 Oct 2013 12:14:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Oct 2013 15:44:00 +0200

perf/x86: Optimize intel_pmu_pebs_fixup_ip()

There's been reports of high NMI handler overhead, highlighted by
such kernel messages:

  [ 3697.380195] perf samples too long (10009 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
  [ 3697.389509] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 9.331 msecs

Don Zickus analyzed the source of the overhead and reported:

 > While there are a few places that are causing latencies, for now I focused on
 > the longest one first.  It seems to be 'copy_user_from_nmi'
 >
 > intel_pmu_handle_irq ->
 >	intel_pmu_drain_pebs_nhm ->
 >		__intel_pmu_drain_pebs_nhm ->
 >			__intel_pmu_pebs_event ->
 >				intel_pmu_pebs_fixup_ip ->
 >					copy_from_user_nmi
 >
 > In intel_pmu_pebs_fixup_ip(), if the while-loop goes over 50, the sum of
 > all the copy_from_user_nmi latencies seems to go over 1,000,000 cycles
 > (there are some cases where only 10 iterations are needed to go that high
 > too, but in generall over 50 or so).  At this point copy_user_from_nmi
 > seems to account for over 90% of the nmi latency.

The solution to that is to avoid having to call copy_from_user_nmi() for
every instruction.

Since we already limit the max basic block size, we can easily
pre-allocate a piece of memory to copy the entire thing into in one
go.

Don reported this test result:

 > Your patch made a huge difference in improvement.  The
 > copy_from_user_nmi() no longer hits the million of cycles.  I still
 > have a batch of 100,000-300,000 cycles.  My longest NMI paths used
 > to be dominated by copy_from_user_nmi, now it is not (I have to dig
 > up the new hot path).

Reported-and-tested-by: Don Zickus <dzickus@redhat.com>
Cc: jmario@redhat.com
Cc: acme@infradead.org
Cc: dave.hansen@linux.intel.com
Cc: eranian@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131016105755.GX10651@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 52 ++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 32e9ed8..c1760ff 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -12,6 +12,7 @@
 
 #define BTS_BUFFER_SIZE		(PAGE_SIZE << 4)
 #define PEBS_BUFFER_SIZE	PAGE_SIZE
+#define PEBS_FIXUP_SIZE		PAGE_SIZE
 
 /*
  * pebs_record_32 for p4 and core not supported
@@ -228,12 +229,14 @@ void fini_debug_store_on_cpu(int cpu)
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
+static DEFINE_PER_CPU(void *, insn_buffer);
+
 static int alloc_pebs_buffer(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 	int node = cpu_to_node(cpu);
 	int max, thresh = 1; /* always use a single PEBS record */
-	void *buffer;
+	void *buffer, *ibuffer;
 
 	if (!x86_pmu.pebs)
 		return 0;
@@ -242,6 +245,19 @@ static int alloc_pebs_buffer(int cpu)
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
+	/*
+	 * HSW+ already provides us the eventing ip; no need to allocate this
+	 * buffer then.
+	 */
+	if (x86_pmu.intel_cap.pebs_format < 2) {
+		ibuffer = kzalloc_node(PEBS_FIXUP_SIZE, GFP_KERNEL, node);
+		if (!ibuffer) {
+			kfree(buffer);
+			return -ENOMEM;
+		}
+		per_cpu(insn_buffer, cpu) = ibuffer;
+	}
+
 	max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
 
 	ds->pebs_buffer_base = (u64)(unsigned long)buffer;
@@ -262,6 +278,9 @@ static void release_pebs_buffer(int cpu)
 	if (!ds || !x86_pmu.pebs)
 		return;
 
+	kfree(per_cpu(insn_buffer, cpu));
+	per_cpu(insn_buffer, cpu) = NULL;
+
 	kfree((void *)(unsigned long)ds->pebs_buffer_base);
 	ds->pebs_buffer_base = 0;
 }
@@ -729,6 +748,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
+	void *kaddr;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -752,7 +772,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	 * unsigned math, either ip is before the start (impossible) or
 	 * the basic block is larger than 1 page (sanity)
 	 */
-	if ((ip - to) > PAGE_SIZE)
+	if ((ip - to) > PEBS_FIXUP_SIZE)
 		return 0;
 
 	/*
@@ -763,29 +783,33 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		return 1;
 	}
 
+	if (!kernel_ip(ip)) {
+		int size, bytes;
+		u8 *buf = this_cpu_read(insn_buffer);
+
+		size = ip - to; /* Must fit our buffer, see above */
+		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
+		if (bytes != size)
+			return 0;
+
+		kaddr = buf;
+	} else {
+		kaddr = (void *)to;
+	}
+
 	do {
 		struct insn insn;
-		u8 buf[MAX_INSN_SIZE];
-		void *kaddr;
 
 		old_to = to;
-		if (!kernel_ip(ip)) {
-			int bytes, size = MAX_INSN_SIZE;
-
-			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
-			if (bytes != size)
-				return 0;
-
-			kaddr = buf;
-		} else
-			kaddr = (void *)to;
 
 #ifdef CONFIG_X86_64
 		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
 #endif
 		insn_init(&insn, kaddr, is_64bit);
 		insn_get_length(&insn);
+
 		to += insn.length;
+		kaddr += insn.length;
 	} while (to < ip);
 
 	if (to == ip) {
