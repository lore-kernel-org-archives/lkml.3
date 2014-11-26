Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaKZQ1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:27:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaKZQ1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:27:05 -0500
Message-ID: <5475FF50.4030400@redhat.com>
Date: Wed, 26 Nov 2014 17:26:56 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpeng.li@linux.intel.com, namit@cs.technion.ac.il,
        hpa@linux.intel.com, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <1416847414-22253-3-git-send-email-pbonzini@redhat.com> <20141126120753.GA31982@potion.redhat.com> <5475D20A.90505@redhat.com> <20141126135322.GA4887@potion.brq.redhat.com> <5475DC30.4010104@redhat.com> <20141126144252.GB4887@potion.brq.redhat.com>
In-Reply-To: <20141126144252.GB4887@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/11/2014 15:42, Radim Krčmář wrote:
> 2014-11-26 14:57+0100, Paolo Bonzini:
>>
>>
>> On 26/11/2014 14:53, Radim Krčmář wrote:
>>>>>>> get_xsave = native_xrstor(guest_xsave);  xsave(aligned_userspace_buffer)
>>>>>>> set_xsave = xrstor(aligned_userspace_buffer);  native_xsave(guest_xsave)
>>>>>>>
>>>>>>> Could that work?
>>>>>
>>>>> It could, though it is more like
>>>>>
>>>>>    get_fpu()
>>>>>    native_xrstor(guest_xsave)
>>>>>    xsave(buffer)
>>>>>    put_fpu()
>>>>>
>>>>> and vice versa.  Also, the userspace buffer is mos likely not aligned,
>>>>> so you need some kind of bounce buffer.  It can be done if the CPUID
>>>>> turns out to be a bottleneck, apart from that it'd most likely be slower.
>>> Yeah, it was mostly making this code more future-proof ... it is easier
>>> to convince xsave.h to export its structures if CPUID is the problem.
>>> (I still see some hope for Linux, so performance isn't my primary goal.)
>>>
>>> I'm quite interested in CPUID now though, so I'll try to benchmark it,
>>> someday.
> 
> (Sorry, I don't fully understand your thoughts and I just talk more of
>  the same in those scenarios.)
> 
>> I'm not sure what is more future proof. :)  I wonder if native_xrstor
>> could be a problem the day XRSTORS actually sets/restores MSRs as the
>> processor documentation promises.
> 
> XRSTORS won't affect the guest in any way, we are just going to use it
> to convert the xsave, so any side-effects are going to stay in the host.
> (This could break the host though.)

Yes, that's the problem. :)

> My main presumption is that XSAVE*->XRSTOR*->XSAVE->XRSTOR has the same
> result as XSAVE->XRSTOR, because we are only interested in the state,
> not in any metadata.
> (If it isn't possible to combine intructions, like XSAVE after XRSTORS,
>  this solution won't work.)

Yes, that should be right.  But actually what KVM would do it is
XRSTOR->XSAVE*->XRSTOR*->XSAVE.  The problem here is the side effects of
doing XRSTORS far from a guest entry... though that would likely be
handled by load_guest_fpu/put_guest_fpu.
