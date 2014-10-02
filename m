Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaJBCBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 22:01:55 -0400
Received: from ozlabs.org ([103.22.144.67]:56092 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaJBCBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 22:01:54 -0400
Message-ID: <1412215312.19209.96.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 04/17] powerpc/msi: Improve IRQ bitmap allocator
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 12:01:52 +1000
In-Reply-To: <20141001071331.CBE1B14017C@ozlabs.org>
References: <20141001071331.CBE1B14017C@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 17:13 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:53 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
>                                                                        request
> > to the nearest power of 2.  eg. ask for 5 IRQs and you'll get 8.  This wastes a
>                              ^ one space after a period, or die!
> 
> > lot of IRQs which can be a scarce resource.
> > 
> > For cxl we can require multiple IRQs for every contexts that is attached to the
>                                                  context
> > accelerator.  For AFU directed accelerators, there may be 1000s of contexts
> 
> What is an AFU directed accelerator?

>From the documentation in the last patch:

AFU Models
==========

    There are two programming models supported by the AFU.  Dedicated
    and AFU directed.  AFU may support one or both models.

    In dedicated model only one MMU context is supported.  In this
    model, only one userspace process can use the accelerator at time.

    In AFU directed model, up to 16K simultaneous contexts can be
    supported.  This means up to 16K simultaneous userspace
    applications may use the accelerator (although specific AFUs may
    support less).  In this mode, the AFU sends a 16 bit context ID
    with each of its requests.  This tells the PSL which context is
    associated with this operation.  If the PSL can't translate a
    request, the ID can also be accessed by the kernel so it can
    determine the associated userspace context to service this
    translation with.

>                    
> > attached, hence we can easily run out of IRQs, especially if we are needlessly
> > wasting them.
> > 
> > This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
>                 x
> > of IRQs, hence avoiding this wastage.
> 
> The crucial detail you failed to mention is that you maintain the behaviour that
> allocations are naturally aligned.

ok, I'll add that.

> Can you add a check in the test code at the bottom of the file to confirm that
> please?

Yep
> 
> > diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
> > index 2ff6302..961a358 100644
> > --- a/arch/powerpc/sysdev/msi_bitmap.c
> > +++ b/arch/powerpc/sysdev/msi_bitmap.c
> > @@ -20,32 +20,37 @@ int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
> >  	int offset, order = get_count_order(num);
> >  
> >  	spin_lock_irqsave(&bmp->lock, flags);
> > -	/*
> > -	 * This is fast, but stricter than we need. We might want to add
> > -	 * a fallback routine which does a linear search with no alignment.
> > -	 */
> > -	offset = bitmap_find_free_region(bmp->bitmap, bmp->irq_count, order);
> > +
> > +	offset = bitmap_find_next_zero_area(bmp->bitmap, bmp->irq_count, 0,
> > +					    num, (1 << order) - 1);
> > +	if (offset > bmp->irq_count)
> > +		goto err;
> 
> Can we get a newline here :)

Ok.

> 
> > +	bitmap_set(bmp->bitmap, offset, num);
> >  	spin_unlock_irqrestore(&bmp->lock, flags);
> >  
> >  	pr_debug("msi_bitmap: allocated 0x%x (2^%d) at offset 0x%x\n",
> >  		 num, order, offset);
> 
> This print out is a bit confusing now, should probably just drop the order.

Arrh, yep.

Thanks,
Mikey
