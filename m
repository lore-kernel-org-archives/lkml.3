Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3IQHaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:30:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:34590 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3IQHah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:30:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,921,1371106800"; 
   d="scan'208";a="379347392"
Date: Tue, 17 Sep 2013 12:11:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: kgene.kim@samsung.com, Dan Williams <djbw@fb.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v4 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Message-ID: <20130917064123.GQ17188@intel.com>
References: <201309050033.50333.heiko@sntech.de>
 <201309050035.24237.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309050035.24237.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 12:35:23AM +0200, Heiko Stübner wrote:
> This adds a new driver to support the s3c24xx dma using the dmaengine
> and makes the old one in mach-s3c24xx obsolete in the long run.
> 
> Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> with numerous virtual channels being mapped to a lot less physical ones.
> The driver therefore borrows a lot from the amba-pl08x driver in this
> regard. Functionality-wise the driver gains a memcpy ability in addition
> to the slave_sg one.
> 
> The driver supports both the method for requesting the peripheral used
> by SoCs before the S3C2443 and the different method for S3C2443 and later.
> 
> On earlier SoCs the hardware channels usable for specific peripherals is
> constrainted while on later SoCs all channels can be used for any peripheral.
> 
> Tested on a s3c2416-based board, memcpy using the dmatest module and
> slave_sg partially using the spi-s3c64xx driver.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> +static enum dma_status s3c24xx_dma_tx_status(struct dma_chan *chan,
> +		dma_cookie_t cookie, struct dma_tx_state *txstate)
> +{
> +	struct s3c24xx_dma_chan *s3cchan = to_s3c24xx_dma_chan(chan);
> +	struct virt_dma_desc *vd;
> +	unsigned long flags;
> +	enum dma_status ret;
> +	size_t bytes = 0;
> +
> +	ret = dma_cookie_status(chan, cookie, txstate);
> +	if (ret == DMA_SUCCESS)
> +		return ret;
> +
> +	/*
> +	 * There's no point calculating the residue if there's
> +	 * no txstate to store the value.
> +	 */
> +	if (!txstate)
> +		return ret;
> +
> +	spin_lock_irqsave(&s3cchan->vc.lock, flags);
> +	ret = dma_async_is_complete(cookie, txstate->last, txstate->used);
Did you see what dma_cookie_status() does. There is no need to call
dma_async_is_complete() here!

> +	if (ret != DMA_SUCCESS) {
> +		struct s3c24xx_txd *txd;
> +		struct s3c24xx_sg *dsg;
> +
> +		vd = vchan_find_desc(&s3cchan->vc, cookie);
> +		if (vd) {
> +			/* On the issued list, so hasn't been processed yet */
> +			txd = to_s3c24xx_txd(&vd->tx);
> +
> +			list_for_each_entry(dsg, &txd->dsg_list, node)
> +				bytes += dsg->len;
> +		} else {
> +			/*
> +			 * Currently running, so sum over the pending sg's and
> +			 * the currently active one.
> +			 */
> +			txd = s3cchan->at;
> +
> +			dsg = list_entry(txd->at, struct s3c24xx_sg, node);
> +			list_for_each_entry_from(dsg, &txd->dsg_list, node);
> +				bytes += dsg->len;
> +
> +			bytes += s3c24xx_dma_getbytes_chan(s3cchan);
> +		}
> +	}
> +	spin_unlock_irqrestore(&s3cchan->vc.lock, flags);
> +
> +	/*
> +	 * This cookie not complete yet
> +	 * Get number of bytes left in the active transactions and queue
> +	 */
> +	dma_set_residue(txstate, bytes);
> +
> +	/* Whether waiting or running, we're in progress */
> +	return ret;

Aprt form this driver looks fine to me...

~Vinod

-- 
