Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab3BGPIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:08:47 -0500
Received: from etezian.org ([198.101.225.253]:36704 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab3BGPIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:08:43 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2013 10:08:43 EST
Date: Thu, 7 Feb 2013 15:59:52 +0100
From: Andi Shyti <andi@etezian.org>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: tomi.valkeinen@ti.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/1] OMAP4: DSS: Add panel for Blaze Tablet boards
Message-ID: <20130207145952.GA7860@jack.whiskey>
References: <1360248051-16541-1-git-send-email-ruslan.bilovol@ti.com>
 <1360248051-16541-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360248051-16541-2-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> TC358765 is DSI-to-LVDS transmitter from Toshiba, used in
> OMAP44XX Blaze Tablet and Blaze Tablet2 boards.

I had a really fast look and I have few comments

> +static int tc358765_read_register(struct omap_dss_device *dssdev,
> +					u16 reg, u32 *val)
> +{
> +	int ret = 0;
> +	pm_runtime_get_sync(&dssdev->dev);
> +	/* I2C is preferred way of reading, but fall back to DSI
> +	 * if I2C didn't got initialized
> +	*/
> +	if (tc358765_i2c)
> +		ret = tc358765_i2c_read(reg, val);
> +	else
> +		ret = tc358765_dsi_read(dssdev, reg, val);
> +	pm_runtime_put_sync(&dssdev->dev);
> +
> +	return ret;
> +}
> +
> +static int tc358765_write_register(struct omap_dss_device *dssdev, u16 reg,
> +		u32 value)
> +{
> +	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
> +	u8 buf[6];
> +	int r;
> +
> +	buf[0] = (reg >> 0) & 0xff;
> +	buf[1] = (reg >> 8) & 0xff;
> +	buf[2] = (value >> 0) & 0xff;
> +	buf[3] = (value >> 8) & 0xff;
> +	buf[4] = (value >> 16) & 0xff;
> +	buf[5] = (value >> 24) & 0xff;
> +
> +	r = dsi_vc_generic_write_nosync(dssdev, d2d->channel1, buf, 6);
> +	if (r)
> +		dev_err(&dssdev->dev, "reg write reg(%x) val(%x) failed: %d\n",
> +			       reg, value, r);
> +	return r;
> +}
> +
> +/****************************
> +********* DEBUG *************
> +****************************/
> +#ifdef CONFIG_TC358765_DEBUG
> +static int tc358765_write_register_i2c(u16 reg, u32 val)
> +{
> +	int ret = -ENODEV;
> +	unsigned char buf[6];
> +	struct i2c_msg msg;
> +
> +	if (!tc358765_i2c) {
> +		dev_err(tc358765_debug.dev, "%s: I2C not initilized\n",
> +							__func__);
> +		return ret;
> +	}
> +
> +	buf[0] = (reg >> 8) & 0xff;
> +	buf[1] = (reg >> 0) & 0xff;
> +	buf[2] = (val >> 0) & 0xff;
> +	buf[3] = (val >> 8) & 0xff;
> +	buf[4] = (val >> 16) & 0xff;
> +	buf[5] = (val >> 24) & 0xff;
> +	msg.addr = tc358765_i2c->client->addr;
> +	msg.len = sizeof(buf);
> +	msg.flags = 0;
> +	msg.buf = buf;
> +
> +	mutex_lock(&tc358765_i2c->xfer_lock);
> +	ret = i2c_transfer(tc358765_i2c->client->adapter, &msg, 1);
> +	mutex_unlock(&tc358765_i2c->xfer_lock);
> +
> +	if (ret != 1)
> +		return ret;
> +	return 0;
> +}

What about using smbus?

> +
> +	if (copy_from_user(&buf, ubuf, size))
> +		return -EFAULT;
> +
> +	buf[size-1] = '\0';
> +	if (sscanf(buf, "%s %x", name, &value) != 2) {
> +		dev_err(dev, "%s: unable to parse input\n", __func__);
> +		return -1;
> +	}
> +
> +	if (!tc358765_i2c) {
> +		dev_warn(dev,
> +			"failed to write register: I2C not initialized\n");
> +		return -ENODEV;
> +	}
> +
> +	reg_count = sizeof(tc358765_regs) / sizeof(tc358765_regs[0]);
> +	for (i = 0; i < reg_count; i++) {
> +		if (!strcmp(name, tc358765_regs[i].name)) {
> +			if (!(tc358765_regs[i].perm & A_WO)) {
> +				dev_err(dev, "%s is write-protected\n", name);
> +				return -EACCES;
> +			}
> +
> +			error = tc358765_write_register_i2c(
> +				tc358765_regs[i].reg, value);
> +			if (error) {
> +				dev_err(dev, "%s: failed to write %s\n",
> +					__func__, name);
> +				return -1;

Could avoid returning -1 instead of returning a correct errno?

> +	gpio_set_value(dssdev->reset_gpio, 1);
> +	udelay(200);
> +	/* reset the panel */
> +	gpio_set_value(dssdev->reset_gpio, 0);
> +	/* assert reset */
> +	udelay(200);
> +	gpio_set_value(dssdev->reset_gpio, 1);
> +	/* wait after releasing reset */
> +	msleep(200);

I invite you to have a look at

Documentation/timers/timers-howto.txt

> +	/* reset LVDS-PHY */
> +	tc358765_write_register(dssdev, LVPHY0, (1 << 22));
> +	mdelay(2);

You should give me a really good reason for using mdelay.

> +	if (r) {
> +		dev_err(&dssdev->dev, "failed to configure DSI pins\n");
> +		goto err_disp_enable;
> +	};
        ^^^

???

> +static int tc358765_i2c_probe(struct i2c_client *client,
> +				   const struct i2c_device_id *id)
> +{
> +	tc358765_i2c = kzalloc(sizeof(*tc358765_i2c), GFP_KERNEL);

what about devm_kzalloc?

