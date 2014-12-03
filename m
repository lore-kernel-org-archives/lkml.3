Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaLCMHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaLCMHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:07:44 -0500
Date: Wed, 3 Dec 2014 13:07:40 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH] KVM: cpuid: mask more bits in leaf 0xd and subleaves
Message-ID: <20141203120739.GA26617@potion.brq.redhat.com>
References: <1417525770-16485-1-git-send-email-pbonzini@redhat.com>
 <20141202230536.GA12980@potion.redhat.com>
 <547EC40E.5010506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547EC40E.5010506@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-03 09:04+0100, Paolo Bonzini:
> On 03/12/2014 00:05, Radim Krčmář wrote:
> > 2014-12-02 14:09+0100, Paolo Bonzini:
> >> +			} else {
> >> +				if (entry[i].eax == 0 || !(supported & mask))
> >> +					continue;
> >> +				WARN_ON_ONCE(entry[i].ecx & 1);
> >> +				entry[i].ecx &= 1;
> > 
> >  ECX  Bit 0 is set if the sub-leaf index, n, maps to a valid bit in the
> >       IA32_XSS MSR and bit 0 is clear if n maps to a valid bit in XCR0.
> > 
> > ECX should be set to 0 instead, we definitely don't map to a valid bit
> > in IA32_XSS now.
> 
> Well, there is a WARN just above. :)  But I can change it to zero instead.

Yeah, I wasn't sure about the WARN ... I can only see it trigger after
host xcr0 changes and we are much more screwed in that case anyway :)
(But it has a chance of catching a bug, so it isn't only bad.)

The guest expects 0 here, so I'd rather have it ...

> > (Having only one part of cpuid ready for it is weird ...)
> > 
> >> +			}
> >> +			entry[i].edx = 0;
> >>  			entry[i].flags |=
> >>  			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> > 
> > (Unrelated, I have yet to understand how this flag translates
> >  * If ECX contains an invalid sub-leaf index, EAX/EBX/ECX/EDX return 0.)
> 
> If the index is invalid, entry[i].eax is zero and we do not return
> anything at all.

I see, the field is sparse and "++*nent; ++i;", not the flag, does it,
thanks.
