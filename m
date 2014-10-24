Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbaJXW6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:58:52 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64027 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037AbaJXW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:58:49 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 8/8] x86, perf: Add /sys/devices/cpu/rdpmc=2 to allow rdpmc for all tasks
Date: Fri, 24 Oct 2014 15:58:13 -0700
Message-Id: <caac3c1c707dcca48ecbc35f4def21495856f479.1414190806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While perfmon2 is a sufficiently evil library (it pokes MSRs
directly) that breaking it is fair game, it's still useful, so we
might as well try to support it.  This allows users to write 2 to
/sys/devices/cpu/rdpmc to disable all rdpmc protection so that hack
like perfmon2 can continue to work.

At some point, if perf_event becomes fast enough to replace
perfmon2, then this can go.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/mmu_context.h |  5 ++++-
 arch/x86/kernel/cpu/perf_event.c   | 21 ++++++++++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index ccad8d616038..6133f0d02ea4 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -20,9 +20,12 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
 #endif	/* !CONFIG_PARAVIRT */
 
 #ifdef CONFIG_PERF_EVENTS
+extern struct static_key rdpmc_always_available;
+
 static inline void load_mm_cr4(struct mm_struct *mm)
 {
-	if (atomic_read(&mm->context.perf_rdpmc_allowed))
+	if (static_key_true(&rdpmc_always_available) ||
+	    atomic_read(&mm->context.perf_rdpmc_allowed))
 		cr4_set_bits(X86_CR4_PCE);
 	else
 		cr4_clear_bits(X86_CR4_PCE);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3e875b3b30f2..31fc31e0cf9b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -45,6 +45,8 @@ DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
+struct static_key rdpmc_always_available = STATIC_KEY_INIT_FALSE;
+
 u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -1878,10 +1880,27 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	if (ret)
 		return ret;
 
+	if (val > 2)
+		return -EINVAL;
+
 	if (x86_pmu.attr_rdpmc_broken)
 		return -ENOTSUPP;
 
-	x86_pmu.attr_rdpmc = !!val;
+	if ((val == 2) != (x86_pmu.attr_rdpmc == 2)) {
+		/*
+		 * Changing into or out of always available, aka
+		 * perf-event-bypassing mode.  This path is extremely slow,
+		 * but only root can trigger it, so it's okay.
+		 */
+		if (val == 2)
+			static_key_slow_inc(&rdpmc_always_available);
+		else
+			static_key_slow_dec(&rdpmc_always_available);
+		on_each_cpu(refresh_pce, NULL, 1);
+	}
+
+	x86_pmu.attr_rdpmc = val;
+
 	return count;
 }
 
-- 
1.9.3

