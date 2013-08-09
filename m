Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968028Ab3HIPvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:51:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29370 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3HIPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:51:24 -0400
Date: Fri, 9 Aug 2013 11:50:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v3 07/10] xen: introduce XENMEM_get_dma_buf and
 xen_put_dma_buf
Message-ID: <20130809155050.GA8462@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com>
 <1375720256-8014-7-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130809153606.GD5637@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809153606.GD5637@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:36:06AM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Aug 05, 2013 at 05:30:53PM +0100, Stefano Stabellini wrote:
> > XENMEM_exchange can't be used by autotranslate guests because of two
> > severe limitations:
> > 
> > - it does not copy back the mfns into the out field for autotranslate
> >   guests;
> > 
> > - it does not guarantee that the hypervisor won't change the p2m
> >   mappings for the exchanged pages while the guest is using them. Xen
> >   never promises to keep the p2m mapping stable for autotranslate guests
> >   in general.  In practice it won't happen unless one uses uncommon
> >   features like memory sharing or paging.
> > 
> > To overcome these problems I am introducing two new hypercalls.
> 
> You should also refer to the git or c/s of where it is implemented
> in the hypervisor (once it lands there of course).
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  include/xen/interface/memory.h |   62 ++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 62 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> > index 2ecfe4f..ffd7f4e 100644
> > --- a/include/xen/interface/memory.h
> > +++ b/include/xen/interface/memory.h
> > @@ -263,4 +263,66 @@ struct xen_remove_from_physmap {
> >  };
> >  DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
> >  
> > +#define XENMEM_get_dma_buf             26
> > +/*
> > + * This hypercall is similar to XENMEM_exchange: it exchanges the pages
> > + * passed in with a new set of pages, contiguous and under 4G if so
> 
> The "under 4G" is not true. It is based on the bit value. The user could
> request it be under "1G" if they wanted.

Or say below 16GB. Point here is that I was thinking you should just
mention which of the parameters is needed to set this.
> 
> > + * requested. The new pages are going to be "pinned": it's guaranteed
> > + * that their p2m mapping won't be changed until explicitly "unpinned".
> 
> What if you try to balloon them out? What happens then? Does that
> unpin them automatically?
> 
> What if I use said "pin" page for grants? Can they be shared with another
> guest?
> 
> > + * If return code is zero then @out.extent_list provides the MFNs of the
> > + * newly-allocated memory.  Returns zero on complete success, otherwise
> > + * a negative error code.
> 
> Ahem. Which ones? I know you didn't like the existing grant code b/c it
> returned some general error. Would it make sense to say which are ones
> are expected?
> 
> > + * On complete success then always @nr_exchanged == @in.nr_extents.  On
> > + * partial success @nr_exchanged indicates how much work was done.
> 
> And no error?
> > + */
> > +struct xen_get_dma_buf {
> > +    /*
> > +     * [IN] Details of memory extents to be exchanged (GMFN bases).
> > +     * Note that @in.address_bits is ignored and unused.
> 
> Ohhhh, why? What if the user wants to be it under 2G?

Looking a bit more at the code revealed that we stick that in the
@out.address_bits
> 
> > +     */
> > +    struct xen_memory_reservation in;
> > +
> > +    /*
> > +     * [IN/OUT] Details of new memory extents.
> > +     * We require that:
> > +     *  1. @in.domid == @out.domid
> > +     *  2. @in.nr_extents  << @in.extent_order == 
> > +     *     @out.nr_extents << @out.extent_order
> > +     *  3. @in.extent_start and @out.extent_start lists must not overlap
> > +     *  4. @out.extent_start lists GPFN bases to be populated
> > +     *  5. @out.extent_start is overwritten with allocated GMFN bases

.. which you should document, otherwise the hypervisor might try to give
you pages under 2^0..
> > +     */
> > +    struct xen_memory_reservation out;
> > +
> > +    /*
> > +     * [OUT] Number of input extents that were successfully exchanged:
> > +     *  1. The first @nr_exchanged input extents were successfully
> > +     *     deallocated.
> > +     *  2. The corresponding first entries in the output extent list correctly
> > +     *     indicate the GMFNs that were successfully exchanged.
> > +     *  3. All other input and output extents are untouched.
> > +     *  4. If not all input exents are exchanged then the return code of this
> > +     *     command will be non-zero.
> > +     *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!

as this says the initial value is zero.
