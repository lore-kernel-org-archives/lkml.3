Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbbAXKUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:20:40 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54822 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbAXKUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:20:35 -0500
MIME-Version: 1.0
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Sat, 24 Jan 2015 18:20:12 +0800
Message-ID: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
Subject: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
To: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        =?UTF-8?B?6IyD5paH5LiA?= <fanwenyi0529@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if L1 enables MSR_BITMAP, we will emulate this feature,
all of L2's msr access is intercepted by L0. Since many features
like virtualize x2apic mode has a complicated logic and it is
difficult for us to emulate, we should use hardware and merge
the bitmap.

This patch introduces nested_vmx_merge_msr_bitmap for future use.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/vmx.c |   71 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c987374..36d0724 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -798,6 +798,7 @@ static unsigned long *vmx_msr_bitmap_legacy;
 static unsigned long *vmx_msr_bitmap_longmode;
 static unsigned long *vmx_msr_bitmap_legacy_x2apic;
 static unsigned long *vmx_msr_bitmap_longmode_x2apic;
+static unsigned long *vmx_msr_bitmap_nested;
 static unsigned long *vmx_vmread_bitmap;
 static unsigned long *vmx_vmwrite_bitmap;

@@ -5812,13 +5813,18 @@ static __init int hardware_setup(void)
                                (unsigned long *)__get_free_page(GFP_KERNEL);
        if (!vmx_msr_bitmap_longmode_x2apic)
                goto out4;
+
+       vmx_msr_bitmap_nested = (unsigned long *)__get_free_page(GFP_KERNEL);
+       if (!vmx_msr_bitmap_nested)
+               goto out5;
+
        vmx_vmread_bitmap = (unsigned long *)__get_free_page(GFP_KERNEL);
        if (!vmx_vmread_bitmap)
-               goto out5;
+               goto out6;

        vmx_vmwrite_bitmap = (unsigned long *)__get_free_page(GFP_KERNEL);
        if (!vmx_vmwrite_bitmap)
-               goto out6;
+               goto out7;

        memset(vmx_vmread_bitmap, 0xff, PAGE_SIZE);
        memset(vmx_vmwrite_bitmap, 0xff, PAGE_SIZE);
@@ -5834,10 +5840,11 @@ static __init int hardware_setup(void)

        memset(vmx_msr_bitmap_legacy, 0xff, PAGE_SIZE);
        memset(vmx_msr_bitmap_longmode, 0xff, PAGE_SIZE);
+       memset(vmx_msr_bitmap_nested, 0xff, PAGE_SIZE);

        if (setup_vmcs_config(&vmcs_config) < 0) {
                r = -EIO;
-               goto out7;
+               goto out8;
        }

        if (boot_cpu_has(X86_FEATURE_NX))
@@ -5944,10 +5951,12 @@ static __init int hardware_setup(void)

        return alloc_kvm_area();

-out7:
+out8:
        free_page((unsigned long)vmx_vmwrite_bitmap);
-out6:
+out7:
        free_page((unsigned long)vmx_vmread_bitmap);
+out6:
+       free_page((unsigned long)vmx_msr_bitmap_nested);
 out5:
        free_page((unsigned long)vmx_msr_bitmap_longmode_x2apic);
 out4:
@@ -5970,6 +5979,7 @@ static __exit void hardware_unsetup(void)
        free_page((unsigned long)vmx_msr_bitmap_longmode_x2apic);
        free_page((unsigned long)vmx_msr_bitmap_legacy);
        free_page((unsigned long)vmx_msr_bitmap_longmode);
+       free_page((unsigned long)vmx_msr_bitmap_nested);
        free_page((unsigned long)vmx_io_bitmap_b);
        free_page((unsigned long)vmx_io_bitmap_a);
        free_page((unsigned long)vmx_vmwrite_bitmap);
@@ -8305,6 +8315,38 @@ static void vmx_start_preemption_timer(struct
kvm_vcpu *vcpu)
                      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL);
 }

+static int nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,
+                                               struct vmcs12 *vmcs12)
+{
+       int maxphyaddr;
+       u64 addr;
+
+       if (!nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
+               return 0;
+
+       if (vmcs12_read_any(vcpu, MSR_BITMAP, &addr)) {
+               WARN_ON(1);
+               return -EINVAL;
+       }
+       maxphyaddr = cpuid_maxphyaddr(vcpu);
+
+       if (!PAGE_ALIGNED(vmcs12->msr_bitmap) ||
+          ((addr + PAGE_SIZE) >> maxphyaddr))
+               return -EINVAL;
+
+       return 0;
+}
+
+/*
+ * Merge L0's and L1's MSR bitmap, return false to indicate that
+ * we do not use the hardware.
+ */
+static inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
+                                              struct vmcs12 *vmcs12)
+{
+       return false;
+}
+
 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
                                       unsigned long count_field,
                                       unsigned long addr_field,
@@ -8637,11 +8679,17 @@ static void prepare_vmcs02(struct kvm_vcpu
*vcpu, struct vmcs12 *vmcs12)
                vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
        }

+       if (cpu_has_vmx_msr_bitmap() &&
+           exec_control & CPU_BASED_USE_MSR_BITMAPS &&
+           nested_vmx_merge_msr_bitmap(vcpu, vmcs12)) {
+               vmcs_write64(MSR_BITMAP, __pa(vmx_msr_bitmap_nested));
+       } else
+               exec_control &= ~CPU_BASED_USE_MSR_BITMAPS;
+
        /*
-        * Merging of IO and MSR bitmaps not currently supported.
+        * Merging of IO bitmap not currently supported.
         * Rather, exit every time.
         */
-       exec_control &= ~CPU_BASED_USE_MSR_BITMAPS;
        exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
        exec_control |= CPU_BASED_UNCOND_IO_EXITING;

@@ -8792,15 +8840,13 @@ static int nested_vmx_run(struct kvm_vcpu
*vcpu, bool launch)
                return 1;
        }

-       if ((vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_MSR_BITMAPS) &&
-                       !PAGE_ALIGNED(vmcs12->msr_bitmap)) {
+       if (!nested_get_vmcs12_pages(vcpu, vmcs12)) {
                /*TODO: Also verify bits beyond physical address width are 0*/
                nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
                return 1;
        }

-       if (!nested_get_vmcs12_pages(vcpu, vmcs12)) {
-               /*TODO: Also verify bits beyond physical address width are 0*/
+       if (nested_vmx_check_msr_bitmap_controls(vcpu, vmcs12)) {
                nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
                return 1;
        }
@@ -9356,6 +9402,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
        kvm_set_dr(vcpu, 7, 0x400);
        vmcs_write64(GUEST_IA32_DEBUGCTL, 0);

+       if (cpu_has_vmx_msr_bitmap())
+               vmx_set_msr_bitmap(vcpu);
+
        if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
                                vmcs12->vm_exit_msr_load_count))
                nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
--
1.7.1
