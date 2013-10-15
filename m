Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3JOOcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:32:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab3JOOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:32:42 -0400
Date: Tue, 15 Oct 2013 16:32:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131015143227.GY26785@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015130226.GX26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This one seems to actually work and is somewhat simpler.

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 32e9ed81cd00..9c7e043f8514 100644
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
@@ -729,6 +731,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
+	void *kaddr;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -763,29 +766,33 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		return 1;
 	}
 
+	if (!kernel_ip(ip)) {
+		int size, bytes;
+		u8 *buf = &__get_cpu_var(insn_page[0]);
+
+		size = ip - to; /* Must be le than PAGE_SIZE, see above */
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
