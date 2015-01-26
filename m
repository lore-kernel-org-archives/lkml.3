Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbbAZT7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:59:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:27872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbbAZT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:59:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="445385118"
Message-ID: <1422302369.13382.3.camel@theros.lm.intel.com>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory
 instructions
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Jan 2015 12:59:29 -0700
In-Reply-To: <20150124111430.GA10084@pd.tnic>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
	 <54C2D34D.7010709@intel.com> <20150124111430.GA10084@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-24 at 12:14 +0100, Borislav Petkov wrote:
> On Fri, Jan 23, 2015 at 03:03:41PM -0800, H. Peter Anvin wrote:
> > For the specific case of CLWB, we can use an "m" input rather than a
> > "+m" output, simply because CLWB (or CLFLUSH* used as a standin for CLWB
> > doesn't need to be ordered with respect to loads (whereas CLFLUSH* do).
> 
> Well, we could do something like:
> 
>         volatile struct { char x[64]; } *p = __p;
> 
>         if (static_cpu_has(X86_FEATURE_CLWB))
>                 asm volatile(".byte 0x66,0x0f,0xae,0x30" :: "m" (*p), "a" (p));
>         else
>                 asm volatile(ALTERNATIVE(
>                         ".byte 0x3e; clflush (%[pax])",
>                         ".byte 0x66; clflush (%[pax])", /* clflushopt (%%rax) */
>                         X86_FEATURE_CLFLUSHOPT)
>                         : [p] "+m" (*p)
>                         : [pax] "a" (p));
> 
> which would simplify the alternative macro too.

This is interesting!  I guess I'm confused as to how this solves the ordering
issue, though.  The "m" input vs "+m" output parameter will tell gcc whether
or not the assembly can be reordered at compile time with respect to reads at
that same location, correct?

So if we have an inline function that could either read or write from gcc's
point of view (input vs output parameter, depending on the branch), it seems
like it would be forced to fall back to the most restrictive case (assume it
will write), and not reorder with respect to reads.  If so, you'd end up in
the same place as using "+m" output, only now you've got an additional branch
instead of a 3-way alternative.

Am I misunderstanding this?

> Generated asm looks ok to me (my objdump doesn't know CLWB yet :)):
> 
> 0000000000000aa0 <myclflush>:
>  aa0:   55                      push   %rbp
>  aa1:   48 89 e5                mov    %rsp,%rbp
>  aa4:   eb 0a                   jmp    ab0 <myclflush+0x10>
>  aa6:   48 89 f8                mov    %rdi,%rax
>  aa9:   66 0f ae 30             data16 xsaveopt (%rax)
>  aad:   5d                      pop    %rbp
>  aae:   c3                      retq
>  aaf:   90                      nop
>  ab0:   48 89 f8                mov    %rdi,%rax
>  ab3:   3e 0f ae 38             clflush %ds:(%rax)
>  ab7:   5d                      pop    %rbp
>  ab8:   c3                      retq
> 
> > Should we use an SFENCE as a standin if pcommit is unavailable, in case
> > we end up using CLFLUSHOPT?
> 
> Btw, is PCOMMIT a lightweight SFENCE for this persistent memory aspect
> to make sure stuff has become persistent after executing it? But not all
> stuff like SFENCE so SFENCE is the bigger hammer?

Ah, yep, I definitely need to include an example flow in my commit comments.
:) Here's a snip from my reply to hpa, to save searching:

	Both the flushes (wmb/clflushopt/clflush) and the pcommit are ordered
	by either mfence or sfence.

	An example function that flushes and commits a buffer could look like
	this (based on clflush_cache_range):

	void flush_and_commit_buffer(void *vaddr, unsigned int size)
	{       
		void *vend = vaddr + size - 1;
		
		for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
			clwb(vaddr);
		
		/* Flush any possible final partial cacheline */
		clwb(vend);
		
		/* 
		 * sfence to order clwb/clflushopt/clflush cache flushes
		 * mfence via mb() also works 
		 */
		wmb();

		pcommit();

		/* 
		 * sfence to order pcommit
		 * mfence via mb() also works 
		 */
		wmb();
	}


