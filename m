Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab3G2Qfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:35:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3G2Qfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:35:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v4] dmaengine: Add MOXA ART DMA engine driver
Date: Mon, 29 Jul 2013 18:35:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com,
        linux@arm.linux.org.uk
References: <1374055584-15746-1-git-send-email-jonas.jensen@gmail.com> <1375105442-14827-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1375105442-14827-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307291835.21151.arnd@arndb.de>
X-Provags-ID: V02:K0:Dzs1oAodBx5MXgJE7onrreKT44WB+0LyV5TE7SQDfK3
 RgOBFr5IgUAOe1AwyJqMyDeLaWLlD1A4ykrrrMrz1FseCmLuKZ
 Fa7LSP8XKQR6OMfme5lwiHsoDfBCFTzcYZeHWJyKBgjAJ3j5rc
 yIOyWs9C5X2n/E+fCPiFjQsVhfNNbJ3iI1BO/KrDkxyFGul8e8
 P6kxlqqs3pKRR9vKocDFzyjav68VoD6mjmfpD6JBhfBu27zv/T
 zdb7O3m/oJCyoMDK3u28T4d0v5WxlY2kjCEsEtPoTARZY8oCdR
 vwX3McRhA+9agzxuh+OkwOw6Nm203S2/smq2wkrkZZCSWoaEGe
 xyLNEH2AirvYOPKdUHd0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 July 2013, Jonas Jensen wrote:

> diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> new file mode 100644
> index 0000000..f18f0fb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> @@ -0,0 +1,19 @@
> +MOXA ART DMA Controller
> +
> +See dma.txt first
> +
> +Required properties:
> +
> +- compatible : Must be "moxa,moxart-dma"
> +- reg : Should contain registers location and length
> +- interrupts : Should contain the interrupt number
> +- #dma-cells : see dma.txt, should be 1
> +
> +Example:
> +
> +	dma: dma@90500000 {
> +		compatible = "moxa,moxart-dma";
> +		reg = <0x90500000 0x1000>;
> +		interrupts = <24 0>;
> +		#dma-cells = <1>;
> +	};

The binding should really define what the one cell in the dma specifier refers
to. For all I can tell, it is a hardcoded channel number, and each channel
corresponds to exactly one slave request line.

> +static DEFINE_SPINLOCK(dma_lock);

Can't this be part of the device structure? You should not need a global lock here.

> +struct moxart_dma_container {
> +	int			ctlr;
> +	struct dma_device	dma_slave;
> +	struct moxart_dma_chan	slave_chans[APB_DMA_MAX_CHANNEL];
> +};
> +
> +struct moxart_dma_container *mdc;

Same here. Also, you should never have global identifiers with just three characters.
Most of your 'static' variables are already prefixed "moxart_".

> +static int moxart_slave_config(struct dma_chan *chan,
> +			       struct dma_slave_config *cfg)
> +{
> +	struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
> +	union moxart_dma_reg_cfg mcfg;
> +	unsigned long flags;
> +	unsigned int data_width, data_inc;
> +
> +	spin_lock_irqsave(&dma_lock, flags);
> +
> +	memcpy(&mchan->cfg, cfg, sizeof(mchan->cfg));
> +
> +	mcfg.ul = readl(&mchan->reg->cfg.ul);
> +	mcfg.bits.burst = APB_DMAB_BURST_MODE;
> +
> +	switch (mchan->cfg.src_addr_width) {
> +	case DMA_SLAVE_BUSWIDTH_1_BYTE:
> +		data_width = APB_DMAB_DATA_WIDTH_1;
> +		data_inc = APB_DMAB_DEST_INC_1_4;
> +		break;
> +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> +		data_width = APB_DMAB_DATA_WIDTH_2;
> +		data_inc = APB_DMAB_DEST_INC_2_8;
> +		break;
> +	default:
> +		data_width = APB_DMAB_DATA_WIDTH_4;
> +		data_inc = APB_DMAB_DEST_INC_4_16;
> +		break;
> +	}
> +
> +	if (mchan->cfg.direction == DMA_MEM_TO_DEV) {
> +		mcfg.bits.data_width = data_width;
> +		mcfg.bits.dest_sel = APB_DMAB_DEST_APB;
> +		mcfg.bits.dest_inc = APB_DMAB_DEST_INC_0;
> +		mcfg.bits.source_sel = APB_DMAB_SOURCE_AHB;
> +		mcfg.bits.source_inc = data_inc;
> +
> +		mcfg.bits.dest_req_no = mchan->cfg.slave_id;
> +		mcfg.bits.source_req_no = 0;

You must not override the "dest_req_no" and "dest_req_no" in moxart_slave_config
since they are already set by the ->xlate() function and the driver calling 
slave_config generally has no knowledge of what the slave id is.

> +static struct platform_driver moxart_driver;

Please reorder the symbols so you don't need the forward declaration.

> +bool moxart_filter_fn(struct dma_chan *chan, void *param)
> +{
> +	if (chan->device->dev->driver == &moxart_driver.driver) {

No need to check the driver. What you want to check instead is that
the *device* matches.

> +		struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
> +		unsigned int ch_req = *(unsigned int *)param;
> +		dev_dbg(chan2dev(chan), "%s: mchan=%p ch_req=%d mchan->ch_num=%d\n",
> +			__func__, mchan, ch_req, mchan->ch_num);
> +		return ch_req == mchan->ch_num;
> +	} else {
> +		dev_dbg(chan2dev(chan), "%s: device not registered to this DMA engine\n",
> +			__func__);
> +		return false;
> +	}
> +}
> +EXPORT_SYMBOL(moxart_filter_fn);

Don't export the filter function. No slave driver should rely on this, since you
have DT probing.


> diff --git a/drivers/dma/moxart-dma.h b/drivers/dma/moxart-dma.h
> new file mode 100644
> index 0000000..a37b13f
> --- /dev/null
> +++ b/drivers/dma/moxart-dma.h

You don't need a separate file here, just move the contents into moxart-dma.c

> +union moxart_dma_reg_cfg {
> +
> +#define APB_DMA_ENABLE				BIT(0)
> +#define APB_DMA_FIN_INT_STS			BIT(1)
> +#define APB_DMA_FIN_INT_EN			BIT(2)
> +#define APB_DMA_BURST_MODE			BIT(3)
> +#define APB_DMA_ERR_INT_STS			BIT(4)
> +#define APB_DMA_ERR_INT_EN			BIT(5)
> +#define APB_DMA_SOURCE_AHB			BIT(6)
> +#define APB_DMA_SOURCE_APB			0
> +#define APB_DMA_DEST_AHB			BIT(7)
> +#define APB_DMA_DEST_APB			0
> +#define APB_DMA_SOURCE_INC_0			0
> +#define APB_DMA_SOURCE_INC_1_4			0x100
> +#define APB_DMA_SOURCE_INC_2_8			0x200
> +#define APB_DMA_SOURCE_INC_4_16			0x300
> +#define APB_DMA_SOURCE_DEC_1_4			0x500
> +#define APB_DMA_SOURCE_DEC_2_8			0x600
> +#define APB_DMA_SOURCE_DEC_4_16			0x700
> +#define APB_DMA_SOURCE_INC_MASK			0x700
> +#define APB_DMA_DEST_INC_0			0
> +#define APB_DMA_DEST_INC_1_4			0x1000
> +#define APB_DMA_DEST_INC_2_8			0x2000
> +#define APB_DMA_DEST_INC_4_16			0x3000
> +#define APB_DMA_DEST_DEC_1_4			0x5000
> +#define APB_DMA_DEST_DEC_2_8			0x6000
> +#define APB_DMA_DEST_DEC_4_16			0x7000
> +#define APB_DMA_DEST_INC_MASK			0x7000
> +#define APB_DMA_DEST_REQ_NO_MASK		0xf0000
> +#define APB_DMA_DATA_WIDTH_MASK			0x300000
> +#define APB_DMA_DATA_WIDTH_4			0
> +#define APB_DMA_DATA_WIDTH_2			0x100000
> +#define APB_DMA_DATA_WIDTH_1			0x200000
> +#define APB_DMA_SOURCE_REQ_NO_MASK		0xf000000
> +	unsigned int ul;
> +
> +	struct {
> +
> +#define APB_DMAB_ENABLE				1
> +		/* enable DMA */
> +		unsigned int enable:1;
> +
> +#define APB_DMAB_FIN_INT_STS			1
> +		/* finished interrupt status */
> +		unsigned int fin_int_sts:1;

The bit numbers don't actually match here if you build the kernel as
big-endian. You cannot use bitfields for hw data structures.

While you are here, get rid of the silly 'BIT' macro use as well.
Using hexadecimal literals is much clearer and you do that for
some fields anyway.

	Arnd
