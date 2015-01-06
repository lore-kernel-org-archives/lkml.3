Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbbAFOaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:30:06 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44134 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbAFOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:30:05 -0500
Date: Tue, 6 Jan 2015 15:30:00 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/11] memory: tegra: add flush operation for Tegra124
 memory clients
Message-ID: <20150106142958.GM31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-4-git-send-email-vinceh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Content-Disposition: inline
In-Reply-To: <1419331204-26679-4-git-send-email-vinceh@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2014 at 06:39:56PM +0800, Vince Hsu wrote:
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>  drivers/memory/tegra/tegra124.c | 82 +++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 82 insertions(+)
>=20
> diff --git a/drivers/memory/tegra/tegra124.c b/drivers/memory/tegra/tegra=
124.c
> index 278d40b854c1..036935743a0a 100644
> --- a/drivers/memory/tegra/tegra124.c
> +++ b/drivers/memory/tegra/tegra124.c
> @@ -6,6 +6,7 @@
>   * published by the Free Software Foundation.
>   */
> =20
> +#include <linux/delay.h>
>  #include <linux/of.h>
>  #include <linux/mm.h>
> =20
> @@ -959,7 +960,85 @@ static const struct tegra_smmu_swgroup tegra124_swgr=
oups[] =3D {
>  	{ .swgroup =3D TEGRA_SWGROUP_VI,        .reg =3D 0x280 },
>  };
> =20
> +static const struct tegra_mc_hr tegra124_mc_hr[] =3D {
> +	{TEGRA_SWGROUP_AFI,        0x200, 0x200,  0},
> +	{TEGRA_SWGROUP_AVPC,       0x200, 0x200,  1},
> +	{TEGRA_SWGROUP_DC,         0x200, 0x200,  2},
> +	{TEGRA_SWGROUP_DCB,        0x200, 0x200,  3},
> +	{TEGRA_SWGROUP_HC,         0x200, 0x200,  6},
> +	{TEGRA_SWGROUP_HDA,        0x200, 0x200,  7},
> +	{TEGRA_SWGROUP_ISP2,       0x200, 0x200,  8},
> +	{TEGRA_SWGROUP_MPCORE,     0x200, 0x200,  9},
> +	{TEGRA_SWGROUP_MPCORELP,   0x200, 0x200, 10},
> +	{TEGRA_SWGROUP_MSENC,      0x200, 0x200, 11},
> +	{TEGRA_SWGROUP_PPCS,       0x200, 0x200, 14},
> +	{TEGRA_SWGROUP_SATA,       0x200, 0x200, 15},
> +	{TEGRA_SWGROUP_VDE,        0x200, 0x200, 16},
> +	{TEGRA_SWGROUP_VI,         0x200, 0x200, 17},
> +	{TEGRA_SWGROUP_VIC,        0x200, 0x200, 18},
> +	{TEGRA_SWGROUP_XUSB_HOST,  0x200, 0x200, 19},
> +	{TEGRA_SWGROUP_XUSB_DEV,   0x200, 0x200, 20},
> +	{TEGRA_SWGROUP_TSEC,       0x200, 0x200, 22},
> +	{TEGRA_SWGROUP_SDMMC1A,    0x200, 0x200, 29},
> +	{TEGRA_SWGROUP_SDMMC2A,    0x200, 0x200, 30},
> +	{TEGRA_SWGROUP_SDMMC3A,    0x200, 0x200, 31},

The documentation that I have says that the status register for these is
0x204.

> +	{TEGRA_SWGROUP_SDMMC4A,    0x970, 0x974,  0},
> +	{TEGRA_SWGROUP_ISP2B,      0x970, 0x974,  1},
> +	{TEGRA_SWGROUP_GPU,        0x970, 0x974,  2},
> +};
> +
>  #ifdef CONFIG_ARCH_TEGRA_124_SOC
> +
> +static bool tegra124_stable_hotreset_check(struct tegra_mc *mc,
> +		u32 reg, u32 *stat)
> +{
> +	int i;
> +	u32 cur_stat;
> +	u32 prv_stat;
> +
> +	prv_stat =3D mc_readl(mc, reg);
> +	for (i =3D 0; i < 5; i++) {
> +		cur_stat =3D mc_readl(mc, reg);
> +		if (cur_stat !=3D prv_stat)
> +			return false;
> +	}

Why this loop? The function is already called in a polling loop below.
Also why compare to the previous value of the register? Isn't the only
thing we're interested in the value of the specific bit?

> +	*stat =3D cur_stat;
> +	return true;
> +}
> +
> +static int tegra124_mc_flush(struct tegra_mc *mc,
> +		const struct tegra_mc_hr *hr_client, bool enable)
> +{
> +	u32 val;
> +
> +	if (!mc || !hr_client)
> +		return -EINVAL;
> +
> +	val =3D mc_readl(mc, hr_client->ctrl);
> +	if (enable)
> +		val |=3D BIT(hr_client->bit);
> +	else
> +		val &=3D ~BIT(hr_client->bit);
> +	mc_writel(mc, val, hr_client->ctrl);
> +	mc_readl(mc, hr_client->ctrl);
> +
> +	/* poll till the flush is done */
> +	if (enable) {
> +		do {
> +			udelay(10);

This should probably be usleep_range(10, 20) or something.

Would it be difficult to implement this for Tegra30 and Tegra114?

Thierry

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq/FmAAoJEN0jrNd/PrOhmbMP/RlchLQIqQT8d+1jRBS7PCGV
R+bmvhf2autiKcLDfK3X7D6o0medJhJjYVR7Lazezb9hyZCoumL4EjReBQF+8QrJ
AMwE0sQjljU3aVZqGljmfVK2CviiFf6ycIivaek7pX/fWi8EsLdc6ViumEpDBBpA
u0cavPkEpCB+sIwYjv+QPv67yA50f2yTWKYbYKPEnj9bLyEMuQMBilyQ29pmgLBb
rSHCLEwpS7v4UNQtj3IzOrenG33Z1eTwgNn3/vAIBCOLTMUI1ylx2LYmq2OKsZ7L
CIvOo1SQRqQd0XrWwLXEPJN0Ybfj5F4cG2bprd50UpN8fACFmcOMU6rrMDM1MTQn
RwrwmRoZJDJKTtoCm4wREG1N2Nh6tu78J9svlq19rDLYC1w+HEe4JLiJYkMKC4d5
G0RKO0130qdHlFUULJvpBIMYQEaCw0bPQnnY3M+gODahFLxWaAQbXHxd74b1L7t+
AmzfCCUm9BIJ74nHETCz1KoRyQCQ7FBWAe6ZhAc3AW1T2AS+M6CK/R6zqlaG5W0G
zcuazBOohlCZnoanrhDXkOioRFY2btiZYTpDe9IDT6Lce0OE11BzfKSBcsQ/8ErJ
VVwQOZpsQcjMfo4vdmgLhuW5EhjjGSqON2FU/G1Zd6Ae3Q1REUBLeKAWSwlDHWTp
L6/8HmBViCwS4Rqtxlcu
=aJEa
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--
