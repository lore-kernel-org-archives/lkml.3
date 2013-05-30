Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3E3Tfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645Ab3E3Tfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:35:40 -0400
Message-ID: <51A7AA09.7020901@redhat.com>
Date: Thu, 30 May 2013 15:35:37 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix flaw in pci_acs_enabled()
References: <20130530183638.14466.74855.stgit@bling.home>
In-Reply-To: <20130530183638.14466.74855.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 02:37 PM, Alex Williamson wrote:
> Downstream ports support for all ACS flags supercedes multifunction
> exclusion of some flags.  The PCIe spec also fully specifies which
> PCIe types are subject to the multifunction rules and excludes event
> collectors and PCIe-to-PCI bridges entirely.  Document each rule to
> the section of the PCIe spec.
>
> Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> ---
>   drivers/pci/pci.c |   59 ++++++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 45 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b099e00..457ae51 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2354,6 +2354,19 @@ void pci_enable_acs(struct pci_dev *dev)
>   	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
>   }
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
> +	pci_read_config_word(pdev, pos + PCI_ACS_CTRL,&ctrl);
> +	return (ctrl&  acs_flags) == acs_flags;
> +}
> +
>   /**
>    * pci_acs_enabled - test ACS against required flags for a given device
>    * @pdev: device to test
> @@ -2364,8 +2377,7 @@ void pci_enable_acs(struct pci_dev *dev)
>    */
>   bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>   {
> -	int pos, ret;
> -	u16 ctrl;
> +	int ret;
>
>   	ret = pci_dev_specific_acs_enabled(pdev, acs_flags);
>   	if (ret>= 0)
> @@ -2374,23 +2386,42 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>   	if (!pci_is_pcie(pdev))
>   		return false;
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
> +


>   		acs_flags&= (PCI_ACS_RR | PCI_ACS_CR |
>   			      PCI_ACS_EC | PCI_ACS_DT);
>
> -	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM ||
> -	    pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT ||
> -	    pdev->multifunction) {
> -		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
> -		if (!pos)
> -			return false;
> -
> -		pci_read_config_word(pdev, pos + PCI_ACS_CTRL,&ctrl);
> -		if ((ctrl&  acs_flags) != acs_flags)
> -			return false;
> +		return pci_acs_flags_enabled(pdev, acs_flags);
As I read 6.12.1.2, *if* a multifunction device supports peer-to-peer
traffic with another function(s), then certain ACS subfunctions
must be implemented.
So, I conclude from that statement (3rd bullet under this section),
if a MFD does not support peer-to-peer traffic, it doesn't have to provide
an ACS cap ... which is what I'm seeing in a number of MFD NICs (with sriov devices).
IOW, an MFD w/o an ACS cap == single function device w/o ACS cap.

If that spec interpretation, and more importantly, hw implementation, is
correct, then won't above code return 'false' for an MFD with no ACS cap,
and shouldn't it return true in that case b/c it's optional/only-req'd
if MFD has peer-to-peer btwn functions?

>   	}
>
> +	/*
> +	 * PCIe 3.0, 6.12.1.3 specifies no ACS capabilties are applicable
> +	 * to single function devices with the exception of downstream ports.
> +	 */
>   	return true;
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

