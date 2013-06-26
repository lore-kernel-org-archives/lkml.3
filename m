Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3FZJNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:13:35 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63403 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FZJNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:13:33 -0400
Date: Wed, 26 Jun 2013 10:13:26 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonathan Austin <jonathan.austin@arm.com>,
        Steve Capper <Steve.Capper@arm.com>, Vinod Koul <vinod.koul@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
Message-ID: <20130626091325.GA7389@linaro.org>
References: <51C97F40.5030101@arm.com>
 <20130625184539.GB2718@n2100.arm.linux.org.uk>
 <20130626084011.GA6687@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626084011.GA6687@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:40:25AM +0100, Steve Capper wrote:
> On Tue, Jun 25, 2013 at 07:45:39PM +0100, Russell King - ARM Linux wrote:
> > On Tue, Jun 25, 2013 at 12:30:08PM +0100, Jonathan Austin wrote:
> > > There's a patch making its way to mainline via Russell's tree
> > > (8d96250700: ARM: mm: Transparent huge page support for LPAE systems)
> > > that breaks the build of the amba-pl08x driver (drivers/dma/amba-pl08x.c) 
> > > because the 'get_signal' macro from include/linux/signal.h is now in the
> > > driver's scope and it clobbers a (previously) valid function call.
> > 
> > Well, here's the change to asm/pgtable.h in that patch:
> > 
> > diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> > index 9bcd262..eaedce7 100644
> > --- a/arch/arm/include/asm/pgtable.h
> > +++ b/arch/arm/include/asm/pgtable.h
> > @@ -24,6 +24,9 @@
> >  #include <asm/memory.h>
> >  #include <asm/pgtable-hwdef.h>
> > 
> > +
> > +#include <asm/tlbflush.h>
> > +
> >  #ifdef CONFIG_ARM_LPAE
> >  #include <asm/pgtable-3level.h>
> >  #else
> > 
> > And the question is - if that's all that is going on in that file, why
> > is asm/tlbflush.h being added to it?  What in _that_ file uses anything
> > from asm/tlbflush.h (nothing apparantly from what I can see)?
> > 
> > So, I'm tempted to kill this change off unless someone can justify why
> > that addition happened - it looks completely inappropriate to me.
> > 
> 
> Hi Russell,
> I needed tlbflush.h for the definition of flush_pmd_entry, called by set_pmd_at
> in pgtable-3level.h.
> 
> It was pulled into pgtable.h as it would also be needed for the equivalent
> set_pmd_at function for 2-levels of paging.
> 

I was a little quick sending this sorry....

I have tried converting set_pmd_at into a macro to allow for delayed expansion.
(As I've noticed that other functions in pgtable-3level.h do this to call
flush_pmd_entry.)

Unfortunately, even with set_pmd_at defined as a macro, I get undefined
references to flush_pmd_entry and clean_pmd_entry (called from
pmdp_test_and_clear_young and pmdp_get_and_clear in asm-generic/pgtable.h).

I'm having a look to see if there's anything else I can do.
Apologies for causing this problem.

Best,
-- 
Steve
