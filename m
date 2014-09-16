Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaIPNXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:23:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58885 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753423AbaIPNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:23:14 -0400
Date: Tue, 16 Sep 2014 14:22:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] dmaengine: omap-dma: Fix cyclic suspend/resume
Message-ID: <20140916132259.GE12379@n2100.arm.linux.org.uk>
References: <1410872785-14523-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410872785-14523-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 04:06:25PM +0300, Peter Ujfalusi wrote:
> When the audio stream is paused or suspended we stop the sDMA and when it
> is unpsues/resumed we start the channel without reconfiguring it.
> The omap_dma_stop() clears the link configuration when we pause the dma, but
> it is not setting it back on start. This will result only one audio buffer
> to be played back and the DMA will stop, since the linking is disabled.
> The link need to be enabled in omap_dma_start() to make sure that cyclic
> transfer can continue.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/omap-dma.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> index 4cf7d9a950d7..13a02ff87f28 100644
> --- a/drivers/dma/omap-dma.c
> +++ b/drivers/dma/omap-dma.c
> @@ -280,6 +280,7 @@ static void omap_dma_assign(struct omap_dmadev *od, struct omap_chan *c,
>  static void omap_dma_start(struct omap_chan *c, struct omap_desc *d)
>  {
>  	struct omap_dmadev *od = to_omap_dma_dev(c->vc.chan.device);
> +	uint32_t val;
>  
>  	if (__dma_omap15xx(od->plat->dma_attr))
>  		omap_dma_chan_write(c, CPC, 0);
> @@ -288,6 +289,17 @@ static void omap_dma_start(struct omap_chan *c, struct omap_desc *d)
>  
>  	omap_dma_clear_csr(c);
>  
> +	if (!__dma_omap15xx(od->plat->dma_attr) && c->cyclic) {
> +		val = omap_dma_chan_read(c, CLNK_CTRL);
> +
> +		if (dma_omap1())
> +			val &= ~(1 << 14); /* clear the STOP_LNK bit */
> +		else
> +			val |= CLNK_CTRL_ENABLE_LNK;
> +
> +		omap_dma_chan_write(c, CLNK_CTRL, val);
> +	}
> +

Why is this soo complicated?  What's wrong with simply writing the
stored value back from the omap_desc:

	omap_dma_chan_write(c, CLNK_CTRL, d->clnk_ctrl);

In fact, rather than loading up the above fast path with stuff which
it really doesn't need, why not do this in the resume path?  The
other thing which should be placed in the resume path is a mb() call,
since calling omap_dma_start() won't have a barrier in that path.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
