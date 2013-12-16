Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3LPJTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:19:33 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60192 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab3LPJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:19:31 -0500
Message-ID: <1387185568.9255.4.camel@x41.thuisdomein>
Subject: Re: [PATCH] mmc: sdhci-pci: mention DMA mode only once
From: Paul Bolle <pebolle@tiscali.nl>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 10:19:28 +0100
In-Reply-To: <1374875545.1941.26.camel@x61.thuisdomein>
References: <1374875545.1941.26.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2013 09:19:29.0007 (UTC) FILETIME=[EC06B7F0:01CEFA3F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 23:52 +0200, Paul Bolle wrote:
> A laptop I use prints a warning twice at every boot and every resume:
>     sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
>     sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> 
> These warnings are always printed in pairs.
> 
> This message shouldn't be a warning, but a notice, as there's little the
> user is able to do about the choice for DMA mode. The only way to
> overrule it seems to be the use of (undocumented) debug quirks for the
> sdhci module.
> 
> And, furthermore, this notice needs only be printed once. Everything here
> depends on the hardware of the SD host controller used, which can't
> change.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested on v3.10.3. Compile tested for v3.11-rc2.

Did anyone have a look at this patch? It compiles cleanly on top of
v3.13-rc4. It also does what it claims to do when running v3.13-rc4.

> 1) Note that this warning is printed twice at boot (or module load)
> because the call chain is:
>     sdhci_add_host()
>         host->ops->enable_dma() = sdhci_pci_enable_dma()
>         sdhci_init()
>             sdhci_reset()
>                 host->ops->enable_dma() = sdhci_pci_enable_dma()
> 
> (And, if I understand the code correctly, for non-quirky host
> controllers it can even print the warning three times!)
> 
> The call chain at resume is:
>     sdhci_resume_host()
>         host->ops->enable_dma() = sdhci_pci_enable_dma()
>         sdhci_init()
>             sdhci_reset()
>                 host->ops->enable_dma() = sdhci_pci_enable_dma()
> 
> 2) Note that the patch would be simpler if it's OK to print this message
> once per _module_ and not, as this patch does, once per _host
> controller_. Are there systems that use more than one SD host
> controller, both with different (advertised) DMA capabilities? 
> 
>  drivers/mmc/host/sdhci-pci.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index d7d6bc8..69fc509 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -88,6 +88,7 @@ struct sdhci_pci_chip {
>  	unsigned int		quirks;
>  	unsigned int		quirks2;
>  	bool			allow_runtime_pm;
> +	bool			use_sdma_notified;
>  	const struct sdhci_pci_fixes *fixes;
>  
>  	int			num_slots;	/* Slots on controller */
> @@ -997,17 +998,21 @@ MODULE_DEVICE_TABLE(pci, pci_ids);
>  static int sdhci_pci_enable_dma(struct sdhci_host *host)
>  {
>  	struct sdhci_pci_slot *slot;
> +	struct sdhci_pci_chip *chip;
>  	struct pci_dev *pdev;
>  	int ret;
>  
>  	slot = sdhci_priv(host);
> -	pdev = slot->chip->pdev;
> +	chip = slot->chip;
> +	pdev = chip->pdev;
>  
>  	if (((pdev->class & 0xFFFF00) == (PCI_CLASS_SYSTEM_SDHCI << 8)) &&
>  		((pdev->class & 0x0000FF) != PCI_SDHCI_IFDMA) &&
> -		(host->flags & SDHCI_USE_SDMA)) {
> -		dev_warn(&pdev->dev, "Will use DMA mode even though HW "
> -			"doesn't fully claim to support it.\n");
> +		(host->flags & SDHCI_USE_SDMA) &&
> +		(chip->use_sdma_notified == false)) {
> +		dev_notice(&pdev->dev, "Will use DMA mode even though HW "
> +			   "doesn't fully claim to support it.\n");
> +		chip->use_sdma_notified = true;
>  	}
>  
>  	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> @@ -1504,6 +1509,7 @@ static int sdhci_pci_probe(struct pci_dev *pdev,
>  		chip->allow_runtime_pm = chip->fixes->allow_runtime_pm;
>  	}
>  	chip->num_slots = slots;
> +	chip->use_sdma_notified = false;
>  
>  	pci_set_drvdata(pdev, chip);
>  

Paul Bolle

