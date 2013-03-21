Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3CUDQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab3CUDQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:16:33 -0400
Message-ID: <1363835784.24132.574.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: implement IOMMU driver for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 21:16:24 -0600
In-Reply-To: <20130321015541.GA13838@truffula.fritz.box>
References: <1363660844.24132.452.camel@bling.home>
	 <1363676892-3891-1-git-send-email-aik@ozlabs.ru>
	 <1363812324.24132.544.camel@bling.home>
	 <20130321015541.GA13838@truffula.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 12:55 +1100, David Gibson wrote:
> On Wed, Mar 20, 2013 at 02:45:24PM -0600, Alex Williamson wrote:
> > On Tue, 2013-03-19 at 18:08 +1100, Alexey Kardashevskiy wrote:
> > > VFIO implements platform independent stuff such as
> > > a PCI driver, BAR access (via read/write on a file descriptor
> > > or direct mapping when possible) and IRQ signaling.
> > > 
> > > The platform dependent part includes IOMMU initialization
> > > and handling. This patch implements an IOMMU driver for VFIO
> > > which does mapping/unmapping pages for the guest IO and
> > > provides information about DMA window (required by a POWERPC
> > > guest).
> > > 
> > > The counterpart in QEMU is required to support this functionality.
> > > 
> > > Changelog:
> > > * documentation updated
> > > * containter enable/disable ioctls added
> > > * request_module(spapr_iommu) added
> > > * various locks fixed
> > > 
> > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > > ---
> > 
> > 
> > Looking pretty good.  There's one problem with the detach_group,
> > otherwise just some trivial comments below.  What's the status of the
> > tce code that this depends on?  Thanks,
> 
> [snip]
> > > +static void tce_iommu_detach_group(void *iommu_data,
> > > +		struct iommu_group *iommu_group)
> > > +{
> > > +	struct tce_container *container = iommu_data;
> > > +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> > > +
> > > +	BUG_ON(!tbl);
> > > +	mutex_lock(&container->lock);
> > > +	if (tbl != container->tbl) {
> > > +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
> > > +				iommu_group_id(iommu_group),
> > > +				iommu_group_id(tbl->it_group));
> > > +	} else if (container->enabled) {
> > > +		pr_err("tce_vfio: detaching group #%u from enabled container\n",
> > > +				iommu_group_id(tbl->it_group));
> > 
> > Hmm, something more than a pr_err needs to happen here.  Wouldn't this
> > imply a disable and going back to an unprivileged container?
> 
> Uh, no.  I think the idea here is that we use the enable/disable
> semantic to address some other potential problems.  Specifically,
> sidestepping the problems of what happens if you change the
> container's capabilities by adding/removing groups while in the middle
> of using it.  So the point is that the detach fails when the group is
> enabled, rather than implicitly doing anything.

The function returns void.  We're not failing the detach, just getting
into a broken state.  This is only called to unwind attaching groups
when the iommu is set or if the user explicitly calls
GROUP_UNSET_CONTAINER.  The former won't have had a chance to call
enable but the latter would need to be fixed.  Thanks,

Alex

