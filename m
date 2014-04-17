Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaDQTtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:49:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34460 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaDQTs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:48:57 -0400
Date: Thu, 17 Apr 2014 21:48:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140417194853.GG4321@pd.tnic>
References: <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
 <20140417104533.GB8215@pd.tnic>
 <20140417182637.GA2098@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417182637.GA2098@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:26:37PM -0600, Bjorn Helgaas wrote:
> Thanks a lot for testing this out and debugging my issues.
> 
> Here's a new version that looks for both device IDs I know about.
> 
> I'm still nervous about the modeset problem Dave is seeing.  Since the
> original patch wouldn't find an 8086:0c00 device on Dave's system, it
> should have done nothing.  But since it caused a modesetting problem,
> there's something else doing on that I don't understand.

Yeah, this is strange, to put it mildly. This quirk wouldnt've done
anything besides the iteration over the pci devices with pci_get_device.
Which wouldn't do anything (refcount increment or so) if it didn't find
the device, right?

Bah, today is the day of the strange bugs. :-\

> PNP: Work around BIOS defects in Intel MCH area reporting
> 
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
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

Yep, this one works fine:

[    0.403855] pnp 00:01: [Firmware Bug]: PNP resource [mem 0xfed10000-0xfed13fff] covers only part of 0000:00:00.0 Intel MCH; extending to [mem 0xfed10000-0xfed17fff]

Acked-by: Borislav Petkov <bp@suse.de>
Tested-by: Borislav Petkov <bp@suse.de>

Just a minor nitpick below.

> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/pnp/quirks.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 258fef272ea7..403bd5c42ed1 100644
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
> +	region.end = region.start + 32*1024 - 1 ;

checkpatch complains about a trailing space before the semicolon.

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

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
