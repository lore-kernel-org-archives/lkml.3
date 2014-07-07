Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaGGBnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:43:20 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:43548 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaGGBnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:43:17 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <782afcbe897ea5b9e1d67c76b2e222ce>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53B9FB1C.7080008@rock-chips.com>
Date: Mon, 07 Jul 2014 09:42:52 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: broonie@kernel.org
CC: heiko@sntech.de, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, wei.luo@rock-chips.com
Subject: Re: [PATCH v2 2/2] spi: add driver for Rockchip RK3xxx SoCs integrated
 SPI
References: <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com> <1404176639-3315-1-git-send-email-addy.ke@rock-chips.com> <20140704183249.GC14896@sirena.org.uk>
In-Reply-To: <20140704183249.GC14896@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 01, 2014 at 09:03:59AM +0800, addy ke wrote:
>> In order to facilitate understanding, rockchip SPI controller IP design
>> looks similar in its registers to designware. But IC implementation
>> is different from designware, So we need a dedicated driver for Rockchip
>> RK3XXX SoCs integrated SPI. The main differences:
> 
> This looks good overall, a nice clean driver.  I've applied it but there
> are a few small issues that need fixing up which I've noted below, can
> you please send followup patches dealing with these?
> 
>> +	 * static void spi_set_cs(struct spi_device *spi, bool enable)
>> +	 * {
>> +	 *		if (spi->mode & SPI_CS_HIGH)
>> +	 *			enable = !enable;
>> +	 *
>> +	 *		if (spi->cs_gpio >= 0)
>> +	 *			gpio_set_value(spi->cs_gpio, !enable);
>> +	 *		else if (spi->master->set_cs)
>> +	 *		spi->master->set_cs(spi, !enable);
>> +	 * }
>> +	 *
>> +	 * Note: enable(rockchip_spi_set_cs) = !enable(spi_set_cs)
>> +	 */
> 
> So, the point here is that chip select is an active low signal by
> default which means that if chip select is asserted we have a low logic
> level and the parameter means "asserted" not "logic level for the
> output".  It doesn't really matter but it might be clearer to say so
> directly.
> 
>> +	if (spi->mode & SPI_CS_HIGH) {
>> +		dev_err(rs->dev, "spi_cs_hign: not support\n");
>> +		return -EINVAL;
> 
> Typo here (high).
> 
>> +static int rockchip_spi_unprepare_message(struct spi_master *master,
>> +		struct spi_message *msg)
>> +{
>> +	unsigned long flags;
>> +	struct rockchip_spi *rs = spi_master_get_devdata(master);
>> +
>> +	spin_lock_irqsave(&rs->lock, flags);
>> +
>> +	if (rs->use_dma) {
>> +		if (rs->state & RXBUSY) {
>> +			dmaengine_terminate_all(rs->dma_rx.ch);
>> +			flush_fifo(rs);
>> +		}
>> +
>> +		if (rs->state & TXBUSY)
>> +			dmaengine_terminate_all(rs->dma_tx.ch);
>> +	}
> 
> This initially looks wrong - the DMA should all be quiesced by the time
> that we get to unpreparing the hardware, otherwise the transfer might be
> ongoing while the chip select is deasserted.  However this is really
> just error handling in case something went wrong which is sensible and
> reasonable, a comment explaining this would help so can you please send
> a followup patch adding one.
> 
> The error handling here is actually a good point - we should probably
> add a callback for the core to use when it times out since the issue
> also applies if there are further transactions queued with the hardware.
> I'll look into that later unless someone does it first.
> 
>> +	/* Delay until the FIFO data completely */
>> +	if (xfer->tx_buf)
>> +		xfer->delay_usecs
>> +			= rs->fifo_len * rs->bpw * 1000000 / rs->speed;
> 
> The driver shouldn't be doing this, if it needs a delay it needs to
> implement it itself.  delay_usecs can be set by devices if they need a
> delay between transfers, it should be in addition to the time taken for
> the transfer to complete.
> 
> Please send a followup patch fixing this.
> 
Are the following modifications reasonable?

+static inline void wait_for_idle(struct rockchip_spi *rs)
+{
+        unsigned long timeout = jiffies + msecs_to_jiffies(5);
+
+        while (time_before(jiffies, timeout)) {
+                if (!(readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY))
+                        return;
+        }
+
+        dev_warn(rs->dev, "spi controller is in busy state!\n");
+}

static int rockchip_spi_pio_transfer(struct rockchip_spi *rs)
{
        int remain = 0;

        do {
                if (rs->tx) {
                        remain = rs->tx_end - rs->tx;
                        rockchip_spi_pio_writer(rs);
                }

                if (rs->rx) {
                        remain = rs->rx_end - rs->rx;
                        rockchip_spi_pio_reader(rs);
                }

                cpu_relax();
        } while (remain);

+        /* If tx, wait until the FIFO data completely. */
+        if (rs->tx)
+                wait_for_idle(rs);

        return 0;
}

static void rockchip_spi_dma_txcb(void *data)
{
        unsigned long flags;
        struct rockchip_spi *rs = data;

+        /* Wait until the FIFO data completely. */
+        wait_for_idle(rs);

        spin_lock_irqsave(&rs->lock, flags);

        rs->state &= ~TXBUSY;
        if (!(rs->state & RXBUSY))
                spi_finalize_current_transfer(rs->master);

        spin_unlock_irqrestore(&rs->lock, flags);
}

>> +static bool rockchip_spi_can_dma(struct spi_master *master,
>> +		struct spi_device *spi,
>> +		struct spi_transfer *xfer)
>> +{
>> +	struct rockchip_spi *rs = spi_master_get_devdata(master);
>> +
>> +	return (xfer->len > rs->fifo_len);
>> +}
> 
> We should factor this out into the core as well, just let the driver set
> the minimum size for DMA since it's such a common pattern.  I'll look
> into this as well.
> 
>> +	master = spi_alloc_master(&pdev->dev, sizeof(struct rockchip_spi));
>> +	if (!master) {
>> +		dev_err(&pdev->dev, "No memory for spi_master\n");
>> +		return -ENOMEM;
>> +	}
> 
> No need to print an error message - OOM messags from the memory
> management subsystem are already noisy enough as it is.
> 
>> +	dev_info(&pdev->dev, "Rockchip SPI controller initialized\n");
> 
> Please send a followup patch removing this, it's not really adding
> anything and there's core debug messages that can be enabled - usually
> these prints are done when there is some information that has been read
> back from the hardware (eg, IP revisions).
> 
>> +static const struct of_device_id rockchip_spi_dt_match[] = {
>> +	{ .compatible = "rockchip,rk3066-spi", },
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(of, rockchip_spi_dt_match);
> 
> Your DT binding defined some additional compatible strings, please add
> those to the driver.
> 
So which is better to describe DT binding for rockchip spi driver as follow:

1. Only add "rockchip,rk3066-spi" for all rockchip socs:
In Documentation/devicetree/bindings/spi/spi-rockchip.txt
- compatible: should be one of the following.
    "rockchip,rk3066-spi" for rk3066 and following.

In drivers/spi/spi-rockchip.c
static const struct of_device_id rockchip_spi_dt_match[] = {
        { .compatible = "rockchip,rk3066-spi", },
        { },
};
------
2. Add "rockchip,rk3066-spi", "rockchip,rk3066-spi", "rockchip,rk3066-spi" for each soc:

In Documentation/devicetree/bindings/spi/spi-rockchip.txt
- compatible: should be one of the following.
    "rockchip,rk3066-spi" for rk3066.
    "rockchip,rk3188-spi", "rockchip,rk3066-spi" for rk3188.
    "rockchip,rk3288-spi", "rockchip,rk3066-spi" for rk3288.

In drivers/spi/spi-rockchip.c
static const struct of_device_id rockchip_spi_dt_match[] = {
        { .compatible = "rockchip,rk3066-spi", },
        { .compatible = "rockchip,rk3188-spi", },
        { .compatible = "rockchip,rk3288-spi", },
        { },
};




