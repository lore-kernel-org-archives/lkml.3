Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaLEUMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:12:55 -0500
Received: from ida.rowland.org ([192.131.102.52]:50013 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751535AbaLEUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:12:49 -0500
Date: Fri, 5 Dec 2014 14:27:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@ida.rowland.org
To: Arseny Solokha <asolokha@kb.kras.ru>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OHCI: add a quirk for ULi M5237 blocking on reset
In-Reply-To: <1417768029-31901-1-git-send-email-asolokha@kb.kras.ru>
Message-ID: <Pine.LNX.4.44L0.1412051422120.13167-100000@ida.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014, Arseny Solokha wrote:

> From: Arseny Solokha <asolokha@kb.kras.ru>
> 
> Commit 8dccddbc2368 ("OHCI: final fix for NVIDIA problems (I hope)")
> introduced into 3.1.9 broke boot on e.g. Freescale P2020DS development
> board. The code path that was previously specific to NVIDIA controllers
> had then become taken for all chips.
> 
> However, the M5237 installed on the board wedges solid when accessing
> its base+OHCI_FMINTERVAL register, making it impossible to boot any
> kernel newer than 3.1.8 on this particular and apparently other similar
> machines.
> 
> Don't readl() and writel() base+OHCI_FMINTERVAL on PCI ID 10b9:5237.

I seem to recall seeing something like this before, but I can't 
remember where or when.  At any rate, there's nothing like it in the 
current code...

> The patch is suitable for the -next tree as well as all maintained
> kernels up to 3.2 inclusive.
> 
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
> ---
>  drivers/usb/host/pci-quirks.c | 14 +++++++++++---
>  include/linux/pci_ids.h       |  1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 2f3aceb..3b29478 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -571,7 +571,7 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
>  {
>  	void __iomem *base;
>  	u32 control;
> -	u32 fminterval;
> +	u32 fminterval = 0;
>  	int cnt;
>  
>  	if (!mmio_resource_enabled(pdev, 0))
> @@ -619,7 +619,13 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
>  	}
>  
>  	/* software reset of the controller, preserving HcFmInterval */
> -	fminterval = readl(base + OHCI_FMINTERVAL);
> +	if (!(pdev->vendor == PCI_VENDOR_ID_AL &&
> +	      pdev->device == PCI_DEVICE_ID_AL_M5237)) {
> +		/* ULi M5237 OHCI controller (10b9:5237) locks the whole system
> +		 * when accessing the OHCI_FMINTERVAL offset.
> +		 */

You don't need to specify the vendor and device IDs in the comment.  
That's what #defines are for.

Also, the accepted format for multi-line comments is:

	/*
	 * Blah, blah, blah...
	 * Blah, blah, blah...
	 */

> +		fminterval = readl(base + OHCI_FMINTERVAL);
> +	}
>  	writel(OHCI_HCR, base + OHCI_CMDSTATUS);
>  
>  	/* reset requires max 10 us delay */
> @@ -628,7 +634,9 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
>  			break;
>  		udelay(1);
>  	}
> -	writel(fminterval, base + OHCI_FMINTERVAL);
> +	if (!(pdev->vendor == PCI_VENDOR_ID_AL &&
> +	      pdev->device == PCI_DEVICE_ID_AL_M5237))
> +		writel(fminterval, base + OHCI_FMINTERVAL);

This is very ugly, with these repeated tests.  You should set a
no_fminterval flag at the start of the function and then use it instead 
of doing the same tests over again.

>  	/* Now the controller is safely in SUSPEND and nothing can wake it up */
>  	iounmap(base);
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 1fa99a3..266fc5c 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1107,6 +1107,7 @@
>  #define PCI_DEVICE_ID_AL_M5219		0x5219
>  #define PCI_DEVICE_ID_AL_M5228		0x5228
>  #define PCI_DEVICE_ID_AL_M5229		0x5229
> +#define PCI_DEVICE_ID_AL_M5237		0x5237
>  #define PCI_DEVICE_ID_AL_M5451		0x5451
>  #define PCI_DEVICE_ID_AL_M7101		0x7101

There's no reason to add an ID to pci_ids.h if it's only going to be 
used in one source file.  Put the ID in the source file instead.

Alan Stern

