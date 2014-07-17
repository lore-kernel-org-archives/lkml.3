Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbaGQVNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:13:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:35905 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbaGQVNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:13:53 -0400
Date: Thu, 17 Jul 2014 23:13:48 +0200
From: Sebastian Reichel <sre@kernel.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140717211347.GD13832@earth.universe>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
 <20140703145617.GA23309@earth.universe>
 <20ADAB092842284E95860F279283C56422F95A3E@BGSMSX104.gar.corp.intel.com>
 <20140708155614.GA12945@earth.universe>
 <20ADAB092842284E95860F279283C56422F9B99C@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RhUH2Ysw6aD5utA4"
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C56422F9B99C@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RhUH2Ysw6aD5utA4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 02:46:35AM +0000, Tc, Jenny wrote:
> > From: Sebastian Reichel [mailto:sre@kernel.org]
> > Sent: Tuesday, July 08, 2014 9:26 PM
> > To: Tc, Jenny
> > Cc: linux-kernel@vger.kernel.org; Dmitry Eremin-Solenikov; Pavel Machek=
; Stephen
> > Rothwell; Anton Vorontsov; David Woodhouse; David Cohen; Pallala, Ramak=
rishna
> > Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
> >=20
> > On Tue, Jul 08, 2014 at 06:07:29AM +0000, Tc, Jenny wrote:
> > > > > +static int get_tempzone(struct psy_pse_chrg_prof *pse_mod_bprof,
> > > > > +		int temp)
> > > > > +{
> > > > > +	int i =3D 0;
> > > > > +	int temp_range_cnt;
> > > > > +
> > > > > +	temp_range_cnt =3D  min_t(u16, pse_mod_bprof->temp_mon_ranges,
> > > > > +					BATT_TEMP_NR_RNG);
> > > > > +	if ((temp < pse_mod_bprof->temp_low_lim) ||
> > > > > +		(temp > pse_mod_bprof->temp_mon_range[0].temp_up_lim))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	for (i =3D 0; i < temp_range_cnt; ++i)
> > > > > +		if (temp > pse_mod_bprof->temp_mon_range[i].temp_up_lim)
> > > > > +			break;
> > > > > +	return i-1;
> > > > > +}
> > > >
> > > > pse_mod_bprof->temp_mon_ranges > BATT_TEMP_NR_RNG is not allowed, so
> > > > I suggest to print an error and return some error code.
> > > >
> > > min_t takes care of the upper bound. The algorithm process
> > > BATT_TEMP_NR_RNG even if the actual number of zones are greater than =
this.
> >=20
> > Right, the function will not fail, but the zone information table is tr=
uncated. I would
> > expect at least warning about that. I think it doesn't hurt to have a s=
mall function,
> > which validates the zone data as good as possible. Using incorrect temp=
erature
> > zones is a safety thread and we should try our best to avoid exploding =
batteries ;)
> >=20
> > Maybe something like that:
> >=20
> > static bool check_tempzones(struct psy_pse_chrg_prof *pse_mod_bprof) {
> >     int i =3D 0;
> >     int last_temp =3D ;
> >=20
> >     /* check size */
> >     if (BATT_TEMP_NR_RNG > pse_mod_bprof->temp_mon_ranges)
> >         return false;
>=20
> This is in a way good to have, OK to implement the same.
>=20
> But KO with below suggestion. This doesn't guarantee safety. IMHO
> Safety is 1/0 - SAFE or NOT SAFE. No half safety.

We won't be able to handle every possible case, but we can try our
best to avoid problems. One (possibly useless) safety check too much
is better than one missing check.

> To ensure complete safety, measures should be taken at the entry
> point- where data is read from external source. Since the
> algorithm gets the data from internal kernel component
> (power_supply_charger.c), it trust the data. Since the data is
> originated from battery identification driver, the safety should
> be ensured at that level.

I think some basic checks of kernel's platform data help to avoid
potential problems during development phase.

> >     /* check zone order */
> >     for (i =3D 0; i < pse_mod_bprof->temp_mon_ranges; i++) {
> >         if (last_temp < pse_mod_bprof->temp_mon_range[i].temp_up_lim)
> >             return false;
> >         last_temp =3D pse_mod_bprof->temp_mon_range[i].temp_up_lim;
> >     }
> >=20
> >     return true;
> > }

-- Sebastian

--RhUH2Ysw6aD5utA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTyDyLAAoJENju1/PIO/qacr8P/jJURP0nfVoQFdWwKtOEwZhd
z+XhTeq5GqM4AgQxf5o2lLdtBv7JnaUV28Q4OUAa5MK2rhCtVVr/j3oEyCkFwaXI
pPFQw7Mrax2He0ZNRgvDVGBypIvpnlvIAyJKx7B1um10npzGPM9PKoz7BEgcCITx
6qYS9TtElFqLAU4JwCMt2kSwVP8wu2JprFZKJ5G9ge0hrZzA8IeDtCHDnYAqmmTO
zN1jF9W0Gp8CgRZAH68oWTaWqwTYhcbSpAkpMs4ENtlEy2KBJDyUfF2dTjjvJmAj
czrLVhxItgdfoBFoM1a8UL5iVyc6pxTHuA6wfW/YpqMZDiERaSUd8jZPNulQqerW
WDDYbXTxMyAj04tYHdQqfbM8G5vrftxoYDlwOGvc8+2aFO6wGBI8ZJMoW6i+WtR4
R6lRjsifZ+1CyLhoRsP/gTsFjr/Davtokb3sSLI2SBkCD1NV4BJXc4bS6JujCjAi
rDoL3hpFUZm2pD1jJJdQtkutmryTFXxmTrpkURcPKrGpr4Maqi/UQpRo3yNx3wn+
VAqjjX+T4cLKxL5elc2KHf6Z/M0xlbKtE7kqzLnYUq2Hj/Ow2bkpkBO3j/KZXlDv
rPFWEr/nX84KkMd2ULjtDTaVwYgZ9CmnLzMlRBXyIgszRV/ZhpytqukmrjO6+qWa
NRLxAiuRqzXybo8cNU6D
=UdSM
-----END PGP SIGNATURE-----

--RhUH2Ysw6aD5utA4--
