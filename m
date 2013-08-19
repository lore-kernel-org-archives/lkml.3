Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890Ab3HSFb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 01:31:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:4231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab3HSFbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 01:31:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,910,1367996400"; 
   d="scan'208";a="364684723"
Date: Mon, 19 Aug 2013 10:18:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: kgene.kim@samsung.com, Dan Williams <djbw@fb.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Message-ID: <20130819044811.GR32147@intel.com>
References: <201308141359.13872.heiko@sntech.de>
 <201308141400.25681.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201308141400.25681.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 02:00:25PM +0200, Heiko Stübner wrote:
> This adds a new driver to support the s3c24xx dma using the dmaengine
> and makes the old one in mach-s3c24xx obsolete in the long run.
> 
> Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> with numerous virtual channels being mapped to a lot less physical ones.
> The driver therefore borrows a lot from the amba-pl08x driver in this
> regard. Functionality-wise the driver gains a memcpy ability in addition
> to the slave_sg one.
If that is the case why cant we have this driver supported from pl08x driver? If
the delta is only mapping then can that be seprated or both mapping hanlded?
Maybe you and Linus have already though about that?

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

> +#define DISRC			(0x00)
> +#define DISRCC			(0x04)
> +#define DISRCC_INC_INCREMENT	(0 << 0)
> +#define DISRCC_INC_FIXED	(1 << 0)
> +#define DISRCC_LOC_AHB		(0 << 1)
> +#define DISRCC_LOC_APB		(1 << 1)
> +
> +#define DIDST			(0x08)
> +#define DIDSTC			(0x0C)
> +#define DIDSTC_INC_INCREMENT	(0 << 0)
> +#define DIDSTC_INC_FIXED	(1 << 0)
> +#define DIDSTC_LOC_AHB		(0 << 1)
> +#define DIDSTC_LOC_APB		(1 << 1)
> +#define DIDSTC_INT_TC0		(0 << 2)
> +#define DIDSTC_INT_RELOAD	(1 << 2)
> +
> +#define DCON			(0x10)
> +
> +#define DCON_TC_MASK		0xfffff
> +#define DCON_DSZ_BYTE		(0 << 20)
> +#define DCON_DSZ_HALFWORD	(1 << 20)
> +#define DCON_DSZ_WORD		(2 << 20)
> +#define DCON_DSZ_MASK		(3 << 20)
> +#define DCON_DSZ_SHIFT		20
> +#define DCON_AUTORELOAD		(0 << 22)
> +#define DCON_NORELOAD		(1 << 22)
> +#define DCON_HWTRIG		(1 << 23)
> +#define DCON_HWSRC_SHIFT	24
> +#define DCON_SERV_SINGLE	(0 << 27)
> +#define DCON_SERV_WHOLE		(1 << 27)
> +#define DCON_TSZ_UNIT		(0 << 28)
> +#define DCON_TSZ_BURST4		(1 << 28)
> +#define DCON_INT		(1 << 29)
> +#define DCON_SYNC_PCLK		(0 << 30)
> +#define DCON_SYNC_HCLK		(1 << 30)
> +#define DCON_DEMAND		(0 << 31)
> +#define DCON_HANDSHAKE		(1 << 31)
> +
> +#define DSTAT			(0x14)
> +#define DSTAT_STAT_BUSY		(1 << 20)
> +#define DSTAT_CURRTC_MASK	0xfffff
> +
> +#define DMASKTRIG		(0x20)
> +#define DMASKTRIG_STOP		(1 << 2)
> +#define DMASKTRIG_ON		(1 << 1)
> +#define DMASKTRIG_SWTRIG	(1 << 0)
> +
> +#define DMAREQSEL		(0x24)
> +#define DMAREQSEL_HW		(1 << 0)
This is proper namespacing...

> +static int s3c24xx_dma_set_runtime_config(struct s3c24xx_dma_chan *s3cchan,
> +				  struct dma_slave_config *config)
> +{
> +	if (!s3cchan->slave)
> +		return -EINVAL;
> +
> +	/* Reject definitely invalid configurations */
> +	if (config->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
> +	    config->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
> +		return -EINVAL;
> +
> +	s3cchan->cfg = *config;
you are takinga  ref to client pointer without a clue on when that would be
freed. I dont think its a good idea!

> +static irqreturn_t s3c24xx_dma_irq(int irq, void *data)
> +{
> +	struct s3c24xx_dma_phy *phy = data;
> +	struct s3c24xx_dma_chan *s3cchan = phy->serving;
> +	struct s3c24xx_txd *txd;
> +
> +	dev_dbg(&phy->host->pdev->dev, "interrupt on channel %d\n", phy->id);
> +
> +	if (!s3cchan) {
> +		dev_err(&phy->host->pdev->dev, "interrupt on unused channel %d\n",
> +			phy->id);
> +		return IRQ_NONE;
hmmm, these channles belong to you. So if one of them is behvaing badly, then
not handling the interrupt will make things worse...

~Vinod
