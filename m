Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaGQLAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:00:39 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56198 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGQLAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:00:34 -0400
Date: Thu, 17 Jul 2014 12:52:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
Message-ID: <20140717105244.GG17877@ulmo>
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com>
 <1405510814-31928-1-git-send-email-mperttunen@nvidia.com>
 <53C666E5.6030009@redhat.com>
 <20140716131306.GB23384@ulmo>
 <53C6908A.2050200@redhat.com>
 <20140716195136.GB5212@mithrandir>
 <53C77263.7050903@redhat.com>
 <20140717073956.GA18640@ulmo>
 <53C7A433.4070404@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jt0yj30bxbg11sci"
Content-Disposition: inline
In-Reply-To: <53C7A433.4070404@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jt0yj30bxbg11sci
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 12:23:47PM +0200, Hans de Goede wrote:
> On 07/17/2014 09:39 AM, Thierry Reding wrote:
> > On Thu, Jul 17, 2014 at 08:51:15AM +0200, Hans de Goede wrote:
[...]
> > > I realize that this changes the reset-deassert vs clock enabling orde=
ring,
> > > if this is an issue please add reset support to libahci-platform.c I =
believe
> > > that is something which we will need to do soonish anyways (reset con=
trollers
> > > are popping up everywhere in newer SoCs).
> >=20
> > I think we could safely move the reset deassert after the call to
> > ahci_platform_enable_resources().
>=20
> Will the resets not interfere with the phy_init / power_on which is done =
=66rom
> ahci_platform_enable_resources().

The PHY is a completely different hardware block and I think the only
requisite is that the regulator be turned on. Resets from SATA don't
influence it.

> >> This means that the sata_clk will get enabled twice, but that is harml=
ess
> >> as long as we disable it twice too. This means that we need to add an
> >> extra disable to tegra_ahci_power_off because tegra_powergate_power_off
> >> seems to not do this (unlike power-on, which is rather unsymmetrical
> >> it would be nice to fix this).
> >=20
> > We've never had a need for it because the exact power down sequence
> > isn't nearly as important. But I guess we could add a new function
> > tegra_powergate_sequence_power_down() that takes care of disabling the
> > clock and asserting the reset.
>=20
> Ok, no need to add it for my sake, I was just wondering about the non
> symmetry of the API.

There are discussions on how to make powergates work with PM domains.
They aren't an ideal fit, but if we manage to make it work the powergate
API will likely go away anyway.

> > One other thing that I've been thinking about is whether it would make
> > sense to make the ahci_platform library use a list of clock names that
> > it should request. This would better mirror the clock bindings
> > convention and allow drivers (such as the Tegra one) to take ownership
> > of clocks that need special handling while at the same time leaving it
> > to the helpers to do the bulk of the work.
> >=20
> > One way I can think of to handle this would be by adding a struct
> > ahci_platform_resources * parameter to ahci_platform_get_resources(),
> > sowewhat like this:
> >=20
> > 	struct ahci_platform_resources {
> > 		const char *const *clocks;
> > 		unsigned int num_clocks;
> >=20
> > 		const char *const *resets;
> > 		unsigned int num_resets;
> > 	};
> >=20
> > 	struct ahci_host_priv *ahci_platform_get_resources(struct platform_dev=
ice *pdev,
> > 							   const struct ahci_platform_resources *res)
> > 	{
> > 		...
> >=20
> > 		for (i =3D 0; i < res->num_clocks; i++) {
> > 			clk =3D clk_get(&pdev->dev, res->clocks[i]);
> > 			...
> > 		}
> >=20
> > 		...
> >=20
> > 		for (i =3D 0; i < res->num_resets; i++) {
> > 			rst =3D reset_control_get(&pdev->dev, res->resets[i]);
> > 			...
> > 		}
> >=20
> > 		...
> > 	}
>=20
> Interesting, I think this is a quite good idea. I do see some pitfalls th=
ough,
> to answers Mikko's question from his followup :
>=20
> On 07/17/2014 09:56 AM, Mikko Perttunen wrote:
> > Also: is there a reason to not use the devm_* variants? I note that the=
 helper code has not been able to prevent any of the ahci_platform drivers =
=66rom messing up by not calling ahci_platform_put_resources.
>=20
> The libahci_platform.c code / ahci_platform.c code is also used for
> devices going way back who may not yet be using the new clk framework,
> so where we need to use clk_get(dev, NULL); quoting from libahci_platform=
=2Ec :
>=20
>         for (i =3D 0; i < AHCI_MAX_CLKS; i++) {
>                 /*
>                  * For now we must use clk_get(dev, NULL) for the first c=
lock,
>                  * because some platforms (da850, spear13xx) are not yet
>                  * converted to use devicetree for clocks.  For new platf=
orms
>                  * this is equivalent to of_clk_get(dev->of_node, 0).
>                  */
>                 if (i =3D=3D 0)
>                         clk =3D clk_get(dev, NULL);
>                 else
>                         clk =3D of_clk_get(dev->of_node, i);
>=20
>                 if (IS_ERR(clk)) {
>                         rc =3D PTR_ERR(clk);
>                         if (rc =3D=3D -EPROBE_DEFER)
>                                 goto err_out;
>                         break;
>                 }
>                 hpriv->clks[i] =3D clk;
>         }
>=20
> And there is no devm variant of that, nor is there one to get clocks by i=
ndex.
> Note that we also need ahci_platform_put_resources for runtime pm support=
, so
> that one is going to stay around anyways and thus there is not that much =
value
> in fixing this.
>=20
> So although I like Thierry's idea, if we go this way (which sounds good),=
 we
> should add support for taking a NULL ahci_platform_resources argument and=
 in
> that case behave as before, esp. because of the platforms needing the old
> style clock handling. An advantage of doing this, is that we can simply p=
atch
> all existing users to pass NULL.

Isn't the "legacy" case really just this:

	static const char *const legacy_ahci_clocks[] =3D {
		NULL
	};

	static const struct ahci_platform_resources legacy_ahci_resources =3D {
		.num_clocks =3D ARRAY_SIZE(legacy_ahci_clocks),
		.clocks =3D legacy_ahci_clocks,
	};

?

> > 	static const char *const tegra_ahci_clocks[] =3D {
> > 		"sata-oob", "cml1", pll_e",
> > 	};
>=20
> Note you could also put the "sata" clock here, since then you will
> know its index, and can use hpriv->clks to access it. Not putting
> it here has the advantage of not doing the double enable / disable
> (and the disadvantage of needing to the clk_get yourself).

Right, the intention here was that we wouldn't have it managed by the
ahci_platform library because it needs special handling anyway. Having
it in this table would therefore be redundant.

Thierry

--jt0yj30bxbg11sci
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx6r8AAoJEN0jrNd/PrOh/YAP/0u2rmS8lqSVKsSJugBsvkMe
SAqTzPtCHmIMCCy5YwDYT1b0hmbHxVil1zrhFzlknlgrEi6NKLc146xp+hJKzdlv
RDtlegY850s/Zpk6jKi6YencgnDZpWFAbULw4n5hFsD0qiHPk6cdPLJyArMweeXt
yXCc8wX9FgVWw59VRgM3GwGFh2APkECbixTHZUMM92KGFJ7KaakQpdIfH0vwKEW6
ZVK8Ta3WP0ekNUuF7znwYo3vJCW044voWcGaj4IkkneHoB+5QU20ldMhYVZNzkAh
+Okl2Dw/swpjSyZrq9KiEiCTy1FHdx6dsjSKWmgtraJtqmR4Jm7QFr15VVINy3dw
ZL9AUclHHP1BRdcbzr6SwiFFrBIuJ7yKOUePtNVCxdeP4XGC4OiGWrNlbyQlwXOb
7CvIIJ2RR+JWODt3mzhapgtOvMr7MZCuJIzquQvrcNWW1kk1JrsY50Gpm30BDX1A
a9nuBZLHjaTxyY8kuPvw3nnIgAKh6AAdXZ5+K4EIWN58ePpI8kpfRk0dibrDIcrK
RI12FGcsSZpdCL0Chy2EB7KrzPaZMJwh2XY2hMg9RbOWXATZz4qUauEez5MvolYy
Zf+M1+VHphWFhIIosd8Uku6wnLymUFZ/crATLkw93OxMNdC5/vNahZYBbnhE/U3X
PCME5xA8dbdoCIb1cf7R
=IWw4
-----END PGP SIGNATURE-----

--jt0yj30bxbg11sci--
