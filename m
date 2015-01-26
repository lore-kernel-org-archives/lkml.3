Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbbAZVfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:35:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45201 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbbAZVfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:35:09 -0500
Date: Mon, 26 Jan 2015 22:34:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory instructions
Message-ID: <20150126213457.GI1656@pd.tnic>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
 <54C2D34D.7010709@intel.com>
 <20150124111430.GA10084@pd.tnic>
 <1422302369.13382.3.camel@theros.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422302369.13382.3.camel@theros.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 12:59:29PM -0700, Ross Zwisler wrote:
> This is interesting!  I guess I'm confused as to how this solves the ordering
> issue, though.  The "m" input vs "+m" output parameter will tell gcc whether
> or not the assembly can be reordered at compile time with respect to reads at
> that same location, correct?
> 
> So if we have an inline function that could either read or write from gcc's
> point of view (input vs output parameter, depending on the branch), it seems
> like it would be forced to fall back to the most restrictive case (assume it
> will write), and not reorder with respect to reads.  If so, you'd end up in
> the same place as using "+m" output, only now you've got an additional branch
> instead of a 3-way alternative.
> 
> Am I misunderstanding this?

No, you're not, that is the right question. I was simply hypothesizing
about how we could do what hpa suggests but I don't have any other ideas
about having an "m" and an "+m" in the same inline asm statement.

My hunch is, the moment we have an "+m", the reordering would be
suppressed and that would not give us the CLWB case where we don't have
to suppress reordering wrt reads.

> Ah, yep, I definitely need to include an example flow in my commit comments.
> :) Here's a snip from my reply to hpa, to save searching:
> 
> 	Both the flushes (wmb/clflushopt/clflush) and the pcommit are ordered
> 	by either mfence or sfence.
> 
> 	An example function that flushes and commits a buffer could look like
> 	this (based on clflush_cache_range):
> 
> 	void flush_and_commit_buffer(void *vaddr, unsigned int size)
> 	{       
> 		void *vend = vaddr + size - 1;
> 		
> 		for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
> 			clwb(vaddr);
> 		
> 		/* Flush any possible final partial cacheline */
> 		clwb(vend);
> 		
> 		/* 
> 		 * sfence to order clwb/clflushopt/clflush cache flushes
> 		 * mfence via mb() also works 
> 		 */
> 		wmb();
> 
> 		pcommit();

Oh, so you need an SFENCE to flush out the preceding in-flight writes
*and* PCOMMIT for the persistent memory ranges. Ok, makes sense, PCOMMIT
deals with the persistent stores.

> 		/* 
> 		 * sfence to order pcommit
> 		 * mfence via mb() also works 
> 		 */
> 		wmb();

Doc says PCOMMIT is not ordered wrt loads and SFENCE too. Don't we want
to be absolutely conservative here and use MFENCE both times?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
