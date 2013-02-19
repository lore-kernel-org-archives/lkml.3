Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab3BSPZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:25:11 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41567 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab3BSPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:25:10 -0500
Date: Tue, 19 Feb 2013 16:25:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.9
Message-ID: <20130219152503.GA14862@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: f0322bd341fd63261527bf84afd3272bcc2e8dd3 x86, AMD: Enable WC+ memory type on family 10 processors

The biggest change is the enabling of the WC+ memory type on 
family 10 processors. (This is a BIOS bug workaround in essence: 
if the BIOS fails to do this then we fall back to uncacheable, 
degrading performance, for example for virtualized guests using 
nested pages.)

 Thanks,

	Ingo

------------------>
Boris Ostrovsky (2):
      x86, AMD: Clean up init_amd()
      x86, AMD: Enable WC+ memory type on family 10 processors

Chen Gang (1):
      x86/process: Change %8s to %s for pr_warn() in release_thread()

Kees Cook (1):
      x86/cpu/hotplug: Remove CONFIG_EXPERIMENTAL dependency


 arch/x86/Kconfig                      |  4 +--
 arch/x86/include/uapi/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c             | 50 ++++++++++++++++++++---------------
 arch/x86/kernel/process_64.c          |  2 +-
 4 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..2d62103 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1699,7 +1699,7 @@ config HOTPLUG_CPU
 config BOOTPARAM_HOTPLUG_CPU0
 	bool "Set default setting of cpu0_hotpluggable"
 	default n
-	depends on HOTPLUG_CPU && EXPERIMENTAL
+	depends on HOTPLUG_CPU
 	---help---
 	  Set whether default state of cpu0_hotpluggable is on or off.
 
@@ -1728,7 +1728,7 @@ config BOOTPARAM_HOTPLUG_CPU0
 config DEBUG_HOTPLUG_CPU0
 	def_bool n
 	prompt "Debug CPU0 hotplug"
-	depends on HOTPLUG_CPU && EXPERIMENTAL
+	depends on HOTPLUG_CPU
 	---help---
 	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
 	  soon as possible and boots up userspace with CPU0 offlined. User
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 433a59f..158cde9 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -173,6 +173,7 @@
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_DC_CFG		0xc0011022
+#define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 15239ff..721ef32 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -518,10 +518,9 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
-
-#ifdef CONFIG_SMP
 	unsigned long long value;
 
+#ifdef CONFIG_SMP
 	/*
 	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
 	 * bit 6 of msr C001_0015
@@ -559,12 +558,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * (AMD Erratum #110, docId: 25759).
 		 */
 		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
-			u64 val;
-
 			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
-			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
-				val &= ~(1ULL << 32);
-				wrmsrl_amd_safe(0xc001100d, val);
+			if (!rdmsrl_amd_safe(0xc001100d, &value)) {
+				value &= ~(1ULL << 32);
+				wrmsrl_amd_safe(0xc001100d, value);
 			}
 		}
 
@@ -617,13 +614,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if ((c->x86 == 0x15) &&
 	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
-		u64 val;
 
-		if (!rdmsrl_safe(0xc0011005, &val)) {
-			val |= 1ULL << 54;
-			wrmsrl_safe(0xc0011005, val);
-			rdmsrl(0xc0011005, val);
-			if (val & (1ULL << 54)) {
+		if (!rdmsrl_safe(0xc0011005, &value)) {
+			value |= 1ULL << 54;
+			wrmsrl_safe(0xc0011005, value);
+			rdmsrl(0xc0011005, value);
+			if (value & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
 				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
 				  "disabled Topology Extensions Support\n");
@@ -637,11 +633,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 */
 	if ((c->x86 == 0x15) &&
 	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
-		u64 val;
 
-		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
-			val |= 0x1E;
-			wrmsrl_safe(0xc0011021, val);
+		if (!rdmsrl_safe(0xc0011021, &value) && !(value & 0x1E)) {
+			value |= 0x1E;
+			wrmsrl_safe(0xc0011021, value);
 		}
 	}
 
@@ -703,13 +698,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
-	/*
-	 * Disable GART TLB Walk Errors on Fam10h. We do this here
-	 * because this is always needed when GART is enabled, even in a
-	 * kernel which has no MCE support built in.
-	 */
 	if (c->x86 == 0x10) {
 		/*
+		 * Disable GART TLB Walk Errors on Fam10h. We do this here
+		 * because this is always needed when GART is enabled, even in a
+		 * kernel which has no MCE support built in.
 		 * BIOS should disable GartTlbWlk Errors themself. If
 		 * it doesn't do it here as suggested by the BKDG.
 		 *
@@ -723,6 +716,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			mask |= (1 << 10);
 			wrmsrl_safe(MSR_AMD64_MCx_MASK(4), mask);
 		}
+
+		/*
+		 * On family 10h BIOS may not have properly enabled WC+ support,
+		 * causing it to be converted to CD memtype. This may result in
+		 * performance degradation for certain nested-paging guests.
+		 * Prevent this conversion by clearing bit 24 in
+		 * MSR_AMD64_BU_CFG2.
+		 */
+		if (c->x86 == 0x10) {
+			rdmsrl(MSR_AMD64_BU_CFG2, value);
+			value &= ~(1ULL << 24);
+			wrmsrl(MSR_AMD64_BU_CFG2, value);
+		}
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6e68a61..0f49677 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -117,7 +117,7 @@ void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
 		if (dead_task->mm->context.size) {
-			pr_warn("WARNING: dead process %8s still has LDT? <%p/%d>\n",
+			pr_warn("WARNING: dead process %s still has LDT? <%p/%d>\n",
 				dead_task->comm,
 				dead_task->mm->context.ldt,
 				dead_task->mm->context.size);
