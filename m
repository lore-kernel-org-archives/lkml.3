Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3FGRav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:30:51 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:49012 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932079Ab3FGRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:30:49 -0400
Date: Fri, 7 Jun 2013 18:30:13 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Chris Johnson <CJohnson@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
Message-ID: <20130607173004.GA29344@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
 <20130606110240.GA3320@localhost.localdomain>
 <CAAVeFu+o7oc4Rrn67xxzsgeZ9xrTBkaLd_E4amaVgcNBRsKC_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFu+o7oc4Rrn67xxzsgeZ9xrTBkaLd_E4amaVgcNBRsKC_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:25:07PM +0900, Alexandre Courbot wrote:
> On Thu, Jun 6, 2013 at 8:02 PM, Dave Martin <Dave.Martin@arm.com> wrote:
> 
> >> +static int __attribute__((used)) __tegra_smc_stack[10];
> >
> > Use __used instead of using GCC attributes directly.
> >
> >> +
> >> +/*
> >> + * With EABI, subtype and arg already end up in r0, r1 and r2 as they are
> >> + * function arguments, but we prefer to play safe here and explicitly move
> >> + * these values into the expected registers anyway. mov instructions without
> >> + * any side-effect are turned into nops by the assembler, which limits
> >> + * overhead.
> >> + */
> >> +static void tegra_generic_smc(u32 type, u32 subtype, u32 arg)
> >> +{
> >> +     asm volatile(
> >> +             ".arch_extension        sec\n\t"
> >> +             "ldr    r3, =__tegra_smc_stack\n\t"
> >
> > ldr= should be avoided in inline asm, because GCC can't guess it's size,
> > and can't guarantee that the literal pool word is close enough to be
> > addressable (though for small compilation units it's unlikely to be a
> > problem).
> 
> With Russel's suggested changes this will go away, but that's good to
> know anyway.
> 
> >> +             "dsb\n\t"
> >
> > Can you explain what this DSB is for?
> 
> Just a safety measure to make sure all memory operations are done
> before we enter the secure monitor. Is it unnecessary?

Most likely it's either unnecessary, or insufficient.

Just for entering call SMC properly, it's not needed.  If the Secure
World has its MMU on and maps Normal World memory using the same memory
types as Linux, then the Normal World and Secure World access the memory
coherently with no extra barrier needed.

It the Secure World's MMU is off, or if it maps Normal World memory
as Secure (pagetable NS bit = 0), or if it maps Normal World memory with
memory types incompatible with the ones Linux is using then you will get
coherency problems: the Secure and Normal Worlds won't necessarily see
the same data.

In the latter case, you must do explicit cache maintenance around SMC
for the data you want to exchange.  This might also be needed in the
Secure World if caches are enabled over there.  DSB isn't enough by
itself.


If the Secure World doesn't access Normal World memory at all, you
don't need to do anything special and can remove the DSB.

Otherwise, for performance reasons, it is definitely preferable to have
the Secure World MMU on if possible, though it's a bit more complex to
set up.

> >> +             "smc    #0\n\t"
> >> +             "ldr    r3, =__tegra_smc_stack\n\t"
> >> +             "ldmia  r3, {r4-r12, lr}"
> >> +                     :
> >> +                     : [type]    "r" (type),
> >> +                       [subtype] "r" (subtype),
> >> +                       [arg]     "r" (arg)
> >> +                     : "r0", "r1", "r2", "r3", "r4", "memory");
> >
> > If r5-r12 are not clobbered, why do you save and restore them?
> 
> The secure monitor might change them.

Sure, but you could just add all the registers to the clobber list,
and then the compiler would save and restore them for you in the
function entry/exit sequences, which may be a bit more efficient.

Since you are going to replace this code anyway, it's academic
though.

> 
> > In the ARM ABI, r12 is a caller-save register, so you probably
> > don't need to save/restore that even if it is clobbered.
> 
> Right, thanks. Didn't know r12 could be used as a scratch register.

What I said is a bit wrong actually: for the naked version of the
function you can go ahead and corrupt r12, because naked functions
are not inlinable and follow the ABI.  Adding "r12" in the clobber
list would be harmless in this case, but I don't think it's necessary.

asm() in any other context needs to declare all registers that it
might clobber.

Cheers
---Dave
