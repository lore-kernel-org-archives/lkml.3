Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaKKLc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:32:29 -0500
Received: from sauhun.de ([89.238.76.85]:34165 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaKKLcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:32:04 -0500
Date: Tue, 11 Nov 2014 12:32:56 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20141111113255.GC3794@katana>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2014 at 11:40:26AM -0700, David E. Box wrote:
> This patch implements an I2C bus sharing mechanism between the host and p=
latform
> hardware on select Intel BayTrail SoC platforms using the X-Powers AXP288=
 PMIC.
>=20
> On these platforms access to the PMIC must be shared with platform hardwa=
re. The
> hardware unit assumes full control of the I2C bus and the host must reque=
st
> access through a special semaphore. Hardware control of the bus also make=
s it
> necessary to disable runtime pm to avoid interfering with hardware transa=
ctions.

Can we foresee that other platforms will have similar mechanisms in the
future?

> +config I2C_BAYTRAIL_SEM

I2C_DESIGNWARE_BAYTRAIL_SEM

> +	tristate "Intel Baytrail I2C semaphore support"
> +	depends on I2C_DESIGNWARE_PLATFORM
> +	select I2C_DESIGNWARE_CORE

This select is already covered by I2C_DESIGNWARE_PLATFORM.

> +	select IOSF_MBI
> +	help
> +	  This driver enables host access to the PMIC I2C bus on select Intel
> +	  BayTrail platforms using the X-Powers AXP288 PMIC. This driver is
> +	  required for host access to the PMIC on these platforms. You should
> +	  probably say Y if you have a BayTrail system, unless you know it uses
> +	  a different PMIC. Otherwises critical PMIC functions, like charging,
> +	  may not operate.
> +
> +	  This driver should be built as a m if I2C_DESIGNWARE_PLATFORM=3Dm,
> +	  and as y if I2C_DESIGNWARE_PLATFORM=3Dy.

That shouldn't be the user's task to ensure. Please enforce this in the
makefile. Check Documentation/kbuid/makefiles.txt, Section 3.3.

> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-baytrail-sem.c
> @@ -0,0 +1,157 @@
> +/*
> + * Intel BayTrail PMIC I2C bus semaphore implementaion
> + * Copyright (c) 2014, Intel Corporation.

Mika, can you have a look at the ACPI part here?

> diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busse=
s/i2c-designware-core.h
> index d66b6cb..13e0809 100644
> --- a/drivers/i2c/busses/i2c-designware-core.h
> +++ b/drivers/i2c/busses/i2c-designware-core.h
> @@ -65,6 +65,8 @@
>   * @ss_lcnt: standard speed LCNT value
>   * @fs_hcnt: fast speed HCNT value
>   * @fs_lcnt: fast speed LCNT value
> + * has_hw_lock: true if bus access requires hardware lock
> + * pm_runtime_disabled: true if pm runtime is disabled

Look closely. There is a difference to the entries above.

> @@ -123,3 +127,18 @@ extern void i2c_dw_disable(struct dw_i2c_dev *dev);
>  extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
>  extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
>  extern u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev);
> +
> +#if IS_ENABLED(CONFIG_I2C_BAYTRAIL_SEM)
> +extern int baytrail_i2c_acquire(struct dw_i2c_dev *dev);
> +extern void baytrail_i2c_release(struct dw_i2c_dev *dev);
> +extern void baytrail_evaluate_sem(struct dw_i2c_dev *dev);
> +#define i2c_dw_acquire_ownership(dev) baytrail_i2c_acquire(dev)
> +#define i2c_dw_release_ownership(dev) baytrail_i2c_release(dev)
> +#define i2c_dw_eval_lock(dev) baytrail_evaluate_sem(dev)
i2c_dw_test_ownership_support()?

That doesn't scale in case other platformts will need this. I could
imagine a struct i2c_dw_ownership_ops() (or whatever name) which gets
populated according to the matched device.

Thanks,

   Wolfram


--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYfPnAAoJEBQN5MwUoCm2rkUP/0vN0/lPlvhsGKjNzGO8Oi7V
5Tpuq/xGsprduYildUePlA3sB7pzQqXxst+rVCbkaCTBSAEHHj4DpuWsFfRrWgex
uDberogI9f0PXwDmXQd12f8ybhEjcM1Y7GKHxgy8AaTITUNija7MKQOZob2tGSP8
nE4dS8aJ8g/FpIJRxsZ72v0kHQDrgrldblOU3lTih5S7q2X50pvNF5g2AvwtYIJB
j+5EWY2F+Upo1pOE6J5j7kF9P8EaoPSBYq14KwRfMQdwe2VjZVhErBByP1RxV8yh
EMYLPc4fJ/gkvvdfX3pnDheryLhN43X/8GbqU0O8HZrZ+cSubRrBhO0Xm7b2guQ0
KDULcC0E/N7i0khss645QKXAMKKbkKafsS0E7DeKpF5sL0k5tsB858/V3j3L7+ut
qYpgaeGNP+5MmASrp0V9/GB5vI1BYQJV8LBeAn4CCjkmqHAr34aSU+F39q5HHXRq
kUNCkQzQ6vwQNjgAFwQ345vFmPhAfV+y9aSiKRYenjY+d/QHaJFdtuYcSEubmM9J
8SlYP2mBld4rLBAqVgswSlUDuklDl5F0iDWyL+U3uJMYTXnP8bLiRujSOWPRl4QE
DER2WTowFySSXAxgrieJ05KkGwTUr6nXjcJrJF8JSt0Fj8qn1HXNSw+bIWH5K+ps
omdCq/Zqfp0L+ODxYamx
=1VEs
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
