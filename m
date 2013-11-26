Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3KZPew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:34:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab3KZPes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:34:48 -0500
Date: Tue, 26 Nov 2013 09:34:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Chao Xu <Chao.Xu@rice.edu>
CC: <linux-omap@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <khilman@deeprootsystems.com>, <linus.walleij@linaro.org>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <balbi@ti.com>
Subject: Re: [PATCH RFC] gpio: omap: =?utf-8?Q?refr?=
 =?utf-8?Q?esh_the_patch_=E2=80=9Cgpio=3A_omap=3A_be_more_aggressive_with_?=
 =?utf-8?B?cG1fcnVudGltZeKAnQ==?= against v3.12-rc5
Message-ID: <20131126153415.GB24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <CAKZq+rdGooV0SV1RH6Hrms_Z-p6_FqcNmpGTAcn3dPU0u478vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <CAKZq+rdGooV0SV1RH6Hrms_Z-p6_FqcNmpGTAcn3dPU0u478vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chao,

On Mon, Nov 25, 2013 at 09:30:46PM -0600, Chao Xu wrote:
> Refresh the patch =E2=80=9Cgpio: omap: be more aggressive with pm_runtime=
=E2=80=9D by
> Felipe Balbi against v3.12-rc5. Add version checking so that the
> aggressive pm_runtime only applies to omap4 devices. Tested with
> pandaboard rev a2 through sysfs.
> Signed-off-by: Chao Xu <chao.xu@rice.edu>

Here, you need to keep authorship and mention that you refreshed the
patch, it should look something like:

=46rom: Felipe Balbi <balbi@ti.com>

try to keep gpio block suspended as much as possible.

Tested with pandaboard and a sysfs exported gpio.

Signed-off-by: Felipe Balbi <balbi at ti.com>

[ chao.xu@rice.edu : refreshed against v3.12-rc5, and added revision
	check to enable aggressive pm_runtime on OMAP4-only ]

Signed-off-by: Chao Xu <chao.xu@rice.edu>

> ---
> According to Mr. Felipe Balbi, the original patch was not accepted
> because interrupts would be missed when GPIO was used as IRQ source.
> But in my tests with pandaboard, interrupts were not missed. This is
> because _idle_sysc() sets the idlemode of gpio module to
> smart-idle-wakeup, and according to OMAP4430 TRM, under this idlemode,
> the gpio can generate an asynchronous wakeup request to the PRCM. And
> after GPIO is awake, the wake-up request is reflected into the
> interrupt status registers.
>=20
> A change I made against the original patch is only using the
> aggressive runtime pm scheme on OMAP4 by adding a flag in pdata,
> because I don=E2=80=99t have HW to test OMAP3 or am33xx devices. Accordin=
g to
> the respective TRMs, their GPIO modules also can generate wake-up
> request if the idlemode is set to smart-idle or smart-idle-wakeup. So
> the patch should work for them, too. But I suspect a potential SW bug
> may cause missed interrupts: the am33xx_gpio_sysc.idlemodes is marked
> as capable of SIDLE_SMART_WKUP in omap_hwmod_33xx.c. But according to
> AM335x TRM, _only_ gpio0 is capable of this mode. This may make GPIO
> stuck in force-idle mode and unable to generate wakeup request. And
> thus interrupt will be missed. Again, I don=E2=80=99t have the HW to veri=
fy
> whether this is a bug or not :(

Some of this information would be very nice to have in the commit log.

>  drivers/gpio/gpio-omap.c                |  103 +++++++++++++++++++++++++=
+-----
>  include/linux/platform_data/gpio-omap.h |    1 +
>  2 files changed, 87 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 89675f8..90661f2 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -76,6 +76,7 @@ struct gpio_bank {
>   int context_loss_count;
>   int power_mode;
>   bool workaround_enabled;
> + bool is_aggressive_pm;
>=20
>   void (*set_dataout)(struct gpio_bank *bank, int gpio, int enable);
>   int (*get_context_loss_count)(struct device *dev);
> @@ -473,8 +474,15 @@ static void _disable_gpio_module(struct gpio_bank
> *bank, unsigned offset)
>  static int gpio_is_input(struct gpio_bank *bank, int mask)
>  {
>   void __iomem *reg =3D bank->base + bank->regs->direction;
> + u32 val;

you see, your email it converting tabs into spaces and loosing all
formatting from the patch. There are lots of tips on how to configure
different emails clients under Documentation/email-clients.txt. You
might also want to use git send-email, which will make patch submission
a lot easier :-)

--=20
balbi

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlL93AAoJEIaOsuA1yqRE9PYP/312VcQovJ1uHclVPi3J6IkD
p4d3dj7bNdqm8Eq+KxBzEsCBpb2mtLxXXYWNYf1AxUdUJduRpIw4eO8ShhfImi+T
TtOOT/QCSomS+fnA4vswahkeViYDB/N+zSuXm8ZTx0gvZShEZb9CTSYAfggVwB5+
7n+RYQESxZDy+C7K+2UiKrYqPO8fOinsAiG084/F0TOeGUTbtptzutHGcfS1lHir
gb/6SenP2ocfi2cvokK/aWtSUWU9s0Oz0SyInJq6zH4HNghS2LUSK1iUpIqRuhve
YvIXORGsCQNu4nlBKIU2Vzj9wcdrObGlDFncALOmcKGrDKxzV0DpQhFvFMXLb84r
W5Xf2Pg/IkkRvGQLLZZlw//MJJ5BI+lYUFHzbUkkSouT0tQYM+B/FBrVcudt6wf5
/bRZOmoTuRnkoKLkxUM7ILhF+qx8mxTgv3ziac0luVA5un+Tynj4mS8oxpWFIJCq
O4fLg4Xnl/ti8rnsl7bGdICNcMwnxXfjq8XL1TtbVSKIwO1Izf0CcgDuZ7kSY13w
1vhBbWnlqIzBr3G/VtEv0ucutYu4hmZHPfqyp3Od41lgQ18/aRsJ4FGNxKVYzjB4
k3nPtpbzm6wWooOkOGRp/OeNnWmgZjF+SrXYIZplfGe9YNoL20AlMbgETFBbgrMw
8ORossz/SV4SpeICmgQK
=052l
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
