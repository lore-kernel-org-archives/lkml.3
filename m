Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHRLPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:15:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61489 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHRLPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:15:52 -0400
Message-ID: <53F1E063.4030805@gmail.com>
Date: Mon, 18 Aug 2014 14:15:47 +0300
From: Avi Kivity <avi.kivity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: x86: drop fpu_activate hook
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com> <1408355431-115633-2-git-send-email-wanpeng.li@linux.intel.com> <53F1D36C.8070606@redhat.com> <53F1D4E1.7@gmail.com> <53F1DA94.3090907@redhat.com>
In-Reply-To: <53F1DA94.3090907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/18/2014 01:51 PM, Paolo Bonzini wrote:
> Il 18/08/2014 12:26, Avi Kivity ha scritto:
>> On 08/18/2014 01:20 PM, Paolo Bonzini wrote:
>>> Il 18/08/2014 11:50, Wanpeng Li ha scritto:
>>>> fpu_activate hook is introduced by commit 6b52d186 (KVM: Activate fpu on
>>>> clts), however, there is no user currently, this patch drop it.
>>>>
>>>> Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>
>>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>>> ---
>>>>    arch/x86/include/asm/kvm_host.h | 1 -
>>>>    arch/x86/kvm/svm.c              | 1 -
>>>>    arch/x86/kvm/vmx.c              | 1 -
>>>>    3 files changed, 3 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h
>>>> b/arch/x86/include/asm/kvm_host.h
>>>> index 5724601..b68f3e5 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -710,7 +710,6 @@ struct kvm_x86_ops {
>>>>        void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>>>>        unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
>>>>        void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
>>>> -    void (*fpu_activate)(struct kvm_vcpu *vcpu);
>>>>        void (*fpu_deactivate)(struct kvm_vcpu *vcpu);
>>>>          void (*tlb_flush)(struct kvm_vcpu *vcpu);
>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>>> index ddf7427..1f49c86 100644
>>>> --- a/arch/x86/kvm/svm.c
>>>> +++ b/arch/x86/kvm/svm.c
>>>> @@ -4349,7 +4349,6 @@ static struct kvm_x86_ops svm_x86_ops = {
>>>>        .cache_reg = svm_cache_reg,
>>>>        .get_rflags = svm_get_rflags,
>>>>        .set_rflags = svm_set_rflags,
>>>> -    .fpu_activate = svm_fpu_activate,
>>>>        .fpu_deactivate = svm_fpu_deactivate,
>>>>          .tlb_flush = svm_flush_tlb,
>>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>>> index 71cbee5..2963303 100644
>>>> --- a/arch/x86/kvm/vmx.c
>>>> +++ b/arch/x86/kvm/vmx.c
>>>> @@ -8896,7 +8896,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
>>>>        .cache_reg = vmx_cache_reg,
>>>>        .get_rflags = vmx_get_rflags,
>>>>        .set_rflags = vmx_set_rflags,
>>>> -    .fpu_activate = vmx_fpu_activate,
>>>>        .fpu_deactivate = vmx_fpu_deactivate,
>>>>          .tlb_flush = vmx_flush_tlb,
>>>>
>>> Avi/Gleb, do you remember any particular reason for this?
>>>
>> IIRC (vaguely) if we expect the fpu to be used in the near future, we
>> activate it eagerly so that we don't fault when it is used.
>>
>> Prevents the sequence:
>>
>> guest user: use fpu
>> #NM
>> host: reflect #NM to guest
>> guest kernel: CLTS
>> guest kernel: switch fpu state
>> #NM
>> host: switch fpu
>> guest kernel: switch fpu state (restarted)
>> guest user: use fpu (restarted)
>>
>> Why was the user removed? Full-time eager fpu?
> No, I mean any reason to keep the hooks.

If there are no callers, I can't think of any.

> In the meanwhile I found it myself:
>
> commit 2d04a05bd7e93c13f13a82ac40de4065a99d069b
> Author: Avi Kivity <avi@redhat.com>
> Date:   Wed Apr 20 15:32:49 2011 +0300
>
>      KVM: x86 emulator: emulate CLTS internally
>      
>      Avoid using ctxt->vcpu; we can do everything with ->get_cr() and ->set_cr().
>      
>      A side effect is that we no longer activate the fpu on emulated CLTS; but that
>      should be very rare.
>      
>      Signed-off-by: Avi Kivity <avi@redhat.com>
>
> vmx_fpu_activate and svm_fpu_activate are still called on #NM and CLTS, but
> never from common code after the above patch.
>
> Activation on CLTS is currently VMX only; I guess on AMD we could check the
> decode assists' CR_VALID bit and instruction length to detect CLTS.


