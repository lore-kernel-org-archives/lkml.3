Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3ICSyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:54:50 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45795 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3ICSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:54:48 -0400
Date: Tue, 3 Sep 2013 20:54:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/paravirt changes for v3.12
Message-ID: <20130903185444.GA31959@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-paravirt-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-paravirt-for-linus

   HEAD: 9df56f19a500bea90d160be1bf77e4fbcd204d3f x86: Correctly detect hypervisor

Hypervisor signature detection cleanup and fixes - the goal is to make KVM 
guests run better on MS/Hyperv and to generalize and factor out the code a 
bit.

 Thanks,

	Ingo

------------------>
Jason Wang (4):
      x86: Introduce hypervisor_cpuid_base()
      xen: Switch to use hypervisor_cpuid_base()
      x86, kvm: Switch to use hypervisor_cpuid_base()
      x86: Correctly detect hypervisor


 arch/x86/include/asm/hypervisor.h     |  2 +-
 arch/x86/include/asm/kvm_para.h       | 24 +++++++++---------------
 arch/x86/include/asm/processor.h      | 15 +++++++++++++++
 arch/x86/include/asm/xen/hypervisor.h | 16 +---------------
 arch/x86/kernel/cpu/hypervisor.c      | 15 +++++++--------
 arch/x86/kernel/cpu/mshyperv.c        | 13 ++++++++-----
 arch/x86/kernel/cpu/vmware.c          |  8 ++++----
 arch/x86/kernel/kvm.c                 |  6 ++----
 arch/x86/xen/enlighten.c              |  9 +++------
 9 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 2d4b5e6..e42f758 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -33,7 +33,7 @@ struct hypervisor_x86 {
 	const char	*name;
 
 	/* Detection routine */
-	bool		(*detect)(void);
+	uint32_t	(*detect)(void);
 
 	/* Adjust CPU feature bits (run once per CPU) */
 	void		(*set_cpu_features)(struct cpuinfo_x86 *);
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 695399f..0644129 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,26 +85,20 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
-static inline bool kvm_para_available(void)
+static inline uint32_t kvm_cpuid_base(void)
 {
-	unsigned int eax, ebx, ecx, edx;
-	char signature[13];
-
 	if (boot_cpu_data.cpuid_level < 0)
-		return false;	/* So we don't blow up on old processors */
+		return 0;	/* So we don't blow up on old processors */
 
-	if (cpu_has_hypervisor) {
-		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
-		memcpy(signature + 0, &ebx, 4);
-		memcpy(signature + 4, &ecx, 4);
-		memcpy(signature + 8, &edx, 4);
-		signature[12] = 0;
+	if (cpu_has_hypervisor)
+		return hypervisor_cpuid_base("KVMKVMKVM\0\0\0", 0);
 
-		if (strcmp(signature, "KVMKVMKVM") == 0)
-			return true;
-	}
+	return 0;
+}
 
-	return false;
+static inline bool kvm_para_available(void)
+{
+	return kvm_cpuid_base() != 0;
 }
 
 static inline unsigned int kvm_arch_para_features(void)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 24cf5ae..7763307 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -971,6 +971,21 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
+static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
+{
+	uint32_t base, eax, signature[3];
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);
+
+		if (!memcmp(sig, signature, 12) &&
+		    (leaves == 0 || ((eax - base) >= leaves)))
+			return base;
+	}
+
+	return 0;
+}
+
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 125f344..d866959 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -40,21 +40,7 @@ extern struct start_info *xen_start_info;
 
 static inline uint32_t xen_cpuid_base(void)
 {
-	uint32_t base, eax, ebx, ecx, edx;
-	char signature[13];
-
-	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
-		cpuid(base, &eax, &ebx, &ecx, &edx);
-		*(uint32_t *)(signature + 0) = ebx;
-		*(uint32_t *)(signature + 4) = ecx;
-		*(uint32_t *)(signature + 8) = edx;
-		signature[12] = 0;
-
-		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
-			return base;
-	}
-
-	return 0;
+	return hypervisor_cpuid_base("XenVMMXenVMM", 2);
 }
 
 #ifdef CONFIG_XEN
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8727921..36ce402 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -25,11 +25,6 @@
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 
-/*
- * Hypervisor detect order.  This is specified explicitly here because
- * some hypervisors might implement compatibility modes for other
- * hypervisors and therefore need to be detected in specific sequence.
- */
 static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
 #ifdef CONFIG_XEN_PVHVM
@@ -49,15 +44,19 @@ static inline void __init
 detect_hypervisor_vendor(void)
 {
 	const struct hypervisor_x86 *h, * const *p;
+	uint32_t pri, max_pri = 0;
 
 	for (p = hypervisors; p < hypervisors + ARRAY_SIZE(hypervisors); p++) {
 		h = *p;
-		if (h->detect()) {
+		pri = h->detect();
+		if (pri != 0 && pri > max_pri) {
+			max_pri = pri;
 			x86_hyper = h;
-			printk(KERN_INFO "Hypervisor detected: %s\n", h->name);
-			break;
 		}
 	}
+
+	if (max_pri)
+		printk(KERN_INFO "Hypervisor detected: %s\n", x86_hyper->name);
 }
 
 void init_hypervisor(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 8f4be53..71a39f3 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -27,20 +27,23 @@
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
 
-static bool __init ms_hyperv_platform(void)
+static uint32_t  __init ms_hyperv_platform(void)
 {
 	u32 eax;
 	u32 hyp_signature[3];
 
 	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
-		return false;
+		return 0;
 
 	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
 	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
-	return eax >= HYPERV_CPUID_MIN &&
-		eax <= HYPERV_CPUID_MAX &&
-		!memcmp("Microsoft Hv", hyp_signature, 12);
+	if (eax >= HYPERV_CPUID_MIN &&
+	    eax <= HYPERV_CPUID_MAX &&
+	    !memcmp("Microsoft Hv", hyp_signature, 12))
+		return HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS;
+
+	return 0;
 }
 
 static cycle_t read_hv_clock(struct clocksource *arg)
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 7076878..628a059 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -93,7 +93,7 @@ static void __init vmware_platform_setup(void)
  * serial key should be enough, as this will always have a VMware
  * specific string when running under VMware hypervisor.
  */
-static bool __init vmware_platform(void)
+static uint32_t __init vmware_platform(void)
 {
 	if (cpu_has_hypervisor) {
 		unsigned int eax;
@@ -102,12 +102,12 @@ static bool __init vmware_platform(void)
 		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &hyper_vendor_id[0],
 		      &hyper_vendor_id[1], &hyper_vendor_id[2]);
 		if (!memcmp(hyper_vendor_id, "VMwareVMware", 12))
-			return true;
+			return CPUID_VMWARE_INFO_LEAF;
 	} else if (dmi_available && dmi_name_in_serial("VMware") &&
 		   __vmware_platform())
-		return true;
+		return 1;
 
-	return false;
+	return 0;
 }
 
 /*
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a96d32c..7817afd 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -498,11 +498,9 @@ void __init kvm_guest_init(void)
 #endif
 }
 
-static bool __init kvm_detect(void)
+static uint32_t __init kvm_detect(void)
 {
-	if (!kvm_para_available())
-		return false;
-	return true;
+	return kvm_cpuid_base();
 }
 
 const struct hypervisor_x86 x86_hyper_kvm __refconst = {
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 193097e..2fcaedc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1720,15 +1720,12 @@ static void __init xen_hvm_guest_init(void)
 	xen_hvm_init_mmu_ops();
 }
 
-static bool __init xen_hvm_platform(void)
+static uint32_t __init xen_hvm_platform(void)
 {
 	if (xen_pv_domain())
-		return false;
-
-	if (!xen_cpuid_base())
-		return false;
+		return 0;
 
-	return true;
+	return xen_cpuid_base();
 }
 
 bool xen_hvm_need_lapic(void)
