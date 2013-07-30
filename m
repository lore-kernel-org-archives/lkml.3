Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab3G3JJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:09:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56415 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758249Ab3G3JJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:09:07 -0400
Date: Tue, 30 Jul 2013 10:08:32 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH v3] mmc: sdhci-moxart: Add MOXA ART SDHCI driver
Message-ID: <20130730090832.GB28716@e106331-lin.cambridge.arm.com>
References: <1374065502-27110-1-git-send-email-jonas.jensen@gmail.com>
 <1375094974-7536-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375094974-7536-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 11:49:34AM +0100, Jonas Jensen wrote:
> Add SDHCI driver for MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Changes since v2:
> 
>     1. #include <linux/bitops.h> because BIT() comes from there
>     2. reinsert dev_set_drvdata() in moxart_remove
>     3. remove MODULE_VERSION()
> 
>     device tree bindings document:
>     4. describe compatible variable "Must be" instead of "Should be".
>     5. change description so it's from the point of view of the device
> 
>     Applies to next-20130729
> 
>  .../devicetree/bindings/mmc/moxa,moxart-mmc.txt    |  17 +
>  drivers/mmc/host/Kconfig                           |   9 +
>  drivers/mmc/host/Makefile                          |   1 +
>  drivers/mmc/host/sdhci-moxart.c                    | 782 +++++++++++++++++++++
>  drivers/mmc/host/sdhci-moxart.h                    | 155 ++++
>  5 files changed, 964 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
>  create mode 100644 drivers/mmc/host/sdhci-moxart.c
>  create mode 100644 drivers/mmc/host/sdhci-moxart.h
> 
> diff --git a/Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt b/Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
> new file mode 100644
> index 0000000..67782ad
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
> @@ -0,0 +1,17 @@
> +MOXA ART SD Host Controller Interface
> +
> +Required properties:
> +
> +- compatible : Must be "moxa,moxart-mmc"
> +- reg : Should contain registers location and length
> +- interrupts : Should contain the interrupt number
> +- clocks : Should contain phandle for the clock feeding the SDHCI controller
> +
> +Example:
> +
> +       mmc: mmc@98e00000 {
> +               compatible = "moxa,moxart-mmc";
> +               reg = <0x98e00000 0x5C>;
> +               interrupts = <5 0>;
> +               clocks = <&coreclk>;
> +       };

This binding looks sensible, but I'd appreciate someone who understands
MMCs checking that this captures the relevant information, as I don't
know much about MMCs.

Most mmc bindings I see have to describe some gpio pins, pinctrl to mux
the relevant pins on from the SoC, etc. Is this a full description of
the hardware supporting all features?

[...]

> +static int moxart_get_ro(struct mmc_host *mmc)
> +{
> +       int ret;
> +       struct moxart_host *host = mmc_priv(mmc);
> +
> +       (readl(&host->reg->status) & MSD_WRITE_PROT) ? (ret = 1) : (ret = 0);
> +       return ret;

This looks a little odd, how about something like:

return !!(readl(&host->reg->status) & SD_WRITE_PROT);

> +}
> +
> +static struct mmc_host_ops moxart_ops = {
> +       .request = moxart_request,
> +       .set_ios = moxart_set_ios,
> +       .get_ro = moxart_get_ro,
> +};
> +
> +static int moxart_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct device_node *node = dev->of_node;
> +       struct resource res_mmc;
> +       struct mmc_host *mmc;
> +       struct moxart_host *host = NULL;
> +       void __iomem *reg_mmc;
> +       dma_cap_mask_t mask;
> +       int ret;
> +       struct dma_slave_config cfg;
> +       unsigned int irq;
> +       struct clk *clk;
> +       unsigned int dma_chan_rx_req = 1;
> +       unsigned int dma_chan_tx_req = 0;
> +
> +       mmc = mmc_alloc_host(sizeof(struct moxart_host), dev);
> +       if (!mmc) {
> +               dev_err(dev, "%s: mmc_alloc_host failed\n", __func__);
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       ret = of_address_to_resource(node, 0, &res_mmc);
> +       if (ret) {
> +               dev_err(dev, "%s: could not get MMC base resource\n", __func__);
> +               goto out;
> +       }
> +
> +       irq = irq_of_parse_and_map(node, 0);
> +
> +       reg_mmc = devm_ioremap_resource(dev, &res_mmc);
> +       if (IS_ERR(reg_mmc)) {
> +               dev_err(dev, "%s: devm_ioremap_resource res_mmc failed\n",
> +                       __func__);
> +               return PTR_ERR(reg_mmc);
> +       }
> +
> +       mmc->ops = &moxart_ops;
> +
> +       /*
> +        * hardware does not support MMC_CAP_SD_HIGHSPEED
> +        * CMD6 will timeout and make things not work
> +        */
> +       mmc->caps = MMC_CAP_4_BIT_DATA;
> +
> +       mmc->f_min = 400000;
> +       mmc->f_max = 25000000;
> +       mmc->ocr_avail = 0xffff00;      /* support 2.0v - 3.6v power */
> +       mmc->max_segs = 32;
> +       mmc->max_blk_size = 512;
> +       mmc->max_blk_count = mmc->max_req_size / mmc->max_blk_size;
> +       mmc->max_seg_size = mmc->max_req_size;
> +
> +       host = mmc_priv(mmc);
> +       host->mmc = mmc;
> +       host->reg = (struct moxart_reg *)reg_mmc;
> +       host->reg_phys = res_mmc.start;
> +       host->timeout = msecs_to_jiffies(1000);
> +
> +       dma_cap_zero(mask);
> +       dma_cap_set(DMA_SLAVE, mask);
> +
> +       clk = of_clk_get(node, 0);
> +       if (IS_ERR(clk)) {
> +               dev_err(dev, "%s: of_clk_get failed\n", __func__);
> +               return PTR_ERR(clk);
> +       }
> +       host->sysclk = clk_get_rate(clk);
> +
> +       spin_lock_init(&host->lock);
> +
> +       /* disable all interrupt */
> +       writel(0, &host->reg->interrupt_mask);
> +
> +       /* reset chip */
> +       writel(MSD_SDC_RST, &host->reg->command);
> +
> +       /* wait for reset finished */
> +       while (readl(&host->reg->command) & MSD_SDC_RST)
> +               udelay(10);
> +
> +       host->dma_chan_tx = dma_request_channel(mask, moxart_filter_fn,
> +                                               (void *)&dma_chan_tx_req);
> +       host->dma_chan_rx = dma_request_channel(mask, moxart_filter_fn,
> +                                               (void *)&dma_chan_rx_req);
> +       dev_dbg(dev, "%s: using 2 DMA channels rx=%p tx=%p\n",
> +               __func__, host->dma_chan_rx, host->dma_chan_tx);
> +
> +       if (!host->dma_chan_rx || !host->dma_chan_tx) {
> +               host->have_dma = false;
> +               mmc->max_blk_count = 1;
> +       } else {
> +               cfg.slave_id = APB_DMA_SD_REQ_NO;
> +               cfg.direction = DMA_MEM_TO_DEV;
> +               cfg.src_addr = 0;
> +               cfg.dst_addr = (unsigned int)host->reg_phys + MSD_DATA_WIN_REG;
> +               cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +               dmaengine_slave_config(host->dma_chan_tx, &cfg);
> +
> +               cfg.slave_id = APB_DMA_SD_REQ_NO;
> +               cfg.direction = DMA_DEV_TO_MEM;
> +               cfg.src_addr = (unsigned int)host->reg_phys + MSD_DATA_WIN_REG;
> +               cfg.dst_addr = 0;
> +               cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +               dmaengine_slave_config(host->dma_chan_rx, &cfg);
> +
> +               host->have_dma = true;
> +
> +               /*
> +                * there seems to be a max size on transfers so
> +                * set max_blk_count low for both DMA and PIO
> +                *
> +                * sending large chunks result either in timeout
> +                * or render the MMC controller unresponsive
> +                * (status register 0 on consecutive read retries,
> +                * also see comments in moxart_send_command)
> +                *
> +                * obviously, DMA is quicker and can handle
> +                * larger chunks but setting it higher than 16
> +                * can still bug the controller
> +                */
> +               mmc->max_blk_count = 16;
> +       }
> +
> +       devm_request_irq(dev, irq, moxart_irq, 0, "moxart-mmc", host);
> +
> +       if (ret)
> +               goto out;

Presumably you meant to record the return code of devm_request_irq?

> +
> +       dev_set_drvdata(dev, mmc);
> +       mmc_add_host(mmc);
> +
> +       dev_dbg(dev, "%s: IRQ=%d\n", __func__, irq);
> +
> +       return 0;
> +
> +out:
> +       if (mmc)
> +               mmc_free_host(mmc);
> +       return ret;
> +}

[...]

> +struct moxart_reg {
> +
> +#define MSD_SDC_RST            BIT(10)
> +#define MSD_CMD_EN             BIT(9)
> +#define MSD_APP_CMD            BIT(8)
> +#define MSD_LONG_RSP           BIT(7)
> +#define MSD_NEED_RSP           BIT(6)
> +#define MSD_CMD_IDX_MASK       0x3f
> +       unsigned int    command;
> +
> +       unsigned int    argument;
> +       unsigned int    response0;
> +       unsigned int    response1;
> +       unsigned int    response2;
> +       unsigned int    response3;
> +
> +#define MSD_RSP_CMD_APP                BIT(6)
> +#define MSD_RSP_CMD_IDX_MASK   0x3f
> +       unsigned int    response_command;
> +
> +#define MSD_DATA_EN            BIT(6)
> +#define MSD_DMA_EN             BIT(5)
> +#define MSD_DATA_WRITE         BIT(4)
> +#define MSD_BLK_SIZE_MASK      0x0f
> +       unsigned int    data_control;
> +
> +       unsigned int    data_timer;
> +
> +#define MSD_DATA_LEN_MASK      0xffffff
> +       unsigned int    data_length;
> +
> +#define MSD_WRITE_PROT         BIT(12)
> +#define MSD_CARD_DETECT                BIT(11)
> +/* 1-10 below can be sent to interrupt or clear register */
> +#define MSD_CARD_CHANGE                BIT(10)
> +#define MSD_FIFO_ORUN          BIT(9)
> +#define MSD_FIFO_URUN          BIT(8)
> +#define MSD_DATA_END           BIT(7)
> +#define MSD_CMD_SENT           BIT(6)
> +#define MSD_DATA_CRC_OK                BIT(5)
> +#define MSD_RSP_CRC_OK         BIT(4)
> +#define MSD_DATA_TIMEOUT       BIT(3)
> +#define MSD_RSP_TIMEOUT                BIT(2)
> +#define MSD_DATA_CRC_FAIL      BIT(1)
> +#define MSD_RSP_CRC_FAIL       BIT(0)
> +       unsigned int    status;
> +
> +       unsigned int    clear;
> +       unsigned int    interrupt_mask;
> +
> +#define MSD_SD_POWER_ON                BIT(4)
> +#define MSD_SD_POWER_MASK      0x0f
> +       unsigned int    power_control;
> +
> +#define MSD_CLK_DIS            BIT(8)
> +#define MSD_CLK_SD             BIT(7)
> +#define MSD_CLK_DIV_MASK       0x7f
> +       unsigned int    clock_control;
> +
> +#define MSD_WIDE_BUS_SUPPORT   BIT(3)
> +#define MSD_WIDE_BUS           BIT(2)  /* bus width is 4 bytes */
> +#define MSD_SINGLE_BUS         BIT(0)  /* bus width is 1 byte */
> +       unsigned int    bus_width;
> +
> +       unsigned int    data_window;
> +
> +#define MSD_CPRM_FUNCTION      BIT(8)
> +       unsigned int    feature;
> +
> +       unsigned int    revision;
> +};

I see you're using this to handle your register offsets. This isn't
necessarily portable, as you're relying on the size of unsigned int
being 4 bytes, and that elements aren't padded to a larger size. At the
very least unsigned int should be replaced with u32.

Thanks,
Mark.
