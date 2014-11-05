Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaKEE5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:57:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59552 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaKEE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:57:18 -0500
Message-ID: <5459AE2C.2050401@wwwdotorg.org>
Date: Tue, 04 Nov 2014 21:57:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Scott Branden <sbranden@broadcom.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, Piotr Krol <pietrushnic@gmail.com>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, linux-rpi-kernel@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCHv2 3/5] mmc: shdci-bcm2835: add efficient back-to-back
 write workaround
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-4-git-send-email-sbranden@broadcom.com>
In-Reply-To: <1414651017-3545-4-git-send-email-sbranden@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 12:36 AM, Scott Branden wrote:
> The bcm2835 has clock domain issues when back to back writes to certain
> registers are written.  The existing driver works around this issue with
> udelay.  A more efficient method is to store the 8 and 16 bit writes
> to the registers affected and then write them as 32 bits at the appropriate
> time.

> diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c

>  static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
>  {
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> -	struct bcm2835_sdhci *bcm2835_host = pltfm_host->priv;
> -	u32 oldval = (reg == SDHCI_COMMAND) ? bcm2835_host->shadow :
> -		bcm2835_sdhci_readl(host, reg & ~3);
> +	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;

Is that type change for bcm2835_host really correct?

> +	} else {
> +		/* Read reg, all other registers are not shadowed */
> +		oldval = readl(host->ioaddr + (reg & ~3));

Is there any reason to use readl() directly here rather than calling
bcm2835_readl()? ...

>  static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
>  {
> -	u32 oldval = bcm2835_sdhci_readl(host, reg & ~3);
> +	u32 oldval = readl(host->ioaddr + (reg & ~3));

... and here in particular, since this seems like an unrelated change?

>  static int bcm2835_sdhci_probe(struct platform_device *pdev)
>  {
>  	struct sdhci_host *host;
> -	struct bcm2835_sdhci *bcm2835_host;
> +	struct bcm2835_sdhci_host *bcm2835_host;

Is that type change for bcm2835_host really correct?
