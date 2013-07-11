Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3GKJMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:12:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60770 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab3GKJMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:12:42 -0400
Message-ID: <51DE76FB.8080303@ti.com>
Date: Thu, 11 Jul 2013 14:42:27 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com> <1373290980-17883-3-git-send-email-sourav.poddar@ti.com> <20130708143251.GG31221@arwen.pp.htv.fi>
In-Reply-To: <20130708143251.GG31221@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 July 2013 08:02 PM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Jul 08, 2013 at 07:12:59PM +0530, Sourav Poddar wrote:
>> +static inline unsigned long dra7xxx_readl(struct dra7xxx_qspi *qspi,
>> +		unsigned long reg)
>> +{
>> +	return readl(qspi->base + reg);
>> +}
>> +
>> +static inline void dra7xxx_writel(struct dra7xxx_qspi *qspi,
>> +		unsigned long val, unsigned long reg)
>> +{
>> +	writel(val, qspi->base + reg);
>> +}
>> +
>> +static inline unsigned long dra7xxx_readl_data(struct dra7xxx_qspi *qspi,
>> +		unsigned long reg, int wlen)
>> +{
>> +	switch (wlen) {
>> +	case 8:
>> +		return readw(qspi->base + reg);
>> +		break;
>> +	case 16:
>> +		return readb(qspi->base + reg);
>> +		break;
>> +	case 32:
>> +		return readl(qspi->base + reg);
>> +		break;
>> +	default:
>> +		return -1;
> return -EINVAL ? or some other error code ?
>
>> +	}
>> +}
>> +
>> +static inline void dra7xxx_writel_data(struct dra7xxx_qspi *qspi,
>> +		unsigned long val, unsigned long reg, int wlen)
>> +{
>> +	switch (wlen) {
>> +	case 8:
>> +		writew(val, qspi->base + reg);
>> +		break;
>> +	case 16:
>> +		writeb(val, qspi->base + reg);
>> +		break;
>> +	case 32:
>> +		writeb(val, qspi->base + reg);
>> +		break;
>> +	default:
>> +		dev_dbg(qspi->dev, "word lenght out of range");
>> +		break;
>> +	}
>> +}
>> +
>> +static int dra7xxx_qspi_setup(struct spi_device *spi)
>> +{
>> +	struct dra7xxx_qspi	*qspi = spi_master_get_devdata(spi->master);
>> +	int clk_div = 0;
>> +	u32 clk_ctrl_reg, clk_rate;
>> +
>> +	clk_rate = clk_get_rate(qspi->fclk);
>> +
>> +	if (!qspi->spi_max_frequency) {
>> +		dev_err(qspi->dev, "spi max frequency not defined\n");
>> +		return -1;
> same here
>
>> +	} else
> this needs to have curly braces too, per CodingStyle
>
>> +		clk_div = (clk_rate / qspi->spi_max_frequency) - 1;
>> +
>> +	dev_dbg(qspi->dev, "%s: hz: %d, clock divider %d\n", __func__,
>> +			qspi->spi_max_frequency, clk_div);
>> +
>> +	pm_runtime_get_sync(qspi->dev);
>> +
>> +	clk_ctrl_reg = dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG);
>> +
>> +	clk_ctrl_reg&= ~QSPI_CLK_EN;
>> +
>> +	/* disable SCLK */
>> +	dra7xxx_writel(qspi, clk_ctrl_reg, QSPI_SPI_CLOCK_CNTRL_REG);
>> +
>> +	if (clk_div<  0) {
>> +		dev_dbg(qspi->dev, "%s: clock divider<  0, using /1 divider\n",
>> +				__func__);
>> +		clk_div = 1;
>> +	}
>> +
>> +	if (clk_div>  QSPI_CLK_DIV_MAX) {
>> +		dev_dbg(qspi->dev, "%s: clock divider>%d , using /%d divider\n",
>> +			__func__, QSPI_CLK_DIV_MAX, QSPI_CLK_DIV_MAX + 1);
>> +		clk_div = QSPI_CLK_DIV_MAX;
>> +	}
>> +
>> +	/* enable SCLK */
>> +	dra7xxx_writel(qspi, QSPI_CLK_EN | clk_div, QSPI_SPI_CLOCK_CNTRL_REG);
>> +
>> +	pm_runtime_mark_last_busy(qspi->dev);
>> +	pm_runtime_put_autosuspend(qspi->dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static int dra7xxx_qspi_prepare_xfer(struct spi_master *master)
>> +{
>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>> +
>> +	pm_runtime_get_sync(qspi->dev);
> not going to check return value ?
>
>> +	return 0;
>> +}
>> +
>> +static int dra7xxx_qspi_unprepare_xfer(struct spi_master *master)
>> +{
>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>> +
>> +	pm_runtime_mark_last_busy(qspi->dev);
>> +	pm_runtime_put_autosuspend(qspi->dev);
> what about on these two ?
>
Just realised this, pm_runtime_mark_last_busy does not need a check, it 
returns nothing.
>> +	return 0;
>> +}
>> +
>> +static int qspi_write_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
>> +{
>> +	const u8 *txbuf;
>> +	int wlen, count;
>> +
>> +	count = t->len;
>> +	txbuf = t->tx_buf;
>> +	wlen = t->bits_per_word;
>> +
>> +	while (count--) {
>> +		dev_dbg(qspi->dev, "tx cmd %08x dc %08x data %02x\n",
>> +			qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);
>> +		dra7xxx_writel(qspi, QSPI_WC_INT_EN, QSPI_INTR_ENABLE_SET_REG);
> you should enable the interrupt as the last step. Also, why aren't you
> using frame interrupt ?
>
>> +		dra7xxx_writel_data(qspi, *txbuf++, QSPI_SPI_DATA_REG, wlen);
>> +		dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
>> +		dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
>> +			QSPI_SPI_CMD_REG);
>> +		wait_for_completion(&qspi->word_complete);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int qspi_read_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
>> +{
>> +	u8 *rxbuf;
>> +	int wlen, count;
>> +
>> +	count = t->len;
>> +	rxbuf = t->rx_buf;
>> +	wlen = t->bits_per_word;
>> +
>> +	while (count--) {
>> +		dev_dbg(qspi->dev, "rx cmd %08x dc %08x\n",
>> +			qspi->cmd | QSPI_RD_SNGL, qspi->dc);
>> +		dra7xxx_writel(qspi, QSPI_WC_INT_EN, QSPI_INTR_ENABLE_SET_REG);
> ditto
>
>> +		dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
>> +		dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
>> +			QSPI_SPI_CMD_REG);
>> +		wait_for_completion(&qspi->word_complete);
>> +		*rxbuf++ = dra7xxx_readl_data(qspi, QSPI_SPI_DATA_REG, wlen);
>> +		dev_dbg(qspi->dev, "rx done, read %02x\n", *(rxbuf-1));
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
>> +{
>> +	if (t->tx_buf)
>> +		qspi_write_msg(qspi, t);
>> +	if (t->rx_buf)
>> +		qspi_read_msg(qspi, t);
>> +
>> +	return 0;
>> +}
>> +
>> +static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
>> +		struct spi_message *m)
>> +{
>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>> +	struct spi_device *spi = m->spi;
>> +	struct spi_transfer *t;
>> +	int status = 0;
>> +	int frame_length;
>> +
>> +	/* setup device control reg */
>> +	qspi->dc = 0;
>> +
>> +	if (spi->mode&  SPI_CPHA)
>> +		qspi->dc |= QSPI_CKPHA(spi->chip_select);
>> +	if (spi->mode&  SPI_CPOL)
>> +		qspi->dc |= QSPI_CKPOL(spi->chip_select);
>> +	if (spi->mode&  SPI_CS_HIGH)
>> +		qspi->dc |= QSPI_CSPOL(spi->chip_select);
>> +
>> +	frame_length = DIV_ROUND_UP(m->frame_length * spi->bits_per_word,
> why this multiplication ? Frame is not counted in bits but in number of
> words. Which means that m->framelength / spi->bits_per_word should be
> enough.
>
> Also, this actually brings up a mistake I made, if I read the TRM
> correclty this time, frame length is nothing but the t->len which
> renders patch 1 in this series unnecessary, my mistake.
>
>> +				spi->bits_per_word);
>> +
>> +	frame_length = clamp(frame_length, 0, QSPI_FRAME_MAX);
>> +
>> +	/* setup command reg */
>> +	qspi->cmd = 0;
>> +	qspi->cmd |= QSPI_EN_CS(spi->chip_select);
>> +	qspi->cmd |= QSPI_FLEN(frame_length);
> right, right, so far so good...
>
>> +	list_for_each_entry(t,&m->transfers, transfer_list) {
>> +		qspi->cmd |= QSPI_WLEN(t->bits_per_word);
> sure about this ? according to TRM a write of 0 means 1 bit, 1, means 2
> bits, 2 means 3 bits, etc... So this should be t->bits_per_word - 1.
>
>> +		qspi->cmd |= QSPI_WC_CMD_INT_EN;
> ... but why are you still interrupting on every word ????
>
> as I said before, we want to interrupt on every frame. one spi_transfer
> is one frame, if that frame has a length of 1MiB, I want to be
> interrupted after 1MiB.
>
>> +		qspi_transfer_msg(qspi, t);
>> +		m->actual_length += t->len;
>> +
>> +		if (list_is_last(&t->transfer_list,&m->transfers))
>> +			goto out;
>> +	}
>> +
>> +out:
>> +	m->status = status;
>> +	spi_finalize_current_message(master);
>> +
>> +	dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL, QSPI_SPI_CMD_REG);
>> +
>> +	return status;
>> +}
>> +
>> +static irqreturn_t dra7xxx_qspi_isr(int irq, void *dev_id)
>> +{
>> +	struct dra7xxx_qspi *qspi = dev_id;
>> +	u16 mask, stat;
>> +
>> +	irqreturn_t ret = IRQ_HANDLED;
>> +
>> +	spin_lock(&qspi->lock);
>> +
>> +	stat = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
>> +	mask = dra7xxx_readl(qspi, QSPI_SPI_CMD_REG);
>> +
>> +	if ((stat&  QSPI_WC)&&  (mask&  QSPI_WC_CMD_INT_EN))
> this is wrong, everytime you want to handle another IRQ bit, you will
> have to update this line.
>
> 	if (stat&  mask)
>
> sounds like it's enough
>

