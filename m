Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab3GSL4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:56:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47371 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab3GSL4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:56:04 -0400
Message-ID: <51E92946.8030907@ti.com>
Date: Fri, 19 Jul 2013 17:25:50 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com> <1374141687-10790-3-git-send-email-sourav.poddar@ti.com> <20130718104233.GG22506@sirena.org.uk>
In-Reply-To: <20130718104233.GG22506@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On Thursday 18 July 2013 04:12 PM, Mark Brown wrote:
> On Thu, Jul 18, 2013 at 03:31:26PM +0530, Sourav Poddar wrote:
>
>> QSPI is a kind of spi module that allows single,
>> dual and quad read access to external spi devices. The module
>> has a memory mapped interface which provide direct interface
>> for accessing data form external spi devices.
> Have you seen the ongoing thread about SPI buses with extra data lines?
> How does this driver fit in with that?
>
>> --- a/drivers/spi/Makefile
>> +++ b/drivers/spi/Makefile
>> @@ -46,6 +46,7 @@ obj-$(CONFIG_SPI_OCTEON)		+= spi-octeon.o
>>   obj-$(CONFIG_SPI_OMAP_UWIRE)		+= spi-omap-uwire.o
>>   obj-$(CONFIG_SPI_OMAP_100K)		+= spi-omap-100k.o
>>   obj-$(CONFIG_SPI_OMAP24XX)		+= spi-omap2-mcspi.o
>> +obj-$(CONFIG_QSPI_DRA7xxx)              += spi-ti-qspi.o
>>   obj-$(CONFIG_SPI_ORION)			+= spi-orion.o
>>   obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
>>   obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
> Please use SPI_ like the other drivers.
>
>> +static int ti_qspi_prepare_xfer(struct spi_master *master)
>> +{
>> +	struct ti_qspi *qspi = spi_master_get_devdata(master);
>> +	int ret;
>> +
>> +	ret = pm_runtime_get_sync(qspi->dev);
>> +	if (ret<  0) {
>> +		dev_err(qspi->dev, "pm_runtime_get_sync() failed\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
> This is a very common pattern, it should probably be factored out into
> the core, probably not even as ops but rather as an actual feature.
>

I see, every other driver doing it this way right now.
Is it ok, if I take your above idea as an seperate excercise after this 
patch.?
>> +	list_for_each_entry(t,&m->transfers, transfer_list) {
>> +		qspi->cmd |= QSPI_WLEN(t->bits_per_word);
>> +		qspi->cmd |= QSPI_WC_CMD_INT_EN;
>> +
>> +		ret = qspi_transfer_msg(qspi, t);
>> +		if (ret) {
>> +			dev_dbg(qspi->dev, "transfer message failed\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		m->actual_length += t->len;
>> +
>> +		if (list_is_last(&t->transfer_list,&m->transfers))
>> +			goto out;
>> +	}
> The use of list_is_last() here is *realy* strange - what's going on
> there?
>
>> +static irqreturn_t ti_qspi_isr(int irq, void *dev_id)
>> +{
>> +	struct ti_qspi *qspi = dev_id;
>> +	u16 mask, stat;
>> +
>> +	irqreturn_t ret = IRQ_HANDLED;
>> +
>> +	spin_lock(&qspi->lock);
>> +
>> +	stat = ti_qspi_readl(qspi, QSPI_SPI_STATUS_REG);
>> +	mask = ti_qspi_readl(qspi, QSPI_INTR_ENABLE_SET_REG);
>> +
>> +	if (stat&&  mask)
>> +		ret = IRQ_WAKE_THREAD;
>> +
>> +	spin_unlock(&qspi->lock);
>> +
>> +	return ret;
> According to the above code we might interrupt for masked events...
> that's a bit worrying isn't it?
>
>> +	ret = devm_request_threaded_irq(&pdev->dev, irq, ti_qspi_isr,
>> +			ti_qspi_threaded_isr, IRQF_NO_SUSPEND | IRQF_ONESHOT,
>> +			dev_name(&pdev->dev), qspi);
>> +	if (ret<  0) {
>> +		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
>> +				irq);
>> +		goto free_master;
>> +	}
> Standard question about devm_request_threaded_irq() - how can we be
> certain it's safe to use during removal?

