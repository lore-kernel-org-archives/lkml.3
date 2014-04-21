Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaDUU2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:28:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55069 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754027AbaDUU2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:28:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Zheng Z Yan <zheng.z.yan@intel.com>,
        Dave Jones <davej@redhat.com>, Rui Zhang <rui.zhang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] PNP: Work around BIOS defects in Intel MCH area reporting
Date: Mon, 21 Apr 2014 22:44:29 +0200
Message-ID: <1702309.mG1EHfKp35@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140417202033.7057.98414.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140417202033.7057.98414.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Thursday, April 17, 2014 02:20:33 PM Bjorn Helgaas wrote:
> Work around BIOSes that don't report the entire Intel MCH area.
> 
> MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
> PNP0C02 resource.  The MCH space was once 16KB, but is 32KB in newer parts.
> Some BIOSes still report a PNP0C02 resource that is only 16KB, which means
> the rest of the MCH space is consumed but unreported.
> 
> This can cause resource map sanity check warnings or (theoretically) a
> device conflict if we assigned the unreported space to another device.
> 
> The Intel perf event uncore driver tripped over this when it claimed the
> MCH region:
> 
>   resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
>   Info: mapping multiple BARs. Your kernel is fine.
> 
> To prevent this, if we find a PNP0C02 resource that covers part of the MCH
> space, extend it to cover the entire space.
> 
> Link: http://lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
> Reported-by: Borislav Petkov <bp@alien8.de>
> Tested-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Borislav Petkov <bp@suse.de>

Do you want me to take this patch for PNP, or are you planning to take it
into your tree?

Rafael


> ---
>  drivers/pnp/quirks.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 258fef272ea7..90b8c12c220d 100644
> --- a/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -334,6 +334,79 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
>  }
>  #endif
>  
> +/* Device IDs of parts that have 32KB MCH space */
> +static const unsigned int mch_quirk_devices[] = {
> +	0x0154,	/* Ivy Bridge */
> +	0x0c00,	/* Haswell */
> +};
> +
> +static struct pci_dev *get_intel_host(void)
> +{
> +	int i;
> +	struct pci_dev *host;
> +
> +	for (i = 0; i < ARRAY_SIZE(mch_quirk_devices); i++) {
> +		host = pci_get_device(PCI_VENDOR_ID_INTEL, mch_quirk_devices[i],
> +				      NULL);
> +		if (host)
> +			return host;
> +	}
> +	return NULL;
> +}
> +
> +static void quirk_intel_mch(struct pnp_dev *dev)
> +{
> +	struct pci_dev *host;
> +	u32 addr_lo, addr_hi;
> +	struct pci_bus_region region;
> +	struct resource mch;
> +	struct pnp_resource *pnp_res;
> +	struct resource *res;
> +
> +	host = get_intel_host();
> +	if (!host)
> +		return;
> +
> +	/*
> +	 * MCHBAR is not an architected PCI BAR, so MCH space is usually
> +	 * reported as a PNP0C02 resource.  The MCH space was originally
> +	 * 16KB, but is 32KB in newer parts.  Some BIOSes still report a
> +	 * PNP0C02 resource that is only 16KB, which means the rest of the
> +	 * MCH space is consumed but unreported.
> +	 */
> +
> +	/*
> +	 * Read MCHBAR for Host Member Mapped Register Range Base
> +	 * https://www-ssl.intel.com/content/www/us/en/processors/core/4th-gen-core-family-desktop-vol-2-datasheet
> +	 * Sec 3.1.12.
> +	 */
> +	pci_read_config_dword(host, 0x48, &addr_lo);
> +	region.start = addr_lo & ~0x7fff;
> +	pci_read_config_dword(host, 0x4c, &addr_hi);
> +	region.start |= (dma_addr_t) addr_hi << 32;
> +	region.end = region.start + 32*1024 - 1;
> +
> +	memset(&mch, 0, sizeof(mch));
> +	mch.flags = IORESOURCE_MEM;
> +	pcibios_bus_to_resource(host->bus, &mch, &region);
> +
> +	list_for_each_entry(pnp_res, &dev->resources, list) {
> +		res = &pnp_res->res;
> +		if (res->end < mch.start || res->start > mch.end)
> +			continue;	/* no overlap */
> +		if (res->start == mch.start && res->end == mch.end)
> +			continue;	/* exact match */
> +
> +		dev_info(&dev->dev, FW_BUG "PNP resource %pR covers only part of %s Intel MCH; extending to %pR\n",
> +			 res, pci_name(host), &mch);
> +		res->start = mch.start;
> +		res->end = mch.end;
> +		break;
> +	}
> +
> +	pci_dev_put(host);
> +}
> +
>  /*
>   *  PnP Quirks
>   *  Cards or devices that need some tweaking due to incomplete resource info
> @@ -364,6 +437,7 @@ static struct pnp_fixup pnp_fixups[] = {
>  #ifdef CONFIG_AMD_NB
>  	{"PNP0c01", quirk_amd_mmconfig_area},
>  #endif
> +	{"PNP0c02", quirk_intel_mch},
>  	{""}
>  };
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
