Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaCEGz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:55:56 -0500
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:56912 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755668AbaCEGzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:55:54 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 01:55:53 EST
Content-Type: multipart/signed; boundary="Apple-Mail=_1528776B-48EC-4CA4-A814-65410CFD3677"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1393984400-14687-1-git-send-email-wenyou.yang@atmel.com>
Date: Wed, 5 Mar 2014 12:58:12 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linus.walleij@linaro.org, b.brezillon@overkiz.com,
        "<linux-arm-kernel@lists.infradead.org> mailing list" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-Id: <635C1A75-4651-4B2C-AB64-E1D170A1F5F9@jcrosoft.com>
References: <1393984400-14687-1-git-send-email-wenyou.yang@atmel.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
X-Mailer: Apple Mail (2.1827)
X-Ovh-Tracer-Id: 12621900906999950213
X-Ovh-Remote: 140.206.255.243 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -200
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrudduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrudduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdengfhvvghrhghhihhtvgdqqdetucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_1528776B-48EC-4CA4-A814-65410CFD3677
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Mar 5, 2014, at 9:53 AM, Wenyou Yang <wenyou.yang@atmel.com> wrote:

> In order to support the pinctrl sleep state.

As I said before NACK

this is not the job of the pinctrl to describe gpio output or input =
state

Best Regards,
J.
>=20
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
> Hi Linus,
>=20
> The patch is based on branch: for-next
> git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
>=20
> Best Regards,
> Wenyou Yang
>=20
> drivers/pinctrl/pinctrl-at91.c     |   31 =
+++++++++++++++++++++++++++++++
> include/dt-bindings/pinctrl/at91.h |    2 ++
> 2 files changed, 33 insertions(+)
>=20
> diff --git a/drivers/pinctrl/pinctrl-at91.c =
b/drivers/pinctrl/pinctrl-at91.c
> index 5d24aae..fc51e59 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -62,6 +62,8 @@ static int gpio_banks;
> #define DEGLITCH	(1 << 2)
> #define PULL_DOWN	(1 << 3)
> #define DIS_SCHMIT	(1 << 4)
> +#define GPIO_OUTPUT_HIGH	(1 << 5)
> +#define GPIO_OUTPUT_LOW		(1 << 6)
> #define DEBOUNCE	(1 << 16)
> #define DEBOUNCE_VAL_SHIFT	17
> #define DEBOUNCE_VAL	(0x3fff << DEBOUNCE_VAL_SHIFT)
> @@ -152,12 +154,15 @@ struct at91_pinctrl_mux_ops {
> 	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool =
is_on);
> 	bool (*get_schmitt_trig)(void __iomem *pio, unsigned pin);
> 	void (*disable_schmitt_trig)(void __iomem *pio, unsigned mask);
> +	bool (*get_gpio_output)(void __iomem *pio, unsigned mask);
> +	void (*set_gpio_output)(void __iomem *pio, unsigned mask, bool =
is_high);
> 	/* irq */
> 	int (*irq_type)(struct irq_data *d, unsigned type);
> };
>=20
> static int gpio_irq_type(struct irq_data *d, unsigned type);
> static int alt_gpio_irq_type(struct irq_data *d, unsigned type);
> +static void at91_mux_gpio_enable(void __iomem *pio, unsigned mask, =
bool input);
>=20
> struct at91_pinctrl {
> 	struct device		*dev;
> @@ -472,6 +477,20 @@ static bool at91_mux_pio3_get_schmitt_trig(void =
__iomem *pio, unsigned pin)
> 	return (__raw_readl(pio + PIO_SCHMITT) >> pin) & 0x1;
> }
>=20
> +static bool at91_mux_pio3_get_gpio_output(void __iomem *pio, unsigned =
pin)
> +{
> +	return (__raw_readl(pio + PIO_ODSR) >> pin) & 0x1;
> +}
> +
> +static void at91_mux_pio3_set_gpio_output(void __iomem *pio,
> +						unsigned mask,
> +						bool is_high)
> +{
> +	at91_mux_gpio_enable(pio, mask, 0);
> +	writel_relaxed(mask, pio + (is_high ? PIO_SODR : PIO_CODR));
> +}
> +
> +
> static struct at91_pinctrl_mux_ops at91rm9200_ops =3D {
> 	.get_periph	=3D at91_mux_get_periph,
> 	.mux_A_periph	=3D at91_mux_set_A_periph,
> @@ -495,6 +514,8 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops =
=3D {
> 	.set_pulldown	=3D at91_mux_pio3_set_pulldown,
> 	.get_schmitt_trig =3D at91_mux_pio3_get_schmitt_trig,
> 	.disable_schmitt_trig =3D at91_mux_pio3_disable_schmitt_trig,
> +	.get_gpio_output =3D at91_mux_pio3_get_gpio_output,
> +	.set_gpio_output =3D at91_mux_pio3_set_gpio_output,
> 	.irq_type	=3D alt_gpio_irq_type,
> };
>=20
> @@ -741,6 +762,10 @@ static int at91_pinconf_get(struct pinctrl_dev =
*pctldev,
> 		*config |=3D PULL_DOWN;
> 	if (info->ops->get_schmitt_trig && =
info->ops->get_schmitt_trig(pio, pin))
> 		*config |=3D DIS_SCHMIT;
> +	if (info->ops->get_gpio_output) {
> +		*config |=3D info->ops->get_gpio_output(pio, pin) ?
> +					GPIO_OUTPUT_HIGH : =
GPIO_OUTPUT_LOW;
> +	}
>=20
> 	return 0;
> }
> @@ -778,6 +803,12 @@ static int at91_pinconf_set(struct pinctrl_dev =
*pctldev,
> 			info->ops->set_pulldown(pio, mask, config & =
PULL_DOWN);
> 		if (info->ops->disable_schmitt_trig && config & =
DIS_SCHMIT)
> 			info->ops->disable_schmitt_trig(pio, mask);
> +		if (info->ops->set_gpio_output) {
> +			if (config & GPIO_OUTPUT_HIGH)
> +				info->ops->set_gpio_output(pio, mask, =
1);
> +			if (config & GPIO_OUTPUT_LOW)
> +				info->ops->set_gpio_output(pio, mask, =
0);
> +		};
>=20
> 	} /* for each config */
>=20
> diff --git a/include/dt-bindings/pinctrl/at91.h =
b/include/dt-bindings/pinctrl/at91.h
> index 0fee6ff..e799268 100644
> --- a/include/dt-bindings/pinctrl/at91.h
> +++ b/include/dt-bindings/pinctrl/at91.h
> @@ -15,6 +15,8 @@
> #define AT91_PINCTRL_DEGLITCH		(1 << 2)
> #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
> #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
> +#define AT91_PINCTRL_OUTPUT_HIGH	(1 << 5)
> +#define AT91_PINCTRL_OUTPUT_LOW		(1 << 6)
> #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
> #define AT91_PINCTRL_DEBOUNCE_VAL(x)	(x << 17)
>=20
> --=20
> 1.7.9.5
>=20


--Apple-Mail=_1528776B-48EC-4CA4-A814-65410CFD3677
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJTFq7kAAoJEOrjwV5ZMRf2QF8P/35yh3Ks3LSytxpXiIQVgeI+
TWy0pKsn1SYPqNpetjE0TqqQcWtlgq4NkFq6ce9Nn3mJruvcPBQy76tenAWU+Yzb
8KiBI45FZd3fTg0TPoh8K0SmrZybKdknitbaaWRqVuu/HV1PExpKMQpar4uE/6o+
jrndbwFONr/zQiw2T0fbLiiSzGXUkDSb7IM1EggXTkZUDiWEMxFSXN1ssrZEwBxR
mPxwGMhBt7pW6/gZQ+wlLOw6Hpgjqzlsw8BHbMS70ymPXypYMc6Onw4uYlaShA8o
m01Mriq+tkRtuiJibkIDEcQzVGIC5WyRq/95imagzfpk8qEDxYsl1s6Oq2vxlNlK
XmoqCsG82UnjB4ZSZ/X/3PWaE1eDn/bB0gJwDdaG5Xw+bO/9ZM4p6+7oztkZWu4C
xacGnIUo9iMYTtTlAbliSNnVLjV86UoOUYc0v/sO7QeizCrYTMhzB8HBTf4Rhb/5
F5cQvpUcTFJFAwgaOGlNR28JwHhkoz7FEVxRFbTfKkmcVOEZGO/lmKKLVmvEq2AC
FcNyrfCCMaFbyxli6Ibsu4hGtfbocCZNlanxuzwvVwDjfmf64Ez1vlfdU31N7COl
RuprIA3RUuyqAqJ0+xcJFtvJvz1V5leRzKmokQl3ckcRIEmgXMrzLRimAN2QjweW
0omh6l341kQ89BsKGgTM
=Y7St
-----END PGP SIGNATURE-----

--Apple-Mail=_1528776B-48EC-4CA4-A814-65410CFD3677--
