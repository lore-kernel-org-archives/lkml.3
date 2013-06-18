Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3FRRJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:09:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60293 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab3FRRJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:09:30 -0400
Date: Tue, 18 Jun 2013 11:09:26 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] pci: Fix flaw in pci_acs_enabled()
Message-ID: <20130618170926.GA9203@google.com>
References: <20130607162732.7733.17758.stgit@bling.home>
 <20130607163441.7733.23221.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607163441.7733.23221.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:34:41AM -0600, Alex Williamson wrote:
> Downstream ports support for all ACS flags supercedes multifunction
> exclusion of some flags.  The PCIe spec also fully specifies which
> PCIe types are subject to the multifunction rules and excludes event
> collectors and PCIe-to-PCI bridges entirely.  Document each rule to
> the section of the PCIe spec.

What's the flaw, exactly?  Does this fix a user-visible issue?  Should
it be backported to any stable releases?  It'd be nice to have an
example or two of devices where we return the wrong thing today.

Oh, I think I see: the original code filters out flags for
multi-function downstream ports, and your new code does not.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/pci/pci.c |   59 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 45 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b099e00..457ae51 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2354,6 +2354,19 @@ void pci_enable_acs(struct pci_dev *dev)
>  	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
>  }
>  
> +static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
> +{
> +	int pos;
> +	u16 ctrl;
> +
> +	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> +	if (!pos)
> +		return false;
> +
> +	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> +	return (ctrl & acs_flags) == acs_flags;
> +}
> +
>  /**
>   * pci_acs_enabled - test ACS against required flags for a given device
>   * @pdev: device to test
> @@ -2364,8 +2377,7 @@ void pci_enable_acs(struct pci_dev *dev)
>   */
>  bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)

I know you didn't change the *name* of this function, but I think it
would be easier to follow if you did change the name to something more
descriptive, e.g., something to do with the actual property you're
interested in, which has to do with routing peer-to-peer DMA.

That property makes sense even for the excluded devices, while the
idea of an ACS capability that doesn't even exist is implicitly
enabled, really doesn't.

>  {
> -	int pos, ret;
> -	u16 ctrl;
> +	int ret;
>  
>  	ret = pci_dev_specific_acs_enabled(pdev, acs_flags);
>  	if (ret >= 0)
> @@ -2374,23 +2386,42 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>  	if (!pci_is_pcie(pdev))
>  		return false;
>  
> -	/* Filter out flags not applicable to multifunction */
> -	if (pdev->multifunction)
> +	switch (pci_pcie_type(pdev)) {
> +	/*
> +	 * PCIe 3.0, 6.12.1 excludes ACS on these devices.  "Not applicable"
> +	 */
> +	case PCI_EXP_TYPE_PCI_BRIDGE:
> +	case PCI_EXP_TYPE_RC_EC:
> +		break;

Why not just return "true" immediately here, or even better, just omit
the case altogether, since it doesn't change the behavior at all?

> +	/*
> +	 * PCIe 3.0, 6.12.1.1 specifies full ACS capabilities on downstream
> +	 * ports, regardless of them being multifunction devices.
> +	 */
> +	case PCI_EXP_TYPE_DOWNSTREAM:
> +	case PCI_EXP_TYPE_ROOT_PORT:
> +		return pci_acs_flags_enabled(pdev, acs_flags);
> +	/*
> +	 * PCIe 3.0, 6.12.1.2 specifies unimplemented ACS capabilities on
> +	 * multifunction devices.  6.12 footnote identifies specifically
> +	 * which devices types this applies to.
> +	 */
> +	case PCI_EXP_TYPE_ENDPOINT:
> +	case PCI_EXP_TYPE_UPSTREAM:
> +	case PCI_EXP_TYPE_LEG_END:
> +	case PCI_EXP_TYPE_RC_END:
> +		if (!pdev->multifunction)
> +			break;

And here.

> +
>  		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
>  			      PCI_ACS_EC | PCI_ACS_DT);
>  
> -	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM ||
> -	    pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT ||
> -	    pdev->multifunction) {
> -		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> -		if (!pos)
> -			return false;
> -
> -		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> -		if ((ctrl & acs_flags) != acs_flags)
> -			return false;
> +		return pci_acs_flags_enabled(pdev, acs_flags);
>  	}
>  
> +	/*
> +	 * PCIe 3.0, 6.12.1.3 specifies no ACS capabilties are applicable
> +	 * to single function devices with the exception of downstream ports.
> +	 */
>  	return true;
>  }
>  
> 

I actually liked the original code organization, because it's closer
to expressing the idea of "here are the control points where hardware
can make choices about routing peer-to-peer DMA and here's the knob
(ACS) that constrains those choices."

Maybe something like (pidgin C):

    if (PCI_EXP_TYPE_DOWNSTREAM || PCI_EXP_TYPE_ROOT_PORT)
	return pci_acs_flags_enabled(pdev, acs_flags);

    if (!pdev->multifunction)
	return true;

    acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | ...);
    return pci_acs_flags_enabled(pdev, acs_flags);

Bjorn
