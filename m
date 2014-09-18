Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaIRNhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbaIRNhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:37:23 -0400
Message-ID: <541ADFEB.6030801@redhat.com>
Date: Thu, 18 Sep 2014 15:36:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
References: <20140917124501.GC5358@nazgul.tnic> <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il> <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il> <20140917132141.GD5358@nazgul.tnic> <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com> <20140917140601.GE5358@nazgul.tnic> <541AD8F3.5010700@redhat.com> <20140918132635.GB27008@nazgul.tnic>
In-Reply-To: <20140918132635.GB27008@nazgul.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/09/2014 15:26, Borislav Petkov ha scritto:
> On Thu, Sep 18, 2014 at 03:06:59PM +0200, Paolo Bonzini wrote:
>> The extra bit used to be reserved and thus will be zero on older
>> families.  So, nothing?
> 
> "thus will be zero" is unfortunately simply not true.
> 
> From the SDM:
> 
> "1.3.2 Reserved Bits and Software Compatibility
> 
> In many register and memory layout descriptions, certain bits are marked
> as reserved. When bits are marked as reserved, it is essential for
> compatibility with future processors that software treat these bits as
> having a future, though unknown, effect. The behavior of reserved bits
> should be regarded as not only undefined, but unpredict- able. Software
> should follow these guidelines in dealing with reserved bits:

We're talking about the case where the field is not reserved anymore and
we _know_ that the vendor has just decided to grow the bitfield that
precedes it.

As soon as we know that the field is not reserved anymore, we obviously
rely on reserved bits being zero in older processors, and in future
processors from other vendors.  The trivial example is feature bits like
XSAVE.  We query them all the time without checking the family when they
were first introduced, don't we?

> * Do not depend on the states of any reserved bits when testing the values of registers that contain such bits.
> Mask out the reserved bits before testing.

Done by the bitfields.

> *  Do not depend on the states of any reserved bits when storing to memory or to a register.

Doesn't apply to CPUID.

> * Do not depend on the ability to retain information written into any reserved bits.

Doesn't apply to CPUID.

> * When loading a register, always load the reserved bits with the values indicated in the documentation, if any,
> or reload them with values previously read from the same register."

Only applies to KVM, where it can be done with the bitfields too.

> And so on and so on.
> 
> Aaanyway, I see kvm folks are strongly determined to do this so I'll
> propose you do it for kvm only and not touch the rest of arch/x86/.
> 
> I really really disagree with casting CPUID words in stone and with
> touching code which is perfectly fine.

It's not really the KVM folks.  I actually kinda agree with you about
"touching code that works", which is why I hadn't yet commented on the
series.  But Ingo and Peter like it, so I can accept the patch as well.

> But this is just me and the final word lies with x86 people so it'll
> happen whatever they say.

Yep, same with me---KVM will just follow suit.

Paolo
