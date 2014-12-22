Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaLVHaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:30:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:35493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaLVHaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:30:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432022412"
Message-ID: <5497C882.4000108@intel.com>
Date: Mon, 22 Dec 2014 15:30:10 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
References: <20141221124640.GA4059@cucamonga.audible.transient.net>
In-Reply-To: <20141221124640.GA4059@cucamonga.audible.transient.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/21 20:46, Jamie Heilman wrote:
> With v3.19-rc1 when I run qemu-system-x86_64 -machine pc,accel=kvm I
> get:
>
> KVM: entry failed, hardware error 0x80000021

Looks some MSR writing issues such a failed entry.

>
> If you're running a guest on an Intel machine without unrestricted mode
> support, the failure can be most likely due to the guest entering an invalid
> state for Intel VT. For example, the guest maybe running in big real mode
> which is not supported on less recent Intel processors.
>
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000663
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000e05b EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 000f0000 0000ffff 00009b00
> SS =0000 00000000 0000ffff 00009300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000

And I don't see any obvious wrong as well. Any valuable info from dmesg?

> Code=85 00 87 00 89 00 8b 00 00 00 86 00 88 00 8a 00 8c 00 00 90 <2e> 66 83 3e 30 6c 00 0f 85 e7 f2 31 c0 8e d0 66 bc 00 70 00 00 66 ba 31 2e 0f 00 e9 45 f1
>
> This is with QEMU emulator version 2.1.2 (Debian 1:2.1+dfsg-11),
> Copyright (c) 2003-2008 Fabrice Bellard
>
> The host system is:
>
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
> stepping        : 10
> microcode       : 0xa0b
> ...
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm dtherm tpr_shadow vnmi flexpriority
>
> I bisected this back to:
>
> commit 34a1cd60d17f62c1f077c1478a6c2ca8c3d17af4
> Author: Tiejun Chen <tiejun.chen@intel.com>
> Date:   Tue Oct 28 10:14:48 2014 +0800
>
>      kvm: x86: vmx: move some vmx setting from vmx_init() to hardware_setup()
>
>      Instead of vmx_init(), actually it would make reasonable sense to do
>      anything specific to vmx hardware setting in vmx_x86_ops->hardware_setup().
>

This commit just reorders something but some MSR writing depend on 
previous status.

Could you try this?

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index feb852b..96c84a8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5840,49 +5840,6 @@ static __init int hardware_setup(void)
         memset(vmx_msr_bitmap_legacy, 0xff, PAGE_SIZE);
         memset(vmx_msr_bitmap_longmode, 0xff, PAGE_SIZE);

-       vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
-       vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
-       vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
-       vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
-       vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
-       vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
-       vmx_disable_intercept_for_msr(MSR_IA32_BNDCFGS, true);
-
-       memcpy(vmx_msr_bitmap_legacy_x2apic,
-                       vmx_msr_bitmap_legacy, PAGE_SIZE);
-       memcpy(vmx_msr_bitmap_longmode_x2apic,
-                       vmx_msr_bitmap_longmode, PAGE_SIZE);
-
-       if (enable_apicv) {
-               for (msr = 0x800; msr <= 0x8ff; msr++)
-                       vmx_disable_intercept_msr_read_x2apic(msr);
-
-               /* According SDM, in x2apic mode, the whole id reg is used.
-                * But in KVM, it only use the highest eight bits. Need to
-                * intercept it */
-               vmx_enable_intercept_msr_read_x2apic(0x802);
-               /* TMCCT */
-               vmx_enable_intercept_msr_read_x2apic(0x839);
-               /* TPR */
-               vmx_disable_intercept_msr_write_x2apic(0x808);
-               /* EOI */
-               vmx_disable_intercept_msr_write_x2apic(0x80b);
-               /* SELF-IPI */
-               vmx_disable_intercept_msr_write_x2apic(0x83f);
-       }
-
-       if (enable_ept) {
-               kvm_mmu_set_mask_ptes(0ull,
-                       (enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
-                       (enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
-                       0ull, VMX_EPT_EXECUTABLE_MASK);
-               ept_set_mmio_spte_mask();
-               kvm_enable_tdp();
-       } else
-               kvm_disable_tdp();
-
-       update_ple_window_actual_max();
-
         if (setup_vmcs_config(&vmcs_config) < 0) {
                 r = -EIO;
                 goto out7;
@@ -5945,6 +5902,49 @@ static __init int hardware_setup(void)
         if (nested)
                 nested_vmx_setup_ctls_msrs();

+       vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
+       vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
+       vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
+       vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
+       vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
+       vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
+       vmx_disable_intercept_for_msr(MSR_IA32_BNDCFGS, true);
+
+       memcpy(vmx_msr_bitmap_legacy_x2apic,
+                       vmx_msr_bitmap_legacy, PAGE_SIZE);
+       memcpy(vmx_msr_bitmap_longmode_x2apic,
+                       vmx_msr_bitmap_longmode, PAGE_SIZE);
+
+       if (enable_apicv) {
+               for (msr = 0x800; msr <= 0x8ff; msr++)
+                       vmx_disable_intercept_msr_read_x2apic(msr);
+
+               /* According SDM, in x2apic mode, the whole id reg is used.
+                * But in KVM, it only use the highest eight bits. Need to
+                * intercept it */
+               vmx_enable_intercept_msr_read_x2apic(0x802);
+               /* TMCCT */
+               vmx_enable_intercept_msr_read_x2apic(0x839);
+               /* TPR */
+               vmx_disable_intercept_msr_write_x2apic(0x808);
+               /* EOI */
+               vmx_disable_intercept_msr_write_x2apic(0x80b);
+               /* SELF-IPI */
+               vmx_disable_intercept_msr_write_x2apic(0x83f);
+       }
+
+       if (enable_ept) {
+               kvm_mmu_set_mask_ptes(0ull,
+                       (enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
+                       (enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
+                       0ull, VMX_EPT_EXECUTABLE_MASK);
+               ept_set_mmio_spte_mask();
+               kvm_enable_tdp();
+       } else
+               kvm_disable_tdp();
+
+       update_ple_window_actual_max();
+
         return alloc_kvm_area();

  out7:


Thanks
Tiejun
