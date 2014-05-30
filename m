Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaE3Lnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaE3Lnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:43:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>
Subject: [PATCH 2/2] x86, Calculate smp_num_siblings once
Date: Fri, 30 May 2014 07:43:05 -0400
Message-Id: <1401450185-23061-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1401450185-23061-1-git-send-email-prarit@redhat.com>
References: <1401450185-23061-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 boxes, smp_num_siblings is set to a value read in a CPUID call in
detect_ht().  This value is the *factory defined* value in all cases; even
if HT is disabled in BIOS the value still returns 2 if the CPU supports
HT.  AMD also reports the factory defined value in all cases.

That is, even with threading disabled,

crash> p smp_num_siblings
smp_num_siblings = $1 = 0x2

on processors that support multi-threading.

smp_num_siblings should be calculated a single time on cpu 0 to determine
whether or not the system is multi-threaded or not.

On a system with HT enabled,

crash> p smp_num_siblings
smp_num_siblings = $1 = 0x2

On a system with HT disabled,

crash> p smp_num_siblings
smp_num_siblings = $1 = 0x1

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Borislav Petkov <bp@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/smpboot.c    |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index fc1235c..81a5aac 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -522,7 +522,7 @@ void detect_ht(struct cpuinfo_x86 *c)
 
 	cpuid(1, &eax, &ebx, &ecx, &edx);
 
-	threads_per_core = smp_num_siblings = (ebx & 0xff0000) >> 16;
+	threads_per_core = (ebx & 0xff0000) >> 16;
 
 	if (threads_per_core <= 1) {
 		pr_info_once("CPU: Hyper-Threading is unsupported on this processor.\n");
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b2ad27c..9eb96d2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -363,6 +363,7 @@ void set_cpu_sibling_map(int cpu)
 		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
 		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
 		c->booted_cores = 1;
+		smp_num_siblings = 1;
 		return;
 	}
 
@@ -407,6 +408,10 @@ void set_cpu_sibling_map(int cpu)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
 	}
+
+	/* Only need to check this on the boot cpu, o/w it is disabled */
+	if (cpu == 0)
+		smp_num_siblings = cpumask_weight(cpu_sibling_mask(cpu));
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-- 
1.7.9.3

