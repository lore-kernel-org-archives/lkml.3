Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3IZF1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:27:37 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:23019
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab3IZF1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:27:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371I936eI542I1432Ic8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Bhushan Bharat-R65777 <R65777@freescale.com>
Subject: RE: [PATCH 7/7] vfio pci: Add vfio iommu implementation for FSL_PAMU
Thread-Topic: [PATCH 7/7] vfio pci: Add vfio iommu implementation for
 FSL_PAMU
Thread-Index: AQHOtQscWLdU2aI1tEqcvOhF42KAXZnW2qWAgAChstA=
Date: Thu, 26 Sep 2013 05:27:28 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D07184DEF@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-8-git-send-email-Bharat.Bhushan@freescale.com>
 <1380136001.3030.380.camel@ul30vt.home>
In-Reply-To: <1380136001.3030.380.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8Q5Rf0T011894



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, September 26, 2013 12:37 AM
> To: Bhushan Bharat-R65777
> Cc: joro@8bytes.org; benh@kernel.crashing.org; galak@kernel.crashing.org; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> pci@vger.kernel.org; agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> foundation.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 7/7] vfio pci: Add vfio iommu implementation for FSL_PAMU
> 
> On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> > This patch adds vfio iommu support for Freescale IOMMU (PAMU -
> > Peripheral Access Management Unit).
> >
> > The Freescale PAMU is an aperture-based IOMMU with the following
> > characteristics.  Each device has an entry in a table in memory
> > describing the iova->phys mapping. The mapping has:
> >   -an overall aperture that is power of 2 sized, and has a start iova that
> >    is naturally aligned
> >   -has 1 or more windows within the aperture
> >   -number of windows must be power of 2, max is 256
> >   -size of each window is determined by aperture size / # of windows
> >   -iova of each window is determined by aperture start iova / # of windows
> >   -the mapped region in each window can be different than
> >    the window size...mapping must power of 2
> >   -physical address of the mapping must be naturally aligned
> >    with the mapping size
> >
> > Some of the code is derived from TYPE1 iommu (driver/vfio/vfio_iommu_type1.c).
> >
> > Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> > ---
> >  drivers/vfio/Kconfig               |    6 +
> >  drivers/vfio/Makefile              |    1 +
> >  drivers/vfio/vfio_iommu_fsl_pamu.c |  952
> ++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h          |  100 ++++
> >  4 files changed, 1059 insertions(+), 0 deletions(-)  create mode
> > 100644 drivers/vfio/vfio_iommu_fsl_pamu.c
> >
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig index
> > 26b3d9d..7d1da26 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -8,11 +8,17 @@ config VFIO_IOMMU_SPAPR_TCE
> >  	depends on VFIO && SPAPR_TCE_IOMMU
> >  	default n
> >
> > +config VFIO_IOMMU_FSL_PAMU
> > +	tristate
> > +	depends on VFIO
> > +	default n
> > +
> >  menuconfig VFIO
> >  	tristate "VFIO Non-Privileged userspace driver framework"
> >  	depends on IOMMU_API
> >  	select VFIO_IOMMU_TYPE1 if X86
> >  	select VFIO_IOMMU_SPAPR_TCE if (PPC_POWERNV || PPC_PSERIES)
> > +	select VFIO_IOMMU_FSL_PAMU if FSL_PAMU
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> >  	  See Documentation/vfio.txt for more details.
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile index
> > c5792ec..7461350 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -1,4 +1,5 @@
> >  obj-$(CONFIG_VFIO) += vfio.o
> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_common.o
> > vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_common.o
> > vfio_iommu_spapr_tce.o
> > +obj-$(CONFIG_VFIO_IOMMU_FSL_PAMU) += vfio_iommu_common.o
> > +vfio_iommu_fsl_pamu.o
> >  obj-$(CONFIG_VFIO_PCI) += pci/
> > diff --git a/drivers/vfio/vfio_iommu_fsl_pamu.c
> > b/drivers/vfio/vfio_iommu_fsl_pamu.c
> > new file mode 100644
> > index 0000000..b29365f
> > --- /dev/null
> > +++ b/drivers/vfio/vfio_iommu_fsl_pamu.c
> > @@ -0,0 +1,952 @@
> > +/*
> > + * VFIO: IOMMU DMA mapping support for FSL PAMU IOMMU
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License, version 2,
> > +as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> > + *
> > + * Copyright (C) 2013 Freescale Semiconductor, Inc.
> > + *
> > + *     Author: Bharat Bhushan <bharat.bhushan@freescale.com>
> > + *
> > + * This file is derived from driver/vfio/vfio_iommu_type1.c
> > + *
> > + * The Freescale PAMU is an aperture-based IOMMU with the following
> > + * characteristics.  Each device has an entry in a table in memory
> > + * describing the iova->phys mapping. The mapping has:
> > + *  -an overall aperture that is power of 2 sized, and has a start iova that
> > + *   is naturally aligned
> > + *  -has 1 or more windows within the aperture
> > + *     -number of windows must be power of 2, max is 256
> > + *     -size of each window is determined by aperture size / # of windows
> > + *     -iova of each window is determined by aperture start iova / # of
> windows
> > + *     -the mapped region in each window can be different than
> > + *      the window size...mapping must power of 2
> > + *     -physical address of the mapping must be naturally aligned
> > + *      with the mapping size
> > + */
> > +
> > +#include <linux/compat.h>
> > +#include <linux/device.h>
> > +#include <linux/fs.h>
> > +#include <linux/iommu.h>
> > +#include <linux/module.h>
> > +#include <linux/mm.h>
> > +#include <linux/pci.h>		/* pci_bus_type */
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/vfio.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/hugetlb.h>
> > +#include <linux/msi.h>
> > +#include <asm/fsl_pamu_stash.h>
> > +
> > +#include "vfio_iommu_common.h"
> > +
> > +#define DRIVER_VERSION  "0.1"
> > +#define DRIVER_AUTHOR   "Bharat Bhushan <bharat.bhushan@freescale.com>"
> > +#define DRIVER_DESC     "FSL PAMU IOMMU driver for VFIO"
> > +
> > +struct vfio_iommu {
> > +	struct iommu_domain	*domain;
> > +	struct mutex		lock;
> > +	dma_addr_t		aperture_start;
> > +	dma_addr_t		aperture_end;
> > +	dma_addr_t		page_size;	/* Maximum mapped Page size */
> > +	int			nsubwindows;	/* Number of subwindows */
> > +	struct rb_root		dma_list;
> > +	struct list_head	msi_dma_list;
> > +	struct list_head	group_list;
> > +};
> > +
> > +struct vfio_dma {
> > +	struct rb_node		node;
> > +	dma_addr_t		iova;		/* Device address */
> > +	unsigned long		vaddr;		/* Process virtual addr */
> > +	size_t			size;		/* Number of pages */
> 
> Is this really pages?

Comment is leftover of previous implementation.

> 
> > +	int			prot;		/* IOMMU_READ/WRITE */
> > +};
> > +
> > +struct vfio_msi_dma {
> > +	struct list_head	next;
> > +	dma_addr_t		iova;		/* Device address */
> > +	int			bank_id;
> > +	int			prot;		/* IOMMU_READ/WRITE */
> > +};
> > +
> > +struct vfio_group {
> > +	struct iommu_group	*iommu_group;
> > +	struct list_head	next;
> > +};
> > +
> > +static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
> > +				      dma_addr_t start, size_t size) {
> > +	struct rb_node *node = iommu->dma_list.rb_node;
> > +
> > +	while (node) {
> > +		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
> > +
> > +		if (start + size <= dma->iova)
> > +			node = node->rb_left;
> > +		else if (start >= dma->iova + dma->size)
> 
> because this looks more like it's bytes...
> 
> > +			node = node->rb_right;
> > +		else
> > +			return dma;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void vfio_insert_dma(struct vfio_iommu *iommu, struct vfio_dma
> > +*new) {
> > +	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
> > +	struct vfio_dma *dma;
> > +
> > +	while (*link) {
> > +		parent = *link;
> > +		dma = rb_entry(parent, struct vfio_dma, node);
> > +
> > +		if (new->iova + new->size <= dma->iova)
> 
> so does this...
> 
> > +			link = &(*link)->rb_left;
> > +		else
> > +			link = &(*link)->rb_right;
> > +	}
> > +
> > +	rb_link_node(&new->node, parent, link);
> > +	rb_insert_color(&new->node, &iommu->dma_list); }
> > +
> > +static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma
> > +*old) {
> > +	rb_erase(&old->node, &iommu->dma_list); }
> 
> 
> So if your vfio_dma.size is actually in bytes, why isn't all this code in
> common?

This takes "struct vfio_iommu " which is not same on type1 and fsl_pamu, so I have not done that in first phase.
But yes I completely agree that much more consolidation can be done. I would like to do that in next step.

> 
> > +
> > +static int iova_to_win(struct vfio_iommu *iommu, dma_addr_t iova) {
> > +	u64 offset = iova - iommu->aperture_start;
> > +	do_div(offset, iommu->page_size);
> > +	return (int) offset;
> > +}
> > +
> > +static int vfio_disable_iommu_domain(struct vfio_iommu *iommu) {
> > +	int enable = 0;
> > +	return iommu_domain_set_attr(iommu->domain,
> > +				     DOMAIN_ATTR_FSL_PAMU_ENABLE, &enable); }
> 
> This is never called?!
> 
> > +
> > +static int vfio_enable_iommu_domain(struct vfio_iommu *iommu) {
> > +	int enable = 1;
> > +	return iommu_domain_set_attr(iommu->domain,
> > +				     DOMAIN_ATTR_FSL_PAMU_ENABLE, &enable); }
> > +
> > +/* Unmap DMA region */
> > +static int vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > +			    dma_addr_t iova, size_t *size) {
> > +	dma_addr_t start = iova;
> > +	int win, win_start, win_end;
> > +	long unlocked = 0;
> > +	unsigned int nr_pages;
> > +
> > +	nr_pages = iommu->page_size / PAGE_SIZE;
> > +	win_start = iova_to_win(iommu, iova);
> > +	win_end = iova_to_win(iommu, iova + *size - 1);
> > +
> > +	/* Release the pinned pages */
> > +	for (win = win_start; win <= win_end; iova += iommu->page_size, win++) {
> > +		unsigned long pfn;
> > +
> > +		pfn = iommu_iova_to_phys(iommu->domain, iova) >> PAGE_SHIFT;
> > +		if (!pfn)
> > +			continue;
> > +
> > +		iommu_domain_window_disable(iommu->domain, win);
> > +
> > +		unlocked += vfio_unpin_pages(pfn, nr_pages, dma->prot, 1);
> > +	}
> > +
> > +	vfio_lock_acct(-unlocked);
> > +	*size = iova - start;
> > +	return 0;
> > +}
> > +
> > +static int vfio_remove_dma_overlap(struct vfio_iommu *iommu, dma_addr_t
> start,
> > +				   size_t *size, struct vfio_dma *dma) {
> > +	size_t offset, overlap, tmp;
> > +	struct vfio_dma *split;
> > +	int ret;
> > +
> > +	if (!*size)
> > +		return 0;
> > +
> > +	/*
> > +	 * Existing dma region is completely covered, unmap all.  This is
> > +	 * the likely case since userspace tends to map and unmap buffers
> > +	 * in one shot rather than multiple mappings within a buffer.
> > +	 */
> > +	if (likely(start <= dma->iova &&
> > +		   start + *size >= dma->iova + dma->size)) {
> > +		*size = dma->size;
> > +		ret = vfio_unmap_unpin(iommu, dma, dma->iova, size);
> > +		if (ret)
> > +			return ret;
> > +
> > +		/*
> > +		 * Did we remove more than we have?  Should never happen
> > +		 * since a vfio_dma is contiguous in iova and vaddr.
> > +		 */
> > +		WARN_ON(*size != dma->size);
> > +
> > +		vfio_remove_dma(iommu, dma);
> > +		kfree(dma);
> > +		return 0;
> > +	}
> > +
> > +	/* Overlap low address of existing range */
> > +	if (start <= dma->iova) {
> > +		overlap = start + *size - dma->iova;
> > +		ret = vfio_unmap_unpin(iommu, dma, dma->iova, &overlap);
> > +		if (ret)
> > +			return ret;
> > +
> > +		vfio_remove_dma(iommu, dma);
> > +
> > +		/*
> > +		 * Check, we may have removed to whole vfio_dma.  If not
> > +		 * fixup and re-insert.
> > +		 */
> > +		if (overlap < dma->size) {
> > +			dma->iova += overlap;
> > +			dma->vaddr += overlap;
> > +			dma->size -= overlap;
> > +			vfio_insert_dma(iommu, dma);
> > +		} else
> > +			kfree(dma);
> > +
> > +		*size = overlap;
> > +		return 0;
> > +	}
> > +
> > +	/* Overlap high address of existing range */
> > +	if (start + *size >= dma->iova + dma->size) {
> > +		offset = start - dma->iova;
> > +		overlap = dma->size - offset;
> > +
> > +		ret = vfio_unmap_unpin(iommu, dma, start, &overlap);
> > +		if (ret)
> > +			return ret;
> > +
> > +		dma->size -= overlap;
> > +		*size = overlap;
> > +		return 0;
> > +	}
> > +
> > +	/* Split existing */
> > +
> > +	/*
> > +	 * Allocate our tracking structure early even though it may not
> > +	 * be used.  An Allocation failure later loses track of pages and
> > +	 * is more difficult to unwind.
> > +	 */
> > +	split = kzalloc(sizeof(*split), GFP_KERNEL);
> > +	if (!split)
> > +		return -ENOMEM;
> > +
> > +	offset = start - dma->iova;
> > +
> > +	ret = vfio_unmap_unpin(iommu, dma, start, size);
> > +	if (ret || !*size) {
> > +		kfree(split);
> > +		return ret;
> > +	}
> > +
> > +	tmp = dma->size;
> > +
> > +	/* Resize the lower vfio_dma in place, before the below insert */
> > +	dma->size = offset;
> > +
> > +	/* Insert new for remainder, assuming it didn't all get unmapped */
> > +	if (likely(offset + *size < tmp)) {
> > +		split->size = tmp - offset - *size;
> > +		split->iova = dma->iova + offset + *size;
> > +		split->vaddr = dma->vaddr + offset + *size;
> > +		split->prot = dma->prot;
> > +		vfio_insert_dma(iommu, split);
> > +	} else
> > +		kfree(split);
> > +
> > +	return 0;
> > +}
> 
> Hmm, this looks identical to type1, can we share more?

Yes, as I said this uses " struct vfio_iommu", vfio_unmap_unpin() etc which are different for type1 and fsl_pamu.
In this patchset I only moved the function which are straight forward. But yes I am working on doing more consolidation patches.

> 
> > +
> > +/* Map DMA region */
> > +static int vfio_dma_map(struct vfio_iommu *iommu, dma_addr_t iova,
> > +			  unsigned long vaddr, long npage, int prot) {
> > +	int ret = 0, i;
> > +	size_t size;
> > +	unsigned int win, nr_subwindows;
> > +	dma_addr_t iovamap;
> > +
> > +	/* total size to be mapped */
> > +	size = npage << PAGE_SHIFT;
> > +	do_div(size, iommu->page_size);
> > +	nr_subwindows  = size;
> > +	size = npage << PAGE_SHIFT;
> 
> Is all this do_div() stuff necessary?  If page_size is a power of two, just
> shift it.

Will do

> 
> > +	iovamap = iova;
> > +	for (i = 0; i < nr_subwindows; i++) {
> > +		unsigned long pfn;
> > +		unsigned long nr_pages;
> > +		dma_addr_t mapsize;
> > +		struct vfio_dma *dma = NULL;
> > +
> > +		win = iova_to_win(iommu, iovamap);
> 
> Aren't these consecutive, why can't we just increment?

Yes, will do

> 
> > +		if (iovamap != iommu->aperture_start + iommu->page_size * win) {
> > +			pr_err("%s iova(%llx) unalligned to window size %llx\n",
> > +				__func__, iovamap, iommu->page_size);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> 
> Can't this only happen on the first one?

iova to be mapped in a window must be (iommu->aperture_start + iommu->page_size * win)
But as you pointed out that "win" can incremented iovamap is always incremented by page_size then checking this outside the look can be done. But this is the requirement of our iommu and we should error out if this is not met.

> Seems like it should be outside of the
> loop.  What about alignment with the end of the window, do you care?  Check
> spelling in your warning, but better yet, get rid of it, this doesn't seem like
> something we need to error on.
> 
> > +
> > +		mapsize = min(iova + size - iovamap, iommu->page_size);
> > +		/*
> > +		 * FIXME: Currently we only support mapping page-size
> > +		 * of subwindow-size.
> > +		 */
> > +		if (mapsize < iommu->page_size) {
> > +			pr_err("%s iova (%llx) not alligned to window size %llx\n",
> > +				__func__, iovamap, iommu->page_size);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> 
> So you do care about the end alignment, but why can't we error for both of these
> in advance?

Eventually this should go away, I will remove this :)

> 
> > +
> > +		nr_pages = mapsize >> PAGE_SHIFT;
> > +
> > +		/* Pin a contiguous chunk of memory */
> > +		ret = vfio_pin_pages(vaddr, nr_pages, prot, &pfn);
> > +		if (ret != nr_pages) {
> > +			pr_err("%s unable to pin pages = %lx, pinned(%lx/%lx)\n",
> > +				__func__, vaddr, npage, nr_pages);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> 
> How likely is this to succeed?  It seems like we're relying on userspace to use
> hugepages to make this work.

Yes, userspace will first have hugepages and than calls DMA_MAP()

> 
> > +
> > +		ret = iommu_domain_window_enable(iommu->domain, win,
> > +						 (phys_addr_t)pfn << PAGE_SHIFT,
> > +						 mapsize, prot);
> > +		if (ret) {
> > +			pr_err("%s unable to iommu_map()\n", __func__);
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> 
> You might consider how many cases you're returning EINVAL and think about how
> difficult this will be to debug.  I don't think we can leave all these pr_err()s
> since it gives userspace a trivial way to spam log files.
> 
> > +
> > +		/*
> > +		 * Check if we abut a region below - nothing below 0.
> > +		 * This is the most likely case when mapping chunks of
> > +		 * physically contiguous regions within a virtual address
> > +		 * range.  Update the abutting entry in place since iova
> > +		 * doesn't change.
> > +		 */
> > +		if (likely(iovamap)) {
> > +			struct vfio_dma *tmp;
> > +			tmp = vfio_find_dma(iommu, iovamap - 1, 1);
> > +			if (tmp && tmp->prot == prot &&
> > +			    tmp->vaddr + tmp->size == vaddr) {
> > +				tmp->size += mapsize;
> > +				dma = tmp;
> > +			}
> > +		}
> > +
> > +		/*
> > +		 * Check if we abut a region above - nothing above ~0 + 1.
> > +		 * If we abut above and below, remove and free.  If only
> > +		 * abut above, remove, modify, reinsert.
> > +		 */
> > +		if (likely(iovamap + mapsize)) {
> > +			struct vfio_dma *tmp;
> > +			tmp = vfio_find_dma(iommu, iovamap + mapsize, 1);
> > +			if (tmp && tmp->prot == prot &&
> > +			    tmp->vaddr == vaddr + mapsize) {
> > +				vfio_remove_dma(iommu, tmp);
> > +				if (dma) {
> > +					dma->size += tmp->size;
> > +					kfree(tmp);
> > +				} else {
> > +					tmp->size += mapsize;
> > +					tmp->iova = iovamap;
> > +					tmp->vaddr = vaddr;
> > +					vfio_insert_dma(iommu, tmp);
> > +					dma = tmp;
> > +				}
> > +			}
> > +		}
> > +
> > +		if (!dma) {
> > +			dma = kzalloc(sizeof(*dma), GFP_KERNEL);
> > +			if (!dma) {
> > +				iommu_unmap(iommu->domain, iovamap, mapsize);
> > +				vfio_unpin_pages(pfn, npage, prot, true);
> > +				ret = -ENOMEM;
> > +				break;
> > +			}
> > +
> > +			dma->size = mapsize;
> > +			dma->iova = iovamap;
> > +			dma->vaddr = vaddr;
> > +			dma->prot = prot;
> > +			vfio_insert_dma(iommu, dma);
> > +		}
> > +
> > +		iovamap += mapsize;
> > +		vaddr += mapsize;
> 
> Another chunk that looks like it's probably identical to type1.  Can we rip this
> out to another function and add it to common?

Yes, and same answer :)

> 
> > +	}
> > +
> > +        if (ret) {
> > +                struct vfio_dma *tmp;
> > +                while ((tmp = vfio_find_dma(iommu, iova, size))) {
> > +                        int r = vfio_remove_dma_overlap(iommu, iova,
> > +                                                        &size, tmp);
> > +                        if (WARN_ON(r || !size))
> > +                                break;
> > +                }
> > +        }
> 
> 
> Broken whitespace, please run scripts/checkpatch.pl before posting.
> 
> > +
> > +	vfio_enable_iommu_domain(iommu);
> 
> I don't quite understand your semantics here since you never use the disable
> version, is this just redundant after the first mapping?  When dma_list is empty
> should it be disabled?

Yes, I intended to do that but somehow in final version it is not there :(

>  Is there a bug here that an error will enable the iommu
> domain even if there are no entries?

Will correct this.

> 
> > +	return 0;
> > +}
> > +
> > +static int vfio_dma_do_map(struct vfio_iommu *iommu,
> > +			   struct vfio_iommu_type1_dma_map *map) {
> > +	dma_addr_t iova = map->iova;
> > +	size_t size = map->size;
> > +	unsigned long vaddr = map->vaddr;
> > +	int ret = 0, prot = 0;
> > +	long npage;
> > +
> > +	/* READ/WRITE from device perspective */
> > +	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
> > +		prot |= IOMMU_WRITE;
> > +	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
> > +		prot |= IOMMU_READ;
> > +
> > +	if (!prot)
> > +		return -EINVAL; /* No READ/WRITE? */
> > +
> > +	/* Don't allow IOVA wrap */
> > +	if (iova + size && iova + size < iova)
> > +		return -EINVAL;
> > +
> > +	/* Don't allow virtual address wrap */
> > +	if (vaddr + size && vaddr + size < vaddr)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * FIXME: Currently we only support mapping page-size
> > +	 * of subwindow-size.
> > +	 */
> > +	if (size < iommu->page_size)
> > +		return -EINVAL;
> > +
> 
> I'd think the start and end alignment could be tested here.
> 
> > +	npage = size >> PAGE_SHIFT;
> > +	if (!npage)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&iommu->lock);
> > +
> > +	if (vfio_find_dma(iommu, iova, size)) {
> > +		ret = -EEXIST;
> > +		goto out_lock;
> > +	}
> > +
> > +	vfio_dma_map(iommu, iova, vaddr, npage, prot);
> > +
> > +out_lock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> > +static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> > +			     struct vfio_iommu_type1_dma_unmap *unmap) {
> > +	struct vfio_dma *dma;
> > +	size_t unmapped = 0, size;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&iommu->lock);
> > +
> > +	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
> > +		size = unmap->size;
> > +		ret = vfio_remove_dma_overlap(iommu, unmap->iova, &size, dma);
> > +		if (ret || !size)
> > +			break;
> > +		unmapped += size;
> > +	}
> > +
> > +	mutex_unlock(&iommu->lock);
> > +
> > +	/*
> > +	 * We may unmap more than requested, update the unmap struct so
> > +	 * userspace can know.
> > +	 */
> > +	unmap->size = unmapped;
> > +
> > +	return ret;
> > +}
> > +
> > +static int vfio_handle_get_attr(struct vfio_iommu *iommu,
> > +			 struct vfio_pamu_attr *pamu_attr) {
> > +	switch (pamu_attr->attribute) {
> > +	case VFIO_ATTR_GEOMETRY: {
> > +		struct iommu_domain_geometry geom;
> > +		if (iommu_domain_get_attr(iommu->domain,
> > +				      DOMAIN_ATTR_GEOMETRY, &geom)) {
> > +			pr_err("%s Error getting domain geometry\n",
> > +			       __func__);
> > +			return -EFAULT;
> > +		}
> > +
> > +		pamu_attr->attr_info.attr.aperture_start = geom.aperture_start;
> > +		pamu_attr->attr_info.attr.aperture_end = geom.aperture_end;
> > +		break;
> > +	}
> > +	case VFIO_ATTR_WINDOWS: {
> > +		u32 count;
> > +		if (iommu_domain_get_attr(iommu->domain,
> > +				      DOMAIN_ATTR_WINDOWS, &count)) {
> > +			pr_err("%s Error getting domain windows\n",
> > +			       __func__);
> > +			return -EFAULT;
> > +		}
> > +
> > +		pamu_attr->attr_info.windows = count;
> > +		break;
> > +	}
> > +	case VFIO_ATTR_PAMU_STASH: {
> > +		struct pamu_stash_attribute stash;
> > +		if (iommu_domain_get_attr(iommu->domain,
> > +				      DOMAIN_ATTR_FSL_PAMU_STASH, &stash)) {
> > +			pr_err("%s Error getting domain windows\n",
> > +			       __func__);
> > +			return -EFAULT;
> > +		}
> > +
> > +		pamu_attr->attr_info.stash.cpu = stash.cpu;
> > +		pamu_attr->attr_info.stash.cache = stash.cache;
> > +		break;
> > +	}
> > +
> > +	default:
> > +		pr_err("%s Error: Invalid attribute (%d)\n",
> > +			 __func__, pamu_attr->attribute);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vfio_handle_set_attr(struct vfio_iommu *iommu,
> > +			 struct vfio_pamu_attr *pamu_attr) {
> > +	switch (pamu_attr->attribute) {
> > +	case VFIO_ATTR_GEOMETRY: {
> > +		struct iommu_domain_geometry geom;
> > +
> > +		geom.aperture_start = pamu_attr->attr_info.attr.aperture_start;
> > +		geom.aperture_end = pamu_attr->attr_info.attr.aperture_end;
> > +		iommu->aperture_start = geom.aperture_start;
> > +		iommu->aperture_end = geom.aperture_end;
> > +		geom.force_aperture = 1;
> > +		if (iommu_domain_set_attr(iommu->domain,
> > +					  DOMAIN_ATTR_GEOMETRY, &geom)) {
> > +			pr_err("%s Error setting domain geometry\n", __func__);
> > +			return -EFAULT;
> > +		}
> > +
> > +		break;
> > +	}
> > +	case VFIO_ATTR_WINDOWS: {
> > +		u32 count = pamu_attr->attr_info.windows;
> > +		u64 size;
> > +		if (count > 256) {
> > +			pr_err("Number of subwindows requested (%d) is 256\n",
> > +				count);
> > +			return -EINVAL;
> > +		}
> > +		iommu->nsubwindows = pamu_attr->attr_info.windows;
> > +		size = iommu->aperture_end - iommu->aperture_start + 1;
> > +		do_div(size, count);
> > +		iommu->page_size = size;
> > +		if (iommu_domain_set_attr(iommu->domain,
> > +				      DOMAIN_ATTR_WINDOWS, &count)) {
> > +			pr_err("%s Error getting domain windows\n",
> > +			       __func__);
> > +			return -EFAULT;
> > +		}
> > +
> > +		break;
> > +	}
> > +	case VFIO_ATTR_PAMU_STASH: {
> > +		struct pamu_stash_attribute stash;
> > +
> > +		stash.cpu = pamu_attr->attr_info.stash.cpu;
> > +		stash.cache = pamu_attr->attr_info.stash.cache;
> > +		if (iommu_domain_set_attr(iommu->domain,
> > +				      DOMAIN_ATTR_FSL_PAMU_STASH, &stash)) {
> > +			pr_err("%s Error getting domain windows\n",
> > +			       __func__);
> > +			return -EFAULT;
> > +		}
> > +		break;
> 
> Why do we throw away the return value of iommu_domain_set_attr and replace it
> with EFAULT in all these cases?

Will use the return of iommu_domain_set_attr().

>  I assume all these pr_err()s are leftover
> debug.  Can the user do anything they shouldn't through these?  How do we
> guarantee that?

I will move these to pr_debug()

> 
> > +	}
> > +
> > +	default:
> > +		pr_err("%s Error: Invalid attribute (%d)\n",
> > +			 __func__, pamu_attr->attribute);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vfio_msi_map(struct vfio_iommu *iommu,
> > +			struct vfio_pamu_msi_bank_map *msi_map, int prot) {
> > +	struct msi_region region;
> > +	int window;
> > +	int ret;
> > +
> > +	ret = msi_get_region(msi_map->msi_bank_index, &region);
> > +	if (ret) {
> > +		pr_err("%s MSI region (%d) not found\n", __func__,
> > +		       msi_map->msi_bank_index);
> > +		return ret;
> > +	}
> > +
> > +	window = iova_to_win(iommu, msi_map->iova);
> > +	ret = iommu_domain_window_enable(iommu->domain, window, region.addr,
> > +					 region.size, prot);
> > +	if (ret) {
> > +		pr_err("%s Error: unable to map msi region\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vfio_do_msi_map(struct vfio_iommu *iommu,
> > +			struct vfio_pamu_msi_bank_map *msi_map) {
> > +	struct vfio_msi_dma *msi_dma;
> > +	int ret, prot = 0;
> > +
> > +	/* READ/WRITE from device perspective */
> > +	if (msi_map->flags & VFIO_DMA_MAP_FLAG_WRITE)
> > +		prot |= IOMMU_WRITE;
> > +	if (msi_map->flags & VFIO_DMA_MAP_FLAG_READ)
> > +		prot |= IOMMU_READ;
> > +
> > +	if (!prot)
> > +		return -EINVAL; /* No READ/WRITE? */
> > +
> > +	ret = vfio_msi_map(iommu, msi_map, prot);
> > +	if (ret)
> > +		return ret;
> > +
> > +	msi_dma = kzalloc(sizeof(*msi_dma), GFP_KERNEL);
> > +	if (!msi_dma)
> > +		return -ENOMEM;
> > +
> > +	msi_dma->iova = msi_map->iova;
> > +	msi_dma->bank_id = msi_map->msi_bank_index;
> > +	list_add(&msi_dma->next, &iommu->msi_dma_list);
> > +	return 0;
> 
> What happens when the user creates multiple MSI mappings at the same iova?  What
> happens when DMA mappings overlap MSI mappings?

Good point, will correct this.

>  Shouldn't there be some locking
> around list manipulation?

Yes, will correct this as well.

Thanks
-Bharat

> 
> > +}
> > +
> > +static void vfio_msi_unmap(struct vfio_iommu *iommu, dma_addr_t iova)
> > +{
> > +	int window;
> > +	window = iova_to_win(iommu, iova);
> > +	iommu_domain_window_disable(iommu->domain, window); }
> > +
> > +static int vfio_do_msi_unmap(struct vfio_iommu *iommu,
> > +			     struct vfio_pamu_msi_bank_unmap *msi_unmap) {
> > +	struct vfio_msi_dma *mdma, *mdma_tmp;
> > +
> > +	list_for_each_entry_safe(mdma, mdma_tmp, &iommu->msi_dma_list, next) {
> > +		if (mdma->iova == msi_unmap->iova) {
> > +			vfio_msi_unmap(iommu, mdma->iova);
> > +			list_del(&mdma->next);
> > +			kfree(mdma);
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +static void *vfio_iommu_fsl_pamu_open(unsigned long arg) {
> > +	struct vfio_iommu *iommu;
> > +
> > +	if (arg != VFIO_FSL_PAMU_IOMMU)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
> > +	if (!iommu)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	INIT_LIST_HEAD(&iommu->group_list);
> > +	iommu->dma_list = RB_ROOT;
> > +	INIT_LIST_HEAD(&iommu->msi_dma_list);
> > +	mutex_init(&iommu->lock);
> > +
> > +	/*
> > +	 * Wish we didn't have to know about bus_type here.
> > +	 */
> > +	iommu->domain = iommu_domain_alloc(&pci_bus_type);
> > +	if (!iommu->domain) {
> > +		kfree(iommu);
> > +		return ERR_PTR(-EIO);
> > +	}
> > +
> > +	return iommu;
> > +}
> > +
> > +static void vfio_iommu_fsl_pamu_release(void *iommu_data) {
> > +	struct vfio_iommu *iommu = iommu_data;
> > +	struct vfio_group *group, *group_tmp;
> > +	struct vfio_msi_dma *mdma, *mdma_tmp;
> > +	struct rb_node *node;
> > +
> > +	list_for_each_entry_safe(group, group_tmp, &iommu->group_list, next) {
> > +		iommu_detach_group(iommu->domain, group->iommu_group);
> > +		list_del(&group->next);
> > +		kfree(group);
> > +	}
> > +
> > +	while ((node = rb_first(&iommu->dma_list))) {
> > +		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
> > +		size_t size = dma->size;
> > +		vfio_remove_dma_overlap(iommu, dma->iova, &size, dma);
> > +		if (WARN_ON(!size))
> > +			break;
> > +	}
> > +
> > +	list_for_each_entry_safe(mdma, mdma_tmp, &iommu->msi_dma_list, next) {
> > +		vfio_msi_unmap(iommu, mdma->iova);
> > +		list_del(&mdma->next);
> > +		kfree(mdma);
> > +	}
> > +
> > +	iommu_domain_free(iommu->domain);
> > +	iommu->domain = NULL;
> > +	kfree(iommu);
> > +}
> > +
> > +static long vfio_iommu_fsl_pamu_ioctl(void *iommu_data,
> > +				   unsigned int cmd, unsigned long arg) {
> > +	struct vfio_iommu *iommu = iommu_data;
> > +	unsigned long minsz;
> > +
> > +	if (cmd == VFIO_CHECK_EXTENSION) {
> > +		switch (arg) {
> > +		case VFIO_FSL_PAMU_IOMMU:
> > +			return 1;
> > +		default:
> > +			return 0;
> > +		}
> > +	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
> > +		struct vfio_iommu_type1_dma_map map;
> > +		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
> > +				VFIO_DMA_MAP_FLAG_WRITE;
> > +
> > +		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
> > +
> > +		if (copy_from_user(&map, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (map.argsz < minsz || map.flags & ~mask)
> > +			return -EINVAL;
> > +
> > +		return vfio_dma_do_map(iommu, &map);
> > +
> > +	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
> > +		struct vfio_iommu_type1_dma_unmap unmap;
> > +		long ret;
> > +
> > +		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
> > +
> > +		if (copy_from_user(&unmap, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (unmap.argsz < minsz || unmap.flags)
> > +			return -EINVAL;
> > +
> > +		ret = vfio_dma_do_unmap(iommu, &unmap);
> > +		if (ret)
> > +			return ret;
> > +
> > +		return copy_to_user((void __user *)arg, &unmap, minsz);
> > +	} else if (cmd == VFIO_IOMMU_PAMU_GET_ATTR) {
> > +		struct vfio_pamu_attr pamu_attr;
> > +
> > +		minsz = offsetofend(struct vfio_pamu_attr, attr_info);
> > +		if (copy_from_user(&pamu_attr, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (pamu_attr.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		vfio_handle_get_attr(iommu, &pamu_attr);
> > +
> > +		copy_to_user((void __user *)arg, &pamu_attr, minsz);
> > +		return 0;
> > +	} else if (cmd == VFIO_IOMMU_PAMU_SET_ATTR) {
> > +		struct vfio_pamu_attr pamu_attr;
> > +
> > +		minsz = offsetofend(struct vfio_pamu_attr, attr_info);
> > +		if (copy_from_user(&pamu_attr, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (pamu_attr.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		vfio_handle_set_attr(iommu, &pamu_attr);
> > +		return 0;
> > +	} else if (cmd == VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT) {
> > +		return msi_get_region_count();
> > +	} else if (cmd == VFIO_IOMMU_PAMU_MAP_MSI_BANK) {
> > +		struct vfio_pamu_msi_bank_map msi_map;
> > +
> > +		minsz = offsetofend(struct vfio_pamu_msi_bank_map, iova);
> > +		if (copy_from_user(&msi_map, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (msi_map.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		vfio_do_msi_map(iommu, &msi_map);
> > +		return 0;
> > +	} else if (cmd == VFIO_IOMMU_PAMU_UNMAP_MSI_BANK) {
> > +		struct vfio_pamu_msi_bank_unmap msi_unmap;
> > +
> > +		minsz = offsetofend(struct vfio_pamu_msi_bank_unmap, iova);
> > +		if (copy_from_user(&msi_unmap, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (msi_unmap.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		vfio_do_msi_unmap(iommu, &msi_unmap);
> > +		return 0;
> > +
> > +	}
> > +
> > +	return -ENOTTY;
> > +}
> > +
> > +static int vfio_iommu_fsl_pamu_attach_group(void *iommu_data,
> > +					 struct iommu_group *iommu_group) {
> > +	struct vfio_iommu *iommu = iommu_data;
> > +	struct vfio_group *group, *tmp;
> > +	int ret;
> > +
> > +	group = kzalloc(sizeof(*group), GFP_KERNEL);
> > +	if (!group)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&iommu->lock);
> > +
> > +	list_for_each_entry(tmp, &iommu->group_list, next) {
> > +		if (tmp->iommu_group == iommu_group) {
> > +			mutex_unlock(&iommu->lock);
> > +			kfree(group);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	ret = iommu_attach_group(iommu->domain, iommu_group);
> > +	if (ret) {
> > +		mutex_unlock(&iommu->lock);
> > +		kfree(group);
> > +		return ret;
> > +	}
> > +
> > +	group->iommu_group = iommu_group;
> > +	list_add(&group->next, &iommu->group_list);
> > +
> > +	mutex_unlock(&iommu->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static void vfio_iommu_fsl_pamu_detach_group(void *iommu_data,
> > +					  struct iommu_group *iommu_group) {
> > +	struct vfio_iommu *iommu = iommu_data;
> > +	struct vfio_group *group;
> > +
> > +	mutex_lock(&iommu->lock);
> > +
> > +	list_for_each_entry(group, &iommu->group_list, next) {
> > +		if (group->iommu_group == iommu_group) {
> > +			iommu_detach_group(iommu->domain, iommu_group);
> > +			list_del(&group->next);
> > +			kfree(group);
> > +			break;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&iommu->lock);
> > +}
> > +
> > +static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_fsl_pamu = {
> > +	.name		= "vfio-iommu-fsl_pamu",
> > +	.owner		= THIS_MODULE,
> > +	.open		= vfio_iommu_fsl_pamu_open,
> > +	.release	= vfio_iommu_fsl_pamu_release,
> > +	.ioctl		= vfio_iommu_fsl_pamu_ioctl,
> > +	.attach_group	= vfio_iommu_fsl_pamu_attach_group,
> > +	.detach_group	= vfio_iommu_fsl_pamu_detach_group,
> > +};
> > +
> > +static int __init vfio_iommu_fsl_pamu_init(void) {
> > +	if (!iommu_present(&pci_bus_type))
> > +		return -ENODEV;
> > +
> > +	return vfio_register_iommu_driver(&vfio_iommu_driver_ops_fsl_pamu);
> > +}
> > +
> > +static void __exit vfio_iommu_fsl_pamu_cleanup(void) {
> > +	vfio_unregister_iommu_driver(&vfio_iommu_driver_ops_fsl_pamu);
> > +}
> > +
> > +module_init(vfio_iommu_fsl_pamu_init);
> > +module_exit(vfio_iommu_fsl_pamu_cleanup);
> > +
> > +MODULE_VERSION(DRIVER_VERSION);
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR(DRIVER_AUTHOR);
> > +MODULE_DESCRIPTION(DRIVER_DESC);
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 0fd47f5..d359055 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -23,6 +23,7 @@
> >
> >  #define VFIO_TYPE1_IOMMU		1
> >  #define VFIO_SPAPR_TCE_IOMMU		2
> > +#define VFIO_FSL_PAMU_IOMMU		3
> >
> >  /*
> >   * The IOCTL interface is designed for extensibility by embedding the
> > @@ -451,4 +452,103 @@ struct vfio_iommu_spapr_tce_info {
> >
> >  /* *****************************************************************
> > */
> >
> > +/*********** APIs for VFIO_PAMU type only ****************/
> > +/*
> > + * VFIO_IOMMU_PAMU_GET_ATTR - _IO(VFIO_TYPE, VFIO_BASE + 17,
> > + *				  struct vfio_pamu_attr)
> > + *
> > + * Gets the iommu attributes for the current vfio container.
> > + * Caller sets argsz and attribute.  The ioctl fills in
> > + * the provided struct vfio_pamu_attr based on the attribute
> > + * value that was set.
> > + * Return: 0 on success, -errno on failure  */ struct vfio_pamu_attr
> > +{
> > +	__u32	argsz;
> > +	__u32	flags;	/* no flags currently */
> > +#define VFIO_ATTR_GEOMETRY	0
> > +#define VFIO_ATTR_WINDOWS	1
> > +#define VFIO_ATTR_PAMU_STASH	2
> > +	__u32	attribute;
> > +
> > +	union {
> > +		/* VFIO_ATTR_GEOMETRY */
> > +		struct {
> > +			/* first addr that can be mapped */
> > +			__u64 aperture_start;
> > +			/* last addr that can be mapped */
> > +			__u64 aperture_end;
> > +		} attr;
> > +
> > +		/* VFIO_ATTR_WINDOWS */
> > +		__u32 windows;  /* number of windows in the aperture
> > +				 * initially this will be the max number
> > +				 * of windows that can be set
> > +				 */
> > +		/* VFIO_ATTR_PAMU_STASH */
> > +		struct {
> > +			__u32 cpu;	/* CPU number for stashing */
> > +			__u32 cache;	/* cache ID for stashing */
> > +		} stash;
> > +	} attr_info;
> > +};
> > +#define VFIO_IOMMU_PAMU_GET_ATTR  _IO(VFIO_TYPE, VFIO_BASE + 17)
> > +
> > +/*
> > + * VFIO_IOMMU_PAMU_SET_ATTR - _IO(VFIO_TYPE, VFIO_BASE + 18,
> > + *				  struct vfio_pamu_attr)
> > + *
> > + * Sets the iommu attributes for the current vfio container.
> > + * Caller sets struct vfio_pamu attr, including argsz and attribute
> > +and
> > + * setting any fields that are valid for the attribute.
> > + * Return: 0 on success, -errno on failure  */ #define
> > +VFIO_IOMMU_PAMU_SET_ATTR  _IO(VFIO_TYPE, VFIO_BASE + 18)
> > +
> > +/*
> > + * VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT - _IO(VFIO_TYPE, VFIO_BASE +
> > +19, __u32)
> > + *
> > + * Returns the number of MSI banks for this platform.  This tells
> > +user space
> > + * how many aperture windows should be reserved for MSI banks when
> > +setting
> > + * the PAMU geometry and window count.
> > + * Return: __u32 bank count on success, -errno on failure  */ #define
> > +VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT _IO(VFIO_TYPE, VFIO_BASE + 19)
> > +
> > +/*
> > + * VFIO_IOMMU_PAMU_MAP_MSI_BANK - _IO(VFIO_TYPE, VFIO_BASE + 20,
> > + *				      struct vfio_pamu_msi_bank_map)
> > + *
> > + * Maps the MSI bank at the specified index and iova.  User space
> > +must
> > + * call this ioctl once for each MSI bank (count of banks is returned
> > +by
> > + * VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT).
> > + * Caller provides struct vfio_pamu_msi_bank_map with all fields set.
> > + * Return: 0 on success, -errno on failure  */
> > +
> > +struct vfio_pamu_msi_bank_map {
> > +	__u32	argsz;
> > +	__u32	flags;		/* no flags currently */
> > +	__u32	msi_bank_index;	/* the index of the MSI bank */
> > +	__u64	iova;		/* the iova the bank is to be mapped to */
> > +};
> > +#define VFIO_IOMMU_PAMU_MAP_MSI_BANK  _IO(VFIO_TYPE, VFIO_BASE + 20)
> > +
> > +/*
> > + * VFIO_IOMMU_PAMU_UNMAP_MSI_BANK - _IO(VFIO_TYPE, VFIO_BASE + 21,
> > + *					struct vfio_pamu_msi_bank_unmap)
> > + *
> > + * Unmaps the MSI bank at the specified iova.
> > + * Caller provides struct vfio_pamu_msi_bank_unmap with all fields set.
> > + * Operates on VFIO file descriptor (/dev/vfio/vfio).
> > + * Return: 0 on success, -errno on failure  */
> > +
> > +struct vfio_pamu_msi_bank_unmap {
> > +	__u32	argsz;
> > +	__u32	flags;	/* no flags currently */
> > +	__u64	iova;	/* the iova to be unmapped to */
> > +};
> > +#define VFIO_IOMMU_PAMU_UNMAP_MSI_BANK  _IO(VFIO_TYPE, VFIO_BASE +
> > +21)
> > +
> >  #endif /* _UAPIVFIO_H */
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
