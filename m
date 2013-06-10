Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3FJOgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:36:45 -0400
Received: from sauhun.de ([89.238.76.85]:54436 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FJOgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:36:43 -0400
Date: Mon, 10 Jun 2013 16:38:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        naveenkrishna.ch@gmail.com
Subject: Re: [PATCH v9] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20130610143834.GD2987@katana>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1368785452-15140-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <1368785452-15140-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Naveen,

> +Optional properties:
> +  - samsung,hs-mode: Mode of operation, High speed or Fast speed mode. If not
> +    specified, default value is 0.

This was probably overlooked from my last review: Why can't you simply
enable hs-mode when clock-frequency is > 1MBit?

> +Example:
> +
> +hsi2c@12ca0000 {
> +	compatible = "samsung,exynos5-hsi2c";
> +	reg = <0x12ca0000 0x100>;
> +	interrupts = <56>;
> +	clock-frequency = <100000>;
> +
> +	/* Pinctrl variant begins here */
> +	pinctrl-0 = <&i2c4_bus>;
> +	pinctrl-names = "default";
> +	/* Pinctrl variant ends here */

I'd think the two comments above are not needed.

> +/*
> + * exynos5_i2c_wait_bus_idle
> + *
> + * Wait for the transaction to complete (indicated by the TRANS_DONE bit
> + * being set), and, if this is the last message in a transfer, wait for the
> + * MASTER_BUSY bit to be cleared.
> + *
> + * Returns -EBUSY if the bus cannot be bought to idle

s/bought/brought/

> +static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
> +			      struct i2c_msg *msgs, int stop)
> +{
> +	unsigned long timeout;
> +	int ret;
> +
> +	i2c->msg = msgs;
> +	i2c->msg_ptr = 0;
> +	i2c->msg_len = 0;
> +	i2c->trans_done = 0;
> +
> +	INIT_COMPLETION(i2c->msg_complete);
> +
> +	exynos5_i2c_message_start(i2c, stop);
> +
> +	ret = wait_for_completion_interruptible_timeout
> +		(&i2c->msg_complete, EXYNOS5_I2C_TIMEOUT);

Have you tested with SIGINT? Most drivers removed the _interruptible_
version of waiting since they couldn't get handling the signals proper
and the bus locked up.

> +	if (ret >= 0)
> +		timeout = ret;
> +	else
> +		return ret;
> +
> +	ret = i2c->state;
> +
> +	if ((timeout == 0) || (ret < 0)) {
> +		exynos5_i2c_reset(i2c);
> +		if (timeout == 0) {
> +			dev_warn(i2c->dev, "%s timeout\n",
> +				 (msgs->flags & I2C_M_RD) ? "rx" : "tx");
> +			return ret;
> +		} else if (ret == -EAGAIN) {
> +			return ret;
> +		}
> +	}
> +
> +	/*
> +	 * If this is the last message to be transfered (stop == 1)
> +	 * Then check if the bus can be brought back to idle.
> +	 *
> +	 * Return -EBUSY if the bus still busy.
> +	 */
> +	if (exynos5_i2c_wait_bus_idle(i2c, stop))
> +		return -EBUSY;
> +
> +	/* Return the state as in interrupt routine */
> +	return ret;
> +}
> +
> +static int exynos5_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg *msgs, int num)
> +{
> +	struct exynos5_i2c *i2c = (struct exynos5_i2c *)adap->algo_data;
> +	struct i2c_msg *msgs_ptr = msgs;
> +	int retry, i = 0;
> +	int ret = 0, ret_pm;
> +	int stop = 0;
> +
> +	if (i2c->suspended) {
> +		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
> +		return -EIO;
> +	}
> +
> +	ret_pm = pm_runtime_get_sync(i2c->dev);
> +	if (IS_ERR_VALUE(ret_pm)) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	for (retry = 0; retry < adap->retries; retry++) {

You don't need to retry. The core does it if you return -EAGAIN.

> +		for (i = 0; i < num; i++) {
> +			stop = (i == num - 1);
> +
> +			ret = exynos5_i2c_xfer_msg(i2c, msgs_ptr, stop);
> +			msgs_ptr++;
> +
> +			if (ret == -EAGAIN) {
> +				msgs_ptr = msgs;
> +				break;
> +			} else if (ret < 0) {
> +				goto out;
> +			}
> +		}
> +
> +		if ((i == num) && (ret != -EAGAIN))
> +			break;
> +
> +		dev_dbg(i2c->dev, "retrying transfer (%d)\n", retry);
> +
> +		udelay(100);
> +	}
> +
> +	if (i == num) {
> +		ret = num;
> +	} else {
> +		/* Only one message, cannot access the device */
> +		if (i == 1)
> +			ret = -EREMOTEIO;
> +		else
> +			ret = i;
> +
> +		dev_warn(i2c->dev, "xfer message failed\n");
> +	}
> +
> + out:
> +	clk_disable_unprepare(i2c->clk);
> +	pm_runtime_mark_last_busy(i2c->dev);
> +	pm_runtime_put_autosuspend(i2c->dev);
> +	return ret;
> +}
> +
> +static u32 exynos5_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
> +}
> +
> +static const struct i2c_algorithm exynos5_i2c_algorithm = {
> +	.master_xfer		= exynos5_i2c_xfer,
> +	.functionality		= exynos5_i2c_func,
> +};
> +
> +static int exynos5_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct exynos5_i2c *i2c;
> +	struct resource *mem;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "no device node\n");
> +		return -ENOENT;
> +	}
> +
> +	i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
> +	if (!i2c) {
> +		dev_err(&pdev->dev, "no memory for state\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Mode of operation High/Fast Speed mode */
> +	if (of_get_property(np, "samsung,hs-mode", NULL)) {
> +		i2c->speed_mode = HSI2C_HIGH_SPD;
> +		i2c->fs_clock = HSI2C_FS_TX_CLOCK;
> +		if (of_property_read_u32(np, "clock-frequency", &i2c->hs_clock))
> +			i2c->hs_clock = HSI2C_HS_TX_CLOCK;
> +	} else {
> +		i2c->speed_mode = HSI2C_FAST_SPD;
> +		if (of_property_read_u32(np, "clock-frequency", &i2c->fs_clock))
> +			i2c->fs_clock = HSI2C_FS_TX_CLOCK;
> +	}
> +
> +	strlcpy(i2c->adap.name, "exynos5-i2c", sizeof(i2c->adap.name));
> +	i2c->adap.owner   = THIS_MODULE;
> +	i2c->adap.algo    = &exynos5_i2c_algorithm;
> +	i2c->adap.retries = 2;
> +	i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD;

Don't use .class unless you have an explicit reason to do so. It may
cost boot-time.

> +
> +	i2c->dev = &pdev->dev;
> +	i2c->clk = devm_clk_get(&pdev->dev, "hsi2c");
> +	if (IS_ERR(i2c->clk)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		return -ENOENT;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	i2c->regs = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(i2c->regs)) {
> +		dev_err(&pdev->dev, "cannot map HS-I2C IO\n");

devm_ioremap_resource will print the error message for you.

> +		ret = PTR_ERR(i2c->regs);
> +		goto err_clk;
> +	}
> +
> +	i2c->adap.dev.of_node = np;
> +	i2c->adap.algo_data = i2c;
> +	i2c->adap.dev.parent = &pdev->dev;
> +
> +	/* Clear pending interrupts from u-boot or misc causes */
> +	exynos5_i2c_clr_pend_irq(i2c);
> +
> +	init_completion(&i2c->msg_complete);
> +
> +	i2c->irq = ret = irq_of_parse_and_map(np, 0);
> +	if (ret <= 0) {
> +		dev_err(&pdev->dev, "cannot find HS-I2C IRQ\n");
> +		ret = -EINVAL;
> +		goto err_clk;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, i2c->irq, exynos5_i2c_irq,
> +				0, dev_name(&pdev->dev), i2c);
> +
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "cannot request HS-I2C IRQ %d\n", i2c->irq);
> +		goto err_clk;
> +	}
> +
> +	/*
> +	 * TODO: Use private lock to avoid race conditions as
> +	 * mentioned in pm_runtime.txt
> +	 */

Is this planned somewhen?

> +	pm_runtime_enable(i2c->dev);
> +	pm_runtime_set_autosuspend_delay(i2c->dev, EXYNOS5_I2C_PM_TIMEOUT);
> +	pm_runtime_use_autosuspend(i2c->dev);
> +
> +	ret = pm_runtime_get_sync(i2c->dev);
> +	if (IS_ERR_VALUE(ret))
> +		goto err_clk;
> +
> +	ret = exynos5_hsi2c_clock_setup(i2c);
> +	if (ret)
> +		goto err_pm;
> +
> +	i2c->bus_id = of_alias_get_id(i2c->adap.dev.of_node, "hsi2c");
> +
> +	exynos5_i2c_init(i2c);
> +
> +	i2c->adap.nr = -1;
> +	ret = i2c_add_numbered_adapter(&i2c->adap);

Skip setting -1 and use i2c_add_adapter.

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
> +		goto err_pm;
> +	}
> +
> +	of_i2c_register_devices(&i2c->adap);
> +	platform_set_drvdata(pdev, i2c);
> +
> +	clk_disable_unprepare(i2c->clk);
> +	pm_runtime_mark_last_busy(i2c->dev);
> +	pm_runtime_put_autosuspend(i2c->dev);
> +
> +	return 0;
> +
> + err_pm:
> +	pm_runtime_put(i2c->dev);
> +	pm_runtime_disable(&pdev->dev);
> + err_clk:
> +	clk_disable_unprepare(i2c->clk);
> +	return ret;
> +}

...

> +
> +static struct platform_driver exynos5_i2c_driver = {
> +	.probe		= exynos5_i2c_probe,
> +	.remove		= exynos5_i2c_remove,
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= "exynos5-hsi2c",
> +		.pm	= EXYNOS5_DEV_PM_OPS,
> +		.of_match_table = exynos5_i2c_match,
> +	},
> +};
> +
> +static int __init i2c_adap_exynos5_init(void)
> +{
> +	return platform_driver_register(&exynos5_i2c_driver);
> +}
> +subsys_initcall(i2c_adap_exynos5_init);
> +
> +static void __exit i2c_adap_exynos5_exit(void)
> +{
> +	platform_driver_unregister(&exynos5_i2c_driver);
> +}
> +module_exit(i2c_adap_exynos5_exit);

Use the module_platform_driver macro, please.

Thanks for keeping at it!

   Wolfram

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRteTpAAoJEBQN5MwUoCm27cEP+wW9ApvKdwSJRgBxNfLjfe53
o48bYBF8x3PQRR8+MWHw8usUNmltRIwzL32x2JTC0sUW75nGC0+8WnNiQ5QrR6WH
5JUfv4AYQhMbpf9PtrqBFHdZOgd+ocRfxqllzuA0z2e8QMLKlbnB50ePXKwD15Z6
74qTiiCo2p/HkN9r8r9RTTEM1yniSOgMZaKTyQCmCkLOjDSVyVVts2+7sLZ89R0K
4jSMHcwil6OcVRSVvteVWwWXdRUfa2h4pLkOW0ZcjZJRsQYO6a8UuJv+/JILcY8j
KgTjeYFPb65e7T+vRHh3EPtZA7mNKZnmgSm7M+iqxf+niuX3jrRwU2fhJsWTeSBG
AJvCQ6Qmyc6hKmQJG7Llomo4K66m2UHA67sX9+OfbLCCGtkYu04INBLPmjYxlCUV
jlQwMyXOnHK/9vN5ZBWCwnGKcYne61sFrDn/B4UubXn7MlGcRSt/C9wYqBYDgTOB
5rY1k+ZmT1WBiwpYa/AhQR41o3L91TpO+zgNefbN9Ts99hUQM1RxQUFdqwt781xY
z8ImjaSIa4a/8mhsfhW6HSwoiI0Pe+mdjPEVNU2v+2HTQuKn5cSkSLcjR2F9bPNX
Pq/jB8cac5hKo+uEsdLrjnz/c5tK0bdWqyKxWP+nnLUnbaAcshlWxT8T55V8S0AO
kFLYReeldI333DkxedBm
=nW2c
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
