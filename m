Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaKZMyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:54:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaKZMyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:54:32 -0500
Message-ID: <5475CD79.5050305@redhat.com>
Date: Wed, 26 Nov 2014 13:54:17 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Nadav Amit <nadav.amit@gmail.com>
CC: linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        namit@cs.technion.ac.il, hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <20141125101331.GA28985@kernel> <54745BB0.8080304@redhat.com> <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com> <54748F70.70402@redhat.com> <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com> <20141126012439.GA20090@kernel>
In-Reply-To: <20141126012439.GA20090@kernel>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/11/2014 02:24, Wanpeng Li wrote:
> Hi all,
> On Tue, Nov 25, 2014 at 04:50:06PM +0200, Nadav Amit wrote:
>>
>>> On Nov 25, 2014, at 16:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>
>>>
>>>
>>> On 25/11/2014 15:05, Nadav Amit wrote:
>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>> index 373b0ab9a32e..ca26681455c2 100644
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -6955,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
>>>>> 		return err;
>>>>>
>>>>> 	fpu_finit(&vcpu->arch.guest_fpu);
>>>>> +	if (cpu_has_xsaves)
>>>>> +		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
>>>>> +			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>>>>>
>>>>> 	/*
>>>>> 	 * Ensure guest xcr0 is valid for loading
>>>>
>>>> The second version works for me (w/qemu v2.1.0; Linux 3.13 guest). I
> 
> Could you try 3.17 guest which has xsaves enabled? Because I'm not sure if 
> the below codes from Paolo is enough to mask XSAVES, should we also add 
> F(XSAVES)?
> 
> +       const u32 kvm_supported_word10_x86_features =
> +               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
> +
> 
> In addition, the 3.17 guest is still hang as I mentioned even if I add the 
> F(XSAVES) to the kvm_supported_word10_x86_features.

Note that the point is _hiding_ XSAVES while leaving
XSAVEOPT/XSAVEC/XGETBV1 enabled.  This series only fixes the problems
with xsaves in the host, it doesn't try making XSAVES work in the guest.

> I have another patch which enable xsaves in KVM and the patch is still
> under debug with Paolo's patch "KVM: x86: support XSAVES usage in the host",
> so the 1/2 patch from Paolo can be dropped if my patch is ready. Anyway,
> a quick fix is needed before enable xsaves in kvm. 

Please add XSAVES to kvm_supported_word10_x86_features in your patches
instead.  We still need to mask any (not yet defined) feature in bit 4
and above of CPUID[EAX=0xd,ECX].EAX.

Paolo
