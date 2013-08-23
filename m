Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3HWH65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:58:57 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33184 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3HWH6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:58:55 -0400
Date: Fri, 23 Aug 2013 09:58:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li-B47053 <B47053@freescale.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
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
Message-ID: <20130823075828.GD3535@ulmo>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
 <20130821073659.GN31036@pengutronix.de>
 <1DD289F6464F0949A2FCA5AA6DC23F827D1C51@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130821095049.GQ31036@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <20130821095049.GQ31036@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2013 at 11:50:49AM +0200, Sascha Hauer wrote:
> On Wed, Aug 21, 2013 at 09:24:56AM +0000, Xiubo Li-B47053 wrote:
> > TO Sascha,
> >=20
> > > > +
> > > > +	fpc =3D to_fsl_chip(chip);
> > > > +
> > > > +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> > > > +		return -ESHUTDOWN;
> > > > +
> > > > +	statename =3D kasprintf(GFP_KERNEL, "en%d", pwm->hwpwm);
> > > > +	pins_state =3D pinctrl_lookup_state(fpc->pinctrl,
> > > > +			statename);
> > > > +	/* enable pins to be muxed in and configured */
> > > > +	if (!IS_ERR(pins_state)) {
> > > > +		ret =3D pinctrl_select_state(fpc->pinctrl, pins_state);
> > > > +		if (ret)
> > > > +			dev_warn(&fpc->pdev->dev,
> > > > +					"could not set default pins\n");
> > >=20
> > > Why do you need to manipulate the pinctrl to en/disable a channel?
> > >=20
> >=20
> > This is because in Vybrid VF610 TOWER board, there are 4 leds, and each=
 led's one point(diode's positive pole) is connected to 3.3V,
> > and the other point is connected to pwm's one channel. When the 4 pinct=
rls are configured as enable at the same time,=20
> > the 4 pinctrls is low valtage, and the 4 leds will be lighted up as def=
ault, then when you enable/disable one led will effects others.
> >=20
>=20
> I think the inactive state of a PWM is pretty much undefined by the PWM
> framework and left to the drivers.
>=20
> I stumbled upon this aswell. It would be good to think about the
> inactive state and how the PWM framework could help us here getting
> things right.

I'm not sure if imposing what the inactive state should be is a good
thing to do. For one, it might not be possible to set that particular
state in all of the PWM drivers. Similarly some drivers may know of a
more optimal state to put the pin into.

> There are several things to consider. For a noninverted PWM the inactive
> state should probably logic 0. For an inverted PWM it should probably be
> logic 1. I guess several PWM devices have an undefined inactive state,
> most of the PWM devices probably can control the inactive state by
> setting the duty cycle to 100% / 0% without actually disabling the PWM.

That sounds like a reasonable set of rules. The above should also be
equivalent to the "no power" state. I think we could possibly write down
those rules (even though I think they are obvious enough), but enforcing
one specific state doesn't sound right to me.

> Using the pinctrl is one way to control the inactive state and probaby
> the only one before initialization. It might be good to wire this up in
> the core instead of the individual PWM drivers.

I don't really see how the PWM core can make an educated decision about
this. The proper inactive state for a PWM can only be known by it's
corresponding driver. Each driver's .disable() operation should take
care of putting the PWM into the inactive state. That is, if it can be
done without too much effort. If putting the PWM into the inactive state
involves pinmuxing and such, it's probably better to defer that to the
=2Efree() operation.

Thierry

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSFxYkAAoJEN0jrNd/PrOhSmwP/i3tXKM+XGrAIlTDAJU4CJLd
trE08sWjhDJSfpdFhvn7lwNn5JSF3XBkODrzem4YSxbrIs17Q7PDa3LuZVe0evOL
X+PqvnoUN9U+cMgdZcggKLOmBx2oGKdtOUjK6cisF+4N/ZDi0XBTRcbqMK3Bqmhc
thUaFo7ShcmIdvauWtV9dmC6BLjffBxZXED4mR7uJoi3agjhp6DMuhx46Br++GcA
vPnjS5pzX7rcowDi4CIERBJlmOio9wCD8Spf1ExP4inf+hqBOrcRDXAXjKHH4FZ/
RM9vTGo+jGDHvnskVfL35/Y6ALCNEzU2ey1zKYyesW6kJWs2DGbRbg56d68d6ZKK
lEcSslUsIn0L1c1WkaHZZaa0XpjgKSE6wpJOsj+y9GRnipJcPG39hNysy5JInYlz
6Sb9OmiSSA29G5VTgGhMEaIdvxZePUsNsmj2+eu928+Fi2qPqkF3STG4f0uoqBTY
5E/PzSrgT1VUSuy/+MfbqjmBlUlcE4diozTlfhqtKnl8s5YNQb9B2sTzzMvs5Pxj
3ptTl5f4WO1dJTHmt+LQLBVZU9pk4esSjslH23b0Ud23UmMLW6KjqEbvjo9NPGc6
OP1wOKtvQHJGRLYGu3QwD6RS4+qAmj1CW9asxj4Ou3ByW1yR+8ea4OYrccW38v6A
Nl8fzH/DOXwduEYXoMeQ
=WKm8
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
