Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaIRAak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:30:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbaIRAaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:30:39 -0400
Date: Thu, 18 Sep 2014 02:29:54 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140918002953.GA6918@potion.redhat.com>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <20140917150433.GC1273@potion.brq.redhat.com>
 <20140917152221.GF5358@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917152221.GF5358@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-17 17:22+0200, Borislav Petkov:
> On Wed, Sep 17, 2014 at 05:04:33PM +0200, Radim Krčmář wrote:
> > which would result in a similar if-else hack
> > 
> >   if (family > X)
> >   	ebx.split.max_monitor_line_size_after_family_X = 0
> >   else
> >   	ebx.split.max_monitor_line_size = 0
> > 
> > other options are
> >   ebx.split.after_family_X.max_monitor_line_size
> > or even
> >   ebx.split.max_monitor_line_size.after_family_X
> 
> And how is that better than simply doing
> 
> 	cpuid = cpuid_ebx(5);
> 
> 	if (family > X)
> 		max_monitor_line_size = cpuid & MASK_FAM_X;
> 	else
> 		max_monitor_line_size = cpuid & MASK_BEFORE_FAM_X;
> 
> ?
> 
> With proper variable naming all is perfectly clear, readable
> and simple. You don't need to open even the CPUID manual - the
> variable tells you you're getting the max monitor line size -
> "ebx.split.max_monitor_line_size_after_family_X" needs me to parse it
> with my eyes first.

I think you proposed to use magic constant in place of of MASK_FAM_X, so
the code above is

  	if (family > X)
  		max_monitor_line_size = cpuid & 0x1ffff;
  	else
  		max_monitor_line_size = cpuid & 0xffff;

We can nicely oneline it, but that's about all the benefits I can see.
It is prone to typos, hard to search for and limiting our operations to
a simple assignment to a properly named variable.

(I prefer descriptive, horribly long, names to raw constant everywhere,
 MASK_MAX_MONITOR_LINE_SIZE_FAM_X.)


Second problem:  Most elements don't begin at offset 0, so the usual
retrieval would add a shift, (repurposing max_monitor_line_size)

 max_monitor_line_size = (cpuid & MASK_FAM_X) >> OFFSET_FAM_X;

and it's not better when we write it back after doing stuff.

 cpuid = (cpuid & ~MASK_FAM_X) | (max_monitor_line_size << OFFSET_FAM_X
                                  & MASK_FAM_X);

All would be fine if we abstracted this with more macros ... wait,
bitfield already does that!

 max_monitor_line_size = cpuid.split.max_monitor_line_size_fam_x;

 cpuid.split.max_monitor_line_size_fam_x = max_monitor_line_size;


---
OT: I'd remove '.split', but we probably wouldn't agree about '.full'.
