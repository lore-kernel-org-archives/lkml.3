Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaLJLX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:23:56 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14809 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaLJLXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:23:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Dec 2014 03:22:09 -0800
Date: Wed, 10 Dec 2014 12:23:23 +0100
From: Thierry Reding <treding@nvidia.com>
To: Paul Walmsley <paul@pwsan.com>
CC: <linux-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "Paul Walmsley" <pwalmsley@nvidia.com>,
        Allen Martin <amartin@nvidia.com>,
        "Stephen Warren" <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
Message-ID: <20141210112322.GE15287@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.70.89]
X-ClientProxiedBy: UKMAIL101.nvidia.com (10.26.138.13) To
 drukmail101.nvidia.com (10.25.59.19)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 10:36:50PM +0000, Paul Walmsley wrote:
>=20
> Tegra SoCs with 64-bit ARM support don't currently support deep CPU
> low-power states in mainline Linux.  When this support is added in the
> future, it will probably look rather different from the existing
> 32-bit ARM support, since the ARM64 maintainers' strong preference is
> to use PSCI to implement it.
>=20
> So, for the time being, prevent the CPU suspend-related code and data
> in the Tegra PMC driver from compiling on ARM64.
>=20
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Thierry Reding <treding@nvidia.com>
> Cc: Allen Martin <amartin@nvidia.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> ---
> Applies on next-20141209.
> Intended for v3.20.
> Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> Also boot-tested on Tegra132 Norrin FFD on next-20141209 + some unrelated=
=20
> patches.
>=20
>  drivers/soc/tegra/pmc.c | 7 +++++--
>  include/soc/tegra/pm.h  | 2 +-
>  2 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
> index a2c0ceb95f8f..4bdc654bd747 100644
> --- a/drivers/soc/tegra/pmc.c
> +++ b/drivers/soc/tegra/pmc.c
> @@ -739,7 +739,7 @@ static int tegra_pmc_probe(struct platform_device *pd=
ev)
>  	return 0;
>  }
> =20
> -#ifdef CONFIG_PM_SLEEP
> +#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_ARM)

I would slightly prefer having this as separate #ifdef lines to make it
clearer that we're special-casing 32-bit ARM.

>  static int tegra_pmc_suspend(struct device *dev)
>  {
>  	tegra_pmc_writel(virt_to_phys(tegra_resume), PMC_SCRATCH41);
> @@ -753,10 +753,11 @@ static int tegra_pmc_resume(struct device *dev)
> =20
>  	return 0;
>  }
> -#endif
> =20
>  static SIMPLE_DEV_PM_OPS(tegra_pmc_pm_ops, tegra_pmc_suspend, tegra_pmc_=
resume);
> =20
> +#endif

I don't think this is necessary, SIMPLE_DEV_PM_OPS will not use the
supend or resume hooks if PM_SLEEP is disabled. The result will be an
empty dev_pm_ops structure. While that's somewhat useless, at least
it'll allow...

> +
>  static const char * const tegra20_powergates[] =3D {
>  	[TEGRA_POWERGATE_CPU] =3D "cpu",
>  	[TEGRA_POWERGATE_3D] =3D "3d",
> @@ -894,7 +895,9 @@ static struct platform_driver tegra_pmc_driver =3D {
>  		.name =3D "tegra-pmc",
>  		.suppress_bind_attrs =3D true,
>  		.of_match_table =3D tegra_pmc_match,
> +#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_ARM)
>  		.pm =3D &tegra_pmc_pm_ops,
> +#endif

=2E.. this #ifdef to be avoided.

>  	},
>  	.probe =3D tegra_pmc_probe,
>  };
> diff --git a/include/soc/tegra/pm.h b/include/soc/tegra/pm.h
> index 30fe2078a547..03909101d4e7 100644
> --- a/include/soc/tegra/pm.h
> +++ b/include/soc/tegra/pm.h
> @@ -17,7 +17,7 @@ enum tegra_suspend_mode {
>  	TEGRA_MAX_SUSPEND_MODE,
>  };
> =20
> -#ifdef CONFIG_PM_SLEEP
> +#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_ARM)

Similarly to the above, I'd prefer this to be two separate lines. That
also has the advantage that if we do add code for suspend/resume on 64
bit ARM later on we don't need to untangle the conditional again.

Thierry

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUiC0qAAoJEN0jrNd/PrOhpdoP/Rb5yHJqXrMAx59XiXUInZzX
8PsGsgNaWN/7XSVIQtPLGDhmy9eV5QsxkNe4nhOW01hCFlpAfP2xfzbxn35Q/sLd
9yNIUJE1JcrwffZHtoFJCt2cqifIER8w45sjR623mJ8ZEPwoqQbPWsTjt1nVdjgU
Iyfoh+GxNkN9U4K7X4JDOvIf4nCijfzN2R8E47VIIcaHWd+Ld51bzqSix2uXRNzL
TD8i/U9+yPiDQqAI0a9g4MQhsVHnOsNBzVW6mX1L2WmYoBmY9qKZLKoY4PgoG1ox
TgUGSIg0gEUvsrWfB0BIYB244qQxGq4/OMShD5s6XyePvPvDhzikMrIRoZbe6ZzG
jyoICm/m67MH+Lvatx6bSOlLcKUpCOl7p3QKYAexv7auzQfcgJGK7igxUfMuU2W9
sQgNrhdXdVCHV78uMtUyXv29n4vyn/xr2rV8GdpSFxYuW/ycY7XIiESrRPoSw4d+
7AzDNyAACeEUnXAKnen0qk+FQQShXmh2L3e155eKG+gKaw74SXFauFlsYQH/oXQR
AJnDbT7Y43woAnVDAqcn3heVRTLmVZWqTJQVfwT6mUBKGaQ5nDHSVL1OTE0w9zrk
2bwNjiUIlDFqKoe8iqmifViWv71qYbRNIfzc6+NrNpQY56klf1nT2gAoqKETFamX
jYDauVubx+UnrYeBto5r
=SRLi
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--
