Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3GIHVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:21:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49625 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3GIHVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:21:03 -0400
Message-ID: <51DBB9D1.4000202@ti.com>
Date: Tue, 9 Jul 2013 12:50:49 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com> <1373290980-17883-3-git-send-email-sourav.poddar@ti.com> <20130708203330.GA28322@kahuna>
In-Reply-To: <20130708203330.GA28322@kahuna>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 July 2013 02:03 AM, Nishanth Menon wrote:
> On 19:12-20130708, Sourav Poddar wrote:
> [..]
> generic comment, given our historical mistakes of making drivers
> specific to a SoC family, it never is.
>
> Now, ti-qspi in file name is a step in the right direction, but, rest
> of the code(function names etc) is just married to DRA7 family of
> processor, when it should not be.
>
Make sense. Will change apis accordingly.
>> diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
>> new file mode 100644
>> index 0000000..430de9c
>> --- /dev/null
>> +++ b/drivers/spi/spi-ti-qspi.c
> [...]
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
> Looks like a case to use regmap?
> Dumb q: why cant we use regmap_spi? worst case, you should be able to
> use mmio if regmap_spi cant be used. The commit message was not clear
> about this.
>
MMIO can be used as this controller supports memory mapped port, but that
will be addition/enhancement on top of this.
This driver is adding qspi controller read/write support in SPI mode.
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
>> +	} else
>> +		clk_div = (clk_rate / qspi->spi_max_frequency) - 1;
> did you run checkpatch --strict here?
Didn,t do the strict, yes will add braces.
> Also, would you prefer to use DIV_ROUND_UP?
>
Ok.
>> +
>> +	dev_dbg(qspi->dev, "%s: hz: %d, clock divider %d\n", __func__,
>> +			qspi->spi_max_frequency, clk_div);
>> +
>> +	pm_runtime_get_sync(qspi->dev);
> error check?
Will add.
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
> should you not fail here?
May be yes.
>> +	}
>> +
>> +	if (clk_div>  QSPI_CLK_DIV_MAX) {
>> +		dev_dbg(qspi->dev, "%s: clock divider>%d , using /%d divider\n",
>> +			__func__, QSPI_CLK_DIV_MAX, QSPI_CLK_DIV_MAX + 1);
>> +		clk_div = QSPI_CLK_DIV_MAX;
> should you not fail here?
Yup.
>> +	}
>> +
>> +	/* enable SCLK */
>> +	dra7xxx_writel(qspi, QSPI_CLK_EN | clk_div, QSPI_SPI_CLOCK_CNTRL_REG);
>> +
>> +	pm_runtime_mark_last_busy(qspi->dev);
>> +	pm_runtime_put_autosuspend(qspi->dev);
> error check?
Will add.
>> +
>> +	return 0;
>> +}
>> +
>> +static int dra7xxx_qspi_prepare_xfer(struct spi_master *master)
>> +{
>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>> +
>> +	pm_runtime_get_sync(qspi->dev);
> error check?
Will add.
>> +
>> +	return 0;
>> +}
>> +
>> +static int dra7xxx_qspi_unprepare_xfer(struct spi_master *master)
>> +{
>> +	struct dra7xxx_qspi *qspi = spi_master_get_devdata(master);
>> +
>> +	pm_runtime_mark_last_busy(qspi->dev);
>> +	pm_runtime_put_autosuspend(qspi->dev);
> error check?
Will add.
>> +
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
>> +		dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
>> +		dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
>> +			QSPI_SPI_CMD_REG);
>> +		wait_for_completion(&qspi->word_complete);
>> +		*rxbuf++ = dra7xxx_readl_data(qspi, QSPI_SPI_DATA_REG, wlen);
> *rxbuf =
>> +		dev_dbg(qspi->dev, "rx done, read %02x\n", *(rxbuf-1));
> rxbuf++ after dev_dbg?
I am not sure, anywyas we are decrementing pointer during dev_dbg..
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, struct spi_transfer *t)
>> +{
>> +	if (t->tx_buf)
>> +		qspi_write_msg(qspi, t);
> what is the point of the function returning error when we dont use it?
hmm..yes, will check for errors.
>> +	if (t->rx_buf)
>> +		qspi_read_msg(qspi, t);
> what is the point of the function returning error when we dont use it?
Same as above.
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
>> +				spi->bits_per_word);
>> +
>> +	frame_length = clamp(frame_length, 0, QSPI_FRAME_MAX);
>> +
>> +	/* setup command reg */
>> +	qspi->cmd = 0;
>> +	qspi->cmd |= QSPI_EN_CS(spi->chip_select);
>> +	qspi->cmd |= QSPI_FLEN(frame_length);
>> +
> how does one ensure pm runtime has not disabled clocks in
> background? e.g. long latency between transfers.
As felipe also pointed out, in prepare transfer I will enable clocks which
will get get disabled only during unprepare transfer. I dont know if we
hit the above scenario.
+ list_for_each_entry(t, &m->transfers, transfer_list) {
>> +		qspi->cmd |= QSPI_WLEN(t->bits_per_word);
>> +		qspi->cmd |= QSPI_WC_CMD_INT_EN;
>> +
>> +		qspi_transfer_msg(qspi, t);
> error handling?
Will add.
>> +
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
> what if autosuspend has triggered here? before ISR was scheduled?
Similar understanding as above, autosuspend should get triggered only
during unprepare.
>> +	stat = dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
>> +	mask = dra7xxx_readl(qspi, QSPI_SPI_CMD_REG);
>> +
>> +	if ((stat&  QSPI_WC)&&  (mask&  QSPI_WC_CMD_INT_EN))
>> +		ret = IRQ_WAKE_THREAD;
>> +
>> +	spin_unlock(&qspi->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static irqreturn_t dra7xxx_qspi_threaded_isr(int this_irq, void *dev_id)
>> +{
>> +	struct dra7xxx_qspi *qspi = dev_id;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&qspi->lock, flags);
>> +
> what if autosuspend has triggered here? before ISR was scheduled?
>> +	dra7xxx_writel(qspi, QSPI_WC_INT_DISABLE, QSPI_INTR_ENABLE_CLEAR_REG);
>> +	dra7xxx_writel(qspi, QSPI_WC_INT_DISABLE,
>> +			QSPI_INTR_STATUS_ENABLED_CLEAR);
>> +
>> +	complete(&qspi->word_complete);
>> +
>> +	spin_unlock_irqrestore(&qspi->lock, flags);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static const struct of_device_id dra7xxx_qspi_match[] = {
>> +	{.compatible = "ti,dra7xxx-qspi" },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, dra7xxx_qspi_match);
>> +
>> +static int dra7xxx_qspi_probe(struct platform_device *pdev)
>> +{
>> +	struct  dra7xxx_qspi *qspi;
>> +	struct spi_master *master;
>> +	struct resource         *r;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	u32 max_freq;
>> +	int ret = 0, num_cs, irq;
>> +
>> +	master = spi_alloc_master(&pdev->dev, sizeof(*qspi));
>> +	if (!master)
>> +		return -ENOMEM;
>> +
>> +	master->mode_bits = SPI_CPOL | SPI_CPHA;
>> +
>> +	master->num_chipselect = 1;
>> +	master->bus_num = -1;
>> +	master->setup = dra7xxx_qspi_setup;
>> +	master->prepare_transfer_hardware = dra7xxx_qspi_prepare_xfer;
>> +	master->transfer_one_message = dra7xxx_qspi_start_transfer_one;
>> +	master->unprepare_transfer_hardware = dra7xxx_qspi_unprepare_xfer;
>> +	master->dev.of_node = pdev->dev.of_node;
>> +	master->bits_per_word_mask = BIT(32 - 1) | BIT(16 - 1) | BIT(8 - 1);
>> +
>> +	if (!of_property_read_u32(np, "ti,spi-num-cs",&num_cs))
>> +		master->num_chipselect = num_cs;
>> +
>> +	platform_set_drvdata(pdev, master);
>> +
>> +	qspi = spi_master_get_devdata(master);
>> +	qspi->master = master;
>> +	qspi->dev =&pdev->dev;
>> +
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (r == NULL) {
>> +		ret = -ENODEV;
>> +		goto free_master;
>> +	}
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq<  0) {
>> +		dev_err(&pdev->dev, "no irq resource?\n");
>> +		return irq;
>> +	}
>> +
>> +	spin_lock_init(&qspi->lock);
>> +
>> +	qspi->base = devm_ioremap_resource(&pdev->dev, r);
>> +	if (IS_ERR(qspi->base)) {
>> +		ret = -ENOMEM;
>> +		goto free_master;
>> +	}
> why not use devm_request_and_ioremap? Lock that region down so that no
> two drivers can manage the same region?
>> +
>> +	ret = devm_request_threaded_irq(&pdev->dev, irq, dra7xxx_qspi_isr,
>> +		dra7xxx_qspi_threaded_isr, IRQF_NO_SUSPEND | IRQF_ONESHOT,
>> +			dev_name(&pdev->dev), qspi);
>> +	if (ret<  0) {
>> +		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
>> +				irq);
>> +		goto free_master;
>> +	}
>> +
>> +	qspi->fclk = devm_clk_get(&pdev->dev, "fck");
>> +	if (IS_ERR(qspi->fclk)) {
>> +		ret = PTR_ERR(qspi->fclk);
>> +		dev_err(&pdev->dev, "could not get clk: %d\n", ret);
>> +	}
>> +
>> +	init_completion(&qspi->word_complete);
>> +
>> +	pm_runtime_use_autosuspend(&pdev->dev);
>> +	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
>> +	pm_runtime_enable(&pdev->dev);
>> +
>> +	if (!of_property_read_u32(np, "spi-max-frequency",&max_freq))
>> +		qspi->spi_max_frequency = max_freq;
>> +
>> +	ret = spi_register_master(master);
>> +	if (ret)
>> +		goto free_master;
>> +
>> +	return ret;
>> +
>> +free_master:
>> +	spi_master_put(master);
>> +	return ret;
>> +}
>> +
>> +static int dra7xxx_qspi_remove(struct platform_device *pdev)
>> +{
>> +	struct  dra7xxx_qspi *qspi = platform_get_drvdata(pdev);
>> +
>> +	spi_unregister_master(qspi->master);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver dra7xxx_qspi_driver = {
>> +	.probe	= dra7xxx_qspi_probe,
>> +	.remove	= dra7xxx_qspi_remove,
>> +	.driver = {
>> +		.name	= "ti,dra7xxx-qspi",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = dra7xxx_qspi_match,
>> +	}
> no need for pm_ops?
Yes, we need to, I thought of sending that as  a seperate patch after this
this one gets fixed.
Would you prefer that I add it here?
>> +};
>> +
>> +module_platform_driver(dra7xxx_qspi_driver);
>> +
>> +MODULE_LICENSE("GPL");
> GPL V2?
Yes, will change.
>> +MODULE_DESCRIPTION("TI QSPI controller driver");
> MODULE_AUTHOR?
Will add.
>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

