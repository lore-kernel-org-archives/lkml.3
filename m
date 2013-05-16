Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3EPHIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:08:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:42188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab3EPHIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="334928909"
Date: Thu, 16 May 2013 12:02:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 34/39] dmaengine: ste_dma40: Convert data_width from
 register bit format to value
Message-ID: <20130516063244.GA14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-35-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368611522-9984-35-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:51:57AM +0100, Lee Jones wrote:
> When a DMA client requests and configures a DMA channel, it requests
> data_width in Bytes. The DMA40 driver then swiftly converts it over to
> the necessary register bit value. Unfortunately, for any subsequent
> calculations we have to shift '1' by the bit pattern (1 << data_width)
> times to make any sense of it.
> 
> This patch flips the semantics on its head and only converts the value
> to its respective register bit pattern when writing to registers. This
> way we can use the true data_width (in Bytes) value.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
  
> @@ -2804,14 +2781,24 @@ static int d40_set_runtime_config(struct dma_chan *chan,
>  		src_maxburst = dst_maxburst * dst_addr_width / src_addr_width;
>  	}
>  
> +	/* Only valid widths are; 1, 2, 4 and 8. */
> +	if (src_addr_width <= DMA_SLAVE_BUSWIDTH_UNDEFINED ||
> +	    src_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
> +	    dst_addr_width <= DMA_SLAVE_BUSWIDTH_UNDEFINED ||
> +	    dst_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
> +	    ((src_addr_width > 1) && (src_addr_width & 1)) ||
> +	    ((dst_addr_width > 1) && (dst_addr_width & 1)))
> +		return -EINVAL;
how about a simple macro to check above..

> +
> +	cfg->src_info.data_width = src_addr_width;
> +	cfg->dst_info.data_width = dst_addr_width;
> +
>  	ret = dma40_config_to_halfchannel(d40c, &cfg->src_info,
> -					  src_addr_width,
>  					  src_maxburst);
>  	if (ret)
>  		return ret;
>  
>  	ret = dma40_config_to_halfchannel(d40c, &cfg->dst_info,
> -					  dst_addr_width,
>  					  dst_maxburst);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
> index 5ddd724..a035dfe 100644
> --- a/drivers/dma/ste_dma40_ll.c
> +++ b/drivers/dma/ste_dma40_ll.c
> @@ -10,6 +10,18 @@
>  
>  #include "ste_dma40_ll.h"
>  
> +u8 d40_width_to_bits(enum dma_slave_buswidth width)
> +{
> +	if (width == DMA_SLAVE_BUSWIDTH_1_BYTE)
> +		return STEDMA40_ESIZE_8_BIT;
> +	else if (width == DMA_SLAVE_BUSWIDTH_2_BYTES)
> +		return STEDMA40_ESIZE_16_BIT;
> +	else if (width == DMA_SLAVE_BUSWIDTH_8_BYTES)
> +		return STEDMA40_ESIZE_64_BIT;
> +	else
> +		return STEDMA40_ESIZE_32_BIT;
> +}
> +
Switch looks better for this and how about
	return fls(width);

as your defines are 0...3 and dmaengine define 1,2,..8 for same thing
then you can also get rid of STEDMA40_XXX_WIDTH macros!


> @@ -70,13 +70,6 @@ enum stedma40_flow_ctrl {
>  	STEDMA40_FLOW_CTRL,
>  };
>  
> -enum stedma40_periph_data_width {
> -	STEDMA40_BYTE_WIDTH = STEDMA40_ESIZE_8_BIT,
> -	STEDMA40_HALFWORD_WIDTH = STEDMA40_ESIZE_16_BIT,
> -	STEDMA40_WORD_WIDTH = STEDMA40_ESIZE_32_BIT,
> -	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
> -};
nice

--
~Vinod
