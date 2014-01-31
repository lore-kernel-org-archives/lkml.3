Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaAaXZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:25:52 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58006 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaAaXZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:25:50 -0500
Date: Fri, 31 Jan 2014 16:25:47 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pci/quirks: Enable quirks for PCIe ACS on Intel PCH
 root ports
Message-ID: <20140131232547.GA12318@google.com>
References: <20140120215502.29567.11291.stgit@bling.home>
 <20140120220152.29567.3645.stgit@bling.home>
 <20140131192620.GB8834@google.com>
 <1391198773.6959.133.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391198773.6959.133.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 01:06:13PM -0700, Alex Williamson wrote:
> On Fri, 2014-01-31 at 12:26 -0700, Bjorn Helgaas wrote:
> > On Mon, Jan 20, 2014 at 03:01:52PM -0700, Alex Williamson wrote:

> > > +/*
> > > + * Many Intel PCH root ports do provide ACS-like features to disable peer
> > > + * transactions and validate bus numbers in requests, but do not provide an
> > > + * actual PCIe ACS capability.  This is the list of device IDs known to fall
> > > + * into that category as provided by Intel in Red Hat bugzilla 1037684.
> > 
> > Is there any documentation for this?  I'd feel better if we had a public
> > statement from Intel that "these devices support ACS and this is how you do
> > it."  The standard PCIe ACS capability is an explicit statement that the
> > vendor intends to support the feature as documented in the spec.  If we put
> > in undocumented quirks, we may end up relying on something the vendor has
> > not qualified and does not intend to actually support.
> 
> I've tried to get a public document, but the bz list is the best I've
> been able to achieve and the best I expect to happen.
> 
> > I see the device ID list in the RH bugzilla, of course, but I don't see the
> > name of anybody in Intel who stands behind the list and the knobs used in
> > this patch.  I expect you'll remind me that we don't have any better
> > documentation for 15b100dfd1c9 ("PCI: Claim ACS support for AMD southbridge
> > devices"), which is true.  Mea culpa.
> 
> The list in the bz is actually posted by an Intel partner, for whatever
> reason using their redhat.com login rather than intel.com.  FWIW, I
> agree 100% that I would prefer the list and procedure where public
> documents, those who have been part of the process can attest to how
> hard we've pushed for that, unfortunately this is what we have.

Heh, I saw "Don Dugger," but for some reason I read "Don Dutile" :)  I
wonder if you could get him (Don Dugger) to ack this patch?

Absent that, and maybe even *with* that, I'd like some sort of dmesg note
about enabling undocumented ACS-like features.  I'm not happy with Linux
claiming to support something that the vendor isn't willing to stand
behind, especially a security-related thing like this.

> > > +static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
> > > +{
> > > +	if (!pci_quirk_intel_pch_acs_match(dev))
> > > +		return -ENOTTY;
> > > +
> > > +	if (atomic_read(&intel_pch_acs_quirk_status) < 0)
> > > +		return 0;
> > > +
> > > +	if (pci_quirk_enable_intel_lpc_acs(dev)) {
> > > +		dev_warn(&dev->dev, "Failed to enable Intel PCH ACS quirk\n");
> > > +		atomic_set(&intel_pch_acs_quirk_status, -1);
> > 
> > This means we handle hot-added Root Ports differently than those present at
> > boot.  If the system supports ACS, then we hot-add a Root Port that doesn't
> > support ACS, then remove it, I think the system (with original
> > configuration) no longer supports ACS.
> 
> That's true, sort of.  IOMMU groups are determined as the devices are
> probed and remain static.  So, while this turns off ACS, the IOMMU
> groups after Root Port unplug remain as they were before.  Making them
> dynamic is a much larger problem.  I was trying to use the atomic to
> avoid allocating data structures runtime for this quirk.  The other
> question though would be whether any of these particular PCH devices
> support hotplug.  Do you know for which Intel chipsets this is even
> feasible?  If we need more fine grained tracking we'll need to track the
> segment and bus number, then we might as well use another byte with a
> bit per function identifying the quirked ports.  Unfortunately with a
> list comes some sort of locking and allocation and de-allocation of
> entries, so we need an unplug hook.  It's possible, but I'd rather keep
> it simple if this is only a "what if" question.

This is definitely a "what if" question.  I have no idea whether these
devices can be hotplugged.

My point is that the reader should not *need* to know whether these
particular devices can be hot-plugged.  If we need that knowledge, it
becomes impractical to analyze the code.  So if we can write this in a way
that obviously works for hot-plugged Root Ports, that would be much better.

Can we add an "acs_enabled" bit in the pci_dev or something?

> Thanks,

Don't thank me, I haven't done anything yet except make your life harder :)

Bjorn
