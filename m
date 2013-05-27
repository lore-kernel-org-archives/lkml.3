Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab3E0TNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 15:13:39 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:55644 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3E0TNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 15:13:38 -0400
Date: Mon, 27 May 2013 21:13:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] pwm: add pca9685 driver
Message-ID: <20130527191333.GA10219@mithrandir>
References: <1369646907-18424-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1369646907-18424-1-git-send-email-s.trumtrar@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2013 at 11:28:27AM +0200, Steffen Trumtrar wrote:
> Add pwm driver for the NXP pca9685 16 channel pwm-led controller.

Please stick to the all-caps spelling of PWM in prose. Also why is this
called pwm-led? Can't the generated PWM signal be used for other
purposes?

> The driver is really barebones at this stage. E.g. the OE' pin and
> therefore the according registers are not supported.

s/according/corresponding/?

> The driver was tested on a HW where this pin is tied to GND.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
> Changes since v1:
> 	- fix typo in documentation example
>=20
>  .../devicetree/bindings/pwm/nxp,pca9685-pwmled.txt |  28 +++
>  drivers/pwm/Kconfig                                |   9 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-pca9685-led.c                      | 245 +++++++++++++++=
++++++
>  4 files changed, 283 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/nxp,pca9685-pwm=
led.txt
>  create mode 100644 drivers/pwm/pwm-pca9685-led.c
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt=
 b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
> new file mode 100644
> index 0000000..6646980
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
> @@ -0,0 +1,28 @@
> +NXP PCA9685 16-channel 12-bit PWM LED controller
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Required properties:
> +  - compatible: "nxp,pca9685-pwmled"
> +  - #pwm-cells: should be 2.  The first cell specifies the per-chip index
> +    of the PWM to use and the second cell is the period in nanoseconds.
> +    The index 16 is the ALLCALL channel, that sets all pwm channels at t=
he same

"PWM channels" please.

> +Optional properties:
> +  - invrt:  <0> output logic state not inverted
> +	    <1> output logic state inverted

Why not make this "invert"?

> +  - outdrv: <0> configure outputs with open-drain structure
> +	    <1> configure outputs with totem pole structure

And this could be a boolean property called "totem-pole"? I think that's
much more intuitive to use.

> +Example:
> +
> +For LEDs that are directly connected to the pca, the following setting is

"to the PCA"?

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 115b644..8696f61 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -97,6 +97,15 @@ config PWM_MXS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-mxs.
> =20
> +config PWM_PCA9685_LED
> +	tristate "NXP PCA9685 PWM support for LED drivers"
> +	depends on OF

Isn't this missing a "depends on REGMAP_I2C"? And again, why is this LED
specific? Even if only LEDs are driven by the PWM signals, the part does
not have other functionality than driving PWM signals, right? So adding
an -led suffix isn't meaningful.

> diff --git a/drivers/pwm/pwm-pca9685-led.c b/drivers/pwm/pwm-pca9685-led.c
[...]
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/i2c.h>

I know I'm being picky here, but can you leave a blank line between the
end of the comment and the first #include, please?

> +#define PCA9685_MODE1		0x00
> +#define PCA9685_MODE2		0x01
> +#define PCA9685_SUBADDR1	0x02
> +#define PCA9685_SUBADDR2	0x03
> +#define PCA9685_SUBADDR3	0x04
> +#define PCA9685_ALLCALLADDR	0x05
> +#define PCA9685_LEDX_ON_L	0x06
> +#define PCA9685_LEDX_ON_H	0x07
> +#define PCA9685_LEDX_OFF_L	0x08
> +#define PCA9685_LEDX_OFF_H	0x09
> +
> +#define PCA9685_ALL_LED_ON_L	0xFA
> +#define PCA9685_ALL_LED_ON_H	0xFB
> +#define PCA9685_ALL_LED_OFF_L	0xFC
> +#define PCA9685_ALL_LED_OFF_H	0xFD
> +#define PCA9685_PRESCALE	0xFE
> +
> +#define PCA9685_NUMREGS		0xFF
> +#define PCA9685_MAXCHAN		0x10
> +
> +#define LED_FULL		(1 << 4)
> +#define MODE1_SLEEP		(1 << 4)
> +#define MODE2_INVRT		(1 << 4)
> +#define MODE2_OUTDRV		(1 << 2)
> +
> +#define LED_N_ON_H(N)		(PCA9685_LEDX_ON_H + (4 * (N)))
> +#define LED_N_ON_L(N)		(PCA9685_LEDX_ON_L + (4 * (N)))
> +#define LED_N_OFF_H(N)		(PCA9685_LEDX_OFF_H + (4 * (N)))
> +#define LED_N_OFF_L(N)		(PCA9685_LEDX_OFF_L + (4 * (N)))
> +
> +struct pca9685 {
> +	struct pwm_chip chip;
> +	struct regmap *regmap;
> +	struct device *dev;
> +};
> +
> +static inline struct pca9685 *to_pca(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct pca9685, chip);
> +}
> +
> +static int pca9685_pwmled_config(struct pwm_chip *chip, struct pwm_devic=
e *pwm,
> +			      int duty_ns, int period_ns)

The alignment doesn't look right here.

> +{
> +	struct pca9685 *pca =3D to_pca(chip);
> +	unsigned long long duty;
> +	unsigned int reg;
> +
> +	if (duty_ns < 1)
> +		return 0;

Doesn't duty_ns < 1 mean the signal is off? Why are you ignoring this
case?

> +
> +	if (duty_ns =3D=3D period_ns) {
> +		reg =3D (pwm->hwpwm =3D=3D PCA9685_MAXCHAN) ? PCA9685_ALL_LED_ON_H
> +						: LED_N_ON_H(pwm->hwpwm);

There's a few occurrences of this style in the driver. I don't like it
much because it makes things hard to read. How about writing it this
way?

	if (pwm->hwpwm < PCA9685_MAXCHAN)
		reg =3D LED_N_ON_H(pwm->hwpwm);
	else
		reg =3D PCA9685_ALL_LED_ON_H;

And similar for the other cases.

> +	duty =3D 4096 * (unsigned long long)duty_ns;
> +	duty =3D DIV_ROUND_UP_ULL(duty, period_ns);
> +
> +	reg =3D (pwm->hwpwm =3D=3D PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_L
> +					: LED_N_OFF_L(pwm->hwpwm);

Like here.

> +	regmap_write(pca->regmap, reg, 0xff & (int)duty);

"(int)duty & 0xff", please.

> +	regmap_write(pca->regmap, reg, 0xf & ((int)duty >> 8));

Same here.

> +static int pca9685_pwmled_enable(struct pwm_chip *chip, struct pwm_devic=
e *pwm)
> +{
> +	struct pca9685 *pca =3D to_pca(chip);
> +	unsigned int reg;
> +
> +	/* the PWM subsystem does not support a pre-delay */

What do you mean by that? How is it relevant to this code. Maybe there's
a case to be made to add functionality that you miss.

> +static int pca9685_pwmled_request(struct pwm_chip *chip, struct pwm_devi=
ce *pwm)
> +{
> +	struct pca9685 *pca =3D to_pca(chip);
> +
> +	return regmap_update_bits(pca->regmap, PCA9685_MODE1, MODE1_SLEEP, 0x0);
> +}

Don't you need to set the SLEEP bit in a pca9685_pwmled_free() function?
Since the SLEEP bit is for all PWM channels, you probably need some
reference counting to make sure you only set it when all channels have
been released.

> +static int pca9685_pwmled_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	struct device_node *np =3D client->dev.of_node;
> +	struct pca9685 *pca;
> +	int ret;
> +	int val;
> +	int mode2;
> +
> +	pca =3D devm_kzalloc(&client->dev, sizeof(*pca), GFP_KERNEL);
> +	if (!pca)
> +		return -ENOMEM;
> +
> +	pca->regmap =3D devm_regmap_init_i2c(client, &pca9685_regmap_i2c_config=
);
> +	if (IS_ERR(pca->regmap)) {
> +		ret =3D PTR_ERR(pca->regmap);
> +		dev_err(&client->dev, "Failed to initialize register map: %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	i2c_set_clientdata(client, pca);
> +	pca->dev =3D &client->dev;
> +
> +	regmap_read(pca->regmap, PCA9685_MODE2, &mode2);
> +	if (!of_property_read_u32(np, "invrt", &val)) {

These two lines could use a blank line as a separator.

> +		if (val)
> +			mode2 |=3D MODE2_INVRT;
> +		else
> +			mode2 &=3D ~MODE2_INVRT;
> +	}
> +	if (!of_property_read_u32(np, "outdrv", &val)) {

These too.

> +		if (val)
> +			mode2 |=3D MODE2_OUTDRV;
> +		else
> +			mode2 &=3D ~MODE2_OUTDRV;
> +	}
> +	regmap_write(pca->regmap, PCA9685_MODE2, mode2);

And these.

> +	ret =3D pwmchip_add(&pca->chip);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;

"return pwmchip_add(&pca->chip);"?

> +static const struct i2c_device_id pca9685_id[] =3D {
> +	{"pca9685", 0},

Spaces between '{' and '"' as well as '0' and '}', please.

> +	{},

"{ }", please. Or "{ /* sentinel */ }" as in the "of" table.

> +static struct i2c_driver pca9685_i2c_driver =3D {
> +	.driver =3D {
> +		   .name =3D "pca9685",
> +		   .owner =3D THIS_MODULE,
> +		   .of_match_table =3D pca9685_dt_ids,
> +		   },

This uses weird identing. Please fix.

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRo7BdAAoJEN0jrNd/PrOhp3kQAKLMbYFLNhjEc0DrWnJV9lf9
ymITkhuB7ZDnkV+qU6Gf3sQhg0m2uVUuL6us8cmw0fEUsT2zK6WYJIm4PYq4qg3O
eA0WwZRRzZB8h6VRXkqrWyXI1ssJzHNHC1CFS5q6/zxKeDGRRld/9yzptWwwhAKI
W0fKqFNhLq8iPrK5Swuuk12mV+CwKMyn0qGsAsKanOVnptYSYG+kcEAf/7hnT4Gw
EsaJ9uVQ1oZzH+A51oTyeMakmfMlxlQxsi0BPJV25wJMm+SCh/s7V2oByLl5cz+q
U1zLRrSsOfC15RYloEOorI+BZlkXgiZxvxqpu6X68HcZXcTnQ1NtNpMKaVj6iO52
r+xmlcV4o01M9ZQEsnYvO91ujiFdw4Ltapf6JrTfdFTXOvpWD4YtxbrQzjAmTtbW
jkjRz+dHyUyPFqAP7gZFsw8EDYslmzcT2ivUtxfbGlqQsvMjkOmB2h9e3gEWMiOv
BRmodUXQKSH8baIYtjHZCgNolA6t8v+OSOFf2oHtzLgyryygbsz6oGSLywccVkqi
/Yt4XWxvMjGQ1d5BcejQoypb15Xl/WuFvSEAC48VIumhhi1pR0HafPWRwky9XEKE
YK0Xzssqo++6AAqIkvrmn55eryee9VOiJfuPqhXU7Nh36/UqkNU2zzqisMThRinp
yHLwJf8GaZ+lcjSncvFR
=tX6a
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
