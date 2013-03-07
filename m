Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab3CGL11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:27:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3CGL10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:27:26 -0500
Date: Thu, 7 Mar 2013 12:27:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130307112723.GA2593@avionic-0098.mockup.avionic-design.de>
References: <1362590238-27692-1-git-send-email-achew@nvidia.com>
 <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de>
 <513867CD.4030201@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <513867CD.4030201@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:f/5aDOFek+VgSXINyrIGcJ40CYtDFVkGKvYwvcQdjyl
 hBqrXUfecMm3QikHRSoVHCz5cYQ3kb1UHgoROiFpCIRo2IEVYS
 /kMRmDJ+Vd4ypNWqTXZPA7cGYuP10ORgNVBMful0xmBgmM+GRl
 a/KPAZJiXYrSH4vuf4xsjmvdRXcmRBUefWR16shWVksy99gmjh
 mtagAy7AwRvzNoQFsHTRvMY7ch4Ho7ZUEg52sv4w4tV+NgCvFL
 mb4SO73TRUXH+xmwMeKOOWvjBz3CLYICHC8yXG7wmJPlTHD++8
 kE/mCDSecN3h/J+mSUFQdZjnToGfGqLMQB3h1a6g7/DH+ltiKX
 kRfs5X3igfIUSqHPtLltjmA/WE9Z9t4vHdpQvBOjIR18ldPKwF
 m8D+Ezzfs/Lr5l1TYWvA0EH/3F7CaYQqx8TVdci7boy6c2al/y
 KwJEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2013 at 07:11:25PM +0900, Alex Courbot wrote:
> On 03/07/2013 04:11 PM, Thierry Reding wrote:
> >>+	bool			en_supply_enabled;
> >
> >This boolean can be dropped. As discussed in a previous thread, the
> >pwm-backlight driver shouldn't need to know about any other uses of the
> >regulator.
>=20
> Sorry for being obstinate - but I'm still not convinced we can get
> rid of it. I checked the regulator code, and as you mentioned in the
> previous version, calls to regulator_enable() and
> regulator_disable() *must* be balanced in this driver.
>=20
> Without this variable we would call regulator_enable() every time
> pwm_backlight_enable() is called (and same thing when disabling).
> Now imagine the driver is asked to set the following intensities: 5,
> 12, then 0. You would have two calls to regulator_enable() but only
> one to regulator_disable(), which would result in the enable GPIO
> remaining active even though it would be shut down. Or I missed
> something obvious.
>=20
> The regulator must be enabled/disabled on transitions from/to 0, and
> AFAICT there is no way for this driver to detect them.

Yes, that's true, but I don't think it should be solved for just this
one regulator. Instead if we need to track the enable state we might as
well track it for *any* resource so that the PWM isn't enabled/disabled
twice either.

> >>+static void pwm_backlight_enable(struct backlight_device *bl)
> >>+{
> >>+	struct pwm_bl_data *pb =3D dev_get_drvdata(&bl->dev);
> >>+
> >>+	pwm_enable(pb->pwm);
> >>+
> >>+	if (pb->en_supply && !pb->en_supply_enabled) {
> >>+		if (regulator_enable(pb->en_supply) !=3D 0)
> >>+			dev_warn(&bl->dev, "Failed to enable regulator");
> >>+		else
> >>+			pb->en_supply_enabled =3D true;
> >>+	}
> >>+}
> >>+
> >>+static void pwm_backlight_disable(struct backlight_device *bl)
> >>+{
> >>+	struct pwm_bl_data *pb =3D dev_get_drvdata(&bl->dev);
> >>+
> >>+	if (pb->en_supply && pb->en_supply_enabled) {
> >>+		if (regulator_disable(pb->en_supply) !=3D 0)
> >>+			dev_warn(&bl->dev, "Failed to disable regulator");
> >>+		else
> >>+			pb->en_supply_enabled =3D false;
> >>+	}
> >>+
> >>+	pwm_disable(pb->pwm);
> >>+}
> >
> >Alex already brought this up: shouldn't the sequences be reversed. That
> >is, when enabling the backlight, turn on the regulator first, then
> >enable the PWM. When disabling, disable the PWM first, then turn off the
> >regulator?
>=20
> Actually the current sequence seems to make sense - the PWM is
> always active when the enable GPIO is switched. If we do the
> contrary, we might have a short time where the backlight is enabled
> without receiving anything from the PWM. Don't think that would be
> serious, but the current behavior is similar to e.g. panels which we
> enable only after a signal is available.

Okay, let's leave it like that then.

> >>@@ -213,6 +238,13 @@ static int pwm_backlight_probe(struct platform_dev=
ice *pdev)
> >>  	pb->exit =3D data->exit;
> >>  	pb->dev =3D &pdev->dev;
> >>
> >>+	pb->en_supply =3D devm_regulator_get(&pdev->dev, "enable");
> >>+	if (IS_ERR(pb->en_supply)) {
> >>+		ret =3D PTR_ERR(pb->en_supply);
> >>+		pb->en_supply =3D NULL;
> >>+		goto err_alloc;
> >>+	}
> >
> >This effectively makes the regulator mandatory, so the board files that
> >use pwm-backlight need to be updated or otherwise will break.
>=20
> Yes. Btw, should such changes go into the same patch? This seems
> difficult to split without breaking things at some point.

I expect that if the changes are split up then the board-setup code
changes need to be done prior to the driver change. Using the lookup
tables should make this easy because they aren't tied to the platform
data and can be added independently. The patches should probably go
through the same subsystem tree to take care of the dependencies.

Keeping everything in one patch would work too, but it's certainly more
chaotic.

Thierry

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJROHmaAAoJEN0jrNd/PrOhL2gP/jkcUU6PesQdS4rJvjUy0KJ4
sUI5Ruwc4asXJIz7EDN73js4wbll+SIw6SsmJwNxIr+S/3RxwxZkN0VNnmIJvY81
b1KC+rNQ0REk2GRtXKwFI5MyZSi+ex5OFqjC1EMKohWQ3vney6rRFbrqKEE0TxbV
GQixxvXFSWuCrsQLTzS/XyuKVJUZ/6/UAqqVpsz+lvZwgfYMX9O0F6GTjORZV2hG
fpqlFVvcR+O6Xyx0ZunYc1RHT7+R24g4sh5dfz/SBHK8xsPAkdG2bkUA6FHFuq+U
GlHSfbfBqxabpCP9hH8ezcyRGXE6Lo93rDFcamyPvAuR/8DDw5V9AtUhSgl07QlF
w8PV/7FjicWS/oIB9z45FBMDeMvdSx6/NLepBwSBOhps3fIOjpiJf4j+4NZvB0RM
lPfaDYN1A/ZDL1O16WNcSlk3eGZXl2U7Kp6cLjoxt4dNRCQSvN7vGh0UX0jriary
zev+Nti8JXqzPcm3ymmljw5einK8YDgmbabiGA87JOzNCiWztoTfopTE2tadzX98
MYW8dbftRnoWf7+D6OIXXl9ebSOhz3QOtFiy9RJsvr+qVQcwzfqIw89s18VRapEk
xd3TWDw2bHdiF7wirp+CdIEG22buIgdR0A/8oxlp/lEXUdEojYwXFtXR//dhCXq8
13naWcboU1c2T+pg+0Nx
=WbZi
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
