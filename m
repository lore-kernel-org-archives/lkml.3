Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaFJVxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:53:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaFJVxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:53:51 -0400
Message-ID: <53977E79.2090000@redhat.com>
Date: Tue, 10 Jun 2014 16:54:01 -0500
From: David Milburn <dmilburn@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130912 Thunderbird/17.0.9
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com
CC: tj@kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ata: Check and set 64-bit DMA mask for platform AHCI
 driver
References: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 12:35 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> The current platform AHCI drier does not set the dma_mask correctly
> for 64-bit DMA capable AHCI controller.  This patch checks the AHCI
> capability bit and set the dma_mask and coherent_dma_mask accordingly.
>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>   drivers/ata/libahci_platform.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 7cb3a85..85049ef 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -368,6 +368,15 @@ int ahci_platform_init_host(struct platform_device *pdev,

Hi Suravee,

Would it be better to do the following before ahci_reset_controller()?

         /* initialize adapter */
         rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
         if (rc)
                	return rc;


Thanks,
David



>   	ahci_init_controller(host);
>   	ahci_print_info(host, "platform");
>
> +	if (hpriv->cap & HOST_CAP_64) {
> +		if (!dev->dma_mask)
> +			dev->dma_mask = &dev->coherent_dma_mask;
> +
> +		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +		if (rc)
> +			return rc;
> +	}
> +
>   	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
>   				 &ahci_platform_sht);
>   }
>

