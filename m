Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaGTOS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:18:58 -0400
Received: from smtp-out-215.synserver.de ([212.40.185.215]:1029 "EHLO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752360AbaGTOS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:18:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4941
Message-ID: <53CBCFBF.1040208@metafoo.de>
Date: Sun, 20 Jul 2014 16:18:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dan Williams <dan.j.williams@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: pl330: Check if the DMA descriptor is
 NULL
References: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2014 03:21 AM, Javier Martinez Canillas wrote:
> Commit 6079d38 ("dmaengine: pl330: Remove useless xfer_cb indirection")
> removed the __callback() function which created an unnecessary level of
> indirection to execute the tranfer callback .xfer_cb
>
> Unfortunately the commit also changed the semantics slightly since that
> function used to check if the request was not NULL before attempting to
> execute the callback function. Not checking this could lead to a kernel
> NULL pointer dereference error.

This should not happen, but I guess it can happen when terminal_all() is 
called. (It's wrong to try to complete a descriptor from terminal_all() in 
the first place, but that's a different issue)

>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>   drivers/dma/pl330.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index bc5878a..a55d754 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -1441,9 +1441,14 @@ xfer_exit:
>
>   static void dma_pl330_rqcb(struct dma_pl330_desc *desc, enum pl330_op_err err)
>   {
> -	struct dma_pl330_chan *pch = desc->pchan;
> +	struct dma_pl330_chan *pch;
>   	unsigned long flags;
>
> +	if (!desc)
> +		return;
> +
> +	pch = desc->pchan;
> +
>   	/* If desc aborted */
>   	if (!pch)
>   		return;
>

