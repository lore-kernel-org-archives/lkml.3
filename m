Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaFTWQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:16:49 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62909 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaFTWQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:16:47 -0400
Date: Sat, 21 Jun 2014 00:16:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH 6/7] pwm: st: Add new driver for ST's PWM IP
Message-ID: <20140620221642.GA29400@mithrandir>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-6-git-send-email-lee.jones@linaro.org>
 <20140618231127.GF26514@mithrandir>
 <20140619084404.GA26560@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20140619084404.GA26560@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 09:44:04AM +0100, Lee Jones wrote:
> I'll comment on some of the more fluffy topics, I'll let Ajit reply to
> the more technical details of the patch.
>=20
> On Thu, 19 Jun 2014, Thierry Reding wrote:
> > On Wed, Jun 18, 2014 at 03:52:51PM +0100, Lee Jones wrote:
> > > This driver supports all current STi platforms' PWM IPs.
> > >=20
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/pwm/Kconfig  |   9 ++
> > >  drivers/pwm/Makefile |   1 +
> > >  drivers/pwm/pwm-st.c | 378 +++++++++++++++++++++++++++++++++++++++++=
++++++++++
> > >  3 files changed, 388 insertions(+)
> > >  create mode 100644 drivers/pwm/pwm-st.c
> > >=20
> > > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > > index 4ad7b89..98a7bbc 100644
> > > --- a/drivers/pwm/Kconfig
> > > +++ b/drivers/pwm/Kconfig
> > > @@ -292,4 +292,13 @@ config PWM_VT8500
> > >  	  To compile this driver as a module, choose M here: the module
> > >  	  will be called pwm-vt8500.
> > > =20
> > > +config PWM_ST
> >=20
> > PWM_ST is awfully generic, perhaps PWM_STI would be a better choice?
> > Even that's very generic. Maybe PWM_STI_H4XX? There's nothing wrong with
> > supporting STiH{5,6,7,...}xx SoCs with such a driver. I'm just trying to
> > think ahead what will happen if at some point a new SoC family is
> > released that requires a different driver.
>=20
> I'm inclined to agree with you, but as it stands, this driver supports
> all ST h/w, so it's correct for it to be generic.  If some new IP
> comes into fuition, at worst we'll have to change the name of the
> driver.  I'm happy to put myself on the line for that if the time
> comes.

Renaming a driver isn't a trivial matter. People may be using the name
in blacklists or scripts and renaming will likely annoy them. Like I
said, there's nothing wrong with the driver name being less generic, we
have other ways to identify what hardware it will run on.

> > > diff --git a/drivers/pwm/pwm-st.c b/drivers/pwm/pwm-st.c
[...]
> > > +#define MAX_PWM_CNT_DEFAULT	255
> > > +#define MAX_PRESCALE_DEFAULT	0xff
> > > +#define NUM_CHAN_DEFAULT	1
> >=20
> > These are only used in one place and their meaning is fairly obvious, so
> > I'd just drop them.
>=20
> I _always_ prefer defines over magic numbers, but as you wish - will fix.

In general I agree, but there are cases where in my opinion the defines
obfuscate rather than help. This is one of those. These aren't really
magic numbers, since they are used in a context where their meaning is
crystal clear.

> > > +	PWM_EN,
> > > +	PWM_INT_EN,
> > > +	/* keep last */
> > > +	MAX_REGFIELDS
> > > +};
> > > +
> > > +struct st_pwm_chip {
> > > +	struct device *dev;
> > > +	struct clk *clk;
> > > +	unsigned long clk_rate;
> > > +	struct regmap *regmap;
> > > +	struct st_pwm_compat_data *cdata;
> >=20
> > Doesn't this require a predeclaration of struct st_pwm_compat_data? Or
> > maybe just move struct st_pwm_compat_data before this.
>=20
> You're right, will fix.
>=20
> I think I would have expected at least a compiler warning about that?

Me too. Perhaps one of the includes has a forward declaration? I'd hope
not.

> > > +};
> > > +
> > > +struct st_pwm_compat_data {
> > > +	const struct reg_field *reg_fields;
> > > +	int num_chan;
> > > +	int max_pwm_cnt;
> > > +	int max_prescale;
> >=20
> > Can't these three be unsigned?
>=20
> I see no reason why not.  They can also be signed. :)

I prefer if variables use the strictest type possible.

> > > +static void st_pwm_calc_periods(struct st_pwm_chip *pc)
> > > +{
> > > +	struct st_pwm_compat_data *cdata =3D pc->cdata;
> > > +	struct device *dev =3D pc->dev;
> > > +	unsigned long val;
> > > +	int i;
> >=20
> > unsigned?
>=20
> Why?
>=20
> It's much more common this way:
>=20
> $ git grep $'\t'"int i;" | wc -l
> 17018
> $ git grep $'\t'"unsigned int i;" | wc -l
> 2033

That just means that not everybody is as pedantic as I am. The reason
why it should be unsigned int is that it's used in a loop and compared
to a value which should also be unsigned (cdata->max_prescale). There
just isn't a reasonable scenario where they would need to be negative.

> > > + * 16 possible period values are supported (for a particular clock r=
ate).
> > > + * The requested period will be applied only if it matches one of th=
ese
> > > + * 16 values.
> > > + */
> > > +static int st_pwm_config(struct pwm_chip *chip, struct pwm_device *p=
wm,
> > > +			 int duty_ns, int period_ns)
> > > +{
> > > +	struct st_pwm_chip *pc =3D to_st_pwmchip(chip);
> > > +	struct device *dev =3D pc->dev;
> > > +	struct st_pwm_compat_data *cdata =3D pc->cdata;
> > > +	unsigned int prescale, pwmvalx;
> > > +	unsigned long *found;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * Search for matching period value. The corresponding index is our
> > > +	 * prescale value
> > > +	 */
> > > +	found =3D bsearch(&period_ns, &pc->pwm_periods[0],
> >=20
> > Technically doesn't period_ns need to be converted to an unsigned long
> > here? Otherwise this won't be compatible with 64-bit architectures.
> > Admittedly that's maybe not something relevant for this family of SoCs,
> > but you never know where this driver will be used eventually.
>=20
> This driver depends on ARCH_STI which only supports 32bit.

That's true now. It may not be forever. Also there's always a chance
that somebody will look at your code for inspiration and will copy the
same non-portability.

> > > +	ret =3D regmap_write(pc->regmap, ST_PWMVAL(pwm->hwpwm), pwmvalx);
> > > +	if (ret)
> > > +		goto clk_dis;
> > > +
> > > +	ret =3D regmap_field_write(pc->pwm_int_en, 0);
> >=20
> > This seems to be never set to any other value, so perhaps it should be
> > set at .probe() time?
>=20
> Unfortunately not, as the clk needs to be enabled whilst setting IRQ
> state.  Moving it into .probe() would mean wrapping this command
> between clk_enable() and clk_disable(), which I think it a waste.

That's a one-time thing nevertheless. If you keep it here the register
will keep being written with the same value over and over again.

> > > +	.reg_bits   =3D 32,
> > > +	.val_bits   =3D 32,
> > > +	.reg_stride =3D 4,
> > > +};
> >=20
> > Please drop the artificial padding. A single space on each side of '=3D'
> > will do just fine.
>=20
> /me likes straight lines!
>=20
> ... but as you wish.

And at some point you need to add a field that exceeds the current
padding and then you'll have one line that stands out. Trust me, that's
a whole lot worse than making each of them use a single space around '=3D'
consistently from the beginning.

Or you'd need to update the whole block at the same time, which is just
needless churn.

> > > +static int st_pwm_probe(struct platform_device *pdev)
> > > +{
> > > +	struct device *dev =3D &pdev->dev;
> > > +	struct device_node *np =3D dev->of_node;
> > > +	struct st_pwm_compat_data *cdata;
> > > +	struct st_pwm_chip *pc;
> > > +	struct resource *res;
> > > +	int ret;
> > > +
> > > +	if (!np) {
> > > +		dev_err(dev, "failed to find device node\n");
> > > +		return -EINVAL;
> > > +	}
> >=20
> > I have difficulty imagining how this condition would ever happen. Can
> > this check not simply be removed?
>=20
> Although true, this check is very common.  I wonder if they can _all_
> be removed from OF only drivers?  Probably something worth bringing up
> with the DT guys.

Yes, it's completely unnecessary for OF-only drivers.

> > > +	 */
> > > +	cdata->reg_fields   =3D &st_pwm_regfields[0];
> >=20
> > Why not simply "=3D st_pwm_regfields;"?
>=20
> Although semantically the same, I think what we're trying to achieve
> is more obvious at first glance in the current format.
>=20
> But will fix if you are insistent.

Yes, please.

> Look at those lovely straight lines.  Are you sure you want me to
> unalign the regmap_config above?

	cdata->max_pwm_cnt  =3D MAX_PWM_CNT_DEFAULT;
	cdata->max_prescale =3D MAX_PRESCALE_DEFAULT;
	cdata->num_chan     =3D NUM_CHAN_DEFAULT;
	cdata->some_other_param =3D SOME_OTHER_PARAM_DEFAULT;

Not very pretty, is it?

> > > +	if (IS_ERR(pc->clk)) {
> > > +		dev_err(dev, "failed to get pwm clock\n");
> > > +		return PTR_ERR(pc->clk);
> > > +	}
> > > +
> > > +	pc->clk_rate =3D clk_get_rate(pc->clk);
> > > +	if (!pc->clk_rate) {
> > > +		dev_err(dev, "failed to get clk rate\n");
> >=20
> > "... clock rate\n"
>=20
> clk is a well known synonym for clock in Linux and can be found
> throughout many bootlogs, but again, happy to change if it's causing
> issues.

Yes, please.

Thierry

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpLLKAAoJEN0jrNd/PrOhWYAP/R/wYDZGDCusXnBNHpYpJ912
KlK3mOxTNbTKFsn46qhNTRMTEelzmZ8DNfANIfxrt7uZOxEHYz7w8avqiXkBUN87
NWN442xtN+0ivFS18QgpAFifalMS2qEHz0kWS+O4dnRw5Ebpzh9E19shctJH94MY
wsKKQG1M3bm1y10pYhkvXfuZg2JEltFTjYAe5Px2SDqmYOBYWvp0dSiAr+u5Vhfw
M2TkvNJIXNuuozHvl2Lsm/VOdySrfGWKRXo9o4P+1fRDgMe52ZxPEpGAOt5QTe14
zVbb1E8SXqqk4WWswSTmV9vDQE+7h9qkN+5FzrVVwIvAtOllBZDKNxxKFFfRNEm9
17LPlAx6SWUcbcQMKcWxYAFvv+F08EAH744dnCVxPnLbQ12PBHKpBQi4fAvJvatT
n6AO2DPyUuFzDHtpRMY+nP/qtQl8K/r67Q7E5hwc6xvow8BecT+875l1r71EzVgt
Tp6pAibNR/+7ONqa3Sbzcj3lXiX5Idxo5+aVWoqWDXuLHJJPXrOUnXzX/RqumNpq
Sph+SjHKGJ0EZCCKeW8AdTbwj16APRNMFA5r8boSIEjpxQ5Hp6gvoRV9DhTDz1yE
/HijExG4aIB2328u/uj744P9Dzp/qUaf8MCBelxGHLjvijxl61PRq+S50NtoNTIi
fyWjk8/8hYRrfEZW/9US
=Rl5U
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
