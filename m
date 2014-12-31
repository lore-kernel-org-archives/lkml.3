Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaLaOwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:52:10 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62532 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaLaOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:52:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rameshwar Prasad Sahu <rsahu@apm.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, devicetree@vger.kernel.org, jcm@redhat.com,
        patches@apm.com, linux-kernel@vger.kernel.org, ddutile@redhat.com,
        Loc Ho <lho@apm.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH v1 1/3] dmaengine: Add support for APM X-Gene SoC DMA driver
Date: Wed, 31 Dec 2014 15:51:48 +0100
Message-ID: <1847119.mDQlkgqzsR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420026134-17857-1-git-send-email-rsahu@apm.com>
References: <1420026134-17857-1-git-send-email-rsahu@apm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:U6gwnl6gq5Z6bRjznm16PRobwOFA3gbp2a0ThZBfjLF6YfLTDNA
 nZZcjaGy2kWvWGsGojzI4s4KeVPteXFvyTD7vqvKekA5upKoLbcmXwAPVFHvQQEpN2QysZs
 15GBu9xMIw2cEhuQasyMpIM9SaAWtsIWwb50MpX+8mooybbs0L7rLIOB2oUYJkRIadWwzmQ
 bgSGxEeg3DigOmCRGoouw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2014 17:12:14 Rameshwar Prasad Sahu wrote:
> This patch implements the APM X-Gene SoC DMA driver. The APM X-Gene
> SoC DMA engine consists of 4 DMA channels for performing DMA operations.
> These DMA operations include memory copy and scatter gathering offload.

Is the dma engine capable of slave DMA in theory and you just don't use
that, or does it not do that at all?

> +static int xgene_dma_init_mem(struct xgene_dma *pdma)
> +{
> +	int timeout = 1000;
> +
> +	writel(0x0, pdma->csr_dma + DMA_MEM_RAM_SHUTDOWN);
> +
> +	/* Force a barrier */
> +	readl(pdma->csr_dma + DMA_MEM_RAM_SHUTDOWN);
> +
> +	do {
> +		if (readl(pdma->csr_dma + DMA_BLK_MEM_RDY)
> +			== DMA_BLK_MEM_RDY_DEFAULT)
> +			break;
> +		udelay(1);
> +	} while (--timeout);
> +
> +	if (timeout <= 0) {
> +		dev_err(pdma->dev,
> +			"Failed to release memory from shutdown\n");
> +		return -ENODEV;
> +	}
> +	return 0;
> +}

That's a long busy-loop. Can you use a sleeping function instead?

> +	/* Set DMA mask and coherent mask */
> +	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to set DMA mask\n");
> +		goto err_pm_enable;
> +	}

Never use dma_coerce_mask_and_coherent in new drivers. Instead, make
sure that the information in the device tree is correct in the first
place so the driver doesn't need to override it.

	Arnd

