Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3JUHrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:47:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:22973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3JUHrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,537,1378882800"; 
   d="scan'208";a="420012184"
Date: Mon, 21 Oct 2013 12:23:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Matt Porter <matt@ohporter.com>, Mark Brown <broonie@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jyri Sarha <jsarha@ti.com>, Lars Peter-Clausen <lars@metafoo.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/3] dma: edma: Add support for Cyclic DMA
Message-ID: <20131021065319.GM14013@intel.com>
References: <1379977515-3794-1-git-send-email-joelf@ti.com>
 <1379977515-3794-3-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379977515-3794-3-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:05:14PM -0500, Joel Fernandes wrote:
 
> @@ -449,6 +455,138 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
>  }
>  
> +static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
> +	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +	size_t period_len, enum dma_transfer_direction direction,
> +	unsigned long tx_flags, void *context)
> +{
> +	struct edma_chan *echan = to_edma_chan(chan);
> +	struct device *dev = chan->device->dev;
> +	struct edma_desc *edesc;
> +	dma_addr_t src_addr, dst_addr;
> +	enum dma_slave_buswidth dev_width;
> +	u32 burst;
> +	int i, ret, nr_periods;
> +
> +	if (unlikely(!echan || !buf_len || !period_len))
> +		return NULL;
> +
> +	if (direction == DMA_DEV_TO_MEM) {
> +		src_addr = echan->cfg.src_addr;
> +		dst_addr = buf_addr;
> +		dev_width = echan->cfg.src_addr_width;
> +		burst = echan->cfg.src_maxburst;
> +	} else if (direction == DMA_MEM_TO_DEV) {
> +		src_addr = buf_addr;
> +		dst_addr = echan->cfg.dst_addr;
> +		dev_width = echan->cfg.dst_addr_width;
> +		burst = echan->cfg.dst_maxburst;
> +	} else {
> +		dev_err(dev, "%s: bad direction?\n", __func__);
> +		return NULL;
> +	}
> +
> +	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
> +		dev_err(dev, "Undefined slave buswidth\n");
> +		return NULL;
> +	}
> +
> +	if (unlikely(buf_len % period_len)) {
> +		dev_err(dev, "Period should be multiple of Buffer length\n");
> +		return NULL;
> +	}
> +
> +	nr_periods = (buf_len / period_len) + 1;
?

consider the case of buf = period_len, above makes nr_period = 2.

Or buf len 100, period len 50, makes nr_period = 3

Both doesnt seem right to me?

--
~Vinod
