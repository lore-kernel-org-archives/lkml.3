Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbbAWSrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:47:40 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35598 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbbAWSqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:46:01 -0500
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 4/9] x86: Add support for Intel Cache QoS Monitoring (CQM) detection
Date: Fri, 23 Jan 2015 18:45:43 +0000
Message-Id: <1422038748-21397-5-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>

This patch adds support for the new Cache QoS Monitoring (CQM)
feature found in future Intel Xeon processors.  It includes the
new values to track CQM resources to the cpuinfo_x86 structure,
plus the CPUID detection routines for CQM.

CQM allows a process, or set of processes, to be tracked by the CPU
to determine the cache usage of that task group.  Using this data
from the CPU, software can be written to extract this data and
report cache usage and occupancy for a particular process, or
group of processes.

More information about Cache QoS Monitoring can be found in the
Intel (R) x86 Architecture Software Developer Manual, section 17.14.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/cpufeature.h |  9 ++++++++-
 arch/x86/include/asm/processor.h  |  3 +++
 arch/x86/kernel/cpu/common.c      | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index aede2c347bde..54fd8ebd2aae 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -12,7 +12,7 @@
 #include <asm/disabled-features.h>
 #endif
 
-#define NCAPINTS	11	/* N 32-bit words worth of info */
+#define NCAPINTS	13	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
@@ -225,6 +225,7 @@
 #define X86_FEATURE_ERMS	( 9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	( 9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		( 9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_CQM		( 9*32+12) /* Cache QoS Monitoring */
 #define X86_FEATURE_MPX		( 9*32+14) /* Memory Protection Extension */
 #define X86_FEATURE_AVX512F	( 9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
@@ -241,6 +242,12 @@
 #define X86_FEATURE_XGETBV1	(10*32+ 2) /* XGETBV with ECX = 1 */
 #define X86_FEATURE_XSAVES	(10*32+ 3) /* XSAVES/XRSTORS */
 
+/* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:0 (edx), word 11 */
+#define X86_FEATURE_CQM_LLC	(11*32+ 1) /* LLC QoS if 1 */
+
+/* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:1 (edx), word 12 */
+#define X86_FEATURE_CQM_OCCUP_LLC (12*32+ 0) /* LLC occupancy monitoring if 1 */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a092a0cce0b7..242ceed2de84 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -109,6 +109,9 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	int			x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
+	/* Cache QoS architectural values: */
+	int			x86_cache_max_rmid;	/* max index */
+	int			x86_cache_occ_scale;	/* scale to bytes */
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
 	/* cpuid returned max cores value: */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c6049650c093..9b0fb703992a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -644,6 +644,30 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[10] = eax;
 	}
 
+	/* Additional Intel-defined flags: level 0x0000000F */
+	if (c->cpuid_level >= 0x0000000F) {
+		u32 eax, ebx, ecx, edx;
+
+		/* QoS sub-leaf, EAX=0Fh, ECX=0 */
+		cpuid_count(0x0000000F, 0, &eax, &ebx, &ecx, &edx);
+		c->x86_capability[11] = edx;
+		if (cpu_has(c, X86_FEATURE_CQM_LLC)) {
+			/* will be overridden if occupancy monitoring exists */
+			c->x86_cache_max_rmid = ebx;
+
+			/* QoS sub-leaf, EAX=0Fh, ECX=1 */
+			cpuid_count(0x0000000F, 1, &eax, &ebx, &ecx, &edx);
+			c->x86_capability[12] = edx;
+			if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC)) {
+				c->x86_cache_max_rmid = ecx;
+				c->x86_cache_occ_scale = ebx;
+			}
+		} else {
+			c->x86_cache_max_rmid = -1;
+			c->x86_cache_occ_scale = -1;
+		}
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
@@ -832,6 +856,20 @@ static void generic_identify(struct cpuinfo_x86 *c)
 	detect_nopl(c);
 }
 
+static void x86_init_cache_qos(struct cpuinfo_x86 *c)
+{
+	/*
+	 * The heavy lifting of max_rmid and cache_occ_scale are handled
+	 * in get_cpu_cap().  Here we just set the max_rmid for the boot_cpu
+	 * in case CQM bits really aren't there in this CPU.
+	 */
+	if (c != &boot_cpu_data) {
+		boot_cpu_data.x86_cache_max_rmid =
+			min(boot_cpu_data.x86_cache_max_rmid,
+			    c->x86_cache_max_rmid);
+	}
+}
+
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
@@ -921,6 +959,7 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	init_hypervisor(c);
 	x86_init_rdrand(c);
+	x86_init_cache_qos(c);
 
 	/*
 	 * Clear/Set all flags overriden by options, need do it
-- 
1.9.3

