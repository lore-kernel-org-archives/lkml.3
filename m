Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761872Ab3DDPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761409Ab3DDPW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:22:26 -0400
Message-ID: <1365088930.2882.296.camel@bling.home>
Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
From: Alex Williamson <alex.williamson@redhat.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Joerg Roedel <joro@8bytes.org>, Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Date: Thu, 04 Apr 2013 09:22:10 -0600
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D45883B@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
	 <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
	 <20130402161812.GI15687@8bytes.org> <1365012091.2882.252.camel@bling.home>
	 <C5ECD7A89D1DC44195F34B25E172658D45883B@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 13:00 +0000, Sethi Varun-B16395 wrote:
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Wednesday, April 03, 2013 11:32 PM
> > To: Joerg Roedel
> > Cc: Sethi Varun-B16395; Yoder Stuart-B08248; Wood Scott-B07421;
> > iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> > kernel@vger.kernel.org; galak@kernel.crashing.org;
> > benh@kernel.crashing.org
> > Subject: Re: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
> > implementation.
> > 
> > On Tue, 2013-04-02 at 18:18 +0200, Joerg Roedel wrote:
> > > Cc'ing Alex Williamson
> > >
> > > Alex, can you please review the iommu-group part of this patch?
> > 
> > Sure, it looks pretty reasonable.  AIUI, all PCI devices are below some
> > kind of host bridge that is either new and supports partitioning or old
> > and doesn't.  I don't know if that's a visibility or isolation
> > requirement, perhaps PCI ACS-ish.  In the new host bridge case, each
> > device gets a group.  This seems not to have any quirks for multifunction
> > devices though.  On AMD and Intel IOMMUs we test multifunction device ACS
> > support to determine whether all the functions should be in the same
> > group.  Is there any reason to trust multifunction devices on PAMU?
> > 
> [Sethi Varun-B16395] In the case where we can partition endpoints we
> can distinguish transactions based on the bus,device,function number
> combination. This support is available in the PCIe controller (host
> bridge).

So can x86 IOMMUs, that's the visibility aspect of IOMMU groups.
Visibility alone doesn't necessarily imply that a device is isolated
though.  A multifunction PCI device that doesn't expose ACS support may
not isolate functions from each other.  For example a peer-to-peer DMA
between functions may not be translated by the upstream IOMMU.  IOMMU
groups should encompass both visibility and isolation.

> > I also find it curious what happens to the iommu group of the host
> > bridge.  In the partitionable case the host bridge group is removed, in
> > the non-partitionable case the host bridge group becomes the group for
> > the children, removing the host bridge.  It's unique to PAMU so far that
> > these host bridges are even in an iommu group (x86 only adds pci
> > devices), but I don't see it as necessarily wrong leaving it in either
> > scenario.  Does it solve some problem to remove them from the groups?
> > Thanks,
> [Sethi Varun-B16395] The PCIe controller isn't a partitionable entity,
> it would always be owned by the host.

Ownership of a device shouldn't play into the group context.  An IOMMU
group should be defined by it's visibility and isolation from other
devices.  Whether the PCIe controller is allowed to be handed to
userspace is a question for VFIO.  Thanks,

Alex

