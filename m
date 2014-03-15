Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaCOW4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 18:56:31 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62773 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbaCOW43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 18:56:29 -0400
Message-ID: <5324E8AD.6000206@cogentembedded.com>
Date: Sun, 16 Mar 2014 02:56:29 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>, jcliburn@gmail.com,
        chris.snook@gmail.com, davem@davemloft.net, johannes@sipsolutions.net,
        jg1.han@samsung.com, wangyijing@huawei.com, linux@hahnjo.de,
        sd@queasysnail.net, hahnjo@hahnjo.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ATHEROS-ALX: Use dma_set_mask_and_coherent and fix a
 bug
References: <1394907548-10084-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1394907548-10084-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/15/2014 09:19 PM, Peter Senna Tschudin wrote:

>   1. For the 64 bits dma mask use dma_set_mask_and_coherent instead of
>   dma_set_mask and dma_set_coherent_mask.

>   2. For the 32 bits dma mask dma_set_coherent_mask is only called if
>   dma_set_mask fails, which is unusual. Assuming this as a bug, fixes
>   it by replacing calls to dma_set_mask and dma_set_coherent_mask by a
>   call to dma_set_coherent_mask.

    You meant to say dma_set_mask_and_coherent() here?

>   Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---

>   Tested by compilation only.

>   drivers/net/ethernet/atheros/alx/main.c | 14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)

> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
> index 2e45f6e..380d249 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1248,19 +1248,13 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	 * shared register for the high 32 bits, so only a single, aligned,
>   	 * 4 GB physical address range can be used for descriptors.
>   	 */
> -	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
> -	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
> +	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
>   		dev_dbg(&pdev->dev, "DMA to 64-BIT addresses\n");
>   	} else {
> -		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>   		if (err) {
> -			err = dma_set_coherent_mask(&pdev->dev,
> -						    DMA_BIT_MASK(32));
> -			if (err) {
> -				dev_err(&pdev->dev,
> -					"No usable DMA config, aborting\n");
> -				goto out_pci_disable;
> -			}
> +			dev_err(&pdev->dev, "No usable DMA config, aborting\n");
> +			goto out_pci_disable;
>   		}
>   	}

WBR, Sergei


