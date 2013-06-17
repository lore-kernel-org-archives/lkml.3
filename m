Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3FQPBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3FQPBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:01:07 -0400
Message-ID: <51BF24B0.9080502@redhat.com>
Date: Mon, 17 Jun 2013 11:01:04 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: Enable overrides for missing ACS capabilities
References: <20130530183955.14686.89444.stgit@bling.home>
In-Reply-To: <20130530183955.14686.89444.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 02:40 PM, Alex Williamson wrote:
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
> assume ACS support.  The "downstream" option assumes full ACS support
> on root ports and downstream switch ports.  The "multifunction"
> option assumes the subset of ACS features available on multifunction
> endpoints and upstream switch ports are supported.  The "id:nnnn:nnnn"
> option enables ACS support on devices matching the provided vendor
> and device IDs, allowing more strategic ACS overrides.  These options
> may be combined in any order.  A maximum of 16 id specific overrides
> are available.  It's suggested to use the most limited set of options
> necessary to avoid completely disabling ACS across the topology.
>
> Note to hardware vendors, we have facilities to permanently quirk
> specific devices which enforce isolation but not provide an ACS
> capability.  Please contact me to have your devices added and save
> your customers the hassle of this boot option.
>
> Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
> ---
>   Documentation/kernel-parameters.txt |   10 +++
>   drivers/pci/quirks.c                |  102 +++++++++++++++++++++++++++++++++++
>   2 files changed, 112 insertions(+)
>

Feel free to add my ack.

I like the fact that all of this code is in quirks, and not sprinkled btwn pci core & quirks.
As we have discovered, even common, ACS-compatilbe x86 chipsets are out there w/o ACS caps.
Additionally, an unclear area of the spec has some vendors providing 'null ACS' caps,
which is suppose to be interpreted as no-peer-to-peer DMA; this latter 'feature' is being
brought up to PCI-SIG to get a note added to SRIOV spec in the ACS-related material to clarify.

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 47bb23c..a60e6ad 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2349,6 +2349,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   		nomsi	Do not use MSI for native PCIe PME signaling (this makes
>   			all PCIe root ports use INTx for all services).
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
>   	pcmv=		[HW,PCMCIA] BadgePAD 4
>
>   	pd.		[PARIDE]
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 0369fb6..c7609f6 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3292,11 +3292,113 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>   	return pci_dev_get(dev);
>   }
>
> +static bool acs_on_downstream;
> +static bool acs_on_multifunction;
> +
> +#define NUM_ACS_IDS 16
> +struct acs_on_id {
> +	unsigned short vendor;
> +	unsigned short device;
> +};
At first, I wasn't sure if vid/did would be sufficient, but convinced myself
that a sub-vid/did that differed amongst sub-vid's, even if they added/modified
ACS cap, the ACS-cap-existence test in pcie_acs_overrides() will not exercise
any override for that variant, and both bases -- newer/sub-vid modified devices
w/ACS, and vid/did w/o ACS will be handled properly.
So, another reason for the ack.

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
> +			if (max_acs_id>= NUM_ACS_IDS - 1) {
> +				pr_warn("Out of PCIe ACS override slots (%d)\n",
> +					NUM_ACS_IDS);
> +				goto next;
> +			}
> +
> +			p += 3;
> +			snprintf(opt, 5, "%s", p);
> +			ret = kstrtol(opt, 16,&val);
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
> +			ret = kstrtol(opt, 16,&val);
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
> +	for (i = 0; i<  max_acs_id; i++)
> +		if (acs_on_ids[i].vendor == dev->vendor&&
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
> +		if (acs_on_multifunction&&  dev->multifunction)
> +			return 1;
> +	}
> +
> +	return -ENOTTY;
> +}
> +
>   static const struct pci_dev_acs_enabled {
>   	u16 vendor;
>   	u16 device;
>   	int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
>   } pci_dev_acs_enabled[] = {
> +	{ PCI_ANY_ID, PCI_ANY_ID, pcie_acs_overrides },
>   	{ 0 }
>   };
>
Would like to see this list filled out asap to avoid cmdline workarounds! ;-)
wait!  -- did I say that?  I want quirks?!?  ... ;-)
Honestly, I'd rather see the vid/did here then numerous kernel cmdline args being added.


>

