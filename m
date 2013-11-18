Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3KRLoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:44:05 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35248 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3KRLn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:43:59 -0500
Date: Mon, 18 Nov 2013 12:43:31 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] ARM: tegra: properly use FUSE clock
Message-ID: <20131118114330.GD8646@ulmo.nvidia.com>
References: <1384771247-16547-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Content-Disposition: inline
In-Reply-To: <1384771247-16547-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2013 at 07:40:47PM +0900, Alexandre Courbot wrote:
> FUSE clock is enabled by most bootloaders, but we cannot expect it to be
> on in all contexts (e.g. kexec).
>=20
> This patch adds a FUSE clkdev to all Tegra platforms and makes sure
> it is enabled before touching FUSE registers. tegra_init_fuse() is
> invoked during very early boot and thus cannot rely on the clock
> framework ; therefore the FUSE clock is forcibly enabled using a
> register write in that function, and remains that way until the
> clock framework can be used.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/mach-tegra/fuse.c       | 41 ++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/clk/tegra/clk-tegra114.c |  1 +
>  drivers/clk/tegra/clk-tegra124.c |  1 +
>  drivers/clk/tegra/clk-tegra20.c  |  1 +

Isn't this missing the clock driver changes for Tegra30? Ah... Tegra30
already has this clock defined. I wonder why only Tegra30 has it. grep
says that fuse-tegra isn't used by any drivers, which also indicates
that perhaps we don't need the .dev_id in the first place. We should be
able to get by with just the .con_id =3D "fuse".

Also are there any reasons to keep this in one single patch? Since none
of the fuse clocks are used yet, I think the clock changes could be a
separate patch that can go in through the clock tree. And there isn't
even a hard runtime dependency, since if the Tegra changes were to go in
without the clock changes, then the fallback code in this patch should
still turn the clock on properly. It just might not be turned off again,
but isn't that something we can live with for a short period of time? I
think perhaps that could even be improved, see further below.

I've added Mike on Cc, he'll need to either take the patch in through
his tree or Ack this one, so he needs to see it eventually.

>  4 files changed, 43 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
> index 9a4e910c3796..3b9191b930b5 100644
> --- a/arch/arm/mach-tegra/fuse.c
> +++ b/arch/arm/mach-tegra/fuse.c
> @@ -22,6 +22,7 @@
>  #include <linux/io.h>
>  #include <linux/export.h>
>  #include <linux/random.h>
> +#include <linux/clk.h>
>  #include <linux/tegra-soc.h>
> =20
>  #include "fuse.h"
> @@ -54,6 +55,7 @@ int tegra_cpu_speedo_id;		/* only exist in Tegra30 and =
later */
>  int tegra_soc_speedo_id;
>  enum tegra_revision tegra_revision;
> =20
> +static struct clk *fuse_clk;
>  static int tegra_fuse_spare_bit;
>  static void (*tegra_init_speedo_data)(void);
> =20
> @@ -77,6 +79,22 @@ static const char *tegra_revision_name[TEGRA_REVISION_=
MAX] =3D {
>  	[TEGRA_REVISION_A04]     =3D "A04",
>  };
> =20
> +static void tegra_fuse_enable_clk(void)
> +{
> +	if (IS_ERR(fuse_clk))
> +		fuse_clk =3D clk_get_sys("fuse-tegra", "fuse");
> +	if (IS_ERR(fuse_clk))
> +		return;

Perhaps instead of just returning here, this should actually be where
the code to enable the clock should go.

> +	clk_prepare_enable(fuse_clk);
> +}
> +
> +static void tegra_fuse_disable_clk(void)
> +{
> +	if (IS_ERR(fuse_clk))
> +		return;

And this is where we could disable it again. That way we should get
equal functionality in both cases.

Thierry

> +	clk_disable_unprepare(fuse_clk);
> +}
> +
>  u32 tegra_fuse_readl(unsigned long offset)
>  {
>  	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
> @@ -84,7 +102,15 @@ u32 tegra_fuse_readl(unsigned long offset)
> =20
>  bool tegra_spare_fuse(int bit)
>  {
> -	return tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
> +	bool ret;
> +
> +	tegra_fuse_enable_clk();
> +
> +	ret =3D tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
> +
> +	tegra_fuse_disable_clk();
> +
> +	return ret;
>  }
> =20
>  static enum tegra_revision tegra_get_revision(u32 id)
> @@ -113,10 +139,14 @@ static void tegra_get_process_id(void)
>  {
>  	u32 reg;
> =20
> +	tegra_fuse_enable_clk();
> +
>  	reg =3D tegra_fuse_readl(tegra_fuse_spare_bit);
>  	tegra_cpu_process_id =3D (reg >> 6) & 3;
>  	reg =3D tegra_fuse_readl(tegra_fuse_spare_bit);
>  	tegra_core_process_id =3D (reg >> 12) & 3;
> +
> +	tegra_fuse_disable_clk();
>  }
> =20
>  u32 tegra_read_chipid(void)
> @@ -159,6 +189,15 @@ void __init tegra_init_fuse(void)
>  	reg |=3D 1 << 28;
>  	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x48));
> =20
> +	/*
> +	 * Enable FUSE clock. This needs to be hardcoded because the clock
> +	 * subsystem is not active during early boot.
> +	 */
> +	reg =3D readl(IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
> +	reg |=3D 1 << 7;
> +	writel(reg, IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x14));
> +	fuse_clk =3D ERR_PTR(-EINVAL);
> +
>  	reg =3D tegra_fuse_readl(FUSE_SKU_INFO);
>  	randomness[0] =3D reg;
>  	tegra_sku_id =3D reg & 0xFF;
> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-teg=
ra114.c
> index dbab27f773b5..a83fdfd19bfc 100644
> --- a/drivers/clk/tegra/clk-tegra114.c
> +++ b/drivers/clk/tegra/clk-tegra114.c
> @@ -925,6 +925,7 @@ static struct tegra_devclk devclks[] __initdata =3D {
>  	{ .con_id =3D "sclk", .dt_id =3D TEGRA114_CLK_SCLK },
>  	{ .con_id =3D "hclk", .dt_id =3D TEGRA114_CLK_HCLK },
>  	{ .con_id =3D "pclk", .dt_id =3D TEGRA114_CLK_PCLK },
> +	{ .con_id =3D "fuse", .dev_id =3D "fuse-tegra", .dt_id =3D TEGRA114_CLK=
_FUSE },
>  	{ .dev_id =3D "rtc-tegra", .dt_id =3D TEGRA114_CLK_RTC },
>  	{ .dev_id =3D "timer", .dt_id =3D TEGRA114_CLK_TIMER },
>  };
> diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-teg=
ra124.c
> index 266e80b51d38..0a324a2d7309 100644
> --- a/drivers/clk/tegra/clk-tegra124.c
> +++ b/drivers/clk/tegra/clk-tegra124.c
> @@ -1007,6 +1007,7 @@ static struct tegra_devclk devclks[] __initdata =3D=
 {
>  	{ .con_id =3D "sclk", .dt_id =3D TEGRA124_CLK_SCLK },
>  	{ .con_id =3D "hclk", .dt_id =3D TEGRA124_CLK_HCLK },
>  	{ .con_id =3D "pclk", .dt_id =3D TEGRA124_CLK_PCLK },
> +	{ .con_id =3D "fuse", .dev_id =3D "fuse-tegra", .dt_id =3D TEGRA124_CLK=
_FUSE },
>  	{ .dev_id =3D "rtc-tegra", .dt_id =3D TEGRA124_CLK_RTC },
>  	{ .dev_id =3D "timer", .dt_id =3D TEGRA124_CLK_TIMER },
>  };
> diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegr=
a20.c
> index 58faac5f509e..48dca0f4762a 100644
> --- a/drivers/clk/tegra/clk-tegra20.c
> +++ b/drivers/clk/tegra/clk-tegra20.c
> @@ -452,6 +452,7 @@ static struct tegra_devclk devclks[] __initdata =3D {
>  	{ .con_id =3D "sclk", .dt_id =3D TEGRA20_CLK_SCLK },
>  	{ .con_id =3D "hclk", .dt_id =3D TEGRA20_CLK_HCLK },
>  	{ .con_id =3D "pclk", .dt_id =3D TEGRA20_CLK_PCLK },
> +	{ .con_id =3D "fuse", .dev_id =3D "fuse-tegra", .dt_id =3D TEGRA20_CLK_=
FUSE },
>  	{ .con_id =3D "twd", .dt_id =3D TEGRA20_CLK_TWD },
>  	{ .con_id =3D "audio", .dt_id =3D TEGRA20_CLK_AUDIO },
>  	{ .con_id =3D "audio_2x", .dt_id =3D TEGRA20_CLK_AUDIO_2X },
> --=20
> 1.8.4.2
>=20

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSif1iAAoJEN0jrNd/PrOhbYUP/2c+5upYtnd9lWq8wDRfkfUl
arRMmus/+bg2nD4hhMc04VVI+idquWyzxCtUfqofUfVmEBzWQo2iYxbkNeIJlqLf
/UVW5n2U55CpwijGG+ICJgTEYAW8ncy8UdXUmiOCgapiNM4ek7RI5XWSmSJcqUPa
sXoHWWyuN9KerwhZlbv8N+/haFgGsUZxVv1zbWSFhnVlpghUfu3K+FlERl+NvHtP
v5QJ5/OPec+ZQwdYEgguGu7wFUdr/UYWQWsciIrHPWo3Vsj6CoH4ht/vb86AFoFI
rx/gEJVqMBgt2V+fozaUOyf3vqE7+N30rATArLIKHgOMPy1ZQuYWEXrzf9WqJr0w
GSSCe9gaueF2ShZK1+BKzq8nKkyTbLbW3lHc6IHwG5rUGAi2Cy5oHjPHYQDUFhXg
ljf/68rztixl/vMpwoSIS+ZIsPf8DgyMfz3L8tla9eyFw5B59rFg1Wyy2Z6mhPZ7
7PDCoOTcVE4Z3edj8hZ7ZvByi0v1xPZFoFcdXuOt84dN8ed1f004JMy7+joCTPz4
iyeKHEAsIGddVIXBiBMJDtkQM+sU183Y5txY0gpsWNodl2fcGjuNo+/k6ai6uQ/e
Xfe0jvuwMSIrsdjKj6DWUpTAbmZz+8lXrgPKJJNQUZ1q6/9IJGkEP9z8DNe/r4C6
SmRwcEUlyNnDrbC0nS/t
=RivJ
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--
