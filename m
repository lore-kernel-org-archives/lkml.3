Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaBSBOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:14:39 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53810 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaBSBOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:14:38 -0500
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: devel@driverdev.osuosl.org, mark.einon@gmail.com,
        linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] et131x: fix allocation failures
References: <20140217141252.26738.33549.stgit@alan.etchedpixels.co.uk>
Date: Wed, 19 Feb 2014 09:14:19 +0800
In-Reply-To: <20140217141252.26738.33549.stgit@alan.etchedpixels.co.uk>
	(Alan's message of "Mon, 17 Feb 2014 14:13:08 +0000")
Message-ID: <874n3v52fo.fsf@will.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, thanks for resending this patch. But it seems you overlooked
something we discussed earlier.

On Mon, 2014-02-17 at 22:13:08 +0800, Alan wrote:
> We should check the ring allocations don't fail.
> If we get a fail we need to clean up properly. The allocator assumes the
> deallocator will be used on failure, but it isn't. Make sure the
> right deallocator is always called and add a missing check against
> fbr allocation failure.
>
> [v2]: Correct check logic
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/staging/et131x/et131x.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index 6413500..cc600df 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -2124,7 +2124,11 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
>  
>  	/* Alloc memory for the lookup table */
>  	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
> +	if (rx_ring->fbr[0] == NULL)
> +		return -ENOMEM;
>  	rx_ring->fbr[1] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
> +	if (rx_ring->fbr[1] == NULL)
> +		return -ENOMEM;

Shouldn't rx_ring->fbr[0] be freed when allocation of rx_ring->fbr[1]
fails ? Or we will leak memory here.

>  
>  	/* The first thing we will do is configure the sizes of the buffer
>  	 * rings. These will change based on jumbo packet support.  Larger
> @@ -2289,7 +2293,7 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
>  	for (id = 0; id < NUM_FBRS; id++) {
>  		fbr = rx_ring->fbr[id];
>  
> -		if (!fbr->ring_virtaddr)
> +		if (!fbr || !fbr->ring_virtaddr)
>  			continue;
>  
>  		/* First the packet memory */
> @@ -3591,6 +3595,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
>  	if (status) {
>  		dev_err(&adapter->pdev->dev,
>  			  "et131x_tx_dma_memory_alloc FAILED\n");
> +		et131x_tx_dma_memory_free(adapter);
>  		return status;
>  	}
>  	/* Receive buffer memory allocation */
> @@ -3598,7 +3603,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
>  	if (status) {
>  		dev_err(&adapter->pdev->dev,
>  			  "et131x_rx_dma_memory_alloc FAILED\n");
> -		et131x_tx_dma_memory_free(adapter);
> +		et131x_adapter_memory_free(adapter);
>  		return status;
>  	}
>  
