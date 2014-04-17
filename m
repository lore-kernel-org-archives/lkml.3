Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaDQKpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:45:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33301 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDQKph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:45:37 -0400
Date: Thu, 17 Apr 2014 12:45:33 +0200
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
Message-ID: <20140417104533.GB8215@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
 <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140416225600.GA23781@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

thanks for the patch, a couple of notes below:

On Wed, Apr 16, 2014 at 04:56:00PM -0600, Bjorn Helgaas wrote:
> PNP: Work around Haswell BIOS defect in MCH area reporting
> 
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Work around a Haswell BIOS defect that causes part of the MCH area to be
> unreported.

Yep, what Stephane said, this is not HSW only.

> MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
> PNP0C02 resource.  The MCH space was 16KB prior to Haswell, but it is 32KB
> in Haswell.  Some Haswell BIOSes still report a PNP0C02 resource that is
> only 16KB, which means the rest of the MCH space is consumed but
> unreported.
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
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/pnp/quirks.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 258fef272ea7..8402088d4145 100644
> --- a/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -334,6 +334,60 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
>  }
>  #endif
>  
> +static void quirk_intel_haswell_mch(struct pnp_dev *dev)
> +{
> +	struct pci_dev *host;
> +	u32 addr_lo, addr_hi;
> +	struct pci_bus_region region;
> +	struct resource mch;
> +	struct pnp_resource *pnp_res;
> +	struct resource *res;
> +
> +	host = pci_get_device(PCI_VENDOR_ID_INTEL, 0x0c00, NULL);

And because it is not HSW only, this PCI device ID doesn't match on my
IVB system. On mine the hostbridge is

00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
        Subsystem: Lenovo Device 21fa
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: <access denied>
        Kernel driver in use: ivb_uncore
00: 86 80 54 01 06 00 90 20 09 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

and from looking at Dave's, it is the same one, so PCI device ID is
0x154.

With that changed to

	host = pci_get_device(PCI_VENDOR_ID_INTEL, 0x0154, NULL);

and a bit of debugging code, it says now:

[    0.235739] quirk_intel_haswell_mch: entry
[    0.235800] quirk_intel_haswell_mch: got host: 0x0
[    0.235860] quirk_intel_haswell_mch: mch: [mem 0xfed10000-0xfed17fff]
[    0.235930] quirk_intel_haswell_mch: res: [mem 0xfed10000-0xfed13fff]
[    0.235990] pnp 00:01: [Firmware Bug]: [mem 0xfed10000-0xfed13fff] covers only part of Intel Haswell MCH; extending to [mem 0xfed10000-0xfed17fff]

So you probably want to have a list of hostbridge pci ids in the quirk
or so.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
