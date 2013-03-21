Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3CUB35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3CUB3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:29:54 -0400
Message-ID: <1363829387.24132.559.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: implement IOMMU driver for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 19:29:47 -0600
In-Reply-To: <514A5AED.1050405@ozlabs.ru>
References: <1363660844.24132.452.camel@bling.home>
	  <1363676892-3891-1-git-send-email-aik@ozlabs.ru>
	 <1363812324.24132.544.camel@bling.home> <514A5AED.1050405@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 11:57 +1100, Alexey Kardashevskiy wrote:
> On 21/03/13 07:45, Alex Williamson wrote:
> > On Tue, 2013-03-19 at 18:08 +1100, Alexey Kardashevskiy wrote:
> >> VFIO implements platform independent stuff such as
> >> a PCI driver, BAR access (via read/write on a file descriptor
> >> or direct mapping when possible) and IRQ signaling.
> >>
> >> The platform dependent part includes IOMMU initialization
> >> and handling. This patch implements an IOMMU driver for VFIO
> >> which does mapping/unmapping pages for the guest IO and
> >> provides information about DMA window (required by a POWERPC
> >> guest).
> >>
> >> The counterpart in QEMU is required to support this functionality.
> >>
> >> Changelog:
> >> * documentation updated
> >> * containter enable/disable ioctls added
> >> * request_module(spapr_iommu) added
> >> * various locks fixed
> >>
> >> Cc: David Gibson <david@gibson.dropbear.id.au>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> ---
> >
> >
> > Looking pretty good.  There's one problem with the detach_group,
> > otherwise just some trivial comments below.  What's the status of the
> > tce code that this depends on?  Thanks,
> 
> 
> It is done, I am just waiting till other patches of the series will be 
> reviewed (by guys) and fixed (by me) and then I'll post everything again.
> 
> [skipped]
> 
> >> +static int tce_iommu_enable(struct tce_container *container)
> >> +{
> >> +	int ret = 0;
> >> +	unsigned long locked, lock_limit, npages;
> >> +	struct iommu_table *tbl = container->tbl;
> >> +
> >> +	if (!container->tbl)
> >> +		return -ENXIO;
> >> +
> >> +	if (!current->mm)
> >> +		return -ESRCH; /* process exited */
> >> +
> >> +	mutex_lock(&container->lock);
> >> +	if (container->enabled) {
> >> +		mutex_unlock(&container->lock);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Accounting for locked pages.
> >> +	 *
> >> +	 * On sPAPR platform, IOMMU translation table contains
> >> +	 * an entry per 4K page. Every map/unmap request is sent
> >> +	 * by the guest via hypercall and supposed to be handled
> >> +	 * quickly, ecpesially in real mode (if such option is
> >
> > s/ecpesially/especially/
> 
> 
> I replaced the whole text by the one written by Ben and David.
> 
> [skipped]
> 
> >> +	}
> >> +
> >> +	return -ENOTTY;
> >> +}
> >> +
> >> +static int tce_iommu_attach_group(void *iommu_data,
> >> +		struct iommu_group *iommu_group)
> >> +{
> >> +	int ret;
> >> +	struct tce_container *container = iommu_data;
> >> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> >> +
> >> +	BUG_ON(!tbl);
> >> +	mutex_lock(&container->lock);
> >> +	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
> >> +			iommu_group_id(iommu_group), iommu_group);
> >> +	if (container->tbl) {
> >> +		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
> >> +				iommu_group_id(container->tbl->it_group),
> >> +				iommu_group_id(iommu_group));
> >> +		mutex_unlock(&container->lock);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	ret = iommu_take_ownership(tbl);
> >> +	if (!ret)
> >> +		container->tbl = tbl;
> >> +
> >> +	mutex_unlock(&container->lock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void tce_iommu_detach_group(void *iommu_data,
> >> +		struct iommu_group *iommu_group)
> >> +{
> >> +	struct tce_container *container = iommu_data;
> >> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> >> +
> >> +	BUG_ON(!tbl);
> >> +	mutex_lock(&container->lock);
> >> +	if (tbl != container->tbl) {
> >> +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
> >> +				iommu_group_id(iommu_group),
> >> +				iommu_group_id(tbl->it_group));
> >> +	} else if (container->enabled) {
> >> +		pr_err("tce_vfio: detaching group #%u from enabled container\n",
> >> +				iommu_group_id(tbl->it_group));
> >
> > Hmm, something more than a pr_err needs to happen here.  Wouldn't this
> > imply a disable and going back to an unprivileged container?
> 
> Ah. It does not return error code... Then something like that?
> 
> ...
>           } else if (container->enabled) {
>                   pr_warn("tce_vfio: detaching group #%u from enabled 
> container, forcing disable\n",
>                                   iommu_group_id(tbl->it_group));
>                   tce_iommu_disable(container);
> ...

Yep, but of course it also needs to fall through and set tbl = NULL and
release ownership as well.  BTW, don't you think the pr_debug in that
path is a little excessive?  Likewise the one in the attach path.
Thanks,

Alex


