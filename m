Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3K2JXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:23:32 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57322 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3K2JXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:23:14 -0500
Date: Fri, 29 Nov 2013 10:22:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Li Xiubo <Li.Xiubo@freescale.com>
Cc: Shawn Guo <Shawn.Guo@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: Re: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131129092224.GB22771@ulmo.nvidia.com>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-2-git-send-email-Li.Xiubo@freescale.com>
 <20131128212510.GC14689@mithrandir>
 <1DD289F6464F0949A2FCA5AA6DC23F828DD76C@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F828DD76C@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2013 at 06:42:06AM +0000, Li Xiubo wrote:
> > > +#define FTM_CNTIN_VAL       0x00
> >=20
> > Do we really need this?
> >=20
>=20
> Maybe not, I think that the initial value maybe modified in the future.
> And this can be more easy to ajust it.=20

Why would it need to be modified?

> > > +	writel(period_cycles + cntin - 1, fpc->base + FTM_MOD);
> > > +	writel(duty_cycles + cntin, fpc->base + FTM_CV(pwm->hwpwm));
> >=20
> > And these:
> >=20
> > 	writel(period - 1, fpc->base + FTM_MOD);
> > 	writel(duty, fpc->base + FTM_CV(pwm->hwpwm));
> >=20
> > Although now that I think about it, this seems broken. The period is set
> > in a global register, so I assume it is valid for all channels. What if
> > you want to use different periods for individual channels? The way I
> > read this the last one to be configured will win and change the period
> > to whatever it wants. Other channels won't even notice.
> >=20
>=20
> That's right. And all the 8 channels share the same period settings.
>=20
> > Is there a way to set the period per channel?
> >=20
>=20
> Not yet. Only could we do is to set the duty value individually for each
> channel. So here is a limitation for the cusumers that all the 8 channels'
> period values should be the same.

That will need to be handled some way. Perhaps the easiest would be to
check whether or not another channel is already running and check that
indeed the period as requested by the new channel matches that of any
running channels. If it doesn't match, then pwm_config() should fail.

When you do that you can also optimize this a bit by only setting the
frequency once. Whenever a new channel is configured it will have the
same period and therefore the register doesn't need to be reprogrammed.

> > > +static void fsl_pwm_disable(struct pwm_chip *chip, struct pwm_device
> > *pwm)
> > > +{
> > > +	struct fsl_pwm_chip *fpc;
> > > +
> > > +	fpc =3D to_fsl_chip(chip);
> > > +
> > > +	fsl_counter_clock_disable(fpc);
> > > +}
> >=20
> > Same here. Since you can't propagate the error, perhaps an error message
> > would be appropriate here?
> >=20
>=20
> Well, in fsl_counter_clock_disable(fpc); only '0' could be returned, maybe
> let it a void type value to return is better.
> Just like:
> static void fsl_counter_clock_disable(struct fsl_pwm_chip *fpc) {}

Yes, that sounds good.

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmFzQAAoJEN0jrNd/PrOhLIoQAINi7aR7LD3wcMGwXdoJ1ft4
k0Y47ZClp1yvmw+dSK5dDQolEfQFeVoKtANo4KAF7AA6g9eSOffpWHHEve2WN8NE
Ad6u239vCyjbD7RzF8KqLZmMKzkzOrcGLxLZlsMdZ8t+Z8VY8ZdxPnzH6xhU5eJo
7dlt6zWe3qE+qQbnUH6U3GdFCtcyVv2ZcEeunUybi6s9KHnrdFH4dfMo/zjwbNE2
Q/Z/HHY3T7uDwij04hOBBUTA/RkfMYVaibuBm/JtsjnixP4py7+gx9P540ajUIgh
Nzw5NdOh3yvlt0n74kspWicdMDe6bYx1HjRlns/kCApnTDcGrg2pWB10wKDRfk0f
wK3RIzot/21fEcJOzsAIObGo782ej5Z4s39imsXcVzQd4livZJz+krC1LPsQw6Q3
ydl/3qrcJ+O1rJ9YMcXJeJpVmBJ56BQSb9wKxrz87B0NC/TuIuJWkW8CbB/y1GHo
jWXuzO8DXe/Lkz4ANcMCCi+asjYkhoar+UifYZHP9QQpByxxqbdH+NYnxegqt/bT
iyywhcO4MgHfNPaIrgsg/RYqWDoCIgUoa5GZmH1nHWBn12/0iih+wZ5wHW0meR4z
P9fLtKjUTnLIlUjqp/x5txqcKZni9a6xo6uhr1yNyjQGK5wHRtZwivEsLIFgQSO2
hgwlTBvojqW/TINpsZdj
=6Q/n
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
