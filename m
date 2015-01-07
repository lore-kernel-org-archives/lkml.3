Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbbAGNeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:34:20 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41337 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbAGNeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:34:17 -0500
Date: Wed, 7 Jan 2015 14:34:14 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Vince Hsu <vinceh@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        gnurou@gmail.com, bskeggs@redhat.com, martin.peres@free.fr,
        seven@nimrod-online.com, samuel.pitoiset@gmail.com,
        nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/11] memory: tegra: add mc flush support
Message-ID: <20150107133413.GB6988@ulmo>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-3-git-send-email-vinceh@nvidia.com>
 <20150106141821.GJ31830@ulmo.nvidia.com>
 <20150107100804.GO10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <20150107100804.GO10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 12:08:05PM +0200, Peter De Schrijver wrote:
> On Tue, Jan 06, 2015 at 03:18:22PM +0100, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Tue, Dec 23, 2014 at 06:39:55PM +0800, Vince Hsu wrote:
> > > The flush operation of memory clients is needed for various IP blocks=
 in
> > > the Tegra SoCs to perform a clean reset.
> > >=20
> > > Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> > > ---
> > >  drivers/memory/tegra/mc.c | 21 +++++++++++++++++++++
> > >  include/soc/tegra/mc.h    | 23 ++++++++++++++++++++++-
> > >  2 files changed, 43 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
> > > index fe3c44e7e1d1..a2928b4b26fe 100644
> > > --- a/drivers/memory/tegra/mc.c
> > > +++ b/drivers/memory/tegra/mc.c
> > > @@ -62,6 +62,27 @@ static const struct of_device_id tegra_mc_of_match=
[] =3D {
> > >  };
> > >  MODULE_DEVICE_TABLE(of, tegra_mc_of_match);
> > > =20
> > > +int tegra_mc_flush(struct tegra_mc *mc, unsigned int swgroup, bool e=
nable)
> > > +{
> > > +	int i;
> > > +	const struct tegra_mc_hr *client;
> > > +
> > > +	if (!mc || !mc->soc->hr_clients ||
> > > +			!mc->soc->ops || !mc->soc->ops->flush)
> > > +		return -EINVAL;;
> > > +
> > > +	client =3D mc->soc->hr_clients;
> > > +
> > > +	for (i =3D 0; i < mc->soc->num_hr_clients; i++, client++) {
> > > +		if (swgroup =3D=3D client->swgroup) {
> > > +			return mc->soc->ops->flush(mc, client, enable);
> > > +		}
> > > +	}
> > > +
> > > +	return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL(tegra_mc_flush);
> >=20
> > Like Lucas already mentioned in response to another patch, having a
> > boolean "enable" argument is suboptimal here. Now according to
> > documentation the proper reset sequence for clients is something like
> > this:
> >=20
> > 	1) set the FLUSH_ENABLE bit for the client
> > 	2) poll the FLUSH_DONE bit for the client
> > 	3) assert reset to the client using the CAR
> > 	4) deassert reset to the client using the CAR
> > 	5) clear the FLUSH_ENABLE bit for the client
> >=20
>=20
> Do we ever need to do this outside a powergating or railgating sequence?

I don't think so. I worry a little that we may encounter situations
where the driver itself wants to reset the hardware module via the CAR,
though I think if we made sure that any driver resets would only happen
with a runtime PM reference held it should be safe.

Furthermore there's the issue of keeping backwards-compatibility. There
are some drivers that actually do this kind of reset today, so they need
to be carefully audited before conversion.

And we need to conditionalize the manual powergate sequences that are
currently used by the various drivers so that they don't happen when
power domains are initialized.

> > This is really inconvenient because we can't flush the client using a
> > single operation. So I think we'll need two functions here, something
> > like: tegra_mc_flush_enable/disable(), or tegra_mc_flush_{,de}assert().
> > Or maybe even: tegra_mc_reset_{,de}assert() to mirror the reset
> > controller API. I suppose we could even export it using the reset
> > controller framework.
> >=20
> > Doing so would allow us to have power domain DT nodes like this:
> >=20
> > 	pmc@0,7000e400 {
> > 		power-domains {
> > 			...
> >=20
> > 			gpu {
> > 				resets =3D <&tegra_car 184>,
> > 					 <&mc TEGRA_SWGROUP_GPU>;
> > 				reset-names =3D "module", "client";
> > 			};
> >=20
> > 			...
> > 		};
> > 	};
> >=20
> > The PMC driver could then grab the "module" and "client" resets and do
> > something like this:
> >=20
> > 	reset_control_assert(powergate->rst_client);
> > 	reset_control_assert(powergate->rst_module);
> > 	reset_control_deassert(powergate->rst_module);
> > 	reset_control_deassert(powergate->rst_client);
> >=20
> > Optionally the above could be extended with a reset_control_status()-
> > loop. Alternatively reset_control_assert() would block until the
> > FLUSH_DONE bit is set.
> >=20
>=20
> I think the reset_control_assert should wait for the FLUSH_DONE bit to be=
 set
> because only then all outstanding memory transactions for the client are
> completed so you can't realistically claim the reset has been asserted be=
fore
> the bit is set. Then you could also expose a single reset which handles b=
oth
> the memory client and the module reset in CAR? Ie:
>=20
> reset_control_assert(powergate->rst_module); would set FLUSH_ENABLE for t=
he
> memory client, wait for the FLUSH_DONE bit and then assert the CAR reset.
> reset_control_deassert(powergate->rst_module); would deassert the CAR res=
et
> and then clear the FLUSH_ENABLE bit. Or is there a usecase to control them
> individually?

I suppose that would be possible, but it'd mean that we need to access
registers across driver boundaries (the CAR driver would need to write
the memory controller's registers or vice versa). Doing this with
separate reset controls allows the drivers to be nicely separated.

Thierry

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrTXVAAoJEN0jrNd/PrOhro0P/1MVKOt81IZLSj54jGlCQldj
mVXIEhufcgL1Byrd3r83ap7jMsw+G9V1zqaJRB6zh1qHZgVuGIdhvNcIaakRzw8m
iu8DQy2YZiY915RidxwkFgVyRoUid536s4By1MB0wKKf1WlxyC/H97ox8R41/UnN
jf4qWqU4iAMTctzHwyPQ1DNyiO+SQheBpHBPZeXeV2qODzUBCCMJz1OnuFzKNj0e
qFpQZxKnc0guupqmjBK2l8qKxOKbwytoFtGIHNvcJ4tzbiodNZUoLpSH/9ITXbI3
ATyEVEGD+ou4bez7J4IEkm2Y78p0irsWZeskcLpJmJQ0v5RilxbczAvxvH6FGyOk
bifWwguxkeZ1cPaDInz8INwa3XiJfwEzuAkk8yOWlFUVoV8C99Cp67wJEthExWm5
+Tvt93if0AxJJKr5Z407JChVI/alLYsE5vujYnX1YukUjn/+eyVmX7XGTU1im4zx
FhwDVQde/G01pRmpAYWmgbcVkGXX0Hjou++F4x99TeL07A/w/omO34ozwPm9KnOP
8ZIqmF8kILf9UY7BRqH/9a/1pwIlskVQz56cLLSpMiMjdH87DeDCj0gyI6yep/6O
BcwDmuEZAJJck9j6l5yGg2WWJEgU9soCrmGe/VoQV0ntJqF5C9PgBp9LGJC0L3Uf
fxkmZRYqZPiG4RWFFyak
=WyPW
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
