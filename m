Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3FJQBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:01:43 -0400
Received: from sauhun.de ([89.238.76.85]:55889 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab3FJQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:01:41 -0400
Date: Mon, 10 Jun 2013 18:03:29 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: vt8500: Add support for I2C bus on Wondermedia SoCs
Message-ID: <20130610160328.GG2987@katana>
References: <1368350634-12654-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Content-Disposition: inline
In-Reply-To: <1368350634-12654-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tony,

> +static int wmt_i2c_wait_bus_not_busy(struct wmt_i2c_dev *i2c_dev)
> diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
> new file mode 100644
> index 0000000..5cebb29
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-wmt.c

...

> +{
> +	u16 val;
> +	int i;
> +	int ret = 0;
> +
> +	for (i = 0; i < 100000; i++) {
> +		val = readw(i2c_dev->base + REG_CSR);
> +		if (val & CSR_READY_MASK)
> +			break;
> +
> +		udelay(1);
> +	}
> +	if (i >= 9999999)
> +		ret = -EBUSY;

What about using time_after and usleep_range?

> +
> +	return ret;
> +}
> +static int wmt_i2c_write(struct i2c_adapter *adap, struct i2c_msg *pmsg,
> +						   int restart, int last)
> +{
> +	struct wmt_i2c_dev *i2c_dev = i2c_get_adapdata(adap);
> +	u16 val, tcr_val;
> +	int ret, wait_result;
> +	int xfer_len = 0;
> +
> +	if (!restart) {
> +		ret = wmt_i2c_wait_bus_not_busy(i2c_dev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (pmsg->len == 0) {
> +		/*
> +		 * We still need to run through the while (..) once, so
> +		 * start at -1 and break out early from the loop
> +		 */
> +		xfer_len = -1;
> +		writew(0, i2c_dev->base + REG_CDR);
> +	} else {
> +		writew(pmsg->buf[0] & 0xFF, i2c_dev->base + REG_CDR);
> +	}
> +
> +	if (!restart) {
> +		val = readw(i2c_dev->base + REG_CR);
> +		val &= ~CR_TX_END;
> +		writew(val, i2c_dev->base + REG_CR);
> +
> +		val = readw(i2c_dev->base + REG_CR);
> +		val |= CR_CPU_RDY;
> +		writew(val, i2c_dev->base + REG_CR);
> +	}
> +
> +	init_completion(&i2c_dev->complete);

INIT_COMPLETION (and init_completion in probe)

> +static int wmt_i2c_read(struct i2c_adapter *adap, struct i2c_msg *pmsg,
> +						  int restart, int last)
> +{
> +	struct wmt_i2c_dev *i2c_dev = i2c_get_adapdata(adap);
> +	u16 val, tcr_val;
> +	int ret, wait_result;
> +	u32 xfer_len = 0;
> +
> +	if (!restart) {
> +		ret = wmt_i2c_wait_bus_not_busy(i2c_dev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	val = readw(i2c_dev->base + REG_CR);
> +	val &= ~CR_TX_END;
> +	writew(val, i2c_dev->base + REG_CR);
> +
> +	val = readw(i2c_dev->base + REG_CR);
> +	val &= ~CR_TX_NEXT_NO_ACK;
> +	writew(val, i2c_dev->base + REG_CR);
> +
> +	if (!restart) {
> +		val = readw(i2c_dev->base + REG_CR);
> +		val |= CR_CPU_RDY;
> +		writew(val, i2c_dev->base + REG_CR);
> +	}
> +
> +	if (pmsg->len == 1) {
> +		val = readw(i2c_dev->base + REG_CR);
> +		val |= CR_TX_NEXT_NO_ACK;
> +		writew(val, i2c_dev->base + REG_CR);
> +	}
> +
> +	init_completion(&i2c_dev->complete);

ditto

> +static int wmt_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg msgs[],
> +			int num)
> +{
> +	struct i2c_msg *pmsg;
> +	int i, is_last, restart;
> +	int ret = 0;
> +
> +	for (i = 0; ret >= 0 && i < num; i++) {
> +		is_last = ((i + 1) == num);
> +		restart = (i != 0);
> +
> +		pmsg = &msgs[i];
> +		if (pmsg->flags & I2C_M_NOSTART)
> +			restart = 1;

NOSTART is not restart!? Either your variable is misnamed or check
Documentation/i2c/i2c-protocol what it is about.

> +		if (pmsg->flags & I2C_M_RD)
> +			ret = wmt_i2c_read(adap, pmsg, restart, is_last);
> +		else
> +			ret = wmt_i2c_write(adap, pmsg, restart, is_last);
> +	}
> +
> +	return (ret < 0) ? ret : i;
> +}
> +
> +static int wmt_i2c_reset_hardware(struct wmt_i2c_dev *i2c_dev)
> +{
> +	int err;
> +
> +	err = clk_prepare_enable(i2c_dev->clk);
> +	if (err) {
> +		dev_err(i2c_dev->dev, "failed to enable clock\n");
> +		return err;
> +	}
> +
> +	err = clk_set_rate(i2c_dev->clk, 20000000);
> +	if (err) {
> +		dev_err(i2c_dev->dev, "failed to set clock = 20Mhz\n");
> +		return err;
> +	}
> +
> +	writew(0, i2c_dev->base + REG_CR);
> +	writew(12, i2c_dev->base + REG_MCR);

What are those magic values?

> +	writew(ISR_WRITE_ALL, i2c_dev->base + REG_ISR);
> +	writew(IMR_ENABLE_ALL, i2c_dev->base + REG_IMR);
> +	writew(CR_ENABLE, i2c_dev->base + REG_CR);
> +	readw(i2c_dev->base + REG_CSR);		/* read clear */
> +	writew(ISR_WRITE_ALL, i2c_dev->base + REG_ISR);
> +
> +	if (i2c_dev->mode == I2C_MODE_STANDARD)
> +		writew(SCL_TIMEOUT(128) | TR_STD, i2c_dev->base + REG_TR);
> +	else
> +		writew(SCL_TIMEOUT(128) | TR_HS, i2c_dev->base + REG_TR);
> +
> +	return 0;
> +}
> +
> +static int wmt_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct wmt_i2c_dev *i2c_dev;
> +	struct i2c_adapter *adap;
> +	struct resource *res;
> +	int err;
> +	u32 clk_rate;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "device node not found\n");
> +		return -ENODEV;
> +	}

This can't happen since we were matched by the driver core.

> +
> +	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
> +	if (!i2c_dev) {
> +		dev_err(&pdev->dev, "device memory allocation failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	i2c_dev->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(i2c_dev->base))
> +		return PTR_ERR(i2c_dev->base);
> +
> +	i2c_dev->irq = irq_of_parse_and_map(np, 0);
> +	if (!i2c_dev->irq) {
> +		dev_err(&pdev->dev, "irq missing or invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	i2c_dev->clk = of_clk_get(np, 0);
> +	if (IS_ERR(i2c_dev->clk)) {
> +		dev_err(&pdev->dev, "unable to request clock\n");
> +		return PTR_ERR(i2c_dev->clk);
> +	}
> +
> +	i2c_dev->mode = I2C_MODE_STANDARD;
> +	err = of_property_read_u32(np, "clock-frequency", &clk_rate);
> +	if ((!err) && (clk_rate == 400000))
> +		i2c_dev->mode = I2C_MODE_FAST;
> +
> +	i2c_dev->dev = &pdev->dev;
> +
> +	err = devm_request_irq(&pdev->dev, i2c_dev->irq, wmt_i2c_isr, 0,
> +							"i2c", i2c_dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to request irq %i\n", i2c_dev->irq);
> +		return err;
> +	}
> +
> +	adap = &i2c_dev->adapter;
> +	i2c_set_adapdata(adap, i2c_dev);
> +	strlcpy(adap->name, "WMT I2C adapter", sizeof(adap->name));
> +	adap->owner = THIS_MODULE;
> +	adap->class = I2C_CLASS_HWMON;

Don't use .class unless you have an explicit reason to do so. It may
cost boot-time.

> +	adap->algo = &wmt_i2c_algo;
> +	adap->dev.parent = &pdev->dev;
> +	adap->dev.of_node = pdev->dev.of_node;
> +	adap->nr = of_alias_get_id(pdev->dev.of_node, "i2c");
> +
> +	err = wmt_i2c_reset_hardware(i2c_dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "error initializing hardware\n");
> +		return err;
> +	}
> +
> +	if (adap->nr < 0)
> +		err = i2c_add_adapter(adap);
> +	else
> +		err = i2c_add_numbered_adapter(adap);

add_numbered_adapter does handle this case internally.

> +
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to add adapter\n");
> +		return err;
> +	}
> +
> +	platform_set_drvdata(pdev, i2c_dev);
> +
> +	of_i2c_register_devices(adap);
> +
> +	return 0;
> +}
> +
> +static int wmt_i2c_remove(struct platform_device *pdev)
> +{
> +	struct wmt_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
> +
> +	/* Disable interrupts, clock and delete adapter */
> +	writew(0, i2c_dev->base + REG_IMR);
> +	clk_disable_unprepare(i2c_dev->clk);
> +	i2c_del_adapter(&i2c_dev->adapter);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id wmt_i2c_dt_ids[] = {
> +	{ .compatible = "wm,wm8505-i2c" },
> +	{ /* Sentinel */ },
> +};
> +
> +static struct platform_driver wmt_i2c_driver = {
> +	.probe		= wmt_i2c_probe,
> +	.remove		= wmt_i2c_remove,
> +	.driver		= {
> +		.name	= "wmt-i2c",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = wmt_i2c_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(wmt_i2c_driver);
> +
> +MODULE_DESCRIPTION("Wondermedia I2C master-mode bus adapter");
> +MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
> +MODULE_LICENSE("GPL v2");

Header says GPLv2+

> +MODULE_DEVICE_TABLE(of, wmt_i2c_dt_ids);

Thanks,

   Wolfram


--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRtfjQAAoJEBQN5MwUoCm2XjUQAIQ+EF1B1S97rmMsm10YqRrJ
Ggu/SMGRThok7ZpuwPQYjO+4hl1v+ip+hDTPav4RpFdGSicGELxUxZ5JbVZSw3gI
7Raiq1PrU0Ib+Ooao74kEevxamnc3cey77nhIn/hkhUecQSKelWfk4MuV5okEblA
QY103pGVcgMQ05SmQWF9JRABi1QbuAeCIreIKnygsSpQihajwv2h8gW9AJkQmCWf
42LxUnDuw/JlKLR2nScg1bDTLrkpeUxgrn1rBKD2xzzXObzTZU+97q1IHQGpL7pi
xqqs4jPHk7RH4F6wD1lR8SeojKIeBvSgHfxEgE21sSJclYMvYrloi7L4Zhx9dD+g
LfrN/GLZaH0wQDcUh6XiA+t+HyQk2BrBFFxHZbKz09RC4uX0zjPXkfMkfO2mPi/V
dN5D+cwg4tUSzyWoj8PjBri9hNc+/xj0wIerWnYcZnCrFehWkd/hzCESaTF6IFQz
jo37Qm8QQRL9YiC6tn+t8lOgI/BrZ5F9pgcNR2va6vN49aG4mf7spWFJGIZD8aKI
aaPvRrvtguipEMB8UgKnES0ui0QCw2dxHINYErxbOIXSGP9XRgCVz4qQkQ9pjFQ7
RbUgTy4zBZNO6PpSBYeHRwgOEtcVsmR8K6Fo92mLVvySiscNXJiYNafZ2OvEhWUe
nHypuvHDt2O5jLouDarH
=4S8Y
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
