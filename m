Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaCPJty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 05:49:54 -0400
Received: from ms-10.1blu.de ([178.254.4.101]:49903 "EHLO ms-10.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaCPJtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 05:49:52 -0400
X-Greylist: delayed 4201 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2014 05:49:52 EDT
Message-ID: <1394959174.5764.4.camel@archlinux-laptop.fritz.box>
Subject: Re: [PATCH V2] ATHEROS-ALX: Use dma_set_mask_and_coherent and fix a
 bug
From: hahnjo <hahnjo@hahnjo.de>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: jcliburn@gmail.com, chris.snook@gmail.com, davem@davemloft.net,
        johannes@sipsolutions.net, jg1.han@samsung.com, wangyijing@huawei.com,
        sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 16 Mar 2014 09:39:34 +0100
In-Reply-To: <1394926252-2269-1-git-send-email-peter.senna@gmail.com>
References: <1394926252-2269-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Con-Id: 154395
X-Con-U: 0-hahnjo
X-Originating-IP: 93.201.36.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 16.03.2014, 00:30 +0100 schrieb Peter Senna Tschudin:
>  1. For the 64 bits dma mask use dma_set_mask_and_coherent instead of
>  dma_set_mask and dma_set_coherent_mask.
> 
>  2. For the 32 bits dma mask dma_set_coherent_mask is only called if
>  dma_set_mask fails, which is unusual. Assuming this as a bug, fixes
>  it by replacing calls to dma_set_mask and dma_set_coherent_mask by a
>  call to dma_set_mask_and_coherent.
>  
Tested-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
>  Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
> 
>  Tested by compilation only.
> 
>  Change from V1: Updated commit message.
> 
>  drivers/net/ethernet/atheros/alx/main.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
> index 2e45f6e..380d249 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1248,19 +1248,13 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	 * shared register for the high 32 bits, so only a single, aligned,
>  	 * 4 GB physical address range can be used for descriptors.
>  	 */
> -	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
> -	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
> +	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
>  		dev_dbg(&pdev->dev, "DMA to 64-BIT addresses\n");
>  	} else {
> -		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>  		if (err) {
> -			err = dma_set_coherent_mask(&pdev->dev,
> -						    DMA_BIT_MASK(32));
> -			if (err) {
> -				dev_err(&pdev->dev,
> -					"No usable DMA config, aborting\n");
> -				goto out_pci_disable;
> -			}
> +			dev_err(&pdev->dev, "No usable DMA config, aborting\n");
> +			goto out_pci_disable;
>  		}
>  	}
>  

No obvious problems noticed on my ASUS N56VZ.

