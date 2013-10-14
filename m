Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3JNUf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3JNUf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:35:56 -0400
Date: Mon, 14 Oct 2013 16:35:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: dave.hansen@linux.intel.com, a.p.zijlstra@chello.nl, eranian@google.com,
        ak@linux.intel.com
Cc: jmario@redhat.com, linux-kernel@vger.kernel.org
Subject: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131014203549.GY227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I have been playing with quad socket Ivy Bridges for awhile and have seen
numerous "perf samples too long" messages, to the point, the machine is
unusable for any perf analyzing.

So I tried to investigate the source of the NMI latencies using the
traditional 'rdtscll()' command.  That failed miserably.  Then it was
pointed out to me that rdtscll() is terrible for benchmarking due to
out-of-order execution by the Intel processors.  This Intel whitepaper
describes a better way using cpuid and rdtsc:

http://www.intel.fr/content/dam/www/public/us/en/documents/white-papers/ia-32-ia-64-benchmark-code-execution-paper.pdf

(I attached the patch I used below)

This gave more stable numbers such that I could now narrow things down.
While there are a few places that are causing latencies, for now I focused on
the longest one first.  It seems to be 'copy_user_from_nmi'

intel_pmu_handle_irq ->
	intel_pmu_drain_pebs_nhm ->
		__intel_pmu_drain_pebs_nhm ->
			__intel_pmu_pebs_event ->
				intel_pmu_pebs_fixup_ip ->
					copy_from_user_nmi

In intel_pmu_pebs_fixup_ip(), if the while-loop goes over 50, the sum of
all the copy_from_user_nmi latencies seems to go over 1,000,000 cycles
(there are some cases where only 10 iterations are needed to go that high
too, but in generall over 50 or so).  At this point copy_user_from_nmi
seems to account for over 90% of the nmi latency.

I am not entirely familar with how copy_from_user_nmi() works, so I am
posting this email to help with suggestions on how to proceed or if this is
even an issue.

The command I most frequently run to gather my data is:

<some linpack benchmark test in background>
perf record  -W -d -a -e cpu/mem-loads,ldlat=30/pp,cpu/mem-stores/pp sleep 50

Help?

Cheers,
Don


diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index cb75028..f957948 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -57,6 +57,39 @@ static inline unsigned long long native_read_tscp(unsigned int *aux)
 #define EAX_EDX_RET(val, low, high)	"=A" (val)
 #endif
 
+/* benchmark functions based on the Intel doc .... */
+static __always_inline unsigned long long __benchmark_start(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("cpuid\n\t"
+		     "rdtsc\n\t"
+		     "mov %%edx, %0\n\t"
+		     "mov %%eax, %1\n\t" : "=r" (high), "=r" (low)
+		     :: "%rax", "%rbx", "%rcx", "%rdx");
+
+	return EAX_EDX_VAL(val, low, high);
+}
+
+static __always_inline unsigned long long __benchmark_stop(void)
+{
+	unsigned low, high;
+
+	asm volatile(".byte 0x0f,0x01,0xf9\n\t"
+		     "mov %%edx, %0\n\t"
+		     "mov %%eax, %1\n\t"
+		     "cpuid\n\t" : "=r" (high), "=r" (low)
+		     :: "%rax", "%rbx", "%rcx", "%rdx");
+
+	return low | ((u64)high << 32);
+}
+
+#define benchmark_start(val)						\
+	((val) = __benchmark_start())
+
+#define benchmark_stop(val)						\
+	((val) = __benchmark_stop())
+
 static inline unsigned long long native_read_msr(unsigned int msr)
 {
 	DECLARE_ARGS(val, low, high);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3e6c653..d6ffea2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -143,6 +143,8 @@ struct cpu_hw_events {
 	 */
 	struct debug_store	*ds;
 	u64			pebs_enabled;
+	u64			benchmark;
+	int			count;
 
 	/*
 	 * Intel LBR bits
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d9cb6a7..eb3e5e5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1180,8 +1180,13 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	int bit, loops;
 	u64 status;
 	int handled;
+	u64 start, finish;
+	u64 finish1=0;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
+	cpuc->benchmark = 0;
+	cpuc->count = 0;
+	benchmark_start(start);
 
 	/*
 	 * Some chipsets need to unmask the LVTPC in a particular spot
@@ -1223,6 +1228,7 @@ again:
 		x86_pmu.drain_pebs(regs);
 	}
 
+	benchmark_stop(finish1);
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -1251,6 +1257,11 @@ again:
 		goto again;
 
 done:
+	benchmark_stop(finish);
+	if (((finish - start) > 10000))
+		trace_printk("DON [%d][%d]: %lld/%lld/%lld\n", handled, cpuc->count,
+				(finish - start), (finish1-start),(cpuc->benchmark));
+
 	intel_pmu_enable_all(0);
 	return handled;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 60250f6..b4ab92d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -617,6 +617,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
+	u64 start, finish;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -660,9 +661,19 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		if (!kernel_ip(ip)) {
 			int bytes, size = MAX_INSN_SIZE;
 
+			benchmark_start(start);
 			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
-			if (bytes != size)
+			benchmark_stop(finish);
+			cpuc->benchmark += finish - start;
+
+			//count how many non-kernel_ip paths taken
+			cpuc->count += 10000;
+
+			if (bytes != size) {
+				//mark early exit
+				cpuc->count += 10000000;
 				return 0;
+			}
 
 			kaddr = buf;
 		} else
@@ -674,6 +685,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		insn_init(&insn, kaddr, is_64bit);
 		insn_get_length(&insn);
 		to += insn.length;
+		cpuc->count++;
 	} while (to < ip);
 
 	if (to == ip) {
