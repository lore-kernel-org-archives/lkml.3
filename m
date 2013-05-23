Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3EWVp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:45:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab3EWVp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:45:26 -0400
Date: Thu, 23 May 2013 23:45:17 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2 04/11] pwm: Add Renesas TPU PWM driver
Message-ID: <20130523214517.GA18249@avionic-0098.adnet.avionic-design.de>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1366836616-21475-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1366836616-21475-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:x87WMdw6HxvqznNuIV9jQA1zyzAt08L0QGsaZDxFbv/
 y7HTbv/bA7smT5lXlA27h9mfNzOvipqZyXMv2wxDXZcw7/jVxv
 D3hcn/IniQcJKhLswf+O6fLufJSPmMR0/ZMo5eyUHMJJ0C5Lhc
 4LAUTwyADVNaKtzkOtMIjHNlw4zuxWNiVtsM5+miFQ8YM/LWhY
 r7igKRY2o/ss2Kq+ncatZzl9hAZf3aaHyXNB5ygULBox2rXu5a
 s3QTzQAJq9bAyYVj2hnQK6iyB/tJh/Tq6bRru8YNh/Lb0Dt1jy
 Vivfc0FxiV/PPAAkUbqwLCHlioNfy86/C8MKgvSSUZoWKI1JpY
 6F1Ie3N52dg8kPRU2t7DZnfRWuVfi19Mzdn4StMWeUMCtaZHAF
 XcC21FID8Fwj2jpYet9cCa468AN5Pc/VRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 10:50:09PM +0200, Laurent Pinchart wrote:
> The Timer Pulse Unit (TPU is a 4-channels 16-bit timer used to generate
> waveforms. This driver exposes PWM functions through the PWM API for
> other drivers to use.
>=20
> The code is loosely based on the leds-renesas-tpu driver by Magnus Damm
> and the TPU PWM driver shipped in the Armadillo EVA 800 kernel sources.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>
> Tested-by: Simon Horman <horms@verge.net.au>

Sorry for taking so long to look at this...

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 0e0bfa0..d57ef66 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -115,6 +115,13 @@ config PWM_PXA
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-pxa.
> =20
> +config PWM_RENESAS_TPU
> +	tristate "Renesas TPU PWM support"
> +	depends on ARCH_SHMOBILE
> +	help
> +	  This driver exposes the Timer Pulse Unit (TPU) PWM controller found
> +	  in Renesas chips through the PWM API.

If the driver can be built, it'd be good to include a short sentence
saying what it will be called, just like for the other drivers.

> diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
[...]
> +struct tpu_pwm_device {
> +	bool timer_on;			/* Whether the timer is running */
> +
> +	struct tpu_pwm_channel_data *pdata;
> +	struct tpu_device *tpu;
> +	unsigned int channel;		/* Channel number in the TPU */

I don't think you need this. The pwm_device.hwpwm field carries the same
information.

> +
> +	unsigned int prescaler;
> +	u16 period;
> +	u16 duty;
> +};
> +
> +struct tpu_device {
> +	struct platform_device *pdev;
> +	struct pwm_chip chip;
> +	spinlock_t lock;
> +
> +	void __iomem *base;
> +	struct clk *clk;
> +
> +	struct tpu_pwm_device pwms[TPU_CHANNEL_MAX];
> +};

Can't you reuse the infrastructure built into the PWM subsystem? You can
associate chip-specific data with each PWM device. You can look at the
pwm-atmel-tcb and pwm-bfin drivers for usage examples. In a nutshell you
hook the .request() function and setup the driver-specific structure and
associate them with the PWM using pwm_set_chip_data().

This has the advantage that you don't need the pwms array in tpu_device
and you also don't need TPU_CHANNEL_MAX because only the pwm_chip.npwm
field needs to contain the number of channels.

> +static int tpu_pwm_timer_start(struct tpu_pwm_device *pwm)
> +{
> +	int ret;
> +
> +	if (!pwm->timer_on) {
> +		/* Wake up device and enable clock. */
> +		pm_runtime_get_sync(&pwm->tpu->pdev->dev);
> +		ret =3D clk_prepare_enable(pwm->tpu->clk);
> +		if (ret) {
> +			dev_err(&pwm->tpu->pdev->dev, "cannot enable clock\n");
> +			return ret;
> +		}
> +		pwm->timer_on =3D true;
> +	}
> +
> +	/* Make sure the channel is stopped, as we need to reconfigure it
> +	 * completely. First drive the pin to the inactive state to avoid
> +	 * glitches.
> +	 */

Can you please stick to the standard coding style for block comments?
That is:

	/*
	 * Make sure...
	 * ...
	 * glitches.
	 */

> +/* ---------------------------------------------------------------------=
--------
> + * PWM API
> + */

I find these separators more distracting than helpful. But if you have a
strong preference for them I can live with it.

> +
> +static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device *_pw=
m)
> +{
> +	struct tpu_device *tpu =3D to_tpu_device(chip);
> +	struct tpu_pwm_device *pwm =3D &tpu->pwms[_pwm->hwpwm];
> +
> +	return pwm->pdata =3D=3D NULL ? -EPROBE_DEFER : 0;
> +}

If you use the same method as the pwm-bfin or pwm-atmel-tcb drivers, you
could initialize each PWM channel here and associated them with the PWM
device using pwm_set_chip_data() (as I hinted at earlier).

> +static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
> +			  int duty_ns, int period_ns)
[...]
> +	if (period_ns <=3D 0 || duty_ns < 0 || duty_ns > period_ns)
> +		return -EINVAL;

The core already performs these checks so they can be dropped.

> +	/* Pick a prescaler to avoid overflowing the counter.
> +	 * TODO: Pick the highest acceptable prescaler.
> +	 */
> +	clk_prepare_enable(tpu->clk);

Shouldn't you check the return value here?

> +	clk_rate =3D clk_get_rate(tpu->clk);
> +	clk_disable_unprepare(pwm->tpu->clk);

And does the clock really need to be enabled to obtain the rate?

> +	for (prescaler =3D 0; prescaler < ARRAY_SIZE(prescalers); ++prescaler) {
> +		period =3D clk_rate / prescalers[prescaler]
> +		       / (NSEC_PER_SEC / period_ns);

I prefer to have the operator on the previous line, as in:

		period =3D clk_rate / prescalers[prescaler] /
			 (NSEC_PER_SEC / period_ns);

> +	duty_only =3D pwm->prescaler =3D=3D prescaler && pwm->period =3D=3D per=
iod;

Maybe the following would be easier to read?

	if (prescaler =3D=3D pwm->prescaler && period =3D=3D pwm->period)
		duty_only =3D true;

And initialize duty_only =3D false when declaring it.

> +static int tpu_probe(struct platform_device *pdev)
> +{
> +	struct tpu_pwm_platform_data *pdata =3D pdev->dev.platform_data;
> +	struct tpu_device *tpu;
> +	struct resource *res;
> +	unsigned int i;
> +	int ret;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "missing platform data\n");
> +		return -ENXIO;
> +	}
> +
> +	tpu =3D devm_kzalloc(&pdev->dev, sizeof(*tpu), GFP_KERNEL);
> +	if (tpu =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to allocate driver data\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Map memory, get clock and pin control. */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get I/O memory\n");
> +		return -ENXIO;
> +	}
> +
> +	tpu->base =3D devm_ioremap_nocache(&pdev->dev, res->start,
> +					 resource_size(res));
> +	if (tpu->base =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> +		return -ENXIO;
> +	}

Isn't this mising a request_mem_region()? Couldn't you just use a call
to devm_ioremap_resource() instead?

> +static struct platform_driver tpu_driver =3D {
> +	.probe		=3D tpu_probe,
> +	.remove		=3D tpu_remove,
> +	.driver		=3D {
> +		.name	=3D "renesas_tpu_pwm",

Can this perhaps be renamed to "renesas-tpu-pwm" for consistency with
other drivers?

And I think this is missing

		.owner =3D THIS_MODULE,

as well. I know not all drivers have this either, but I have that on my
TODO already.

> diff --git a/include/linux/platform_data/pwm-renesas-tpu.h b/include/linu=
x/platform_data/pwm-renesas-tpu.h
[...]
> +#define TPU_CHANNEL_MAX		4
> +
> +#define TPU_PWM_ID(device, channel) \
> +	((device) * TPU_CHANNEL_MAX + (channel))

Please don't do this. It assumes a global namespace for PWM devices.
However the global namespace is only for compatibility with legacy code
and shouldn't be depended on by new drivers. You should be using either
DT to dynamically refer to PWM devices or use a PWM lookup table. Refer
to Documentation/pwm.txt for details.

> +struct tpu_pwm_channel_data {
> +	bool enabled;
> +	bool active_low;

Maybe this should be enum pwm_polarity?

> +};
> +
> +struct tpu_pwm_platform_data {
> +	struct tpu_pwm_channel_data channels[TPU_CHANNEL_MAX];
> +};

This could be a little difficult to handle in the absence of
TPU_CHANNEL_MAX. Depending on the hardware, I suppose you could just
handle it via the .request() function. In that case all channels would
be disabled by default and enabled automatically when requested by a
user driver.

Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRno3tAAoJEN0jrNd/PrOhn+8QAKMYF2bl4ywBF+AIAAPSnYIZ
NZiw4hLSd4J3E06ylQKHfodsiVwClUb9FRa12772VSxnv0jd1UCOFqsgZ+UmQdTz
pB+YnjvYE4swGDySd3CeN0alqPYtpLpbzUZqgTAZ4O1WRrpLm0FGjsR41o9Z7/MS
BBcfsv3MeTKbEQWN08Hf+myBJ3zoBfrXXxKx0iD0PjV+7CU/AbuIXmv0zGUlvUGn
gxFiMdYWQeQlkvMh1Lsj7vSaD96TwyuxHJXX8DbW/8lXExa+5y8XCD/qkwtUwhYZ
IfgmTk9mke8GR8kyZihDbNvpLecyXls87fe0bvy5WVMBgTEmf/zhNN8hdGo9hmkf
laH402xcfNJypIZb6bjG2wxOaPlxECueecsEfnsH7WtqPhbHgY8sdmC2VBbK2k0X
sYmi05UADT9ogzMIy1nY5ZNsVlP8g9Veg7jkRR1svcA1stgGRHEfaQ/L8r2CB5Zq
pjUobyj7dzDnpeolI6gMwX1capum95kaG2HtJ/jxVcH5yBdDxeioK70PACOvPah2
MBI4wierNndz0yVxj0kKL/ZpDSzwFnksQI1IbVJNnkAvmPwclItlapR6PTo2NSsE
fvb3JCXKzOfOE8Q8xGfIRs4R4qPHN0ZOahxAKpshM2iMFqlurq6PUw3JZ3oS9nNb
5Di/nfUZ1FeTuFf9CIzc
=8WSw
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
