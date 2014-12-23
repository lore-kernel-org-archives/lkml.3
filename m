Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaLWBuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 20:50:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:52207 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbaLWBuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 20:50:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,628,1413270000"; 
   d="scan'208";a="627982896"
Message-ID: <5498CA50.8070906@intel.com>
Date: Tue, 23 Dec 2014 09:50:08 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
References: <20141221124640.GA4059@cucamonga.audible.transient.net> <5497C882.4000108@intel.com> <20141222092358.GA3915@cucamonga.audible.transient.net>
In-Reply-To: <20141222092358.GA3915@cucamonga.audible.transient.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/22 17:23, Jamie Heilman wrote:
> Chen, Tiejun wrote:
>> On 2014/12/21 20:46, Jamie Heilman wrote:
>>> With v3.19-rc1 when I run qemu-system-x86_64 -machine pc,accel=kvm I
>>> get:
>>>
>>> KVM: entry failed, hardware error 0x80000021
>>
>> Looks some MSR writing issues such a failed entry.
>>
>>> If you're running a guest on an Intel machine without unrestricted mode
>>> support, the failure can be most likely due to the guest entering an invalid
>>> state for Intel VT. For example, the guest maybe running in big real mode
>>> which is not supported on less recent Intel processors.
>>>
>>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000663
>>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>>> EIP=0000e05b EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>>> ES =0000 00000000 0000ffff 00009300
>>> CS =f000 000f0000 0000ffff 00009b00
>>> SS =0000 00000000 0000ffff 00009300
>>> DS =0000 00000000 0000ffff 00009300
>>> FS =0000 00000000 0000ffff 00009300
>>> GS =0000 00000000 0000ffff 00009300
>>> LDT=0000 00000000 0000ffff 00008200
>>> TR =0000 00000000 0000ffff 00008b00
>>> GDT=     00000000 0000ffff
>>> IDT=     00000000 0000ffff
>>> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
>>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
>>> DR6=00000000ffff0ff0 DR7=0000000000000400
>>> EFER=0000000000000000
>>
>> And I don't see any obvious wrong as well. Any valuable info from dmesg?
>
> With the simple qemu command above, on 3.18.1 I see:
>
> kern.info: kvm: zapping shadow pages for mmio generation wraparound
>
> when I fire up a full guest that's actually useful I get:
>
> kern.info: kvm: zapping shadow pages for mmio generation wraparound
> kern.err: kvm [4073]: vcpu0 disabled perfctr wrmsr: 0xc1 data 0xffff
>
> On 3.18.0-rc3-00042-g34a1cd6 nothing appears in the dmesg, just the
> message I mention above to stderr.  Same thing with a stock
> 3.19.0-rc1.  Once I apply your patch the simple test command produces
> the same zapping shadow pages messages as 3.18.1, and a test guest of
> a Debian Jessie image (w/stock distro kernel) produces the same thing
> with disabled perfctr wrmsr message.  However, it doesn't look like

Sorry I'm not sure if I understood current status. Looks 3.19-rc1 & my 
patch just fix that error above,

KVM: entry failed, hardware error 0x80000021
...

Right?

> I'm entirely out of the woods, because one of my other guest VMs with a
> custom kernel that works great under 3.18.1 now fails to run.  Nothing
> in dmesg, but here's the stderr:

But even you revert 34a1cd60d17 or just apply my patch, something else 
introduced between 3.18.1 and 3.19-rc1 led this error below, right?

>
> KVM internal error. Suberror: 1
> emulation failure
> EAX=000de494 EBX=00000000 ECX=00000000 EDX=00000cfd
> ESI=00000059 EDI=00000000 EBP=00000000 ESP=00006fb4
> EIP=000f15c1 EFL=00010016 [----AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
> SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
> TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
> GDT=     000f6be8 00000037
> IDT=     000f6c26 00000000
> CR0=60000011 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> Code=e8 ae fc ff ff 89 f2 a8 10 89 d8 75 0a b9 41 15 ff ff ff d1 <5b> 5e c3 5b 5e e9 76 ff ff ff b0 11 e6 20 e6 a0 b0 08 e6 21 b0 70 e6 a1 b0 04 e6 21 b0 02
>
> FWIW, I get the same thing with 34a1cd60d17 reverted.  Maybe there are
> two bugs, maybe there's more to this first one.  I can repro this

So if my understanding is correct, this is probably another bug. And 
especially, I already saw the same log in another thread, "Cleaning up 
the KVM clock". Maybe you can continue to `git bisect` to locate that 
bad commit.

Thanks
Tiejun

> error with the command: qemu-system-x86_64 -machine pc,accel=kvm -nodefaults
>
>>> This is with QEMU emulator version 2.1.2 (Debian 1:2.1+dfsg-11),
>>> Copyright (c) 2003-2008 Fabrice Bellard
>>>
>>> The host system is:
>>>
>>> cpu family      : 6
>>> model           : 23
>>> model name      : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
>>> stepping        : 10
>>> microcode       : 0xa0b
>>> ...
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm dtherm tpr_shadow vnmi flexpriority
>>>
>>> I bisected this back to:
>>>
>>> commit 34a1cd60d17f62c1f077c1478a6c2ca8c3d17af4
>>> Author: Tiejun Chen <tiejun.chen@intel.com>
>>> Date:   Tue Oct 28 10:14:48 2014 +0800
>>>
>>>      kvm: x86: vmx: move some vmx setting from vmx_init() to hardware_setup()
>>>
>>>      Instead of vmx_init(), actually it would make reasonable sense to do
>>>      anything specific to vmx hardware setting in vmx_x86_ops->hardware_setup().
>>>
>>
>> This commit just reorders something but some MSR writing depend on previous
>> status.
>>
>> Could you try this?
>
> I unmangled the expanded tabs, and applied this:
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index feb852b..96c84a8 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5840,49 +5840,6 @@ static __init int hardware_setup(void)
>   	memset(vmx_msr_bitmap_legacy, 0xff, PAGE_SIZE);
>   	memset(vmx_msr_bitmap_longmode, 0xff, PAGE_SIZE);
>
> -	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
> -	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
> -	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
> -	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
> -	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
> -	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
> -	vmx_disable_intercept_for_msr(MSR_IA32_BNDCFGS, true);
> -
> -	memcpy(vmx_msr_bitmap_legacy_x2apic,
> -			vmx_msr_bitmap_legacy, PAGE_SIZE);
> -	memcpy(vmx_msr_bitmap_longmode_x2apic,
> -			vmx_msr_bitmap_longmode, PAGE_SIZE);
> -
> -	if (enable_apicv) {
> -		for (msr = 0x800; msr <= 0x8ff; msr++)
> -			vmx_disable_intercept_msr_read_x2apic(msr);
> -
> -		/* According SDM, in x2apic mode, the whole id reg is used.
> -		 * But in KVM, it only use the highest eight bits. Need to
> -		 * intercept it */
> -		vmx_enable_intercept_msr_read_x2apic(0x802);
> -		/* TMCCT */
> -		vmx_enable_intercept_msr_read_x2apic(0x839);
> -		/* TPR */
> -		vmx_disable_intercept_msr_write_x2apic(0x808);
> -		/* EOI */
> -		vmx_disable_intercept_msr_write_x2apic(0x80b);
> -		/* SELF-IPI */
> -		vmx_disable_intercept_msr_write_x2apic(0x83f);
> -	}
> -
> -	if (enable_ept) {
> -		kvm_mmu_set_mask_ptes(0ull,
> -			(enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
> -			(enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
> -			0ull, VMX_EPT_EXECUTABLE_MASK);
> -		ept_set_mmio_spte_mask();
> -		kvm_enable_tdp();
> -	} else
> -		kvm_disable_tdp();
> -
> -	update_ple_window_actual_max();
> -
>   	if (setup_vmcs_config(&vmcs_config) < 0) {
>   		r = -EIO;
>   		goto out7;
> @@ -5945,6 +5902,49 @@ static __init int hardware_setup(void)
>   	if (nested)
>   		nested_vmx_setup_ctls_msrs();
>
> +	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
> +	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
> +	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
> +	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
> +	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
> +	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
> +	vmx_disable_intercept_for_msr(MSR_IA32_BNDCFGS, true);
> +
> +	memcpy(vmx_msr_bitmap_legacy_x2apic,
> +			vmx_msr_bitmap_legacy, PAGE_SIZE);
> +	memcpy(vmx_msr_bitmap_longmode_x2apic,
> +			vmx_msr_bitmap_longmode, PAGE_SIZE);
> +
> +	if (enable_apicv) {
> +		for (msr = 0x800; msr <= 0x8ff; msr++)
> +			vmx_disable_intercept_msr_read_x2apic(msr);
> +
> +		/* According SDM, in x2apic mode, the whole id reg is used.
> +		 * But in KVM, it only use the highest eight bits. Need to
> +		 * intercept it */
> +		vmx_enable_intercept_msr_read_x2apic(0x802);
> +		/* TMCCT */
> +		vmx_enable_intercept_msr_read_x2apic(0x839);
> +		/* TPR */
> +		vmx_disable_intercept_msr_write_x2apic(0x808);
> +		/* EOI */
> +		vmx_disable_intercept_msr_write_x2apic(0x80b);
> +		/* SELF-IPI */
> +		vmx_disable_intercept_msr_write_x2apic(0x83f);
> +	}
> +
> +	if (enable_ept) {
> +		kvm_mmu_set_mask_ptes(0ull,
> +			(enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
> +			(enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
> +			0ull, VMX_EPT_EXECUTABLE_MASK);
> +		ept_set_mmio_spte_mask();
> +		kvm_enable_tdp();
> +	} else
> +		kvm_disable_tdp();
> +
> +	update_ple_window_actual_max();
> +
>   	return alloc_kvm_area();
>
>    out7:
>
>
