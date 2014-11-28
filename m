Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaK1NOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:14:41 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52933 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaK1NOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:14:39 -0500
Date: Fri, 28 Nov 2014 09:14:27 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@majess.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCHv2 1/1] thermal: cpu_cooling: check for the readiness of
 cpufreq layer
Message-ID: <20141128131425.GA23622@developer>
References: <1417097577-3548-1-git-send-email-edubezval@gmail.com>
 <CAKohponu_PRrqsuMdCJDznhiO_-=iCaYPhCCad8F4WS3rNxo5A@mail.gmail.com>
 <20141128111824.533c4641@jawa>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20141128111824.533c4641@jawa>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Folks,

On Fri, Nov 28, 2014 at 11:18:24AM +0100, Lukasz Majewski wrote:
> On Fri, 28 Nov 2014 13:35:49 +0530
> Viresh Kumar <viresh.kumar@linaro.org> wrote:
>=20
> > On 27 November 2014 at 19:42, Eduardo Valentin <edubezval@gmail.com>
> > wrote:
> > > (I'm sorry VireshK, I am still using my normal practice) :-)
> >=20
> > That's fine :)
> >=20
> > > diff --git a/drivers/thermal/cpu_cooling.c
> > > b/drivers/thermal/cpu_cooling.c index 1ab0018..bed3fa2 100644
> > > --- a/drivers/thermal/cpu_cooling.c
> > > +++ b/drivers/thermal/cpu_cooling.c
> > > @@ -440,6 +440,11 @@ __cpufreq_cooling_register(struct device_node
> > > *np, int ret =3D 0, i;
> > >         struct cpufreq_policy policy;
> > >
> > > +       if (!cpufreq_frequency_get_table(0)) {
> > > +               pr_err("cpu_cooling: cpufreq layer not ready!
> > > Deferring.\n");
> >=20
> > Throwing an error here doesn't look to be the right thing. Ultimately
> > we will register the cooling dev when probed again after some time.
> >=20
> > So, a pr_debug() suits more here.
> >=20

Yeah, I agree here.=20

> > Also, this breaks existing exynos thermal drivers as they don't handle
> > -EPROBE_DEFER well right now.
>=20
> Unfortunately Viresh is correct here. Current (before rework) Exynos
> TMU driver expects that cpu_cooling device will succeed.
>=20


Well, I wouldn't say unfortunately, but fortunately! :-)

Ok. But I believe it is a matter of propagating the error code. As I
included in this patch:=20

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/ther=
mal/samsung/exynos_thermal_common.c
index 3f5ad25..f84975e 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -373,7 +373,7 @@ int exynos_register_thermal(struct thermal_sensor_conf =
*sensor_conf)
 		if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size])) {
 			dev_err(sensor_conf->dev,
 				"Failed to register cpufreq cooling device\n");
-			ret =3D -EINVAL;
+			ret =3D PTR_ERR(th_zone->cool_dev[th_zone->cool_dev_size]);
 			goto err_unregister;
 		}
 		th_zone->cool_dev_size++;



> >=20
> > I reached here, because one of my patches had something similar to
> > what you wrote. Just for this file though, haven't updated any other
> > drivers though.
> >=20
> > Will be sending you my small patchset by end of day today, please see
> > if they make any sense at all..

The version you sent (for exynos) is better because there is a check for
not print error messages in case of deferring.

However, I would prefer, at least to what comes to deferring, to update
the drivers altogether with the inclusion of the check in cpu cooling.
This way the change in behavior is atomic, in terms of commit changes.

Viresh, if you don't mind, I will merge your patch 04/26 into this one.

>=20
> Best regards,
> =C5=81ukasz Majewski

BR, Eduardo Valentin

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeHUpAAoJEMLUO4d9pOJWPAYH/RZ2pwN7Ksx7Wkgg8Xjl1AfC
IHecRQ0+0k61qf5rbso1Kr+w4sZ+UXD1xIw+4Mgkcfk8GSpTSEB57Hsi0CpIb6rN
kGBHPK2SIuemS25XV06rVZFidCnHUS3GZ82ZgsUBADkKcey/ZVPb7pNrtvpS/uzN
e5YPbQXpEXGYCSDiEtgTr/dO1+I7IL0rdnkVS5Rn6gBPXcqKey5XZC/kOi+UQ3NI
ch4Sw0BrMOiJBxfwNdHOb5OlMDdUJKPuhLcHX+NQEeLZ7pKT5RexBedISVFDlJZX
CulOwfyuHQgGdMjkLnfCMRndhVpI6a3oNxXwdQpg1PBUAYRi8GLpTpNrjdukrRg=
=wr2c
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
