Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935223AbaFTR22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbaFTR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:28:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Oren Twaig <oren@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>
Subject: [PATCH 2/2] x86, disable ht flag when hyperthreading is disabled
Date: Fri, 20 Jun 2014 13:27:33 -0400
Message-Id: <1403285253-25547-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1403285253-25547-1-git-send-email-prarit@redhat.com>
References: <1403285253-25547-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ht flag indicates that a processor is capable of having sibling threads.
This has long been confusing for users who confuse the ht flag as
indicating that hyperthreading is enabled on their systems even though
it may have been disabled in BIOS.

This patch removes the hyperthreading flag when no cpu thread siblings are
found, ie) smp_num_siblings == 1.

Cc: Oren Twaig <oren@scalemp.com>
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
 arch/x86/kernel/smpboot.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e5ab30b..2eaadf0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -371,6 +371,7 @@ void set_cpu_sibling_map(int cpu)
 		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
 		c->booted_cores = 1;
 		smp_num_siblings = 1;
+		clear_cpu_cap(c, X86_FEATURE_HT);
 		return;
 	}
 
@@ -419,6 +420,9 @@ void set_cpu_sibling_map(int cpu)
 	/* Only need to check this on the boot cpu, o/w it is disabled */
 	if (cpu == 0)
 		smp_num_siblings = cpumask_weight(cpu_sibling_mask(cpu));
+
+	if (cpu_has_ht && smp_num_siblings == 1)
+		clear_cpu_cap(c, X86_FEATURE_HT);
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-- 
1.7.9.3

