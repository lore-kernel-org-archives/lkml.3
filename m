Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaCLQQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:16:09 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39042 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaCLQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:16:07 -0400
Message-ID: <53208845.5090305@kernel.dk>
Date: Wed, 12 Mar 2014 10:16:05 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Felipe Franciosi <felipe@paradoxo.org>, linux-kernel@vger.kernel.org
CC: Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Don't bounce IO requests
References: <1394640348-9109-1-git-send-email-felipe@paradoxo.org> <1394640348-9109-2-git-send-email-felipe@paradoxo.org>
In-Reply-To: <1394640348-9109-2-git-send-email-felipe@paradoxo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 10:05 AM, Felipe Franciosi wrote:
> This device support 64-bit DMA and therefore no IO requests needs bouncing.
> On 32-bit systems, blk_queue_bounce() will bounce all IO requests with high
> mem pages. This makes performance really really bad.
>
> Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
> ---
>   drivers/block/mtip32xx/mtip32xx.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index 5160269..24c87fdb 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -4082,8 +4082,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
>
>   	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
>   	if (likely(sg != NULL)) {
> -		blk_queue_bounce(queue, &bio);
> -
>   		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
>   			dev_warn(&dd->pdev->dev,
>   				"Maximum number of SGL entries exceeded\n");

That seems to be because the driver forgets to set the DMA capabilities. 
It needs a blk_queue_bounce_limit() call when it sets up the queue.

-- 
Jens Axboe

