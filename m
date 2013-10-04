Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3JDVld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:41:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:30818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab3JDVjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="388081443"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, bp@suse.de
Subject: [PATCH 1/6] perf, x86, amd: Move __get_ibs_caps into common amd CPU file
Date: Fri,  4 Oct 2013 14:39:43 -0700
Message-Id: <1380922788-23112-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

__get_ibs_caps is used by both oprofile and perf events.
This causes oprofile to be dependent on perf.

__get_ibs_caps is actually only a few lines, so we can
easily move that to the standard AMD CPU initialization
file.

It will be always compiled in this way, but it's far
better than requiring perf always to be compiled in for this.

Cc: bp@suse.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h        |  2 ++
 arch/x86/kernel/cpu/amd.c                | 27 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 23 -----------------------
 arch/x86/oprofile/op_model_amd.c         |  4 +++-
 4 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8249df4..866b0f3 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -198,6 +198,8 @@ struct x86_pmu_capability {
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 #define IBS_RIP_INVALID		(1ULL<<38)
 
+extern u32 __get_ibs_caps(void);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 extern u32 get_ibs_caps(void);
 #else
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 903a264..887ad1e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -16,6 +16,8 @@
 # include <asm/cacheflush.h>
 #endif
 
+#include <asm/perf_event.h>
+
 #include "cpu.h"
 
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
@@ -909,3 +911,28 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 
 	return false;
 }
+
+
+/* IBS - apic initialization, for perf and oprofile */
+
+u32 __get_ibs_caps(void)
+{
+	u32 caps;
+	unsigned int max_level;
+
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return 0;
+
+	/* check IBS cpuid feature flags */
+	max_level = cpuid_eax(0x80000000);
+	if (max_level < IBS_CPUID_FEATURES)
+		return IBS_CAPS_DEFAULT;
+
+	caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (!(caps & IBS_CAPS_AVAIL))
+		/* cpuid flags not valid */
+		return IBS_CAPS_DEFAULT;
+
+	return caps;
+}
+EXPORT_SYMBOL(__get_ibs_caps);
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..c4fed71 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -664,29 +664,6 @@ static __init int perf_event_ibs_init(void) { return 0; }
 
 #endif
 
-/* IBS - apic initialization, for perf and oprofile */
-
-static __init u32 __get_ibs_caps(void)
-{
-	u32 caps;
-	unsigned int max_level;
-
-	if (!boot_cpu_has(X86_FEATURE_IBS))
-		return 0;
-
-	/* check IBS cpuid feature flags */
-	max_level = cpuid_eax(0x80000000);
-	if (max_level < IBS_CPUID_FEATURES)
-		return IBS_CAPS_DEFAULT;
-
-	caps = cpuid_eax(IBS_CPUID_FEATURES);
-	if (!(caps & IBS_CAPS_AVAIL))
-		/* cpuid flags not valid */
-		return IBS_CAPS_DEFAULT;
-
-	return caps;
-}
-
 u32 get_ibs_caps(void)
 {
 	return ibs_caps;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 50d86c0..964171f 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -26,6 +26,8 @@
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
 
+#include <asm/perf_event.h> /* for __get_ibs_caps */
+
 #include "op_x86_model.h"
 #include "op_counter.h"
 
@@ -446,7 +448,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 
 static void init_ibs(void)
 {
-	ibs_caps = get_ibs_caps();
+	ibs_caps = __get_ibs_caps();
 
 	if (!ibs_caps)
 		return;
-- 
1.8.3.1

