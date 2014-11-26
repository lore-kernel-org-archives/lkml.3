Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaKZOnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:43:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKZOnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:43:08 -0500
Date: Wed, 26 Nov 2014 15:42:53 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpeng.li@linux.intel.com, namit@cs.technion.ac.il,
        hpa@linux.intel.com, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141126144252.GB4887@potion.brq.redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
 <20141126120753.GA31982@potion.redhat.com>
 <5475D20A.90505@redhat.com>
 <20141126135322.GA4887@potion.brq.redhat.com>
 <5475DC30.4010104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5475DC30.4010104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 14:57+0100, Paolo Bonzini:
> 
> 
> On 26/11/2014 14:53, Radim Krčmář wrote:
> >>> > > get_xsave = native_xrstor(guest_xsave);  xsave(aligned_userspace_buffer)
> >>> > > set_xsave = xrstor(aligned_userspace_buffer);  native_xsave(guest_xsave)
> >>> > > 
> >>> > > Could that work?
> >> > 
> >> > It could, though it is more like
> >> > 
> >> >    get_fpu()
> >> >    native_xrstor(guest_xsave)
> >> >    xsave(buffer)
> >> >    put_fpu()
> >> > 
> >> > and vice versa.  Also, the userspace buffer is mos likely not aligned,
> >> > so you need some kind of bounce buffer.  It can be done if the CPUID
> >> > turns out to be a bottleneck, apart from that it'd most likely be slower.
> > Yeah, it was mostly making this code more future-proof ... it is easier
> > to convince xsave.h to export its structures if CPUID is the problem.
> > (I still see some hope for Linux, so performance isn't my primary goal.)
> > 
> > I'm quite interested in CPUID now though, so I'll try to benchmark it,
> > someday.

(Sorry, I don't fully understand your thoughts and I just talk more of
 the same in those scenarios.)

> I'm not sure what is more future proof. :)  I wonder if native_xrstor
> could be a problem the day XRSTORS actually sets/restores MSRs as the
> processor documentation promises.

Isn't that a problem only for emulation?

>                                    We do not need that to pass them to
> userspace via KVM_GET/SET_XSAVE because we have KVM_GET/SET_MSR for
> that, but it may cause problems if get_xsave uses XRSTORS and thus sets
> the MSRs to unanticipated values.

KVM_GET/SET_XSAVE is defined to use the format of XSAVE/XRSTOR.
(Userspace shouldn't know how we actually store guest's state;
 KVM_GET/SET_MSR doesn't read host's state.)

XRSTORS won't affect the guest in any way, we are just going to use it
to convert the xsave, so any side-effects are going to stay in the host.
(This could break the host though.)

>                                    Difficult to say without more
> information on Intel's plans.

My main presumption is that XSAVE*->XRSTOR*->XSAVE->XRSTOR has the same
result as XSAVE->XRSTOR, because we are only interested in the state,
not in any metadata.
(If it isn't possible to combine intructions, like XSAVE after XRSTORS,
 this solution won't work.)
