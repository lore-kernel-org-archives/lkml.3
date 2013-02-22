Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3BVAgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 19:36:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3BVAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 19:36:31 -0500
Date: Thu, 21 Feb 2013 16:33:57 -0800
Message-Id: <201302220033.r1M0XvN0008295@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/cpu for v3.9-rc1 [take 2]
Cc: Andre Przywara <andre@andrep.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>, Chen Gang <gang.chen@asianux.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Gleb Natapov <gleb@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Feb 2013 16:34:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a corrected attempt at the x86/cpu branch, this time with the
fixes in that makes it not break on KVM (current or past), or any
other virtualizer which traps on this configuration.

Again, the biggest change here is enabling the WC+ memory type on AMD
processors, if the BIOS doesn't.


The following changes since commit ff7532ca2c631e7e96dcd305a967b610259dc0ea:

  Merge tag 'usb-3.8-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2013-01-23 20:11:35 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

for you to fetch changes up to 2e32b7190641a184b8510d3e342400473ff1ab60:

  x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs (2013-02-19 10:44:07 -0800)

----------------------------------------------------------------
Boris Ostrovsky (2):
      x86, AMD: Clean up init_amd()
      x86, AMD: Enable WC+ memory type on family 10 processors

Borislav Petkov (2):
      x86, cpu, amd: Fix WC+ workaround for older virtual hosts
      x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs

Chen Gang (1):
      x86/process: Change %8s to %s for pr_warn() in release_thread()

Kees Cook (1):
      x86/cpu/hotplug: Remove CONFIG_EXPERIMENTAL dependency

 arch/x86/Kconfig                      |  4 +--
 arch/x86/include/uapi/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c             | 52 ++++++++++++++++++++---------------
 arch/x86/kernel/process_64.c          |  2 +-
 arch/x86/kvm/x86.c                    | 16 ++++++-----
 5 files changed, 43 insertions(+), 32 deletions(-)

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
index 15239ff..163af4a 100644
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
@@ -723,6 +716,21 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
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
+		 *
+		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
+		 * guests on older kvm hosts.
+		 */
+
+		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
+		value &= ~(1ULL << 24);
+		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c243b81..3704007 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1881,6 +1881,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u64 data = msr_info->data;
 
 	switch (msr) {
+	case MSR_AMD64_NB_CFG:
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_UCODE_WRITE:
+	case MSR_VM_HSAVE_PA:
+	case MSR_AMD64_PATCH_LOADER:
+	case MSR_AMD64_BU_CFG2:
+		break;
+
 	case MSR_EFER:
 		return set_efer(vcpu, data);
 	case MSR_K7_HWCR:
@@ -1900,8 +1908,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case MSR_AMD64_NB_CFG:
-		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!data) {
 			/* We support the non-activated case already */
@@ -1914,11 +1920,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
 			    __func__, data);
 		break;
-	case MSR_IA32_UCODE_REV:
-	case MSR_IA32_UCODE_WRITE:
-	case MSR_VM_HSAVE_PA:
-	case MSR_AMD64_PATCH_LOADER:
-		break;
 	case 0x200 ... 0x2ff:
 		return set_msr_mtrr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
@@ -2253,6 +2254,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_K8_INT_PENDING_MSG:
 	case MSR_AMD64_NB_CFG:
 	case MSR_FAM10H_MMIO_CONF_BASE:
+	case MSR_AMD64_BU_CFG2:
 		data = 0;
 		break;
 	case MSR_P6_PERFCTR0:
