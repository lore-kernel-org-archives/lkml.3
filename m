Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaBYSqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:46:53 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64445 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaBYSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:46:51 -0500
Message-ID: <530CE510.8060008@redhat.com>
Date: Tue, 25 Feb 2014 19:46:40 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, mtosatti@redhat.com, Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86: Add nested virtualization support for MPX
References: <1393350577-11532-1-git-send-email-pbonzini@redhat.com> <1393350577-11532-3-git-send-email-pbonzini@redhat.com> <530CDB5D.6020304@siemens.com> <530CDD59.4040006@redhat.com>
In-Reply-To: <530CDD59.4040006@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/02/2014 19:13, Paolo Bonzini ha scritto:
> Il 25/02/2014 19:05, Jan Kiszka ha scritto:
>> On 2014-02-25 18:49, Paolo Bonzini wrote:
>>> This is simple to do, the "host" BNDCFGS is either 0 or the guest value.
>>> However, both controls have to be present.  We cannot provide MPX if
>>> we only have one of the "load BNDCFGS" or "clear BNDCFGS" controls.
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/x86/kvm/vmx.c | 16 ++++++++++++++++
>>>  1 file changed, 16 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>> index 729b1e42aded..da28ac46ca88 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -202,6 +202,7 @@ struct __packed vmcs12 {
>>>      u64 guest_pdptr1;
>>>      u64 guest_pdptr2;
>>>      u64 guest_pdptr3;
>>> +    u64 guest_bndcfgs;
>>>      u64 host_ia32_pat;
>>>      u64 host_ia32_efer;
>>>      u64 host_ia32_perf_global_ctrl;
>>> @@ -534,6 +535,7 @@ static const unsigned long
>>> shadow_read_write_fields[] = {
>>>      GUEST_CS_LIMIT,
>>>      GUEST_CS_BASE,
>>>      GUEST_ES_BASE,
>>> +    GUEST_BNDCFGS,
>>>      CR0_GUEST_HOST_MASK,
>>>      CR0_READ_SHADOW,
>>>      CR4_READ_SHADOW,
>>> @@ -589,6 +591,7 @@ static const unsigned short
>>> vmcs_field_to_offset_table[] = {
>>>      FIELD64(GUEST_PDPTR1, guest_pdptr1),
>>>      FIELD64(GUEST_PDPTR2, guest_pdptr2),
>>>      FIELD64(GUEST_PDPTR3, guest_pdptr3),
>>> +    FIELD64(GUEST_BNDCFGS, guest_bndcfgs),
>>>      FIELD64(HOST_IA32_PAT, host_ia32_pat),
>>>      FIELD64(HOST_IA32_EFER, host_ia32_efer),
>>>      FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
>>> @@ -719,6 +722,7 @@ static unsigned long nested_ept_get_cr3(struct
>>> kvm_vcpu *vcpu);
>>>  static u64 construct_eptp(unsigned long root_hpa);
>>>  static void kvm_cpu_vmxon(u64 addr);
>>>  static void kvm_cpu_vmxoff(void);
>>> +static bool vmx_mpx_supported(void);
>>>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
>>>  static void vmx_set_segment(struct kvm_vcpu *vcpu,
>>>                  struct kvm_segment *var, int seg);
>>> @@ -2279,6 +2283,8 @@ static __init void
>>> nested_vmx_setup_ctls_msrs(void)
>>>      }
>>>      nested_vmx_exit_ctls_high |= (VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
>>>          VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER);
>>> +    if (vmx_mpx_supported())
>>> +        nested_vmx_exit_ctls_high |= VM_EXIT_CLEAR_BNDCFGS;
>>>
>>>      /* entry controls */
>>>      rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
>>> @@ -2292,6 +2298,8 @@ static __init void
>>> nested_vmx_setup_ctls_msrs(void)
>>>          VM_ENTRY_LOAD_IA32_PAT;
>>>      nested_vmx_entry_ctls_high |= (VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |
>>>                         VM_ENTRY_LOAD_IA32_EFER);
>>> +    if (vmx_mpx_supported())
>>> +        nested_vmx_entry_ctls_high |= VM_ENTRY_LOAD_BNDCFGS;
>>>
>>>      /* cpu-based controls */
>>>      rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
>>> @@ -7847,6 +7855,9 @@ static void prepare_vmcs02(struct kvm_vcpu
>>> *vcpu, struct vmcs12 *vmcs12)
>>>
>>>      set_cr4_guest_host_mask(vmx);
>>>
>>> +    if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)
>>> +        vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>>> +
>>>      if (vmcs12->cpu_based_vm_exec_control &
>>> CPU_BASED_USE_TSC_OFFSETING)
>>>          vmcs_write64(TSC_OFFSET,
>>>              vmx->nested.vmcs01_tsc_offset + vmcs12->tsc_offset);
>>> @@ -8277,6 +8288,7 @@ static void prepare_vmcs12(struct kvm_vcpu
>>> *vcpu, struct vmcs12 *vmcs12,
>>>      vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
>>>      vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
>>>      vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
>>> +    vmcs12->guest_bndcfgs = vmcs_readl(GUEST_BNDCFGS);
>>
>> Can we read this value unconditionally, even when the host does not
>> support the feature?
>
> return -EWRONGPATCH;

Makes sense to clarify since I'll only be able to send the right patch 
tomorrow.

I had not noticed this problem because vmcs_readl just returns a random 
value if it fails and GUEST_BNDCFGS will not be vmcs_written. 
x86/vmx.flat passes even with this bug.

However, this should be a vmcs_read64.

Paolo

>>>
>>>      /* update exit information fields: */
>>>
>>> @@ -8386,6 +8398,10 @@ static void load_vmcs12_host_state(struct
>>> kvm_vcpu *vcpu,
>>>      vmcs_writel(GUEST_IDTR_BASE, vmcs12->host_idtr_base);
>>>      vmcs_writel(GUEST_GDTR_BASE, vmcs12->host_gdtr_base);
>>>
>>> +    /* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
>>> +    if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
>>> +        vmcs_write64(GUEST_BNDCFGS, 0);
>>> +
>>>      if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
>>>          vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>>>          vcpu->arch.pat = vmcs12->host_ia32_pat;
>>>
>>
>> Do we also have a unit test to stress this? Or are we lacking silicon
>> with MPX and corresponding VMX features?
>
> No silicon yet.
>
> There is an emulator, but it is already slow enough without nested
> virtualization... it would be three-level virtualization :)
>
> Paolo
>

