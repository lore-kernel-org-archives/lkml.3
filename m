Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaAVLtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:49:05 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41815 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaAVLtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:49:01 -0500
Message-ID: <52DFB02A.4070500@redhat.com>
Date: Wed, 22 Jan 2014 12:48:58 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: Re: [PATCH v3 2/4] KVM/X86: Intel MPX vmx and msr handle
References: <DE8DF0795D48FD4CA783C40EC82923350149E31D@SHSMSX101.ccr.corp.intel.com> <52DFAD9F.9040304@redhat.com>
In-Reply-To: <52DFAD9F.9040304@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/01/2014 12:38, Paolo Bonzini ha scritto:
> Il 21/01/2014 20:01, Liu, Jinsong ha scritto:
>> From 31e68d752ac395dc6b65e6adf45be5324e92cdc8 Mon Sep 17 00:00:00 2001
>> From: Liu Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 13 Dec 2013 02:32:43 +0800
>> Subject: [PATCH v3 2/4] KVM/X86: Intel MPX vmx and msr handle
>>
>> This patch handle vmx and msr of Intel MPX feature.
>>
>> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
>> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
>> ---
>>  arch/x86/include/asm/vmx.h            |    2 ++
>>  arch/x86/include/uapi/asm/msr-index.h |    1 +
>>  arch/x86/kvm/vmx.c                    |   12 ++++++++++--
>>  3 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index 966502d..1bf4681 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -85,6 +85,7 @@
>>  #define VM_EXIT_SAVE_IA32_EFER                  0x00100000
>>  #define VM_EXIT_LOAD_IA32_EFER                  0x00200000
>>  #define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER       0x00400000
>> +#define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>>
>>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR    0x00036dff
>>
>> @@ -95,6 +96,7 @@
>>  #define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL     0x00002000
>>  #define VM_ENTRY_LOAD_IA32_PAT            0x00004000
>>  #define VM_ENTRY_LOAD_IA32_EFER                 0x00008000
>> +#define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>>
>>  #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR    0x000011ff
>>
>> diff --git a/arch/x86/include/uapi/asm/msr-index.h
>> b/arch/x86/include/uapi/asm/msr-index.h
>> index 37813b5..2a418c4 100644
>> --- a/arch/x86/include/uapi/asm/msr-index.h
>> +++ b/arch/x86/include/uapi/asm/msr-index.h
>> @@ -294,6 +294,7 @@
>>  #define MSR_SMI_COUNT            0x00000034
>>  #define MSR_IA32_FEATURE_CONTROL        0x0000003a
>>  #define MSR_IA32_TSC_ADJUST             0x0000003b
>> +#define MSR_IA32_BNDCFGS        0x00000d90
>>
>>  #define FEATURE_CONTROL_LOCKED                (1<<0)
>>  #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX    (1<<1)
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index b2fe1c2..6d7d9ad 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -439,6 +439,7 @@ struct vcpu_vmx {
>>  #endif
>>          int           gs_ldt_reload_needed;
>>          int           fs_reload_needed;
>> +        u64           msr_host_bndcfgs;
>>      } host_state;
>>      struct {
>>          int vm86_active;
>> @@ -1647,6 +1648,8 @@ static void vmx_save_host_state(struct kvm_vcpu
>> *vcpu)
>>      if (is_long_mode(&vmx->vcpu))
>>          wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
>>  #endif
>> +    if (boot_cpu_has(X86_FEATURE_MPX))
>> +        rdmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_bndcfgs);
>>      for (i = 0; i < vmx->save_nmsrs; ++i)
>>          kvm_set_shared_msr(vmx->guest_msrs[i].index,
>>                     vmx->guest_msrs[i].data,
>> @@ -1684,6 +1687,8 @@ static void __vmx_load_host_state(struct
>> vcpu_vmx *vmx)
>>  #ifdef CONFIG_X86_64
>>      wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
>>  #endif
>> +    if (vmx->host_state.msr_host_bndcfgs)
>> +        wrmsrl(MSR_IA32_BNDCFGS, vmx->host_state.msr_host_bndcfgs);
>>      /*
>>       * If the FPU is not active (through the host task or
>>       * the guest vcpu), then restore the cr0.TS bit.
>> @@ -2800,7 +2805,7 @@ static __init int setup_vmcs_config(struct
>> vmcs_config *vmcs_conf)
>>      min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
>>  #endif
>>      opt = VM_EXIT_SAVE_IA32_PAT | VM_EXIT_LOAD_IA32_PAT |
>> -        VM_EXIT_ACK_INTR_ON_EXIT;
>> +        VM_EXIT_ACK_INTR_ON_EXIT | VM_EXIT_CLEAR_BNDCFGS;
>>      if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>>                  &_vmexit_control) < 0)
>>          return -EIO;
>> @@ -2817,7 +2822,7 @@ static __init int setup_vmcs_config(struct
>> vmcs_config *vmcs_conf)
>>          _pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
>>
>>      min = 0;
>> -    opt = VM_ENTRY_LOAD_IA32_PAT;
>> +    opt = VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>>      if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>>                  &_vmentry_control) < 0)
>>          return -EIO;
>
> You need to disable MPX in the guest if the two controls are not
> available.  You can do this, for example, in vmx_cpuid_update.

Better: add a mpx_supported field to struct kvm_x86_ops.  You can use 
invpcid_supported as a model.

> Otherwise, nested VMX is broken.

>> @@ -8636,6 +8641,9 @@ static int __init vmx_init(void)
>>      vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_CS, false);
>>      vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
>>      vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
>> +    if (boot_cpu_has(X86_FEATURE_MPX))
>> +        vmx_disable_intercept_for_msr(MSR_IA32_BNDCFGS, true);
>
> This needs to be done unconditionally.  Otherwise, reading/writing
> BNDCFGS will access a nonexistent VMCS field.
>
> Paolo
>
>>      memcpy(vmx_msr_bitmap_legacy_x2apic,
>>              vmx_msr_bitmap_legacy, PAGE_SIZE);
>>      memcpy(vmx_msr_bitmap_longmode_x2apic,
>>
>

