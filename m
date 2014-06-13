Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaFMIke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbaFMIkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:40:31 -0400
Message-ID: <539AB8F1.2040608@redhat.com>
Date: Fri, 13 Jun 2014 10:40:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com, tj@kernel.org, b.zolnierkie@samsung.com
CC: lho@apm.com, tphan@apm.com, stripathi@apm.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ahci: Check and set 64-bit DMA mask for platform
 AHCI driver
References: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com> <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/12/2014 07:40 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> The current platform AHCI driver does not set the dma_mask correctly
> for 64-bit DMA capable AHCI controller. This patch checks the AHCI
> capability bit and set the dma_mask and coherent_dma_mask accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

I did not review this patch, just because you CC-ed me does not mean
I've reviewed it. Please don't add my Reviewed-by unless you've gotten
a mail from me saying something along these lines:

This patch is:
Reviewed-by: Hans de Goede <hdegoede@redhat.com>

More in general please do not add any tags, other then Cc or your own
Signed-off-by, unless you've actually received those tags in an email
from people.

Regards,

Hans

p.s.

About the patch itself, I'll try to test this on sunxi devices to
make sure that it does not break anything this weekend.



> ---
>  drivers/ata/libahci_platform.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 3a5b4ed..a958a2b 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -364,6 +364,19 @@ int ahci_platform_init_host(struct platform_device *pdev,
>  			ap->ops = &ata_dummy_port_ops;
>  	}
>  
> +	if (hpriv->cap & HOST_CAP_64) {
> +		rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +		if (rc) {
> +			rc = dma_coerce_mask_and_coherent(dev,
> +							  DMA_BIT_MASK(32));
> +			if (rc) {
> +				dev_err(dev, "Failed to enable 64-bit DMA.\n");
> +				return rc;
> +			}
> +			dev_warn(dev, "Enable 32-bit DMA instead of 64-bit.\n");
> +		}
> +	}
> +
>  	rc = ahci_reset_controller(host);
>  	if (rc)
>  		return rc;
> 
