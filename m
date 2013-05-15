Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948Ab3EOSxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:53:34 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44736 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab3EOSxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <201305111331.25405.heiko@sntech.de>
References: <201305111330.05046.heiko@sntech.de>
	<201305111331.25405.heiko@sntech.de>
Date: Wed, 15 May 2013 20:53:32 +0200
Message-ID: <CACRpkdaT195McX9NeccJYpmWbuYK-AZUTHr9AXKHnJdkf+Qzuw@mail.gmail.com>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 1:31 PM, Heiko Stübner <heiko@sntech.de> wrote:

> This adds a new driver to support the s3c24xx dma using the dmaengine
> and make the old one in mach-s3c24xx obsolete in the long run.
>
> Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> with numerous virtual channels being mapped to a lot less physical ones.
> The driver therefore borrows a lot from the amba-pl08x driver in this
> regard. Functionality-wise the driver gains a memcpy ability in addition
> to the slave_sg one.
>
> The driver currently only supports the "newer" SoCs which can use any
> physical channel for any dma slave. Support for the older SoCs where
> each channel only supports a subset of possible dma slaves will have to
> be added later.
>
> Tested on a s3c2416-based board, memcpy using the dmatest module and
> slave_sg partially using the spi-s3c64xx driver.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
(...)
> +static u32 s3c24xx_dma_getbytes_chan(struct s3c24xx_dma_chan *s3cchan)
> +{
> +       struct s3c24xx_dma_phy *phy = s3cchan->phy;
> +       struct s3c24xx_txd *txd = s3cchan->at;
> +       u32 tc = readl(phy->base + DSTAT) & DSTAT_CURRTC_MASK;
> +
> +       switch (txd->dcon & DCON_DSZ_MASK) {
> +       case DCON_DSZ_BYTE:
> +               return tc;
> +       case DCON_DSZ_HALFWORD:
> +               return tc * 2;
> +       case DCON_DSZ_WORD:
> +               return tc * 4;
> +       default:
> +               break;
> +       }
> +
> +       BUG();

Isn't that a bit nasty. This macro should be used with care and we
should recover if possible. dev_err()?

> +/*
> + * Set the initial DMA register values.
> + * Put them into the hardware and start the transfer.
> + */
> +static void s3c24xx_dma_start_next_txd(struct s3c24xx_dma_chan *s3cchan)
> +{
> +       struct s3c24xx_dma_engine *s3cdma = s3cchan->host;
> +       struct s3c24xx_dma_phy *phy = s3cchan->phy;
> +       struct virt_dma_desc *vd = vchan_next_desc(&s3cchan->vc);
> +       struct s3c24xx_txd *txd = to_s3c24xx_txd(&vd->tx);
> +       u32 dcon = txd->dcon;
> +       u32 val;
> +
> +       list_del(&txd->vd.node);
> +
> +       s3cchan->at = txd;
> +
> +       /* Wait for channel inactive */
> +       while (s3c24xx_dma_phy_busy(phy))
> +               cpu_relax();
> +
> +       /* transfer-size and -count from len and width */
> +       switch (txd->width) {
> +       case 1:
> +               dcon |= DCON_DSZ_BYTE | txd->len;
> +               break;
> +       case 2:
> +               dcon |= DCON_DSZ_HALFWORD | (txd->len / 2);
> +               break;
> +       case 4:
> +               dcon |= DCON_DSZ_WORD | (txd->len / 4);
> +               break;
> +       }
> +
> +       if (s3cchan->slave) {
> +               if (s3cdma->sdata->has_reqsel) {
> +                       int reqsel = s3cdma->pdata->reqsel_map[s3cchan->id];
> +                       writel((reqsel << 1) | DMAREQSEL_HW,
> +                              phy->base + DMAREQSEL);
> +               } else {
> +                       dev_err(&s3cdma->pdev->dev, "non-reqsel unsupported\n");
> +                       return;
> +                       dcon |= DCON_HWTRIG;
> +               }
> +       } else {
> +               if (s3cdma->sdata->has_reqsel) {
> +                       writel(0, phy->base + DMAREQSEL);
> +               } else {
> +                       dev_err(&s3cdma->pdev->dev, "non-reqsel unsupported\n");
> +                       return;
> +               }
> +       }
> +
> +       writel(txd->src_addr, phy->base + DISRC);
> +       writel(txd->disrcc, phy->base + DISRCC);
> +       writel(txd->dst_addr, phy->base + DIDST);
> +       writel(txd->didstc, phy->base + DIDSTC);
> +
> +       writel(dcon, phy->base + DCON);
> +
> +       val = readl(phy->base + DMASKTRIG);
> +       val &= ~DMASKTRIG_STOP;
> +       val |= DMASKTRIG_ON;
> +       writel(val, phy->base + DMASKTRIG);
> +
> +       /* trigger the dma operation for memcpy transfers */
> +       if (!s3cchan->slave) {
> +               val = readl(phy->base + DMASKTRIG);
> +               val |= DMASKTRIG_SWTRIG;
> +               writel(val, phy->base + DMASKTRIG);
> +       }
> +}

Since you have a few readl() and writel() in potentially
time-critical code, consider using readl_relaxed() and
writel_relaxed().

> +static irqreturn_t s3c24xx_dma_irq(int irq, void *data)
> +{
> +       struct s3c24xx_dma_phy *phy = data;
> +       struct s3c24xx_dma_chan *s3cchan = phy->serving;
> +       struct s3c24xx_txd *txd;
> +
> +       dev_dbg(&phy->host->pdev->dev, "interrupt on channel %d\n", phy->id);
> +
> +       if (!s3cchan) {
> +               dev_err(&phy->host->pdev->dev, "interrupt on unused channel %d\n",
> +                       phy->id);
> +               return IRQ_NONE;
> +       }
> +
> +       spin_lock(&s3cchan->vc.lock);
> +       txd = s3cchan->at;
> +       if (txd) {
> +               s3cchan->at = NULL;
> +               vchan_cookie_complete(&txd->vd);
> +
> +               /*
> +                * And start the next descriptor (if any),
> +                * otherwise free this channel.
> +                */
> +               if (vchan_next_desc(&s3cchan->vc))
> +                       s3c24xx_dma_start_next_txd(s3cchan);
> +               else
> +                       s3c24xx_dma_phy_free(s3cchan);
> +       }
> +       spin_unlock(&s3cchan->vc.lock);
> +
> +       return IRQ_HANDLED;
> +}

OK so one IRQ per channel. Is there really no status
register to check or flag to clear on these IRQs?

Apart from these smallish things it looks good to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
