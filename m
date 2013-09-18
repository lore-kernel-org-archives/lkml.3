Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3IRQYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:24:45 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62014 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3IRQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:24:44 -0400
Date: Wed, 18 Sep 2013 18:24:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20130918162439.GA11190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 0f531431d3de88efb4234d6c0ce22089ec035a38 x86/intel/lpss: Add pin control support to Intel low power subsystem

Misc fixes.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86: Remove now-unused save_rest()

Libin (1):
      x86/smpboot: Fix announce_cpu() to printk() the last "OK" properly

Mathias Nyman (1):
      x86/intel/lpss: Add pin control support to Intel low power subsystem

Stephane Eranian (1):
      perf/x86/intel: Mark MEM_LOAD_UOPS_MISS_RETIRED as precise on SNB


 arch/x86/Kconfig                          |  5 +++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  1 +
 arch/x86/kernel/entry_64.S                | 15 ---------------
 arch/x86/kernel/smpboot.c                 |  3 ++-
 4 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..4d5843d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -482,11 +482,12 @@ config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
 	depends on ACPI
 	select COMMON_CLK
+	select PINCTRL
 	---help---
 	  Select to build support for Intel Low Power Subsystem such as
 	  found on Intel Lynxpoint PCH. Selecting this option enables
-	  things like clock tree (common clock framework) which are needed
-	  by the LPSS peripheral drivers.
+	  things like clock tree (common clock framework) and pincontrol
+	  which are needed by the LPSS peripheral drivers.
 
 config X86_RDC321X
 	bool "RDC R-321x SoC"
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..4ab70ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -558,6 +558,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1b69951..b077f4c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -487,21 +487,6 @@ ENDPROC(native_usergs_sysret64)
 	TRACE_IRQS_OFF
 	.endm
 
-ENTRY(save_rest)
-	PARTIAL_FRAME 1 (REST_SKIP+8)
-	movq 5*8+16(%rsp), %r11	/* save return address */
-	movq_cfi rbx, RBX+16
-	movq_cfi rbp, RBP+16
-	movq_cfi r12, R12+16
-	movq_cfi r13, R13+16
-	movq_cfi r14, R14+16
-	movq_cfi r15, R15+16
-	movq %r11, 8(%rsp)	/* return address */
-	FIXUP_TOP_OF_STACK %r11, 16
-	ret
-	CFI_ENDPROC
-END(save_rest)
-
 /* save complete stack frame */
 	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index aecc98a..6cacab6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -653,6 +653,7 @@ static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
+	int max_cpu_present = find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
@@ -661,7 +662,7 @@ static void announce_cpu(int cpu, int apicid)
 			current_node = node;
 			pr_info("Booting Node %3d, Processors ", node);
 		}
-		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " OK\n" : "");
+		pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
 		return;
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
