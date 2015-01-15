Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbAOImN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:42:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59067 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbAOImJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:42:09 -0500
Date: Thu, 15 Jan 2015 09:41:19 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150115084119.GN22880@pengutronix.de>
References: <rjui@broadcom.com>
 <1421274213-3544-1-git-send-email-rjui@broadcom.com>
 <1421274213-3544-3-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421274213-3544-3-git-send-email-rjui@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 14, 2015 at 02:23:32PM -0800, Ray Jui wrote:
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
some of them are not needed. I tested on amd64 and efm32 and could drop
linux/device.h, linux/sched.h, linux/clk.h. (BTW, I wonder that you
don't need clk handling.)

> +#define TIM_CFG_OFFSET               0x04
> +#define TIME_CFG_MODE_400_SHIFT      31
Is the register name and the bit name prefix really different or is this
a typo?

> +static int __wait_for_bus_idle(struct bcm_iproc_i2c_dev *iproc_i2c)
A bcm_iproc_i2c prefix would be nice here.

> +static int bcm_iproc_i2c_format_addr(struct bcm_iproc_i2c_dev *iproc_i2c,
> +				     struct i2c_msg *msg, u8 *addr)
> +{
> +
> +	if (msg->flags & I2C_M_TEN) {
> +		dev_err(iproc_i2c->device, "no support for 10-bit address\n");
> +		return -EINVAL;
> +	}
> +
> +	*addr = (msg->addr << 1);
You can also drop the parentheses.

> +	switch (val) {
> +	case M_CMD_STATUS_SUCCESS:
> +		return 0;
> +
> +	case M_CMD_STATUS_LOST_ARB:
> +		dev_err(iproc_i2c->device, "lost bus arbitration\n");
> +		return -EREMOTEIO;
> +
> +	case M_CMD_STATUS_NACK_ADDR:
> +		dev_err(iproc_i2c->device, "NAK addr:0x%02x\n",
> +			iproc_i2c->msg->addr);
> +		return -EREMOTEIO;
> +
> +	case M_CMD_STATUS_NACK_DATA:
> +		dev_err(iproc_i2c->device, "NAK data\n");
> +		return -EREMOTEIO;
> +
> +	case M_CMD_STATUS_TIMEOUT:
> +		dev_err(iproc_i2c->device, "bus timeout\n");
> +		return -ETIMEDOUT;
> +
> +	default:
> +		dev_err(iproc_i2c->device, "unknown error code=%d\n", val);
> +		return -EREMOTEIO;
> +	}
> +
> +	return -EREMOTEIO;
This is not reached.

> +}
> +
> +static int bcm_iproc_i2c_xfer_single_msg(struct bcm_iproc_i2c_dev *iproc_i2c,
> +					 struct i2c_msg *msg)
> +{
> +	int ret, i;
> +	u8 addr;
> +	u32 val;
> +	unsigned long time_left = msecs_to_jiffies(I2C_TIMEOUT_MESC);
> +
> +	if (msg->len < 1 || msg->len > M_TX_RX_FIFO_SIZE - 1) {
Is the < 1 a hardware or a software limitation? That means your driver
doesn't support I2C_SMBUS_QUICK which is used for example by i2cdetect.

> +		dev_err(iproc_i2c->device,
> +			"supported data length is 1 - %u bytes\n",
> +			M_TX_RX_FIFO_SIZE - 1);
> +		return -EINVAL;
> +	}
> +
> +	iproc_i2c->msg = msg;
Can it happen that iproc_i2c->msg still holds an uncompleted message
here or is this serialized by the core? Wolfram? Either here something
like:

	if (iproc_i2c->msg)
		return -EBUSY;

and

	iproc_i2c->msg = NULL;

when a transfer is completed is needed, or the respective code can be
dropped from other drivers (e.g. i2c-efm32).
On the other hand .msg is only used in bcm_iproc_i2c_check_status() to
give a diagnostic message. Maybe you can drop .msg and instead give it
as an additional parameter to bcm_iproc_i2c_check_status().

> +	ret = __wait_for_bus_idle(iproc_i2c);
> +	if (ret)
> +		return ret;
I would still prefer to have something like:

	if (bcm_iproc_i2c_bus_busy())
		return -EBUSY;

instead of a tight loop here.

> +	ret = bcm_iproc_i2c_format_addr(iproc_i2c, msg, &addr);
> +	if (ret)
> +		return ret;
> +
> +	/* load slave address into the TX FIFO */
> +	writel(addr, iproc_i2c->base + M_TX_OFFSET);
> +
> +	/* for a write transaction, load data into the TX FIFO */
> +	if (!(msg->flags & I2C_M_RD)) {
> +		for (i = 0; i < msg->len; i++) {
> +			val = msg->buf[i];
> +
> +			/* mark the last byte */
> +			if (i == msg->len - 1)
> +				val |= 1 << M_TX_WR_STATUS_SHIFT;
What happens if you don't mark this last byte? Could this be used to
support transfers bigger than the fifo size?

> +	/*
> +	 * Enable the "start busy" interrupt, which will be triggered after
> +	 * the transaction is done, i.e., the internal start_busy bit
s/\.,/./ I think

> +	 * transitions from 1 to 0
s/$/./
> +	 */
> +	writel(1 << IE_M_START_BUSY_SHIFT, iproc_i2c->base + IE_OFFSET);
> +
> +	/*
> +	 * Now we can activate the transfer. For a read operation, specify the
> +	 * number of bytes to read
s/$/./

> +	 */
> +	val = 1 << M_CMD_START_BUSY_SHIFT;
> +	if (msg->flags & I2C_M_RD) {
> +		val |= (M_CMD_PROTOCOL_BLK_RD << M_CMD_PROTOCOL_SHIFT) |
> +		       (msg->len << M_CMD_RD_CNT_SHIFT);
> +	} else {
> +		val |= (M_CMD_PROTOCOL_BLK_WR << M_CMD_PROTOCOL_SHIFT);
> +	}
> +	writel(val, iproc_i2c->base + M_CMD_OFFSET);
> +
> +	time_left = wait_for_completion_timeout(&iproc_i2c->done, time_left);

When the interrupt fires here after the complete timed out and before
you disable the irq you still throw the result away.
> +
> +	/* disable all interrupts */
> +	writel(0, iproc_i2c->base + IE_OFFSET);
> +
> +	if (!time_left) {
> +		dev_err(iproc_i2c->device, "transaction times out\n");
s/times/timed/

> +static uint32_t bcm_iproc_i2c_functionality(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
Note that I2C_FUNC_SMBUS_EMUL includes I2C_FUNC_SMBUS_QUICK, so your
driver claims to support transfers of length 0.

> +static int bcm_iproc_i2c_cfg_speed(struct bcm_iproc_i2c_dev *iproc_i2c)
> +{
> +	unsigned int bus_speed, speed_bit;
> +	u32 val;
> +	int ret = of_property_read_u32(iproc_i2c->device->of_node,
> +				       "clock-frequency", &bus_speed);
> +	if (ret < 0) {
> +		dev_err(iproc_i2c->device,
> +			"missing clock-frequency property\n");
> +		return -ENODEV;
Is a missing property the only situation where of_property_read_u32
returns an error? Would it be sane to default to 100 kHz?

> +static int bcm_iproc_i2c_remove(struct platform_device *pdev)
> +{
> +	struct bcm_iproc_i2c_dev *iproc_i2c = platform_get_drvdata(pdev);
> +
> +	i2c_del_adapter(&iproc_i2c->adapter);
You need to free the irq before i2c_del_adapter.

> +	free_irq(iproc_i2c->irq, iproc_i2c);
> +	bcm_iproc_i2c_disable(iproc_i2c);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id bcm_iproc_i2c_of_match[] = {
> +	{.compatible = "brcm,iproc-i2c",},
Not sure this is specified to be a must, but I'd add spaces after { and
before }.

> +	{},
It's a good habit to write this as

	{ /* sentinel */ }

without trailing comma.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
