Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3IWPYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3IWPYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:24:06 -0400
Message-ID: <52405D24.1010708@redhat.com>
Date: Mon, 23 Sep 2013 17:24:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: prevent setting unsupported XSAVE states
References: <1379341591-6538-1-git-send-email-pbonzini@redhat.com> <1379341591-6538-3-git-send-email-pbonzini@redhat.com> <20130922093353.GI25202@redhat.com> <5240166D.5020401@redhat.com> <20130923150955.GB10353@redhat.com>
In-Reply-To: <20130923150955.GB10353@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/09/2013 17:09, Gleb Natapov ha scritto:
> On Mon, Sep 23, 2013 at 12:22:37PM +0200, Paolo Bonzini wrote:
>>>> @@ -6940,6 +6948,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>>>  
>>>>  	vcpu->arch.ia32_tsc_adjust_msr = 0x0;
>>>>  	vcpu->arch.pv_time_enabled = false;
>>>> +
>>>> +	vcpu->arch.supported_xcr0 = XSTATE_FPSSE;
>>>> +
>>> Why is this needed? It will make make __kvm_set_xcr() succeed if attempt
>>> is made to set SSE bit when it is not supported in cpuid. This may not
>>> be an issue in practice, but for clarity it is better for supported_xcr0
>>> to contain only what is supported in guest's cpuid bits and handle the
>>> fact that FP/SSE state should always be copied to/from userspace in
>>> kvm_vcpu_ioctl_x86_(set|get)_xsave functions.
>>
>> I don't think it makes sense to disable SSE but not XSAVE.  Linux even
>> has this:
>>
>>         if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
>>                 pr_err("FP/SSE not shown under xsave features 0x%llx\n",
>>                        pcntxt_mask);
>>                 BUG();
>>         }
>>
> That's why I said it may not be an issue in practice. What makes the
> code confusing to me is that it is not clear what .supported_xcr0
> contains. Why not make it contain only guest cpuid bits and use
> XSTATE_FPSSE explicitly in get_xsave. I mean drop this from next patch:
> 
>         vcpu->arch.supported_xcr0 =
> -               (best->eax | ((u64)best->edx << 32)) &
> +               (best->eax | ((u64)best->edx << 32) | XSTATE_FPSSE) &
>                 host_xcr0 & KVM_SUPPORTED_XCR0;
> 
> And change
> *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] !=  vcpu->arch.supported_xcr0;
> to
> *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] != (vcpu->arch.supported_xcr0 | XSTATE_FPSSE);

Ok.

> 
>> I preferred this to adding dubiously-testable code that probed CPUID for
>> SSE support (or should I check FXSR instead?)

I didn't understand you wanted the "| XSTATE_FPSSE" moved, I thought you
wanted to check for SSE bits in userspace (similar to AVX).  I wasn't
sure whether to tie this to the SSE bit, or to FXSR.  But what you
propose makes sense, I'll test it.

Paolo
