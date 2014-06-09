Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaFITjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:39:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34310 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaFITju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:39:50 -0400
Date: Mon, 9 Jun 2014 20:38:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140609193849.GE5099@sirena.org.uk>
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402306670-17041-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wUMz9o/vfMbinXcu"
Content-Disposition: inline
In-Reply-To: <1402306670-17041-3-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wUMz9o/vfMbinXcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 11:37:47AM +0200, Javier Martinez Canillas wrote:

> +	case REGULATOR_MODE_STANDBY:			/* switch off */
> +		if (id != MAX77802_LDO1 && id != MAX77802_LDO20 &&
> +			id != MAX77802_LDO21 && id != MAX77802_LDO3) {
> +			val = MAX77802_OPMODE_STANDBY;
> +			break;
> +		}
> +		/* no break */

This sounds very broken...

> +		/* OK if some GPIOs aren't defined */
> +		if (!gpio_is_valid(gpio))
> +			continue;
> +
> +		/* If a GPIO is valid, we'd better be able to claim it */
> +		ret = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
> +					    "max77802 selb");
> +		if (ret) {
> +			dev_err(dev, "can't claim gpio[%d]: %d\n", i, ret);
> +			return ret;
> +		}

Can this use the GPIO descriptor API?

> +static void max77802_copy_reg(struct device *dev, struct regmap *regmap,
> +			      int from_reg, int to_reg)
> +{
> +	int val;
> +	int ret;
> +
> +	if (from_reg == to_reg)
> +		return;
> +
> +	ret = regmap_read(regmap, from_reg, &val);
> +	if (!ret)
> +		ret = regmap_write(regmap, to_reg, val);
> +
> +	if (ret)
> +		dev_warn(dev, "Copy err %d => %d (%d)\n",
> +			 from_reg, to_reg, ret);
> +}

This doesn't look at all device specific, better implement it in generic
code.

> +	if (pdata->num_regulators != MAX77802_MAX_REGULATORS) {
> +		dev_err(&pdev->dev,
> +			"Invalid initial data for regulator's initialiation: " \
> +			"expected %d, pdata/dt provided %d\n",
> +			MAX77802_MAX_REGULATORS,
> +			pdata->num_regulators);
> +		return -EINVAL;
> +	}

Don't split log messages over multiple lines so people can find the log
message in the kernel source with grep, though in any case checking for
this is a bug - the driver should always be at least able to read the
current state from the hardware.

> +static int __init max77802_pmic_init(void)
> +{
> +	return platform_driver_register(&max77802_pmic_driver);
> +}
> +subsys_initcall(max77802_pmic_init);

module_platform_driver().

--wUMz9o/vfMbinXcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlg1GAAoJELSic+t+oim91rsP/REjU5VbMDkGIC/InQFkOIU4
evhlm0UkJVsPUmShVahVbj7RPZ6nRllBT7neubpr5xriX/L9qPqv103o903gaDDz
QGIVL2RMoMHDY3sbZG1iSzQfzcwHSOz2BFfSViAZfY0JjfEth68mORO9I9gTrdbQ
ZJcjDpGEp5xv4kFYF4/4kElVYJLdgzRsEwx8JvZ7LuJo9XBenyWFy60A7OUeZjV6
/o7spbsrF9sthwhxusnPznHxfylDCSNKFASYwrbw2IWC5tDbN7n9QzFZCPkeMzL0
59cj8VP9t/+dhKf6qLwCoU4jGNVdeDQeNkZsHS6bb6MdwrThT/p+1DzYBaAzGYoN
4/MyCeu1FyqYSGfScG0/e/bF+85Om8NftXbFb+joVRmVHqhz3R3YGevgGwr7CTOx
XASvXeIP13O4YTuGBDN5pol8IfJIvuXUIGDfFl0n9pmLToLTdp+s10kEoMy1y2Ur
Rh5eXJ0eG8cNomYAKYhUGo1sr3dwIpOgegLfGBF8bTFQtOYsemWgraNrT1qqOgJe
SeQ+CEomtg9bFkjZz6wQ1gcPcuSxGMnj9B2HP57yT6b7zepg/wlJtOxH6XsHH+3m
FL6RUOtiEHPl8F3U2H8VAp5/7Q7jhcaMUHofQ4plnFJc6e8NrvO/G6fmvGx/GnBb
o/6fscw3L4Ldo6m8+fAL
=KpTv
-----END PGP SIGNATURE-----

--wUMz9o/vfMbinXcu--
