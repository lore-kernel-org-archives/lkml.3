Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbaFTXNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:13:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:59762 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaFTXNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:13:16 -0400
Message-ID: <1403305961.4587.66.camel@pasglop>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Date: Sat, 21 Jun 2014 09:12:41 +1000
In-Reply-To: <1403234514.3707.278.camel@ul30vt.home>
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
	 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>
	 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>
	 <1403234514.3707.278.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 21:21 -0600, Alex Williamson wrote:

> Working on big endian being an accident may be a matter of perspective

 :-)

> The comment remains that this patch doesn't actually fix anything except
> the overhead on big endian systems doing redundant byte swapping and
> maybe the philosophy that vfio regions are little endian.

Yes, that works by accident because technically VFIO is a transport and
thus shouldn't perform any endian swapping of any sort, which remains
the responsibility of the end driver which is the only one to know
whether a given BAR location is a a register or some streaming data
and in the former case whether it's LE or BE (some PCI devices are BE
even ! :-)

But yes, in the end, it works with the dual "cancelling" swaps and the
overhead of those swaps is probably drowned in the noise of the syscall
overhead.

> I'm still not a fan of iowrite vs iowritebe, there must be something we
> can use that doesn't have an implicit swap.

Sadly there isn't ... In the old day we didn't even have the "be"
variant and readl/writel style accessors still don't have them either
for all archs.

There is __raw_readl/writel but here the semantics are much more than
just "don't swap", they also don't have memory barriers (which means
they are essentially useless to most drivers unless those are platform
specific drivers which know exactly what they are doing, or in the rare
cases such as accessing a framebuffer which we know never have side
effects). 

>  Calling it iowrite*_native is also an abuse of the namespace.


>  Next thing we know some common code
> will legitimately use that name. 

I might make sense to those definitions into a common header. There have
been a handful of cases in the past that wanted that sort of "native
byte order" MMIOs iirc (though don't ask me for examples, I can't really
remember).

>  If we do need to define an alias
> (which I'd like to avoid) it should be something like vfio_iowrite32.
> Thanks,

Cheers,
Ben.

> Alex
> 
> > > ===
> > > 
> > > any better?
> > > 
> > > 
> > > 
> > > 
> > >>>> Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > >>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > >>>> ---
> > >>>>  drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++++++++----
> > >>>>  1 file changed, 16 insertions(+), 4 deletions(-)
> > >>>>
> > >>>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> > >>>> index 210db24..f363b5a 100644
> > >>>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > >>>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > >>>> @@ -21,6 +21,18 @@
> > >>>>  
> > >>>>  #include "vfio_pci_private.h"
> > >>>>  
> > >>>> +#ifdef __BIG_ENDIAN__
> > >>>> +#define ioread16_native		ioread16be
> > >>>> +#define ioread32_native		ioread32be
> > >>>> +#define iowrite16_native	iowrite16be
> > >>>> +#define iowrite32_native	iowrite32be
> > >>>> +#else
> > >>>> +#define ioread16_native		ioread16
> > >>>> +#define ioread32_native		ioread32
> > >>>> +#define iowrite16_native	iowrite16
> > >>>> +#define iowrite32_native	iowrite32
> > >>>> +#endif
> > >>>> +
> > >>>>  /*
> > >>>>   * Read or write from an __iomem region (MMIO or I/O port) with an excluded
> > >>>>   * range which is inaccessible.  The excluded range drops writes and fills
> > >>>> @@ -50,9 +62,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
> > >>>>  				if (copy_from_user(&val, buf, 4))
> > >>>>  					return -EFAULT;
> > >>>>  
> > >>>> -				iowrite32(le32_to_cpu(val), io + off);
> > >>>> +				iowrite32_native(val, io + off);
> > >>>>  			} else {
> > >>>> -				val = cpu_to_le32(ioread32(io + off));
> > >>>> +				val = ioread32_native(io + off);
> > >>>>  
> > >>>>  				if (copy_to_user(buf, &val, 4))
> > >>>>  					return -EFAULT;
> > >>>> @@ -66,9 +78,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
> > >>>>  				if (copy_from_user(&val, buf, 2))
> > >>>>  					return -EFAULT;
> > >>>>  
> > >>>> -				iowrite16(le16_to_cpu(val), io + off);
> > >>>> +				iowrite16_native(val, io + off);
> > >>>>  			} else {
> > >>>> -				val = cpu_to_le16(ioread16(io + off));
> > >>>> +				val = ioread16_native(io + off);
> > >>>>  
> > >>>>  				if (copy_to_user(buf, &val, 2))
> > >>>>  					return -EFAULT;
> > >>>
> > >>>
> > >>>
> > >>
> > >>
> > > 
> > > 
> > 
> > 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


