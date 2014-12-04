Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaLDNng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:43:36 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55070 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaLDNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:43:34 -0500
Message-ID: <548064FF.3000107@redhat.com>
Date: Thu, 04 Dec 2014 14:43:27 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: Nadav Amit <nadav.amit@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Nadav Amit <namit@cs.technion.ac.il>, hpa@linux.intel.com,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <1416847414-22253-3-git-send-email-pbonzini@redhat.com> <802AF3F4-2631-4979-A8CC-46B406546062@gmail.com> <547F1D84.9040505@redhat.com> <20141203184537.GA27128@potion.brq.redhat.com>
In-Reply-To: <20141203184537.GA27128@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/12/2014 19:45, Radim Krčmář wrote:
> 2014-12-03 15:26+0100, Paolo Bonzini:
>>
>>
>> On 03/12/2014 15:23, Nadav Amit wrote:
>>> I think it is better just to replace the last line with:
>>>
>>> *(u64 *)(dest + XSAVE_HDR_OFFSET) = xsave->xsave_hdr.xstate_bv
> 
> Yeah, or we can use this value for xstate_bv to save some copying too,
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 19e5e8f..ba2b7bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3137,7 +3137,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
>  {
>  	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
> -	u64 xstate_bv = vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
> +	u64 xstate_bv = xsave->xsave_hdr.xstate_bv;

Also good.

>  	u64 valid;
>  
>  	/*
> 
>> Right, this matches
>>
>>         u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
>> 	...
>>         xsave->xsave_hdr.xstate_bv = xstate_bv;
>>
>> in load_xsave.
> 
> Btw, we don't care about crashers from userspace?

We do, but they're taken care of by

                if (xstate_bv & ~kvm_supported_xcr0())
                        return -EINVAL;

in kvm_vcpu_ioctl_x86_set_xsave.  kvm_supported_xcr0 is always a subset
of host_xcr0, hence:

>  	/* Set XSTATE_BV and possibly XCOMP_BV.  */
>  	xsave->xsave_hdr.xstate_bv = xstate_bv;
> -	if (cpu_has_xsaves)
> +	if (cpu_has_xsaves) {
>  		xsave->xsave_hdr.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
> +		xsave->xsave_hdr.xstate_bv &= xsave->xsave_hdr.xcomp_bv;

this is not zeroing any bit.  Thanks for thinking about it, though. :)

Paolo
