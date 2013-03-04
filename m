Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3CDFqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:46:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:21245 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3CDFqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:46:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,777,1355126400"; 
   d="scan'208";a="298564608"
Date: Mon, 4 Mar 2013 11:15:56 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Boojin Kim <boojin.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Dan Williams'" <djbw@fb.com>,
        "'Jaswinder Singh'" <jassi.brar@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Subject: Re: [PATCH 2/2] ARM: EXYNOS: support burst mode for for dev-to-mem
 and dev-to-mem transmit
Message-ID: <20130304054556.GG22513@intel.com>
References: <00eb01ce0e45$20223c90$6066b5b0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00eb01ce0e45$20223c90$6066b5b0$%kim@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 11:02:09AM +0900, Boojin Kim wrote:
> This patch adds to support burst mode for for dev-to-mem and dev-to-mem transmit
> 
> Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> ---
>  arch/arm/plat-samsung/dma-ops.c              |   10 ++++++++--
>  arch/arm/plat-samsung/include/plat/dma-ops.h |    1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
> index d088afa..c25e842 100644
> --- a/arch/arm/plat-samsung/dma-ops.c
> +++ b/arch/arm/plat-samsung/dma-ops.c
> @@ -54,14 +54,20 @@ static int samsung_dmadev_config(unsigned ch,
>  		slave_config.direction = param->direction;
>  		slave_config.src_addr = param->fifo;
>  		slave_config.src_addr_width = param->width;
> -		slave_config.src_maxburst = 1;
Hi Boojin,

what do you mean by the busrt mode here?

fwiw the meanining of above maxburst is:
@src_maxburst: the maximum number of words (note: words, as in
units of the src_addr_width member, not bytes) that can be sent
in one burst to the device. Typically something like half the
FIFO depth on I/O peripherals so you don't overflow it. This
may or may not be applicable on memory sources.

> +		if (param->maxburst)
> +			slave_config.src_maxburst = param->maxburst;
> +		else
> +			slave_config.src_maxburst = 1;
>  		dmaengine_slave_config(chan, &slave_config);
>  	} else if (param->direction == DMA_MEM_TO_DEV) {
>  		memset(&slave_config, 0, sizeof(struct dma_slave_config));
>  		slave_config.direction = param->direction;
>  		slave_config.dst_addr = param->fifo;
>  		slave_config.dst_addr_width = param->width;
> -		slave_config.dst_maxburst = 1;
> +		if (param->maxburst)
> +			slave_config.dst_maxburst = param->maxburst;
> +		else
> +			slave_config.dst_maxburst = 1;
>  		dmaengine_slave_config(chan, &slave_config);
>  	} else {
>  		pr_warn("unsupported direction\n");
> diff --git a/arch/arm/plat-samsung/include/plat/dma-ops.h b/arch/arm/plat-samsung/include/plat/dma-ops.h
> index f5144cd..95893c7 100644
> --- a/arch/arm/plat-samsung/include/plat/dma-ops.h
> +++ b/arch/arm/plat-samsung/include/plat/dma-ops.h
> @@ -35,6 +35,7 @@ struct samsung_dma_prep {
>  struct samsung_dma_config {
>  	enum dma_transfer_direction direction;
>  	enum dma_slave_buswidth width;
> +	u32 maxburst;
>  	dma_addr_t fifo;
>  };
> 
> --
> 1.7.5.4
> 
> 
> 
