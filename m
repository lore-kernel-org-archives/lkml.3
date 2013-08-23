Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3HWN5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:57:09 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57234 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3HWN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:57:07 -0400
MIME-Version: 1.0
In-Reply-To: <1376237877-1740-2-git-send-email-sre@debian.org>
References: <1376237628-1077-1-git-send-email-sre@debian.org>
	<1376237877-1740-1-git-send-email-sre@debian.org>
	<1376237877-1740-2-git-send-email-sre@debian.org>
Date: Fri, 23 Aug 2013 15:57:05 +0200
Message-ID: <CACRpkdZpB0YjZzhOsyN9uNETQWJM=2N50eUBaxDF29jDw3ZJfw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: OMAP2+: HSI: Introduce OMAP SSI driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Sebastian Reichel <sre@ring0.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 6:17 PM, Sebastian Reichel <sre@debian.org> wrote:

> From: Sebastian Reichel <sre@ring0.de>
>
> This patch adds an OMAP SSI driver to the HSI framework.
>
> The Synchronous Serial Interface (SSI) is a legacy version
> of HSI. As in the case of HSI, it is mainly used to connect
> Application engines (APE) with cellular modem engines (CMT)
> in cellular handsets.
>
> It provides a multichannel, full-duplex, multi-core communication
> with no reference clock. The OMAP SSI block is capable of reaching
> speeds of 110 Mbit/s.

First: good to see this.

The HSI subsystem is lacking an active maintainer, interested?
Given that you can apparently test the OMAP HSI driver you're
one of the few applicable candidates.

Overall there is one big problem with this patch in that it implements
a lot of stuff that should not be implemented in the driver at all,
but in the HSI core.

For example compare commit
ffbbdd21329f3e15eeca6df2d4bc11c04d9d91c0
"spi: create a message queueing infrastructure"

This patch basically seems to redo the mistake we did in
SPI and not create a central message queue from day one,
instead re-implementing the same code in each and every
driver.

Please attempt to draw the message queueuing into the
driver core atlease.

Further the allocation of hosts seem pretty generic as well
but I'm unsure about this. I'd prefer if you take a second
look at the generalizeable parts.

(...)
>> +       spinlock_t              wk_lock;
> +       spinlock_t              lock;
> +       unsigned int            channels;
> +       struct list_head        txqueue[SSI_MAX_CHANNELS];
> +       struct list_head        rxqueue[SSI_MAX_CHANNELS];
> +       struct list_head        brkqueue;
> +       unsigned int            irq;
> +       int                     wake_irq;
> +       int                     wake_gpio;
> +       struct tasklet_struct   pio_tasklet;
> +       struct tasklet_struct   wake_tasklet;
> +       unsigned int            wktest:1; /* FIXME: HACK to be removed */
> +       unsigned int            wkin_cken:1; /* Workaround */

Atleast make them into the bool type.

> +       int                     wk_refcount;

A refcount does not seem like it coul be negative. Should
this be unsigned?

Since these seem to be associated with a piece of code
that only runs when this goes to 0, why not just use kref?

> +       /* OMAP SSI port context */
> +       u32                     sys_mpu_enable; /* We use only one irq */
> +       struct omap_ssm_ctx     sst;
> +       struct omap_ssm_ctx     ssr;
> +};
> +
> +/**
> + * struct omap_ssi_controller - OMAP SSI controller data
> + * @dev: device associated to the controller (HSI controller)
> + * @sys: SSI I/O base address
> + * @gdd: GDD I/O base address
> + * @ick: SSI interconnect clock
> + * @fck: SSI functional clock
> + * @ck_refcount: References count for clocks
> + * @gdd_irq: IRQ line for GDD
> + * @gdd_tasklet: bottom half for DMA transfers
> + * @gdd_trn: Array of GDD transaction data for ongoing GDD transfers
> + * @lock: lock to serialize access to GDD
> + * @ck_lock: lock to serialize access to the clocks
> + * @loss_count: To follow if we need to restore context or not
> + * @max_speed: Maximum TX speed (Kb/s) set by the clients.
> + * @sysconfig: SSI controller saved context
> + * @gdd_gcr: SSI GDD saved context
> + * @get_loss: Pointer to omap_pm_get_dev_context_loss_count, if any
> + * @port: Array of pointers of the ports of the controller
> + * @dir: Debugfs SSI root directory
> + */
> +struct omap_ssi_controller {
> +       struct device           *dev;
> +       void __iomem            *sys;
> +       void __iomem            *gdd;
> +       struct clk              *ick;
> +       struct clk              *fck;
> +       int                     ck_refcount;

Unsigned?

Since these seem to be associated with a piece of code
that only runs when this goes to 0, why not just use kref?

(...)
> +static int ssi_set_port_mode(struct omap_ssi_port *omap_port, void *data)
> +{
> +       u32 *mode = data;
> +
> +       __raw_writel(*mode, omap_port->sst_base + SSI_SST_MODE_REG);
> +       __raw_writel(*mode, omap_port->ssr_base + SSI_SSR_MODE_REG);
> +       /* OCP barrier */
> +       *mode = __raw_readl(omap_port->ssr_base + SSI_SSR_MODE_REG);
> +
> +       return 0;
> +}

Why do you insist on using __raw_readl/writel()? I can understand
that you want to use readl/writel_relaxed() but __raw* is just
ugly and confusing.

The last in a series of writel should probably be a plain
writel() so as to flush buffers etc.

Comment applies to every instance of these.

> +static u32 ssi_calculate_div(struct hsi_controller *ssi)
> +{
> +       struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
> +       u32 tx_fckrate = (u32) omap_ssi->fck_rate;
> +
> +       /* / 2 : SSI TX clock is always half of the SSI functional clock */
> +       tx_fckrate >>= 1;
> +       /* Round down when tx_fckrate % omap_ssi->max_speed == 0 */
> +       tx_fckrate--;
> +       dev_dbg(&ssi->device, "TX div %d for fck_rate %lu Khz speed %d Kb/s\n",
> +                       tx_fckrate / omap_ssi->max_speed, omap_ssi->fck_rate,
> +                                                       omap_ssi->max_speed);
> +
> +       return tx_fckrate / omap_ssi->max_speed;

Don't you want to use:
DIV_ROUND_CLOSEST(tx_fckrate, omap_ssi->max_speed)
?

(...)
> +static int ssi_setup(struct hsi_client *cl)
> +{
(...)
> +       /* Set TX/RX module to sleep to stop TX/RX during cfg update */
> +       __raw_writel(SSI_MODE_SLEEP, sst + SSI_SST_MODE_REG);
> +       __raw_writel(SSI_MODE_SLEEP, ssr + SSI_SSR_MODE_REG);
> +       /* Flush posted write */
> +       val = __raw_readl(ssr + SSI_SSR_MODE_REG);
> +       /* TX */
> +       __raw_writel(31, sst + SSI_SST_FRAMESIZE_REG);

31??

Use a #define for this, I have no clue why this is 31.

(...)
> +       __raw_writel(31, ssr + SSI_SSR_FRAMESIZE_REG);
(...)
> +       omap_port->sst.frame_size = 31;
(...)
> +       omap_port->ssr.frame_size = 31;

Seems like some universal constant.

> +static int ssi_flush(struct hsi_client *cl)
(...)
> +       /* Clear interrupts */
> +       __raw_writel(0, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
> +       __raw_writel(0xffffff00,
> +                       omap_ssi->sys + SSI_MPU_STATUS_REG(port->num, 0));
> +       __raw_writel(0, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
> +       __raw_writel(0xff, omap_ssi->sys + SSI_GDD_MPU_IRQ_STATUS_REG);

Here are other magic numbers 0xfffff00, 0xff...

(...)
> +static int __init ssi_hw_init(struct hsi_controller *ssi)
> +{
> +       struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
> +       unsigned int i;
> +       u32 val;
> +       int err;
> +
> +       err = ssi_clk_enable(ssi);
> +       if (err < 0) {
> +               dev_err(&ssi->device, "Failed to enable the clocks %d\n", err);
> +               return err;
> +       }
> +       /* Reseting SSI controller */
> +       __raw_writel(SSI_SOFTRESET, omap_ssi->sys + SSI_SYSCONFIG_REG);
> +       val = __raw_readl(omap_ssi->sys + SSI_SYSSTATUS_REG);
> +       for (i = 0; ((i < 20) && !(val & SSI_RESETDONE)); i++) {
> +               msleep(20);
> +               val = __raw_readl(omap_ssi->sys + SSI_SYSSTATUS_REG);
> +       }

Explain constants chosen in a comment. From datasheet?

> +       /* Reseting GDD */
> +       __raw_writel(SSI_SWRESET, omap_ssi->gdd + SSI_GDD_GRST_REG);
> +       /* Get FCK rate */
> +       omap_ssi->fck_rate = ssi_get_clk_rate(ssi) / 1000; /* KHz */

DIV_ROUND_CLOSEST()? Or is this an integer divider?

Yours,
Linus Walleij
