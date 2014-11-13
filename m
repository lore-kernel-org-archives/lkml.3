Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaKMRC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:02:58 -0500
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:33352 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753543AbaKMRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:02:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2902:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:6119:6261:7903:10004:10400:10848:10946:11026:11232:11658:11914:12296:12438:12517:12519:12555:12740:13069:13255:13311:13357:13870:14093:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wind61_195419307ab54
X-Filterd-Recvd-Size: 2835
Message-ID: <1415898172.4223.1.camel@perches.com>
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined reference
 to `__aeabi_uldivmod'"
From: Joe Perches <joe@perches.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 09:02:52 -0800
In-Reply-To: <1415896047.1787.4.camel@linaro.org>
References: <1415896047.1787.4.camel@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 16:27 +0000, Jon Medhurst (Tixy) wrote:
> 32-bit ARM kernels may have a 64-bit dma_addr_t but have no
> implementation of the compiler helper for 64-bit unsigned division,
> therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
> the link error "undefined reference to `__aeabi_uldivmod'"
> 
> As the burst value is always a power of two we can fix the problem, and
> make the code more efficient, by replacing "% burst" with "& (burst-1)".
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> ---
> 
> Vinod. I haven't added a 'Fixes:' line because I was unsure if the patch
> in linux-next is part of a stable branch or if the SHA1 might change
> before hitting mainline. If it stable then the line should be...
> 
> Fixes: 63369d0a96dc ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")
> 
> 
>  drivers/dma/pl330.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 38c9617..52c4c62 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2464,11 +2464,8 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
>  	 * parameters because our DMA programming algorithm doesn't cope with
>  	 * transfers which straddle an entry in the DMA device's MFIFO.
>  	 */
> -	while (burst > 1) {
> -		if (!((src | dst | len) % burst))
> -			break;
> +	while ((src | dst | len) & (burst - 1))
>  		burst /= 2;
> -	}

Maybe something like:

	div = ffs(src | dst | len);
	if (burst > 1 && div)
		burst >>= div;

?

dunno if dma_addr_t src or dst can ever be a 64 bit value
for AMBA or not.  If so, the ffs would need to be different.

Maybe:

	if (sizeof(dma_addr_t) == sizeof(u64))
		div = __ffs64(src | dst | len);
	else
		div = ffs(src | dst | len);
	if (burst > 1 && div)
		burst >>= div;


