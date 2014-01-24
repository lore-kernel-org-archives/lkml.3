Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaAXB0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 20:26:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38586 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaAXB0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 20:26:02 -0500
Message-ID: <52E1C125.9090708@codeaurora.org>
Date: Thu, 23 Jan 2014 20:25:57 -0500
From: Philip Elcan <pelcan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Ralston <james.d.ralston@intel.com>,
        Bill Brown <bill.e.brown@intel.com>,
        Matt Porter <matt.porter@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the QUP I2C controller
References: <1389999819-10648-1-git-send-email-bjorn.andersson@sonymobile.com> <1389999819-10648-3-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1389999819-10648-3-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 06:03 PM, Bjorn Andersson wrote:
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

qup->xfer_time should be set after you calculate qup->out_fifo_sz below.

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
> +static int qup_i2c_remove(struct platform_device *pdev)
> +{
> +	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
> +
> +	disable_irq(qup->irq);
> +	qup_i2c_disable_clocks(qup);
> +	i2c_del_adapter(&qup->adap);
> +	pm_runtime_disable(qup->dev);
> +	pm_runtime_set_suspended(qup->dev);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int qup_i2c_pm_suspend_runtime(struct device *device)
> +{
> +	struct qup_i2c_dev *qup = dev_get_drvdata(device);
> +
> +	dev_dbg(device, "pm_runtime: suspending...\n");
> +	qup_i2c_disable_clocks(qup);
> +	return 0;
> +}
> +
> +static int qup_i2c_pm_resume_runtime(struct device *device)
> +{
> +	struct qup_i2c_dev *qup = dev_get_drvdata(device);
> +
> +	dev_dbg(device, "pm_runtime: resuming...\n");
> +	qup_i2c_enable_clocks(qup);
> +	return 0;
> +}
> +#endif
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int qup_i2c_suspend(struct device *device)
> +{
> +	dev_dbg(device, "system suspend");
> +	qup_i2c_pm_suspend_runtime(device);
> +	return 0;
> +}
> +
> +static int qup_i2c_resume(struct device *device)
> +{
> +	dev_dbg(device, "system resume");
> +	qup_i2c_pm_resume_runtime(device);
> +	pm_runtime_mark_last_busy(device);
> +	pm_request_autosuspend(device);
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops qup_i2c_qup_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(
> +		qup_i2c_suspend,
> +		qup_i2c_resume)
> +	SET_RUNTIME_PM_OPS(
> +		qup_i2c_pm_suspend_runtime,
> +		qup_i2c_pm_resume_runtime,
> +		NULL)
> +};
> +
> +static const struct of_device_id qup_i2c_dt_match[] = {
> +	{.compatible = "qcom,i2c-qup"},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, qup_i2c_dt_match);
> +
> +static struct platform_driver qup_i2c_driver = {
> +	.probe  = qup_i2c_probe,
> +	.remove = qup_i2c_remove,
> +	.driver = {
> +		.name = "i2c_qup",
> +		.owner = THIS_MODULE,
> +		.pm = &qup_i2c_qup_pm_ops,
> +		.of_match_table = qup_i2c_dt_match,
> +	},
> +};
> +
> +module_platform_driver(qup_i2c_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:i2c_qup");
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
