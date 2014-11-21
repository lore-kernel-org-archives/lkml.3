Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaKUVPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:15:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaKUVPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:15:22 -0500
Date: Fri, 21 Nov 2014 16:14:55 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: Add support for Broadwell-DE processor
Message-ID: <20141121211455.GN21208@redhat.com>
References: <546a37ab3156619eb3@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546a37ab3156619eb3@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
On Mon, Nov 17, 2014 at 10:00:11AM -0800, Luck, Tony wrote:
> Broadwell-DE is the microserver version of next generation Xeon
> processors.  A whole bunch of new PCIe device ids, but otherwise
> pretty much the same as Haswell.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> 
> Mauro: Naming of routines and #defines follows the existing
> convention of only making new functions where changes are
> needed, and using older functions with names from previous
> generations where no changes are needed.  Can you take this
> as-is for the next merge window and we can have a discussion
> about whether to have a massive re-naming to some "better"
> nomenclature in the coming months.  More changes will be
> needed for Broadwell-EP and Broadwell-EX
> 
> Also needs that Haswell TOLM fix I posted in October:
>   http://www.spinics.net/lists/linux-edac/msg04109.html#.VGo3FHW9_CI
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index e9bb1af67c8d..5a140adb5191 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -261,6 +261,7 @@ enum type {
>  	SANDY_BRIDGE,
>  	IVY_BRIDGE,
>  	HASWELL,
> +	BROADWELL,
>  };
>  
>  struct sbridge_pvt;
> @@ -445,7 +446,7 @@ static const struct pci_id_table pci_dev_descr_ibridge_table[] = {
>   *	- each SMI channel interfaces with a scalable memory buffer
>   *	- each scalable memory buffer supports 4 DDR3/DDR4 channels, 3 DPC
>   */
> -#define HASWELL_DDRCRCLKCONTROLS 0xa10
> +#define HASWELL_DDRCRCLKCONTROLS 0xa10 /* Ditto on Broadwell */
>  #define HASWELL_HASYSDEFEATURE2 0x84
>  #define PCI_DEVICE_ID_INTEL_HASWELL_IMC_VTD_MISC 0x2f28
>  #define PCI_DEVICE_ID_INTEL_HASWELL_IMC_HA0	0x2fa0
> @@ -496,6 +497,44 @@ static const struct pci_id_table pci_dev_descr_haswell_table[] = {
>  	{0,}			/* 0 terminated list. */
>  };
>  
> +/* Broadwell support */
> +/* DE processor:
> + *	- 1 IMC
> + *	- 2 DDR3 channels, 2 DPC per channel
> + */
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_VTD_MISC 0x6f28
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0	0x6fa0
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TA	0x6fa8
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_THERMAL 0x6f71
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD0 0x6ffc
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD1 0x6ffd
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD0 0x6faa
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD1 0x6fab
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD2 0x6fac
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD3 0x6fad
> +#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_DDRIO0 0x6faf
> +
> +static const struct pci_id_descr pci_dev_descr_broadwell[] = {
> +	/* first item must be the HA */
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0, 0)		},
> +
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD0, 0)	},
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD1, 0)	},
> +
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TA, 0)	},
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_THERMAL, 0)	},
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD0, 0)	},
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD1, 0)	},
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD2, 1)	},
> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD3, 1)	},

You are marking TAD2 and TAD3 as optional here, but

> +	for (i = 0; i < NUM_CHANNELS; i++) {
> +		if (!pvt->pci_tad[i])
> +			goto enodev;
> +	}

It's not optional here.

Doesn't matter much and we should get rid of one of the checks anyway.

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

