Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3H0Hle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:41:34 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38838 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3H0Hlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:41:31 -0400
Date: Tue, 27 Aug 2013 09:40:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li-B47053 <B47053@freescale.com>
Cc: Guo Shawn-R65073 <r65073@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: Re: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Message-ID: <20130827074057.GC8686@ulmo>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
 <20130823090523.GF3535@ulmo>
 <1DD289F6464F0949A2FCA5AA6DC23F827E42BD@039-SN2MPN1-012.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827E42BD@039-SN2MPN1-012.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2013 at 07:32:23AM +0000, Xiubo Li-B47053 wrote:
> > > +#define FTM_CSC_BASE        0x0C
> > > +#define FTM_CSC(_CHANNEL) \
> > > +	(FTM_CSC_BASE + (_CHANNEL * 0x08))
> >=20
> > I prefer lowercase variables in macros:
> >=20
> > 	#define FTM_CSC(channel) \
> > 		(FTM_CSC_BASE + (channel * 8))
> >=20
> Yes, That's better.

Actually it should even be:

	#define FTM_CSC(channel) \
		(FTM_CSC_BASE + ((channel) * 8))

Just in case channel ends up being an expression.

> > > +	ret =3D clk_prepare_enable(fpc->clk);
> >=20
> > This should probably be just clk_prepare(). Or is there some reason why
> > you can't delay clk_enable() to the .enable() operation?
> >=20
>=20
> Firstly, we should be clear that the fpc->clk is chip's work clock.
> If so, after the .request() is called and before .enable() is called, the=
 custumer will call .config(),=20
> in which will read/write the pwm chip registers, if the module clock is s=
till disabled, then the system will hang up.

Okay. In that case perhaps the better thing to do is call clk_prepare()
during driver probe and only clk_enable() here.

> > Perhaps time_ns should be "unsigned long"?
> >=20
>=20
> Shouldn't this be same with "int duty_ns" and "int period_ns", which are =
defined by=20
> struct pwm_ops {
> ...
> 	int (*config)(struct pwm_chip *chip,
>                     struct pwm_device *pwm,
>                     int duty_ns, int period_ns);
> ...
> }  ?

Well, the plan is to eventually make duty_ns and period_ns unsigned int
or unsigned long because negative values don't make any sense for them.
With that in mind I think it makes sense to use the proper type here
now.

> > > +static int fsl_pwm_config_channel(struct pwm_chip *chip,
> >=20
> > I think you can safely drop the _channel suffix from the PWM operations.
> >=20
>=20
> By adding _channel suffix just for more comprehensave about the pwm's mut=
i-channel operation.
> If this is redundant here, I will drop it.

The operations are implicitly per-channel operations. So yes, the
_channel suffix is redundant here.

> > > +	fpc =3D to_fsl_chip(chip);
> > > +
> > > +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> > > +		return -ESHUTDOWN;
> >=20
> > Erm... how do you think this could ever happen? Users need to request a
> > PWM to obtain a struct pwm_device, in which case PWMF_REQUESTED will
> > always be set. There are a few other occurrences throughout the rest of
> > the driver that I haven't pointed out explicitly.
> >=20
>=20
> Does the following case is exist ?
> The customer in one thread has .free(pwm_1), while in another thread,=20
> which maybe had slept in for some reason, will call .config/.enable/.disa=
ble?
>=20
> If so, as I have explained before, if the pwm_1 has been freed, the modul=
e clock maybe
> disabled too, so if the .config is call the system will hang up.

While the above could possibly happen, there's no way the core could
prevent it. And your explicit test couldn't either. So what usually
happens is that a driver requests a PWM device and then has exclusive
access to it. Any other driver that wants to use the same PWM device
can't because it will get an -EBUSY return.

So in your hypothetical case above, if one driver does stuff like that
with a PWM device then that's a driver bug, not something the PWM core
should be required to handle.

> > > +static int fsl_pwm_parse_dt(struct fsl_pwm_chip *fpc) {
> > [...]
> > > +	int ret =3D 0;
> > > +	u32 chs[FTM_MAX_CHANNEL];
> > > +	struct device_node *np =3D fpc->pdev->dev.of_node;
> > > +
> > > +	ret =3D of_property_read_u32(np, "fsl,pwm-clk-ps",
> > > +				   &fpc->clk_ps);
> > > +	if (ret < 0) {
> > > +		dev_err(&fpc->pdev->dev,
> > > +				"failed to get pwm "
> > > +				"clk prescaler : %d\n",
> > > +				ret);
> >=20
> > Perhaps it's more useful to mention the missing property explicitly in
> > the error message:
> >=20
> > 		dev_err(fpc->chip.dev,
> > 			"failed to parse \"fsl,pwm-clk-ps\" property: %d\n",
> > 			ret);
> >=20
>=20
> Whil I think the following is better in code.=20
> =20
>  		dev_err(fpc->chip.dev,
>  			"failed to parse <fsl,pwm-clk-ps> property: %d\n",
>  			ret);

Why? You're quoting which property failed to parse so you should use the
correct character for quoting, which is either the apostrophe (') or the
quotation mark (").

Thierry

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHFgJAAoJEN0jrNd/PrOhRJEQAICKI9DFjT5QPahQIxEYQGbb
7VCTyaA9ip8SOI63bb2F/2YL05AqnKjenAWtRlEfDifuzJ0vQ+ruQaoJUz7fSTJZ
FtQkx0BeVXJvk8XduGlUVQdr4jmeq8z687CAMtwJ7FPX1ehKohwrKk43ddAj+7/4
5rsCT177QzCyDpsPhxUMbgp4t99FuoZpl3VDiipHRgyeV9HrmLguRSN9La+hXQKt
6Cd4E+zU/7mEOFFZybSoSvpZiMa7cyiQLlB7WZM3vUZIyutXHXEzAoKVoGckfg51
XwkdUHgPEG7j6VRwkSYMQWuJ6KneZI51KdmAxhyP0+GGAiBgnGxGZgnQQTOq47V8
0GrfzLSQ2AM5h6vDgg5Rskjmm5cWIKqXhEZLUwuBmaz3MHfDGiVw/ZlNxZbF0VeT
pM183LggpqJ67AfUesPqTYYKoGNZEjs0+GxAhAWn5+3/6zzibk4zW9RG3nwuM+F/
rmOG/xuZKFsVkcq+gtf4bdl3ohLOvMLd7480gUkVmPKAv4o6+/9kdUMiq8a8OkPO
EOsWoVZTJBvqAEhN2kJW27gt4H6ep2+B2Y56blwnvEWoINw8aNNBOxqu03I9QHYH
ffiyRWqMScGTVSYV1Uk1UfNDvosntgIoTybplzhkfnFyh7111HORQhDVn2+atJHe
JaUBhEfu6N2zeYhLohAi
=V5Qk
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
