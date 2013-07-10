Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3GKKdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:33:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43736 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3GKKdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:33:32 -0400
Date: Wed, 10 Jul 2013 16:47:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130710154712.GG24508@sirena.org.uk>
References: <1373464848-28146-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3607uds81ZQvwCD0"
Content-Disposition: inline
In-Reply-To: <1373464848-28146-1-git-send-email-jonas.jensen@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] rtc: Add MOXA ART RTC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3607uds81ZQvwCD0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2013 at 04:00:48PM +0200, Jonas Jensen wrote:

> +++ b/drivers/rtc/Makefile
> @@ -77,6 +77,7 @@ obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
>  obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
>  obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
>  obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
> +obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
>  obj-$(CONFIG_RTC_DRV_MPC5121)	+= rtc-mpc5121.o

It'd be good to keep this sorted.

> +struct rtc_plat_data {

This is a bit confusing - normally platform data is data passed in by
the platform as part of device registration, not runtime data.

> +	struct rtc_device *rtc;
> +};
> +
> +static spinlock_t rtc_lock;

Why is this global not part of the runtime data?  Not that anyone is
likely to have two RTCs in the one system but still...

> +u8 moxart_rtc_read_byte(void)
> +{
> +	int i;
> +	u8 data = 0;
> +
> +	for (i = 0; i < 8; i++) {
> +		gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_LOW);
> +		udelay(GPIO_RTC_DELAY_TIME);
> +		gpio_set_value(GPIO_RTC_SCLK, GPIO_EM1240_HIGH);
> +		if (gpio_get_value(GPIO_RTC_DATA))
> +			data |= (1 << i);
> +		udelay(GPIO_RTC_DELAY_TIME);

This looks wrong, although I expect it's probably fine - you're reading
the value with no delay after setting the GPIO high.  I assume the
hardware actually strobes the data out on the the high to low transition
but in that case I'd expect the get to be before the raise.  Either that
or some delay after the raise just to make sure.

It's also very odd seeing the constants for _LOW and _HIGH, these should
just be booleans.

> +static int moxart_rtc_ioctl(struct device *dev, unsigned int cmd,
> +	unsigned long arg)
> +{
> +	switch (cmd) {
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +
> +	return 0;
> +}

Why not just remove this function?

> + out:
> +	if (pdata->rtc)
> +		rtc_device_unregister(pdata->rtc);
> +	devm_kfree(&pdev->dev, pdata);

devm_kfree() isn't needed, the main point of devm_ is to avoid having to
explicitly free things.

> +	gpio_free(GPIO_RTC_DATA);
> +	gpio_free(GPIO_RTC_SCLK);
> +	gpio_free(GPIO_RTC_RESET);

Use devm_gpio_request().

--3607uds81ZQvwCD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3YH8AAoJELSic+t+oim9zRkP/iml1pL7a1fKYjiStiQtyK8E
0i2eqtjl84hqsjsVkpCEcYSaSYAqYi9eid1HjvKUh8KxrE7fwPsp025RperacRgI
agjQ1jEVbp/G684k/x+eNkJZwhtp2NaqLg27mbqgCmp9Dzm8CgeL1T20/Uer3Rlw
3fHjlnuI9Wp2a8ISofeE30nMgoeX5Ir5IYoccOuC0+Rp04Fx3LJbPS7kpYCNb9k2
j8NhbhpAraBn4zFfc0a9EcSveXVlfxGxFyTaJE2D6/p9HCxRv4Oo7F2UCl2B/TDZ
pClYdCobkcT6OWCzQXK+VEiUlzpVNOJC9dPwsAnn0UQnk3dA9B3JccGZo7nBclvE
Jjm+QkXqfUGjVd75rsdDHR/QudjiovjcitPP7IUWHLPwuJ3BuwuqRspZkcyIw847
6llcQzLB+F0DNzEl0dq2VEFNjA4/46CC0hoEuJkV8Q8U3jJNg/L6i8r0mHhy69KO
1Fht5z6kW4AIzFUbpDgFRg5+Bg+IbyRcmA6L7GyyqKqWjGS3qunMUvFROyvxd6eA
gGivghPtefNSsYeL5BdVSCsZ6tXSrcejWDcMayEVSsjWjrGcHY6kDT//PZ5kke3V
KSNtKTuMS2y1S4PeuTzTLHLY2/NJqfF9Dwo7o/rm8BsCdoulvUYtXcCf51E2s72K
gJHw/UaIxn274V0VbguM
=N4Bl
-----END PGP SIGNATURE-----

--3607uds81ZQvwCD0--
