Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030485AbaGPTVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:21:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030210AbaGPTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:21:16 -0400
Date: Wed, 16 Jul 2014 12:20:05 -0700
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-338b522ca43cfd32d11a370f4203bcd089c6c877@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, maria.n.dimakopoulou@gmail.com, acme@kernel.org,
        kan.liang@intel.com, zheng.z.yan@intel.com, ak@linux.intel.com,
        junk@eslaf.co.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        maria.n.dimakopoulou@gmail.com, kan.liang@intel.com,
        zheng.z.yan@intel.com, ak@linux.intel.com, tglx@linutronix.de,
        junk@eslaf.co.uk
In-Reply-To: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
References: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Protect LBR and extra_regs against KVM lying
Git-Commit-ID: 338b522ca43cfd32d11a370f4203bcd089c6c877
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  338b522ca43cfd32d11a370f4203bcd089c6c877
Gitweb:     http://git.kernel.org/tip/338b522ca43cfd32d11a370f4203bcd089c6c877
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Mon, 14 Jul 2014 12:25:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:18:43 +0200

perf/x86/intel: Protect LBR and extra_regs against KVM lying

With -cpu host, KVM reports LBR and extra_regs support, if the host has
support.

When the guest perf driver tries to access LBR or extra_regs MSR,
it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs support.
So check the related MSRs access right once at initialization time to avoid
the error access at runtime.

For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y
(for host kernel).
And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest kernel).
Start the guest with -cpu host.
Run perf record with --branch-any or --branch-filter in guest to trigger LBR
Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest to
trigger offcore_rsp #GP

Signed-off-by: Kan Liang <kan.liang@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Mark Davies <junk@eslaf.co.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1405365957-20202-1-git-send-email-kan.liang@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c       |  3 ++
 arch/x86/kernel/cpu/perf_event.h       | 12 ++++---
 arch/x86/kernel/cpu/perf_event_intel.c | 66 +++++++++++++++++++++++++++++++++-
 3 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2bdfbff..2879ecd 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+		/* Check if the extra msrs can be safely accessed*/
+		if (!er->extra_msr_access)
+			return -ENXIO;
 
 		reg->idx = er->idx;
 		reg->config = event->attr.config1;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..8ade931 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -295,14 +295,16 @@ struct extra_reg {
 	u64			config_mask;
 	u64			valid_mask;
 	int			idx;  /* per_xxx->regs[] reg index */
+	bool			extra_msr_access;
 };
 
 #define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
-	.event = (e),		\
-	.msr = (ms),		\
-	.config_mask = (m),	\
-	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i,	\
+	.event = (e),			\
+	.msr = (ms),			\
+	.config_mask = (m),		\
+	.valid_mask = (vm),		\
+	.idx = EXTRA_REG_##i,		\
+	.extra_msr_access = true,	\
 	}
 
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c206815..2502d0d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2182,6 +2182,41 @@ static void intel_snb_check_microcode(void)
 	}
 }
 
+/*
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static bool check_msr(unsigned long msr, u64 mask)
+{
+	u64 val_old, val_new, val_tmp;
+
+	/*
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
+	 */
+	if (rdmsrl_safe(msr, &val_old))
+		return false;
+
+	/*
+	 * Only change the bits which can be updated by wrmsrl.
+	 */
+	val_tmp = val_old ^ mask;
+	if (wrmsrl_safe(msr, val_tmp) ||
+	    rdmsrl_safe(msr, &val_new))
+		return false;
+
+	if (val_new != val_tmp)
+		return false;
+
+	/* Here it's sure that the MSR can be safely accessed.
+	 * Restore the old value and return.
+	 */
+	wrmsrl(msr, val_old);
+
+	return true;
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
 	x86_pmu.check_microcode = intel_snb_check_microcode;
@@ -2271,7 +2306,8 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	struct extra_reg *er;
+	int version, i;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2577,6 +2613,34 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
+		x86_pmu.lbr_nr = 0;
+	for (i = 0; i < x86_pmu.lbr_nr; i++) {
+		if (!(check_msr(x86_pmu.lbr_from + i, 0xffffUL) &&
+		      check_msr(x86_pmu.lbr_to + i, 0xffffUL)))
+			x86_pmu.lbr_nr = 0;
+	}
+
+	/*
+	 * Access extra MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support offcore event
+	 * Check all extra_regs here.
+	 */
+	if (x86_pmu.extra_regs) {
+		for (er = x86_pmu.extra_regs; er->msr; er++) {
+			er->extra_msr_access = check_msr(er->msr, 0x1ffUL);
+			/* Disable LBR select mapping */
+			if ((er->idx == EXTRA_REG_LBR) && !er->extra_msr_access)
+				x86_pmu.lbr_sel_map = NULL;
+		}
+	}
+
 	/* Support full width counters using alternative MSR range */
 	if (x86_pmu.intel_cap.full_width_write) {
 		x86_pmu.max_period = x86_pmu.cntval_mask;
