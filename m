Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3FRR20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:28:26 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65440 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab3FRR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:28:23 -0400
Date: Tue, 18 Jun 2013 11:28:19 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: Enable overrides for missing ACS capabilities
Message-ID: <20130618172819.GA16134@google.com>
References: <20130530183955.14686.89444.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530183955.14686.89444.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 12:40:19PM -0600, Alex Williamson wrote:
> PCIe ACS (Access Control Services) is the PCIe 2.0+ feature that
> allows us to control whether transactions are allowed to be redirected
> in various subnodes of a PCIe topology.  For instance, if two
> endpoints are below a root port or downsteam switch port, the
> downstream port may optionally redirect transactions between the
> devices, bypassing upstream devices.  The same can happen internally
> on multifunction devices.  The transaction may never be visible to the
> upstream devices.
> 
> One upstream device that we particularly care about is the IOMMU.  If
> a redirection occurs in the topology below the IOMMU, then the IOMMU
> cannot provide isolation between devices.  This is why the PCIe spec
> encourages topologies to include ACS support.  Without it, we have to
> assume peer-to-peer DMA within a hierarchy can bypass IOMMU isolation.
> 
> Unfortunately, far too many topologies do not support ACS to make this
> a steadfast requirement.  Even the latest chipsets from Intel are only
> sporadically supporting ACS.  We have trouble getting interconnect
> vendors to include the PCIe spec required PCIe capability, let alone
> suggested features.
> 
> Therefore, we need to add some flexibility.  The pcie_acs_override=
> boot option lets users opt-in specific devices or sets of devices to
> assume ACS support.  

"ACS support" means the device provides an ACS capability and we
can change bits in the ACS Control Register to control how things
work.

You are really adding a way to "assume this device always routes
peer-to-peer DMA upstream," which ultimately translates into "assume
this device can be isolated from others via the IOMMU."  I think.

> The "downstream" option assumes full ACS support
> on root ports and downstream switch ports.  The "multifunction"
> option assumes the subset of ACS features available on multifunction
> endpoints and upstream switch ports are supported.  The "id:nnnn:nnnn"
> option enables ACS support on devices matching the provided vendor
> and device IDs, allowing more strategic ACS overrides.  These options
> may be combined in any order.  A maximum of 16 id specific overrides
> are available.  It's suggested to use the most limited set of options
> necessary to avoid completely disabling ACS across the topology.

Probably I'm confused by your use of "assume full ACS support," but I
don't understand the bit about "completely disabling ACS."  If we use
more options than necessary, it seems like we'd assume more isolation
than really exists.  That sounds like pretending ACS is *enabled* in
more places than it really is.

> Note to hardware vendors, we have facilities to permanently quirk
> specific devices which enforce isolation but not provide an ACS
> capability.  Please contact me to have your devices added and save
> your customers the hassle of this boot option.

Who do you expect to decide whether to use this option?  I think it
requires intimate knowledge of how the device works.

I think the benefit of using the option is that it makes assignment of
devices to guests more flexible, which will make it attractive to users.
But most users have no way of knowing whether it's actually *safe* to
use this.  So I worry that you're adding an easy way to pretend isolation
exists when there's no good way of being confident that it actually does.

I see the warning you added for this case; I just don't feel good about
it.  Maybe the idea is that, e.g., Red Hat will research certain devices
and recommend the option for those cases, and sign up to support that
config.  I assume you would not be willing to support its use unless
Red Hat specifically recommended it.

Bjorn

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |   10 +++
>  drivers/pci/quirks.c                |  102 +++++++++++++++++++++++++++++++++++
>  2 files changed, 112 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 47bb23c..a60e6ad 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2349,6 +2349,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  		nomsi	Do not use MSI for native PCIe PME signaling (this makes
>  			all PCIe root ports use INTx for all services).
>  
> +	pcie_acs_override =
> +			[PCIE] Override missing PCIe ACS support for:
> +		downstream
> +			All downstream ports - full ACS capabilties
> +		multifunction
> +			All multifunction devices - multifunction ACS subset
> +		id:nnnn:nnnn
> +			Specfic device - full ACS capabilities
> +			Specified as vid:did (vendor/device ID) in hex
> +
>  	pcmv=		[HW,PCMCIA] BadgePAD 4
>  
>  	pd.		[PARIDE]
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 0369fb6..c7609f6 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3292,11 +3292,113 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>  	return pci_dev_get(dev);
>  }
>  
> +static bool acs_on_downstream;
> +static bool acs_on_multifunction;
> +
> +#define NUM_ACS_IDS 16
> +struct acs_on_id {
> +	unsigned short vendor;
> +	unsigned short device;
> +};
> +static struct acs_on_id acs_on_ids[NUM_ACS_IDS];
> +static u8 max_acs_id;
> +
> +static __init int pcie_acs_override_setup(char *p)
> +{
> +	if (!p)
> +		return -EINVAL;
> +
> +	while (*p) {
> +		if (!strncmp(p, "downstream", 10))
> +			acs_on_downstream = true;
> +		if (!strncmp(p, "multifunction", 13))
> +			acs_on_multifunction = true;
> +		if (!strncmp(p, "id:", 3)) {
> +			char opt[5];
> +			int ret;
> +			long val;
> +
> +			if (max_acs_id >= NUM_ACS_IDS - 1) {
> +				pr_warn("Out of PCIe ACS override slots (%d)\n",
> +					NUM_ACS_IDS);
> +				goto next;
> +			}
> +
> +			p += 3;
> +			snprintf(opt, 5, "%s", p);
> +			ret = kstrtol(opt, 16, &val);
> +			if (ret) {
> +				pr_warn("PCIe ACS ID parse error %d\n", ret);
> +				goto next;
> +			}
> +			acs_on_ids[max_acs_id].vendor = val;
> +
> +			p += strcspn(p, ":");
> +			if (*p != ':') {
> +				pr_warn("PCIe ACS invalid ID\n");
> +				goto next;
> +			}
> +
> +			p++;
> +			snprintf(opt, 5, "%s", p);
> +			ret = kstrtol(opt, 16, &val);
> +			if (ret) {
> +				pr_warn("PCIe ACS ID parse error %d\n", ret);
> +				goto next;
> +			}
> +			acs_on_ids[max_acs_id].device = val;
> +			max_acs_id++;
> +		}
> +next:
> +		p += strcspn(p, ",");
> +		if (*p == ',')
> +			p++;
> +	}
> +
> +	if (acs_on_downstream || acs_on_multifunction || max_acs_id)
> +		pr_warn("Warning: PCIe ACS overrides enabled; This may allow non-IOMMU protected peer-to-peer DMA\n");
> +
> +	return 0;
> +}
> +early_param("pcie_acs_override", pcie_acs_override_setup);
> +
> +static int pcie_acs_overrides(struct pci_dev *dev, u16 acs_flags)
> +{
> +	int i;
> +
> +	/* Never override ACS for legacy devices or devices with ACS caps */
> +	if (!pci_is_pcie(dev) ||
> +	    pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS))
> +		return -ENOTTY;
> +
> +	for (i = 0; i < max_acs_id; i++)
> +		if (acs_on_ids[i].vendor == dev->vendor &&
> +		    acs_on_ids[i].device == dev->device)
> +			return 1;
> +
> +	switch (pci_pcie_type(dev)) {
> +	case PCI_EXP_TYPE_DOWNSTREAM:
> +	case PCI_EXP_TYPE_ROOT_PORT:
> +		if (acs_on_downstream)
> +			return 1;
> +		break;
> +	case PCI_EXP_TYPE_ENDPOINT:
> +	case PCI_EXP_TYPE_UPSTREAM:
> +	case PCI_EXP_TYPE_LEG_END:
> +	case PCI_EXP_TYPE_RC_END:
> +		if (acs_on_multifunction && dev->multifunction)
> +			return 1;
> +	}
> +
> +	return -ENOTTY;
> +}
> +
>  static const struct pci_dev_acs_enabled {
>  	u16 vendor;
>  	u16 device;
>  	int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
>  } pci_dev_acs_enabled[] = {
> +	{ PCI_ANY_ID, PCI_ANY_ID, pcie_acs_overrides },
>  	{ 0 }
>  };
>  
> 
