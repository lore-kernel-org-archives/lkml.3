Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaEPDz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 23:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbaEPDzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 23:55:25 -0400
Message-ID: <1400212520.3289.156.camel@ul30vt.home>
Subject: Re: [PATCH v2 00/15] PCI/iommu: Fix DMA alias problems
From: Alex Williamson <alex.williamson@redhat.com>
To: Andrew Cooks <acooks@gmail.com>
Cc: "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 15 May 2014 21:55:20 -0600
In-Reply-To: <CAJtEV7ZETiGMpPhR=drGArMyqpnGFZoR3CkKEELApP+86=Oyfw@mail.gmail.com>
References: <20140509151735.8321.22017.stgit@bling.home>
	 <CAJtEV7YYB4W_+nZeMgiqZVDV+M4OyFJVBic09z=KbMjOpihnTQ@mail.gmail.com>
	 <1400175834.3289.65.camel@ul30vt.home>
	 <CAJtEV7ZETiGMpPhR=drGArMyqpnGFZoR3CkKEELApP+86=Oyfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 07:45 +0800, Andrew Cooks wrote:
> Hi Alex
> 
> On Fri, May 16, 2014 at 1:43 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Thu, 2014-05-15 at 07:40 +0800, Andrew Cooks wrote:
> >> Hi Alex
> >>
> >> On Fri, May 9, 2014 at 11:28 PM, Alex Williamson
> >> <alex.williamson@redhat.com> wrote:
> >> > ....
> >> >
> >> > Original description:
> >> >
> >> > This series attempts to fix a couple issues we've had outstanding in
> >> > the PCI/IOMMU code for a while.  The first issue is with devices that
> >> > use the wrong requester ID for DMA transactions.  We already have a
> >> > sort of half-baked attempt to fix this for several Ricoh devices, but
> >> > the fix only helps them be useful through IOMMU groups, not the
> >> > general DMA case.  There are also several Marvell devices which use
> >> > use a different wrong requester ID and don't even fit into the DMA
> >> > source idea.  This series creates a DMA alias iterator that will
> >> > step through each possible alias of a device, allowing IOMMUs to
> >> > insert mappings for both the device and its aliases.
> >> >
> >> > Hand-in-hand with this is our broken pci_find_upstream_pcie_bridge()
> >> > function, which is known to blowup when it finds itself suddenly at
> >> > a PCIe device without crossing a PCIe-to-PCI bridge (as identified by
> >> > the PCIe capability).  It also likes to make the invalid assumption
> >> > that a PCIe device never has its requester ID masked by any usptream
> >> > bus.  We can fix this using the above new DMA alias iterator, since
> >> > that's effectively what this function was meant to do.
> >> >
> >>
> >> There are two cases where the DMA requester id seems to use the wrong
> >> slot (as opposed to function) in the patch I attached to
> >> https://bugzilla.kernel.org/show_bug.cgi?id=42679
> >> The original bug reports are listed in the patch.
> >>
> >> Unfortunately, I wasn't able to get test feedback on those two cases,
> >> but I'm wondering...
> >> Did I understand correctly that a slot alias is something that could be needed?
> >> If so, is it a variation of the PCIe-to-PCI bridge case that's already
> >> covered or will it require a different approach?
> >
> > Wow, I didn't think that kind of broken was possible.  Maybe instead of
> > a bitmap of function aliases we could have a single devfn alias for a
> > device.  That means we'd only be able to support a single alias for a
> > device, but since I don't think we've seen devices that use more than a
> > single alias, maybe that's ok.
> 
> The current patch creates a context entry for the reported device
> (function 0), plus it's alias (function 1). Is there reason to always
> add a context entry for the reported devfn and define 'alias' to mean
> 'one additional devfn'? That will work for all the Marvell cases.

Right, that's effectively what it would become, probably making use of a
flag bit to indicate whether the alias devfn is valid.  The
pci_for_each_dma_alias() would just drop the loop over the
dma_alias_funcs bitmap at replace it with a test of the flag and single
dma alias devfn.  I need to think about whether the IOMMU group code can
is such a simple replacement.

I think it makes sense to always include both the actual devfn and, if
it exists, an alias devfn.  Otherwise we'd just end up with more quirks
to add later.

> In the testing I did, the Marvell controllers needed context entries
> for both function 0 and 1. It would be nice if someone could confirm
> or debunk this. I tested with a 88SE9172 with both ports of the
> controller in use.

I think 0 needs to be quirked to 1, but I don't think 1 needs to be
quirked to 0.  Unfortunately intel-iommu doesn't do any of the reference
counting that amd_iommu does, so if we have 0 aliased to 1 and we unbind
function 0 from the driver, intel-iommu will also teardown the mapping
for function 1.  It's horrible.  That's a problem beyond what I'm trying
to do here though, it already exists if you have two devices behind a
PCIe-to-PCI bridge.  Thanks,

Alex

