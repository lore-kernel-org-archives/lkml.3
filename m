Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab3FCTsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:48:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54060 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758483Ab3FCTsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:48:08 -0400
Message-ID: <51ACF2F6.70605@semaphore.gr>
Date: Mon, 03 Jun 2013 22:48:06 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] cpufreq: Remove unused APERF/MPERF support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculation of frequency target in ondemand governor changed and it is
independent from measured average frequency.

Remove unused APERF/MPERF support.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 arch/x86/include/asm/processor.h | 29 -----------------------
 drivers/cpufreq/mperf.c          | 51 ----------------------------------------
 drivers/cpufreq/mperf.h          |  9 -------
 3 files changed, 89 deletions(-)
 delete mode 100644 drivers/cpufreq/mperf.c
 delete mode 100644 drivers/cpufreq/mperf.h

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 22224b3..2874a3b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -941,35 +941,6 @@ extern int set_tsc_mode(unsigned int val);
 
 extern u16 amd_get_nb_id(int cpu);
 
-struct aperfmperf {
-	u64 aperf, mperf;
-};
-
-static inline void get_aperfmperf(struct aperfmperf *am)
-{
-	WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_APERFMPERF));
-
-	rdmsrl(MSR_IA32_APERF, am->aperf);
-	rdmsrl(MSR_IA32_MPERF, am->mperf);
-}
-
-#define APERFMPERF_SHIFT 10
-
-static inline
-unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
-				    struct aperfmperf *new)
-{
-	u64 aperf = new->aperf - old->aperf;
-	u64 mperf = new->mperf - old->mperf;
-	unsigned long ratio = aperf;
-
-	mperf >>= APERFMPERF_SHIFT;
-	if (mperf)
-		ratio = div64_u64(aperf, mperf);
-
-	return ratio;
-}
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/drivers/cpufreq/mperf.c b/drivers/cpufreq/mperf.c
deleted file mode 100644
index 911e193..0000000
--- a/drivers/cpufreq/mperf.c
+++ /dev/null
@@ -1,51 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
-#include <linux/slab.h>
-
-#include "mperf.h"
-
-static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
-
-/* Called via smp_call_function_single(), on the target CPU */
-static void read_measured_perf_ctrs(void *_cur)
-{
-	struct aperfmperf *am = _cur;
-
-	get_aperfmperf(am);
-}
-
-/*
- * Return the measured active (C0) frequency on this CPU since last call
- * to this function.
- * Input: cpu number
- * Return: Average CPU frequency in terms of max frequency (zero on error)
- *
- * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
- * over a period of time, while CPU is in C0 state.
- * IA32_MPERF counts at the rate of max advertised frequency
- * IA32_APERF counts at the rate of actual CPU frequency
- * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
- * no meaning should be associated with absolute values of these MSRs.
- */
-unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
-					unsigned int cpu)
-{
-	struct aperfmperf perf;
-	unsigned long ratio;
-	unsigned int retval;
-
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
-		return 0;
-
-	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
-	per_cpu(acfreq_old_perf, cpu) = perf;
-
-	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
-
-	return retval;
-}
-EXPORT_SYMBOL_GPL(cpufreq_get_measured_perf);
-MODULE_LICENSE("GPL");
diff --git a/drivers/cpufreq/mperf.h b/drivers/cpufreq/mperf.h
deleted file mode 100644
index 5dbf295..0000000
--- a/drivers/cpufreq/mperf.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- *  (c) 2010 Advanced Micro Devices, Inc.
- *  Your use of this code is subject to the terms and conditions of the
- *  GNU general public license version 2. See "COPYING" or
- *  http://www.gnu.org/licenses/gpl.html
- */
-
-unsigned int cpufreq_get_measured_perf(struct cpufreq_policy *policy,
-					unsigned int cpu);
-- 
1.8.1.4

