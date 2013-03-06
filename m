Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3CFHTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:19:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:21770 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab3CFHTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:19:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="299868695"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 1/5] x86: Add cpu capability flag X86_FEATURE_NONSTOP_TSC_S3
Date: Wed,  6 Mar 2013 15:17:47 +0800
Message-Id: <1362554271-22382-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some new Intel Atom processors (Penwell and Cloverview), there is
a feature that the TSC won't stop in S3 state, say the TSC value
won't be reset to 0 after resume. This feature makes TSC a more reliable
clocksource and could benefit the timekeeping code during system
suspend/resume cycle, so add a flag for it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..a8466f2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -100,6 +100,7 @@
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
 #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
+#define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 state */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce9..fe57544 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -96,6 +96,18 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 			sched_clock_stable = 1;
 	}
 
+	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
+	if (c->x86 == 6) {
+		switch (c->x86_model) {
+		case 0x27:	/* Penwell */
+		case 0x35:	/* Cloverview */
+			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
+			break;
+		default:
+			;
+		}
+	}
+
 	/*
 	 * There is a known erratum on Pentium III and Core Solo
 	 * and Core Duo CPUs.
-- 
1.7.9.5

