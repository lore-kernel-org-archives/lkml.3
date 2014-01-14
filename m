Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaANNEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:04:24 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:32836 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANNEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:04:20 -0500
Message-ID: <1389704580.2794.17.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 2/2] i2c: New bus driver for the QUP I2C controller
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Ralston <james.d.ralston@intel.com>,
        Bill Brown <bill.e.brown@intel.com>,
        Matt Porter <matt.porter@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 14 Jan 2014 15:03:00 +0200
In-Reply-To: <1389659437-16406-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1389659437-16406-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1389659437-16406-3-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bjorn, 

Just two comments.

On Mon, 2014-01-13 at 16:30 -0800, Bjorn Andersson wrote: 
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This bus driver supports the QUP i2c hardware controller in the Qualcomm
> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded i2c
> mini-core. The driver supports FIFO mode (for low bandwidth	applications)
> and block mode (interrupt generated for each block-size data transfer).
> The driver currently does not support DMA transfers.
> 
> Shamelessly based on codeaurora version of the driver.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> [bjorn: updated to reflect i2c framework changes
>         splited up qup_i2c_enable() in enable/disable
>         don't overwrite ret value on error in xfer functions
>         initilize core for each transfer
>         remove explicit pinctrl selection
>         use existing clock instead of setting new core clock]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---

<snip>

> +
> +static int qup_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct qup_i2c_dev *qup;
> +	struct resource *res;
> +	u32 val, io_mode, hw_ver, size;
> +	int ret, fs_div, hs_div;
> +	int src_clk_freq;
> +
> +	qup = devm_kzalloc(&pdev->dev, sizeof(*qup), GFP_KERNEL);
> +	if (!qup)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, qup);
> +
> +	ret = of_alias_get_id(node, "i2c");
> +	if (ret >= 0)
> +		pdev->id = ret;

This is part of the i2c_add_adapter() and have to be dropped.

> +
> +	qup->dev = &pdev->dev;
> +
> +	qup->clk_freq = 100000;
> +	if (!of_property_read_u32(node, "clock-frequency", &val))
> +		qup->clk_freq = val;
> +
> +	/* We support frequencies up to FAST Mode(400KHz) */
> +	if (qup->clk_freq <= 0 || qup->clk_freq > 400000) {
> +		dev_err(qup->dev, "clock frequency not supported %d\n",
> +			qup->clk_freq);
> +		return -EIO;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	qup->base = devm_ioremap_resource(qup->dev, res);
> +	if (IS_ERR(qup->base))
> +		return PTR_ERR(qup->base);
> +
> +	qup->irq = platform_get_irq(pdev, 0);
> +	if (qup->irq < 0) {
> +		dev_err(qup->dev, "No IRQ defined\n");
> +		return qup->irq;
> +	}
> +
> +	qup->clk = devm_clk_get(qup->dev, "core");
> +	if (IS_ERR(qup->clk)) {
> +		dev_err(qup->dev, "Could not get core clock\n");
> +		return PTR_ERR(qup->clk);
> +	}
> +
> +	qup->pclk = devm_clk_get(qup->dev, "iface");
> +	if (IS_ERR(qup->pclk)) {
> +		dev_err(qup->dev, "Could not get iface clock\n");
> +		return PTR_ERR(qup->pclk);
> +	}
> +
> +	init_completion(&qup->xfer);
> +
> +	qup_i2c_enable_clocks(qup);
> +
> +	/*
> +	 * Bootloaders might leave a pending interrupt on certain QUP's,
> +	 * so we reset the core before registering for interrupts.
> +	 */
> +	writel(1, qup->base + QUP_SW_RESET);
> +	ret = qup_i2c_poll_state(qup, 0, true);
> +	if (ret)
> +		goto fail;
> +
> +	ret = devm_request_irq(qup->dev, qup->irq, qup_i2c_interrupt,
> +			       IRQF_TRIGGER_HIGH, "i2c_qup", qup);
> +	if (ret) {
> +		dev_err(qup->dev, "Request %d IRQ failed\n", qup->irq);
> +		goto fail;
> +	}
> +	disable_irq(qup->irq);
> +
> +	hw_ver = readl(qup->base + QUP_HW_VERSION);
> +	dev_dbg(qup->dev, "%d Revision %x\n", pdev->id, hw_ver);
> +
> +	src_clk_freq = clk_get_rate(qup->clk);
> +	fs_div = ((src_clk_freq / qup->clk_freq) / 2) - 3;
> +	hs_div = 3;
> +	qup->clk_ctl = (hs_div << 8) | (fs_div & 0xff);
> +	qup->one_bit_t = (USEC_PER_SEC / qup->clk_freq) + 1;
> +
> +	io_mode = readl(qup->base + QUP_IO_MODE);
> +
> +	size = QUP_OUTPUT_BLOCK_SIZE(io_mode);
> +	if (size)
> +		qup->out_blk_sz = size * 16;
> +	else
> +		qup->out_blk_sz = 16;
> +
> +	size = QUP_INPUT_BLOCK_SIZE(io_mode);
> +	if (size)
> +		qup->in_blk_sz = size * 16;
> +	else
> +		qup->in_blk_sz = 16;
> +
> +	qup->xfer_time = msecs_to_jiffies(qup->out_fifo_sz);
> +
> +	/*
> +	 * The block/fifo size w.r.t. 'actual data' is 1/2 due to 'tag'
> +	 * associated with each byte written/received
> +	 */
> +	qup->out_blk_sz /= 2;
> +	qup->in_blk_sz /= 2;
> +
> +	size = QUP_OUTPUT_FIFO_SIZE(io_mode);
> +	qup->out_fifo_sz = qup->out_blk_sz * (2 << size);
> +
> +	size = QUP_INPUT_FIFO_SIZE(io_mode);
> +	qup->in_fifo_sz = qup->in_blk_sz * (2 << size);
> +
> +	/*
> +	 * Wait for FIFO number of bytes to be absolutely sure
> +	 * that I2C write state machine is not idle. Each byte
> +	 * takes 9 clock cycles. (8 bits + 1 ack)
> +	 */
> +	qup->wait_idle = qup->one_bit_t * 9;
> +	qup->wait_idle *= qup->out_fifo_sz;
> +
> +	dev_info(qup->dev, "IN:block:%d, fifo:%d, OUT:block:%d, fifo:%d\n",
> +		qup->in_blk_sz, qup->in_fifo_sz,
> +		qup->out_blk_sz, qup->out_fifo_sz);

This could be lowered to dbg, I think.

> +
> +	i2c_set_adapdata(&qup->adap, qup);
> +	qup->adap.algo = &qup_i2c_algo;
> +	qup->adap.nr = pdev->id;
> +	qup->adap.dev.parent = qup->dev;
> +	qup->adap.dev.of_node = pdev->dev.of_node;
> +	strlcpy(qup->adap.name, "QUP I2C adapter", sizeof(qup->adap.name));
> +
> +	ret = i2c_add_numbered_adapter(&qup->adap);
> +	if (!ret) {
> +		pm_runtime_set_autosuspend_delay(qup->dev, MSEC_PER_SEC);
> +		pm_runtime_use_autosuspend(qup->dev);
> +		pm_runtime_enable(qup->dev);
> +		return 0;
> +	}
> +fail:
> +	qup_i2c_disable_clocks(qup);
> +	return ret;
> +}
> +

Thanks, 
Ivan

