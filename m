Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaBJQ4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:56:30 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:41113 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaBJQ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:56:27 -0500
Message-ID: <1392051302.2853.56.camel@iivanov-dev>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Date: Mon, 10 Feb 2014 18:55:02 +0200
In-Reply-To: <20140207173207.GA19974@qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
	 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
	 <20140207073952.GA2610@qualcomm.com>
	 <1391766753.27491.60.camel@iivanov-dev>
	 <20140207173207.GA19974@qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andy,

On Fri, 2014-02-07 at 11:32 -0600, Andy Gross wrote: 
> On Fri, Feb 07, 2014 at 11:52:33AM +0200, Ivan T. Ivanov wrote:
> > 

<snip>

> > > > +static int spi_qup_transfer_do(struct spi_qup *controller,
> > > > +			       struct spi_qup_device *chip,
> > > > +			       struct spi_transfer *xfer)
> > > > +{
> > > > +	unsigned long timeout;
> > > > +	int ret = -EIO;
> > > > +
> > > > +	reinit_completion(&controller->done);
> > > > +
> > > > +	timeout = DIV_ROUND_UP(controller->speed_hz, MSEC_PER_SEC);
> > > > +	timeout = DIV_ROUND_UP(xfer->len * 8, timeout);
> > > > +	timeout = 100 * msecs_to_jiffies(timeout);
> > > > +
> > > > +	controller->rx_bytes = 0;
> > > > +	controller->tx_bytes = 0;
> > > > +	controller->error = 0;
> > > > +	controller->xfer = xfer;
> > > > +
> > > > +	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
> > > > +		dev_warn(controller->dev, "cannot set RUN state\n");
> > > > +		goto exit;
> > > > +	}
> > > > +
> > > > +	if (spi_qup_set_state(controller, QUP_STATE_PAUSE)) {
> > > > +		dev_warn(controller->dev, "cannot set PAUSE state\n");
> > > > +		goto exit;
> > > > +	}
> > > > +
> > > > +	spi_qup_fifo_write(controller, xfer);
> > > > +
> > > > +	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
> > > > +		dev_warn(controller->dev, "cannot set EXECUTE state\n");
> > > > +		goto exit;
> > > > +	}
> > > > +
> > > > +	if (!wait_for_completion_timeout(&controller->done, timeout))
> > > > +		ret = -ETIMEDOUT;
> > > > +	else
> > > > +		ret = controller->error;
> > > > +exit:
> > > > +	controller->xfer = NULL;
> > > 
> > > Should the manipulation of controller->xfer be protected by spinlock?
> > 
> > :-). Probably. I am wondering, could I avoid locking if firstly place
> > QUP into RESET state and then access these field. This should stop
> > all activities in it, right?
> 
> It's generally safest to not assume the hardware is going to do sane things.
> I'm concerned about spurious IRQs.

Ok, will add protection. 

<snip>

> > > > +
> > > > +	if (of_property_read_u32(dev->of_node, "spi-max-frequency", &max_freq))
> > > > +		max_freq = 19200000;
> > > 
> > > I'd set the default to 50MHz as that is the max supported by hardware.  I'd just
> > > set max_freq declaration to 50MHz and then check the value if it is changed via
> > > DT.
> > 
> > 50MHz doesn't seems to be supported on all chip sets. Currently common
> > denominator on all chip sets, that I can see, is 19.2MHz. I have tried 
> > to test it with more than 19.2MHz on APQ8074 and it fails.
> > 
> 
> I guess my stance is to set it to the hardware max supported frequency if it is
> not specified.  If that needs to be lower on a board because of whatever reason,
> they override it.

Ok, I will do in this way.

<snip>

> > > 
> > > > +
> > > > +	ret = clk_set_rate(cclk, max_freq);
> > > > +	if (ret)
> > > > +		dev_warn(dev, "fail to set SPI frequency %d\n", max_freq);
> > > 
> > > Bail here?
> > 
> > I don't know. What will be the consequences if controller continue to
> > operate on its default rate?
> > 
> 
> It is unclear.  But if you can't set the rate that is configured or if there is
> a misconfiguration, it's probably better to exit the probe and catch it here.


My preference is to delay clock speed change till first
SPI transfer. And use wherever transfer itself mandate.

<snip>

> > > > +
> > > > +static int spi_qup_remove(struct platform_device *pdev)
> > > > +{
> > > > +	struct spi_master *master = dev_get_drvdata(&pdev->dev);
> > > > +	struct spi_qup *controller = spi_master_get_devdata(master);
> > > > +
> > > > +	pm_runtime_get_sync(&pdev->dev);
> > > > +
> > > 
> > > Do we need to wait for any current transactions to complete
> > > and do a devm_free_irq()?
> > > 
> > > > +	clk_disable_unprepare(controller->cclk);
> > > > +	clk_disable_unprepare(controller->iclk);
> > 
> > My understanding is:
> > 
> > Disabling clocks will timeout transaction, if any. Core Device driver
> > will call: devm_spi_unregister(), which will wait pending transactions
> > to complete and then remove the SPI master.
> 
> Disabling clocks will confuse the hardware.  We cannot disable clocks while the
> spi core is active and transferring data.

I could follow approach taken by other SPI drivers, just reset
controller and disable clocks.

> 
> > 
> > > > +
> > > > +	pm_runtime_put_noidle(&pdev->dev);
> > > > +	pm_runtime_disable(&pdev->dev);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static struct of_device_id spi_qup_dt_match[] = {
> > > > +	{ .compatible = "qcom,spi-qup-v2", },
> > > 
> > > Need compatible tags of qcom,spi-qup-v2.1.1 (msm8974 v1) or qcom,spi-qup-v2.2.1
> > > (msm8974 v2)
> > 
> > I am not aware of the difference. My board report v.20020000. 
> > Is there difference of handling these controllers?
> 
> There were some bug fixes between versions.  None of those affect SPI (that I
> can tell), but it's better to be more descriptive and use the full versions in
> the compatible tags.

No strong preference here. Should I add qcom,spi-qup-v2.2.0, then? :-)

Regards,
Ivan


