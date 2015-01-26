Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbbAZTvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:51:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:38375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbbAZTvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:51:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,470,1418112000"; 
   d="scan'208";a="667807730"
Message-ID: <1422301899.13382.2.camel@theros.lm.intel.com>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory
 instructions
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
Date: Mon, 26 Jan 2015 12:51:39 -0700
In-Reply-To: <54C2D34D.7010709@intel.com>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
	 <54C2D34D.7010709@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 15:03 -0800, H. Peter Anvin wrote:
> On 01/23/2015 12:40 PM, Ross Zwisler wrote:
> > This patch set adds support for two new persistent memory instructions, pcommit
> > and clwb.  These instructions were announced in the document "Intel
> > Architecture Instruction Set Extensions Programming Reference" with reference
> > number 319433-022.
> > 
> > https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf
> > 
> 
> Please explain in these patch descriptions what the instructions
> actually do.

Sure, will do.

> +	volatile struct { char x[64]; } *p = __p;
> +
> +	asm volatile(ALTERNATIVE_2(
> +		".byte " __stringify(NOP_DS_PREFIX) "; clflush (%[pax])",
> +		".byte 0x66; clflush (%[pax])", /* clflushopt (%%rax) */
> +		X86_FEATURE_CLFLUSHOPT,
> +		".byte 0x66, 0x0f, 0xae, 0x30",  /* clwb (%%rax) */
> +		X86_FEATURE_CLWB)
> +		: [p] "+m" (*p)
> +		: [pax] "a" (p));
> 
> For the specific case of CLWB, we can use an "m" input rather than a
> "+m" output, simply because CLWB (or CLFLUSH* used as a standin for CLWB
> doesn't need to be ordered with respect to loads (whereas CLFLUSH* do).
> 
> Now, one can argue that for performance reasons we should should still
> use "+m" in case we use the CLFLUSH* standin, to avoid flushing a cache
> line to memory just to bring it back in.

Understood, and an interesting point.  It seems like we can be correct using
either, yea?  I guess I'm happy with "+m" output since it's consistent with
clflush and clflushopt, and since we avoid the clflush* then read issue.
Please let me know if you have a preference.

> +static inline void pcommit(void)
> +{
> +	alternative(ASM_NOP4, ".byte 0x66, 0x0f, 0xae, 0xf8",
> +		    X86_FEATURE_PCOMMIT);
> +}
> +
> 
> Should we use an SFENCE as a standin if pcommit is unavailable, in case
> we end up using CLFLUSHOPT?

Ah, sorry, I really need to include an example flow in my patch descriptions
to make this more clear. :)

Both the flushes (wmb/clflushopt/clflush) and the pcommit are ordered by
either mfence or sfence.

An example function that flushes and commits a buffer could look like this
(based on clflush_cache_range):

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

In this example function I don't begin with a fence because clwb (which may
fall back to clflush/clflushopt) will be ordered with respect to either writes
or reads and writes depending on whether the argument is given as an input or
output parameter.

If the platform doesn't support PCOMMIT, you end up with this:

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

        nop(); /* from pcommit(), via alternatives */

        /* 
         * sfence to order pcommit
         * mfence via mb() also works 
         */
        wmb();
}

This is fine, but now you've got two fences in a row.  Another slightly more
messy choice would be to include the fence in the pcommit assembly, so
you either get pcommit + sfence or a pair of NOPs.

