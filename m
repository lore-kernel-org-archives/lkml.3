Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaKLOoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:44:16 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51386 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKLOoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:44:14 -0500
Date: Wed, 12 Nov 2014 15:44:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/13] memory: tegra: Add API needed by the EMC driver
Message-ID: <20141112144409.GC26488@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-10-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1415779051-26410-10-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 08:56:32AM +0100, Tomeu Vizoso wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
>=20
> The EMC driver needs to know the number of external memory devices and al=
so
> needs to update the EMEM configuration based on the new rate of the memor=
y bus.
>=20
> To know how to update the EMEM config, looks up the values of the burst r=
egs in
> the DT, for a given timing.

This looks somewhat wide. Typically commit messages should wrap after
column 72.

> diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
[...]
> index 286b9c5..9d8585a 100644
> --- a/drivers/memory/tegra/mc.c
> +++ b/drivers/memory/tegra/mc.c
> @@ -13,6 +13,9 @@
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> +#include <linux/sort.h>
> +
> +#include <soc/tegra/fuse.h>
> =20
>  #include "mc.h"
> =20
> @@ -48,6 +51,9 @@
>  #define  MC_EMEM_ARB_CFG_CYCLES_PER_UPDATE_MASK	0x1ff
>  #define MC_EMEM_ARB_MISC0 0xd8
> =20
> +#define MC_EMEM_ADR_CFG 0x54
> +#define MC_EMEM_ADR_CFG_EMEM_NUMDEV BIT(0)
> +
>  static const struct of_device_id tegra_mc_of_match[] =3D {
>  #ifdef CONFIG_ARCH_TEGRA_3x_SOC
>  	{ .compatible =3D "nvidia,tegra30-mc", .data =3D &tegra30_mc_soc },
> @@ -93,6 +99,124 @@ static int tegra_mc_setup_latency_allowance(struct te=
gra_mc *mc)
>  	return 0;
>  }
> =20
> +void tegra_mc_write_emem_configuration(struct tegra_mc *mc, unsigned lon=
g rate)
> +{
> +	int i;

num_timings is unsigned, so this variable should be as well.

> +	struct tegra_mc_timing timing;
> +
> +	for (i =3D 0; i < mc->num_timings; ++i) {

There's no reason for the prefix increment here, postfix would be more
idiomatic I think.

> +		timing =3D mc->timings[i];
> +
> +		if (timing.rate =3D=3D rate)
> +			break;
> +	}
> +
> +	if (i =3D=3D mc->num_timings) {

Perhaps turn this into something like this for better readability:

	struct tegra_mc_timing *timing =3D NULL;

	for (i =3D 0; i < mc->num_timings; i++) {
		if (mc->timings[i].rate =3D=3D rate) {
			timing =3D &mc->timings[i];
			break;
		}
	}

	if (!timing) {

> +		dev_err(mc->dev, "no memory timing registered for rate %lu\n", rate);
> +		return;
> +	}
> +
> +	for (i =3D 0; i < mc->soc->num_emem_regs; ++i)
> +		mc_writel(mc, timing.emem_data[i], mc->soc->emem_regs[i]);
> +}
> +
> +int tegra_mc_get_emem_device_count(struct tegra_mc *mc)
> +{
> +	u8 dram_count;
> +
> +	dram_count =3D mc_readl(mc, MC_EMEM_ADR_CFG);
> +	dram_count &=3D MC_EMEM_ADR_CFG_EMEM_NUMDEV;
> +	dram_count++;
> +
> +	return dram_count;
> +}

Please either make this return unsigned int. signed int would indicate
that the return value needs to be checked.

> +
> +

There's an extra blank line here.

> +static int load_one_timing_from_dt(struct tegra_mc *mc,
> +				   struct tegra_mc_timing *timing,
> +				   struct device_node *node)
> +{
> +	int err;
> +	u32 tmp;
> +
> +	err =3D of_property_read_u32(node, "clock-frequency", &tmp);
> +	if (err) {
> +		dev_err(mc->dev,
> +			"timing %s: failed to read rate\n", node->name);
> +		return err;
> +	}
> +
> +	timing->rate =3D tmp;
> +	timing->emem_data =3D devm_kzalloc(mc->dev, sizeof(u32) * mc->soc->num_=
emem_regs, GFP_KERNEL);

devm_kcalloc() perhaps? And wrap it to fit within 78 columns.

> +	if (!timing->emem_data)
> +		return -ENOMEM;
> +
> +	err =3D of_property_read_u32_array(node, "nvidia,emem-configuration",
> +					 timing->emem_data,
> +					 mc->soc->num_emem_regs);
> +	if (err) {
> +		dev_err(mc->dev,
> +			"timing %s: failed to read emc burst data\n",

s/emc/EMC/

> +			node->name);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int load_timings_from_dt(struct tegra_mc *mc,
> +				struct device_node *node)

No need to wrap this, it fits on one line.

> +{
> +	struct device_node *child;
> +	int child_count =3D of_get_child_count(node);
> +	int i =3D 0, err;
> +
> +	mc->timings =3D devm_kzalloc(mc->dev,
> +				      sizeof(struct tegra_mc_timing) * child_count,
> +				      GFP_KERNEL);

devm_kcalloc(), and alignment looks wrong here.

> +	if (!mc->timings)
> +		return -ENOMEM;
> +
> +	mc->num_timings =3D child_count;
> +
> +	for_each_child_of_node(node, child) {
> +		struct tegra_mc_timing *timing =3D mc->timings + i++;

Perhaps move the declaration of timing one level up, then you can use
sizeof(*timing) in the call to devm_k{z,c}alloc().

And maybe write this as: timing =3D &mc->timings[i++];, that's more
consistent with the other parts of the driver.

> +
> +		err =3D load_one_timing_from_dt(mc, timing, child);

Perhaps leave away the "_from_dt" suffix, there's no alternative to load
this data from, right?

> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tegra_mc_setup_timings(struct tegra_mc *mc)
> +{
> +	struct device_node *node;
> +	u32 ram_code, node_ram_code;
> +	int err;
> +
> +	ram_code =3D tegra_read_ram_code();
> +
> +	mc->num_timings =3D 0;
> +
> +	for_each_child_of_node(mc->dev->of_node, node) {
> +		err =3D of_property_read_u32(node, "nvidia,ram-code", &node_ram_code);
> +		if (err || (node_ram_code !=3D ram_code))
> +			continue;
> +
> +		err =3D load_timings_from_dt(mc, node);
> +		if (err)
> +			return err;
> +		break;
> +	}
> +
> +	if (mc->num_timings =3D=3D 0)
> +		dev_warn(mc->dev, "no memory timings for ram code %u registered\n", ra=
m_code);

s/ram/RAM/

>  static const char *const status_names[32] =3D {
>  	[ 1] =3D "External interrupt",
>  	[ 6] =3D "EMEM address decode error",
> @@ -250,6 +374,12 @@ static int tegra_mc_probe(struct platform_device *pd=
ev)
>  		return err;
>  	}
> =20
> +	err =3D tegra_mc_setup_timings(mc);
> +	if (err < 0) {
> +		dev_err(&pdev->dev, "failed to setup timings: %d\n", err);
> +		return err;
> +	}
> +
>  	if (IS_ENABLED(CONFIG_TEGRA_IOMMU_SMMU)) {
>  		mc->smmu =3D tegra_smmu_probe(&pdev->dev, mc->soc->smmu, mc);
>  		if (IS_ERR(mc->smmu)) {
> diff --git a/drivers/memory/tegra/mc.h b/drivers/memory/tegra/mc.h
> index 8fabe99..4596411 100644
> --- a/drivers/memory/tegra/mc.h
> +++ b/drivers/memory/tegra/mc.h
> @@ -14,6 +14,12 @@
> =20
>  struct page;
> =20
> +struct tegra_mc_timing {
> +	unsigned long rate;
> +
> +	u32 *emem_data;

The emem_ prefix isn't very useful in my opinion.

> +};
> +
>  struct tegra_smmu_enable {
>  	unsigned int reg;
>  	unsigned int bit;
> @@ -67,6 +73,9 @@ struct tegra_mc_soc {
>  	const struct tegra_mc_client *clients;
>  	unsigned int num_clients;
> =20
> +	const unsigned int *emem_regs;

These are offsets to registers, right? I would typically use unsigned
long for that, but that's really just a nitpick.

> +	unsigned int num_emem_regs;
> +
>  	unsigned int num_address_bits;
>  	unsigned int atom_size;
> =20
> @@ -84,6 +93,9 @@ struct tegra_mc {
> =20
>  	const struct tegra_mc_soc *soc;
>  	unsigned long tick;
> +
> +	struct tegra_mc_timing *timings;
> +	unsigned int num_timings;
>  };
> =20
>  static inline u32 mc_readl(struct tegra_mc *mc, unsigned long offset)
> diff --git a/drivers/memory/tegra/tegra124.c b/drivers/memory/tegra/tegra=
124.c
> index ccd19d8..bba8e1c 100644
> --- a/drivers/memory/tegra/tegra124.c
> +++ b/drivers/memory/tegra/tegra124.c
> @@ -15,6 +15,48 @@
> =20
>  #include "mc.h"
> =20
> +#define MC_EMEM_ARB_CFG				0x90
> +#define MC_EMEM_ARB_OUTSTANDING_REQ		0x94
> +#define MC_EMEM_ARB_TIMING_RCD			0x98
> +#define MC_EMEM_ARB_TIMING_RP			0x9c
> +#define MC_EMEM_ARB_TIMING_RC			0xa0
> +#define MC_EMEM_ARB_TIMING_RAS			0xa4
> +#define MC_EMEM_ARB_TIMING_FAW			0xa8
> +#define MC_EMEM_ARB_TIMING_RRD			0xac
> +#define MC_EMEM_ARB_TIMING_RAP2PRE		0xb0
> +#define MC_EMEM_ARB_TIMING_WAP2PRE		0xb4
> +#define MC_EMEM_ARB_TIMING_R2R			0xb8
> +#define MC_EMEM_ARB_TIMING_W2W			0xbc
> +#define MC_EMEM_ARB_TIMING_R2W			0xc0
> +#define MC_EMEM_ARB_TIMING_W2R			0xc4
> +#define MC_EMEM_ARB_DA_TURNS			0xd0
> +#define MC_EMEM_ARB_DA_COVERS			0xd4
> +#define MC_EMEM_ARB_MISC0			0xd8
> +#define MC_EMEM_ARB_MISC1			0xdc
> +#define MC_EMEM_ARB_RING1_THROTTLE		0xe0
> +
> +static int tegra124_mc_emem_regs[] =3D {

static const, please. And the type should match that of
struct tegra_mc_soc's .emem_regs field.

Thierry

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY3I5AAoJEN0jrNd/PrOh00IP/iQTrAEOfB1mP6Q77vSi+mE5
99FZjdirFBP+EwGtprqxJkhZCsu+EZTr9j75LKoR5PAEoNxd1zC59L42chd8PIR2
ujTJfKGegfrewg5A7TDFY/3BaLr3s5di/n8nQv0EFxnyZ9iUtfcCe4QVZKmAj85G
SepqC/xyyDCw+N4JIDGJR3Kcf/g1CC4+yKmUC7A3df30BMgP3UL7wn+a0a4maSc1
5FcnqoZebChI6m/FsoHlChwcx5atjywJ8na0A2Gnk/A4BNql21amOgG9FHlnkWxO
QTOmUKdS5a55uSuUhXbyiZw8uMTMAoF7ItTl6bTrpN1CKoECelDoO4fSAoPRqQfA
EWStbPgSvhVxPVK36VSYiIIO1yHk4Zb9OhDx3ZSrrXF1AioUTwJa2ekY8KbDxsWp
KBdooJp9Iubmqc3EKqTQGt0PB4vwmYr1xXaI+DmMKbVJvSpEWVuR1167R6bFc+RV
2n0+6yEHxtAkG4z0MvLm5WX2ASpa2216nKTSz/mSU480aRQMAVIfZzL2seqbsBx1
ltTfePqfk7W6iGLo2KPh0DFBuS+/E/+0sE/KQf3Jp+60Ow1IHddaecnMJtqGMKTo
caZp4tO+xBun5rK503WQ1IPxzCVUm9ZLtmoiY7cG+4s6L4b5/yIcS0ksPRhgqc+b
Fz9hpwCbnepd4X3WFwlx
=iwC5
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
