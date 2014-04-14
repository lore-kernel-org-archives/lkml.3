Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaDNRfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:35:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaDNRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:35:38 -0400
Date: Mon, 14 Apr 2014 18:35:19 +0100
From: Mark Brown <broonie@kernel.org>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Message-ID: <20140414173519.GC25182@sirena.org.uk>
References: <534AA271.5010303@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <534AA271.5010303@gmail.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] [PATCH] rtc: add support for maxim dallas rtc ds1343
 and ds1344
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 13, 2014 at 08:12:57PM +0530, RAGHAVENDRA GANIGA wrote:

> +static const struct spi_device_id ds1343_id[] = {
> +	{ "ds1343", 0 },
> +	{ "ds1344", 1 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(spi, ds1343_id);

If the 0 and 1 mean anything there they should have #defines, otherwise
just omit them.

> +static int ds1343_get_reg(struct device *dev, unsigned char address,
> +				unsigned char *buf)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +
> +	/* MSB of the spi address                        _
> +	   in this rtc should be zero for read operation R/W */
> +	*buf = address;
> +
> +	return spi_write_then_read(spi, buf, 1, buf, 1);
> +}

This and the set_reg() function look like you should be using regmap.

> +static int ds1343_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +#ifdef RTC_SET_CHARGE
> +	case RTC_SET_CHARGE:
> +	{
> +		int val;
> +
> +		if (copy_from_user(&val, (int __user *)arg, sizeof(int)))
> +			return -EFAULT;
> +
> +		return ds1343_set_reg(dev, DS1343_TRICKLE_REG, val);
> +	}
> +	break;
> +#endif
> +	}

What defines this?  I notice that ds1302 also does this - is this device
different enouh to need a separate driver?

> +static irqreturn_t ds1343_irq(int irq, void *dev_id)
> +{
> +	struct ds1343_priv *priv = dev_id;
> +
> +	disable_irq_nosync(irq);
> +	schedule_work(&priv->work);
> +	return IRQ_HANDLED;
> +}

Use request_threaded_irq() rather than open coding it.

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTBxUAAoJELSic+t+oim96r4P/jRa2MAQfmcT8OwnBqW1vM0O
QbPpJxEVnbbIOhZIbAv+Q0rNfHdrbBwSXN7YABXsPplDOYMw1PnACpFQEQpKtOzj
rx47oPFuZSTthInXj44KXfrbegLSXp4NPNcKuDZAo7ivOrx3o72GL+k6pRPP5Nn/
YcRFLTKrECOrRFsupyEiRNg+juK8HjYKR9XBWB1P8X+rBRMEtLvlbcmbqWPWN5C5
9f8xeAh8Xv1wqw+SoRV6T9HIKaoURr1IcSO1lnB9GzD2RoUjEB/clY5uG8A4KD+w
TM7WjGcuacG2JQ9rgk058wGmDG3DYmWEBwQsS+MwSu1QybiMcTq5jr3Kf1Uk6xkN
WTTiug4/X9MWtQdr82IS0ZPMdZOaQWBVHNzxMi8Brr2rVdJYIoFBEDsJ0Fby7/y5
Cbc98a4gj51cJTJSsW0omVjA45o6ZDLNS19RUu1mOkXBN4RB/F1kNSOBF0Xjzjex
wYCIiMv+VFZ16WrnC1tCVLzAYyZxIM5x0I7JtUXRyJ42Yd1gpGAVRK3Od9QaNvDs
b14HGNg0Yiu2Mz8PwWPLapyYogEgHEac1Tz1T+vFepfkdqPG0q44ZPoUYzTikY8N
8NmeWHsluLQdSZOOC5X4yqaeuXx7QXdNAI4Q3IJBEenC4Ckt21L+Tfpw2xv6huZ8
vphMn3eLdNcH6eGknxyD
=6ENO
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
