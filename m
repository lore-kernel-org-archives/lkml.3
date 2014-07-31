Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaGaJsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbaGaJsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:48:35 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        pbonzini@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com
Subject: [PATCH 1/2] x86: AMD: mark TSC unstable on APU family 15h models 10h-1fh
Date: Thu, 31 Jul 2014 09:47:12 +0000
Message-Id: <1406800033-13404-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
References: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to erratum #778 from
"Revision Guide for AMD Family 15h Models 10h-1Fh Processors,
 Publication # 48931, Issue Date: May 2013, Revision: 3.10"

TSC on affected processor, a core may drift under certain conditions,
which makes initially synchronized TSCs to become unsynchronized.

As result TSC clocksource becomes unsuitable for using as wallclock
and it brakes pvclock when it's running with PVCLOCK_TSC_STABLE_BIT
flag set.
That causes backwards clock jumps when pvclock is first read on
CPU with drifted TSC and then on CPU where TSC was stable or had
a lower drift rate.

To fix issue mark TSC as unstable on affected CPU, so it won't
be used as clocksource. Which in turn disables master_clock
mechanism in KVM and force pvclock using global clock counter
that can't go backwards.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/kernel/cpu/amd.c         | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e265ff9..c47a2a77 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -236,6 +236,7 @@
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
 #define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
 #define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
+#define X86_BUG_AMD_TSC_DRIFT	X86_BUG(5) /* AMD Erratum 778 */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff..5623eb8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -513,6 +513,7 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 
 static const int amd_erratum_383[];
 static const int amd_erratum_400[];
+static const int amd_erratum_778[];
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
 static void init_amd(struct cpuinfo_x86 *c)
@@ -721,6 +722,11 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (cpu_has_amd_erratum(c, amd_erratum_400))
 		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
 
+	if (cpu_has_amd_erratum(c, amd_erratum_778)) {
+		set_cpu_bug(c, X86_BUG_AMD_TSC_DRIFT);
+		mark_tsc_unstable("possible TSC drift as per erratum #778");
+	}
+
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
 }
 
@@ -857,6 +863,9 @@ static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
 
+static const int amd_erratum_778[] =
+	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x15, 0x10, 0, 0x1f, 0xf));
+
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 {
 	int osvw_id = *erratum++;
-- 
1.8.3.1

