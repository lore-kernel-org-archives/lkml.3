Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3HEXoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:44:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40517 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3HEXoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:44:37 -0400
Date: Tue, 6 Aug 2013 00:44:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 46/51] ARM: DMA-API: better handing of DMA masks
	for coherent allocations
Message-ID: <20130805234402.GZ23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk> <E1V51EE-0006uO-C2@rmk-PC.arm.linux.org.uk> <CAL_JsqJH-T3bBNZvQZF2aWS18n5wfSzCMEi20-5e1RmYEfF3Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJH-T3bBNZvQZF2aWS18n5wfSzCMEi20-5e1RmYEfF3Ow@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 05:43:47PM -0500, Rob Herring wrote:
> On Thu, Aug 1, 2013 at 5:20 PM, Russell King
> <rmk+kernel@arm.linux.org.uk> wrote:
> > We need to start treating DMA masks as something which is specific to
> > the bus that the device resides on, otherwise we're going to hit all
> > sorts of nasty issues with LPAE and 32-bit DMA controllers in >32-bit
> > systems, where memory is offset from PFN 0.
> >
> > In order to start doing this, we convert the DMA mask to a PFN using
> > the device specific dma_to_pfn() macro.  This is the reverse of the
> > pfn_to_dma() macro which is used to get the DMA address for the device.
> >
> > This gives us a PFN mask, which we can then check against the PFN
> > limit of the DMA zone.
> >
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> >  arch/arm/mm/dma-mapping.c |   49 ++++++++++++++++++++++++++++++++++++++++----
> >  arch/arm/mm/init.c        |    2 +
> >  arch/arm/mm/mm.h          |    2 +
> >  3 files changed, 48 insertions(+), 5 deletions(-)
> 
> I believe you missed handling __dma_alloc. I have a different fix than
> what Andreas posted. I think DMA zone handling is broken in all cases
> here. Feel free to combine this in to your patch if you agree.

I was starting to wonder if whether anyone was going to look at those
patches...

> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 7f9b179..3d9bdfb 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -651,7 +651,7 @@ static void *__dma_alloc(struct device *dev,
> size_t size, dma_addr_t *handle,
>         if (!mask)
>                 return NULL;
> 
> -       if (mask < 0xffffffffULL)
> +       if (mask <= (u64)arm_dma_limit)
>                 gfp |= GFP_DMA;

I'm not convinced on that - I think you've missed the entire point in
this patch series about what address space the 'mask' is in.  'mask' is
in the device's address space, which may not be the same as the physical
address space.

With LPAE, the two can become quite different address spaces with a
4GB offset between them.  That's why we must stop the old-school
thinking that DMA addresses and physical addresses are the same thing.
We also need to stop doing stuff like passing dma_addr_t variables into
phys_to_virt().  (All those short-cuts are going to break!)

arm_dma_limit is the physical address space.  So, comparing the two
makes no sense what so ever.

However, the use of arm_dma_limit at the top of get_coherent_dma_mask()
is a bug, I think that should just become something like a 24-bit
constant mask, so the NULL device gets GFP_DMA allocations like they
do on x86 for that case.

I also think that 'mask' should be converted to a pfn at the location
you point out before comparing with the amount of memory in the DMA
zone.
