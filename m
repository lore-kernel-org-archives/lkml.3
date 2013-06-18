Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab3FRSi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab3FRSi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:38:58 -0400
Message-ID: <1371580735.22681.216.camel@ul30vt.home>
Subject: Re: [PATCH v2 1/2] pci: Fix flaw in pci_acs_enabled()
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Jun 2013 12:38:55 -0600
In-Reply-To: <20130618170926.GA9203@google.com>
References: <20130607162732.7733.17758.stgit@bling.home>
	 <20130607163441.7733.23221.stgit@bling.home>
	 <20130618170926.GA9203@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 11:09 -0600, Bjorn Helgaas wrote:
> On Fri, Jun 07, 2013 at 10:34:41AM -0600, Alex Williamson wrote:
> > Downstream ports support for all ACS flags supercedes multifunction
> > exclusion of some flags.  The PCIe spec also fully specifies which
> > PCIe types are subject to the multifunction rules and excludes event
> > collectors and PCIe-to-PCI bridges entirely.  Document each rule to
> > the section of the PCIe spec.
> 
> What's the flaw, exactly?  Does this fix a user-visible issue?  Should
> it be backported to any stable releases?  It'd be nice to have an
> example or two of devices where we return the wrong thing today.
> 
> Oh, I think I see: the original code filters out flags for
> multi-function downstream ports, and your new code does not.

Right, if you have a multifunction root port and you want to check a
feature that applies to downstream ports, but not multifunction devices,
we were previously filtering those out.

> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/pci/pci.c |   59 ++++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 45 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index b099e00..457ae51 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2354,6 +2354,19 @@ void pci_enable_acs(struct pci_dev *dev)
> >  	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
> >  }
> >  
> > +static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
> > +{
> > +	int pos;
> > +	u16 ctrl;
> > +
> > +	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> > +	if (!pos)
> > +		return false;
> > +
> > +	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> > +	return (ctrl & acs_flags) == acs_flags;
> > +}
> > +
> >  /**
> >   * pci_acs_enabled - test ACS against required flags for a given device
> >   * @pdev: device to test
> > @@ -2364,8 +2377,7 @@ void pci_enable_acs(struct pci_dev *dev)
> >   */
> >  bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
> 
> I know you didn't change the *name* of this function, but I think it
> would be easier to follow if you did change the name to something more
> descriptive, e.g., something to do with the actual property you're
> interested in, which has to do with routing peer-to-peer DMA.
> 
> That property makes sense even for the excluded devices, while the
> idea of an ACS capability that doesn't even exist is implicitly
> enabled, really doesn't.

I think we also don't want to put the complexity at the caller for
understanding what capabilities are applicable to a given device.  It's
also convenient to use the set of ACS flags.  Given that, the current
naming came about.  It's a little awkward, but it's easy to use.
Suggestions for a better name?

> >  {
> > -	int pos, ret;
> > -	u16 ctrl;
> > +	int ret;
> >  
> >  	ret = pci_dev_specific_acs_enabled(pdev, acs_flags);
> >  	if (ret >= 0)
> > @@ -2374,23 +2386,42 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
> >  	if (!pci_is_pcie(pdev))
> >  		return false;
> >  
> > -	/* Filter out flags not applicable to multifunction */
> > -	if (pdev->multifunction)
> > +	switch (pci_pcie_type(pdev)) {
> > +	/*
> > +	 * PCIe 3.0, 6.12.1 excludes ACS on these devices.  "Not applicable"
> > +	 */
> > +	case PCI_EXP_TYPE_PCI_BRIDGE:
> > +	case PCI_EXP_TYPE_RC_EC:
> > +		break;
> 
> Why not just return "true" immediately here, or even better, just omit
> the case altogether, since it doesn't change the behavior at all?

It could certainly return true, I debated that for a while and decided
to break just to reduce the number of exit points.  Omitting the case
means that anyone who looks at this in the future has to figure out why
those pcie types aren't explicitly listed.

> > +	/*
> > +	 * PCIe 3.0, 6.12.1.1 specifies full ACS capabilities on downstream
> > +	 * ports, regardless of them being multifunction devices.
> > +	 */
> > +	case PCI_EXP_TYPE_DOWNSTREAM:
> > +	case PCI_EXP_TYPE_ROOT_PORT:
> > +		return pci_acs_flags_enabled(pdev, acs_flags);
> > +	/*
> > +	 * PCIe 3.0, 6.12.1.2 specifies unimplemented ACS capabilities on
> > +	 * multifunction devices.  6.12 footnote identifies specifically
> > +	 * which devices types this applies to.
> > +	 */
> > +	case PCI_EXP_TYPE_ENDPOINT:
> > +	case PCI_EXP_TYPE_UPSTREAM:
> > +	case PCI_EXP_TYPE_LEG_END:
> > +	case PCI_EXP_TYPE_RC_END:
> > +		if (!pdev->multifunction)
> > +			break;
> 
> And here.

Same

> > +
> >  		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
> >  			      PCI_ACS_EC | PCI_ACS_DT);
> >  
> > -	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM ||
> > -	    pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT ||
> > -	    pdev->multifunction) {
> > -		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> > -		if (!pos)
> > -			return false;
> > -
> > -		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> > -		if ((ctrl & acs_flags) != acs_flags)
> > -			return false;
> > +		return pci_acs_flags_enabled(pdev, acs_flags);
> >  	}
> >  
> > +	/*
> > +	 * PCIe 3.0, 6.12.1.3 specifies no ACS capabilties are applicable
> > +	 * to single function devices with the exception of downstream ports.
> > +	 */
> >  	return true;
> >  }
> >  
> > 
> 
> I actually liked the original code organization, because it's closer
> to expressing the idea of "here are the control points where hardware
> can make choices about routing peer-to-peer DMA and here's the knob
> (ACS) that constrains those choices."
> 
> Maybe something like (pidgin C):
> 
>     if (PCI_EXP_TYPE_DOWNSTREAM || PCI_EXP_TYPE_ROOT_PORT)
> 	return pci_acs_flags_enabled(pdev, acs_flags);
> 
>     if (!pdev->multifunction)
> 	return true;
> 
>     acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | ...);
>     return pci_acs_flags_enabled(pdev, acs_flags);

Ok.  I re-organized it because I got tired of re-reading the spec to
make sure that a given type of device was handled correctly.  Note that
the above simplification incorrectly handles multifunction bridges or EC
devices.  I can do something like you suggest, but being explicit was
actually a goal in fixing this bug and avoiding future bugs.  Thanks,

Alex

