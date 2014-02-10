Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaBJQaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:30:55 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39695 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaBJQav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:30:51 -0500
Message-ID: <1392049766.2853.43.camel@iivanov-dev>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Date: Mon, 10 Feb 2014 18:29:26 +0200
In-Reply-To: <20140207171202.GD1757@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
	 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
	 <20140207171202.GD1757@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Fri, 2014-02-07 at 17:12 +0000, Mark Brown wrote: 
> On Thu, Feb 06, 2014 at 06:57:48PM +0200, Ivan T. Ivanov wrote:
> 
> This looks mostly good, there's a few odd things and missing use of
> framework features.
> 
> > Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> > provides a common data path (an output FIFO and an input FIFO)
> > for serial peripheral interface (SPI) mini-core. SPI in master mode
> > support up to 50MHz, up to four chip selects, and a programmable
> > data path from 4 bits to 32 bits; MODE0..3 protocols
> 
> The grammar in this and the Kconfig text is a bit garbled, might want to
> give it a once over (support -> supports for example).

Ok

> 
> > +static void spi_qup_deassert_cs(struct spi_qup *controller,
> > +				struct spi_qup_device *chip)
> > +{
> 
> 
> > +	if (chip->mode & SPI_CS_HIGH)
> > +		iocontol &= ~mask;
> > +	else
> > +		iocontol |= mask;
> 
> Implement a set_cs() operation and let the core worry about all this
> for you as well as saving two implementations.

Nice. Will us it.

> 
> > +		word = 0;
> > +		for (idx = 0; idx < controller->bytes_per_word &&
> > +		     controller->tx_bytes < xfer->len; idx++,
> > +		     controller->tx_bytes++) {
> > +
> > +			if (!tx_buf)
> > +				continue;
> 
> Do you need to set the _MUST_TX flag?
> 
> > +	qup_err = readl_relaxed(controller->base + QUP_ERROR_FLAGS);
> > +	spi_err = readl_relaxed(controller->base + SPI_ERROR_FLAGS);
> > +	opflags = readl_relaxed(controller->base + QUP_OPERATIONAL);
> > +
> > +	writel_relaxed(qup_err, controller->base + QUP_ERROR_FLAGS);
> > +	writel_relaxed(spi_err, controller->base + SPI_ERROR_FLAGS);
> > +	writel_relaxed(opflags, controller->base + QUP_OPERATIONAL);
> > +
> > +	if (!xfer)
> > +		return IRQ_HANDLED;
> 
> Are you sure?  It seems wrong to just ignore interrupts, some comments
> would help explain why.

Of course this should never happen. This was left from initial stage
of the implementation.

> 
> > +static int spi_qup_transfer_do(struct spi_qup *controller,
> > +			       struct spi_qup_device *chip,
> > +			       struct spi_transfer *xfer)
> 
> This looks like a transfer_one() function, please use the framework
> features where you can.

Sure, will do. Somehow I have missed this.

> 
> > +	if (controller->speed_hz != chip->speed_hz) {
> > +		ret = clk_set_rate(controller->cclk, chip->speed_hz);
> > +		if (ret) {
> > +			dev_err(controller->dev, "fail to set frequency %d",
> > +				chip->speed_hz);
> > +			return -EIO;
> > +		}
> > +	}
> 
> Is calling into the clock framework really so expensive that we need to
> avoid doing it?  

Probably not. But why to call it if the frequency is the same.


> You also shouldn't be interacting with the hardware in
> setup().

This is internal hw-setup, not master::setup() or I am
missing something?

> 
> > +	if (chip->bits_per_word <= 8)
> > +		controller->bytes_per_word = 1;
> > +	else if (chip->bits_per_word <= 16)
> > +		controller->bytes_per_word = 2;
> > +	else
> > +		controller->bytes_per_word = 4;
> 
> This looks like a switch statement, and looking at the above it's not
> clear that the device actually supports anything other than whole bytes.
> I'm not sure what that would mean from an API point of view.

SPI API didn't validate struct spi_transfer::len field.

The whole sniped looks like this:

	chip->bits_per_word = spi->bits_per_word;
	if (xfer->bits_per_word)
		chip->bits_per_word = xfer->bits_per_word;

	if (chip->bits_per_word <= 8)
		controller->bytes_per_word = 1;
	else if (chip->bits_per_word <= 16)
		controller->bytes_per_word = 2;
	else
		controller->bytes_per_word = 4;

	if (controller->bytes_per_word > xfer->len ||
	    xfer->len % controller->bytes_per_word != 0){
		/* No partial transfers */
		dev_err(controller->dev, "invalid len %d for %d bits\n",
			xfer->len, chip->bits_per_word);
		return -EIO;
	}

	n_words = xfer->len / controller->bytes_per_word;

'bytes_per_word' have to be power of 2. This is my understanding of
struct spi_transfer description. So I am discarding all transfers with
'len' non multiple of word size.


> 
> > +static int spi_qup_transfer_one(struct spi_master *master,
> > +				struct spi_message *msg)
> > +{
> 
> This entire function can be removed, the core can do it for you.

Sure, will use it.

> 
> > +	if (of_property_read_u32(dev->of_node, "spi-max-frequency", &max_freq))
> > +		max_freq = 19200000;
> > +
> > +	if (!max_freq) {
> > +		dev_err(dev, "invalid clock frequency %d\n", max_freq);
> > +		return -ENXIO;
> > +	}
> > +
> > +	ret = clk_set_rate(cclk, max_freq);
> > +	if (ret)
> > +		dev_warn(dev, "fail to set SPI frequency %d\n", max_freq);
> 
> You set the clock rate per transfer so why bother setting it here,

Only if differs from the current one.

> perhaps we support the rate the devices request but not this maximum
> rate?

Thats why it is just a warning. I will see how to handle this better.

> 
> > +	master->num_chipselect = SPI_NUM_CHIPSELECTS;
> > +	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
> 
> Are you *sure* the device supports anything other than whole bytes?

Yep. I see them on the scope.

> 
> > +	ret = devm_spi_register_master(dev, master);
> > +	if (!ret) {
> > +		pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
> > +		pm_runtime_use_autosuspend(dev);
> > +		pm_runtime_set_active(dev);
> > +		pm_runtime_enable(dev);
> > +		return ret;
> > +	}
> 
> This is really unclearly written, the success case looks like error
> handling.

I suppose that if use a goto, I will have to do it consistently. 
Will rework it.

> 
> > +#ifdef CONFIG_PM_RUNTIME
> > +static int spi_qup_pm_suspend_runtime(struct device *device)
> > +{
> > +	struct spi_master *master = dev_get_drvdata(device);
> > +	struct spi_qup *controller = spi_master_get_devdata(master);
> > +
> > +	disable_irq(controller->irq);
> 
> Why do you need to disable the interrupt?  Will the hardware generate
> spurious interrupts, if so some documentation is in order.

I don't know. Just extra protection? I will have t o find how to 
test this.

> 
> > +static int spi_qup_pm_resume_runtime(struct device *device)
> > +{
> > +	struct spi_master *master = dev_get_drvdata(device);
> > +	struct spi_qup *controller = spi_master_get_devdata(master);
> > +
> > +	clk_prepare_enable(controller->cclk);
> > +	clk_prepare_enable(controller->iclk);
> > +	enable_irq(controller->irq);
> 
> No error checking here...

Will fix.

Thanks,
Ivan


