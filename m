Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3GORL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:11:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:28066 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3GORL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,670,1367996400"; 
   d="scan'208";a="268565608"
Date: Mon, 15 Jul 2013 22:02:47 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: pl330: Implement device_slave_caps
Message-ID: <20130715163247.GU16653@intel.com>
References: <1373903588-19358-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373903588-19358-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 05:53:08PM +0200, Lars-Peter Clausen wrote:
> Implemnt the device_slave_caps() callback for the pl330 driver. This allows
typo ^^^^
> dmaengine users like the generic ALSA dmaengine PCM driver to query the
> capabilities of the driver. The PL330 supports all buswidths and both
> mem-to-dev as well as dev-to-mem transfers. In theory there is no limit on the
> number of segments that can be transferred (in practice you'll run out of memory
> eventually) and the number of bytes per segment is limited by the size of the
> PL330 program buffer. Due to the nature of the PL330 the maximum number of bytes
> per segment depends on the burstsize, the driver sets it to the value for a
> 1-byte burstsize, since it is the smallest.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/dma/pl330.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 593827b..2bf578c 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2855,6 +2855,32 @@ static irqreturn_t pl330_irq_handler(int irq, void *data)
>  		return IRQ_NONE;
>  }
>  
> +#define PL330_DMA_BUSWIDTHS \
> +	BIT(DMA_SLAVE_BUSWIDTH_UNDEFINED) | \
> +	BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) | \
> +	BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) | \
> +	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) | \
> +	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)
checkpatch cribs that this is complex macro and should be enclosed in a
parenthesis, I have ignored it as usage doesnt justify it, yet!
> +
> +static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
> +	struct dma_slave_caps *caps)
> +{
> +	caps->src_addr_widths = PL330_DMA_BUSWIDTHS;
> +	caps->dstn_addr_widths = PL330_DMA_BUSWIDTHS;
> +	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
> +	caps->cmd_pause = false;
> +	caps->cmd_terminate = true;
> +
> +	/* 
trailing whitepsace here!
> +	 * This is the limit for transfers with a buswidth of 1, larger buswidths
you could have sticked to 80 char rule here very easily...
> +	 * will have larger limits.
> +	 */
Now, i am catching a plane for a work trip tomorrow, so have fixed checkpatch
and typo and applied this.

~Vinod
