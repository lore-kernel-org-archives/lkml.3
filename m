Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaIZLpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:45:40 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57951 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaIZLpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:45:38 -0400
Date: Fri, 26 Sep 2014 13:45:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <cyndis@kapsi.fi>
Cc: edubezval@gmail.com, swarren@wwwdotorg.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, juha-matti.tilli@iki.fi,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v6 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
Message-ID: <20140926114533.GN31106@ulmo>
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
 <1411724593-4037-5-git-send-email-cyndis@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ7Ovc9/RBrrr0/1"
Content-Disposition: inline
In-Reply-To: <1411724593-4037-5-git-send-email-cyndis@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQ7Ovc9/RBrrr0/1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 12:43:13PM +0300, Mikko Perttunen wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
>=20
> This adds support for the Tegra SOCTHERM thermal sensing and management
> system found in the Tegra124 system-on-chip. This initial driver supports
> temperature polling for four thermal zones.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> v6: fixed sparse warning for wrong order of "__iomem *"

Sorry for jumping in so late. This looks generally good, but I have a
couple of comments of a stylistic nature. I haven't closely followed
earlier rounds of the series, so please let me know if I'm bringing up
issues that have already been discussed.

> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soc=
therm.c
[...]
> @@ -0,0 +1,471 @@
> +/*
> + * drivers/thermal/tegra_soctherm.c

This line is not really necessary and likely to become stale if files
are moved around.

> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +#include <linux/thermal.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/bitops.h>
> +#include <soc/tegra/fuse.h>

These should be sorted alphabetically and I prefer separating them into
sections, so that the last of the linux/* includes is separated from the
soc/* includes by a blank line.

> +
> +#define SENSOR_CONFIG0				0
> +#define		SENSOR_CONFIG0_STOP		BIT(0)
> +#define		SENSOR_CONFIG0_TALL_SHIFT	8
> +#define		SENSOR_CONFIG0_TCALC_OVER	BIT(4)
> +#define		SENSOR_CONFIG0_OVER		BIT(3)
> +#define		SENSOR_CONFIG0_CPTR_OVER	BIT(2)
> +#define SENSOR_CONFIG1				4
> +#define		SENSOR_CONFIG1_TSAMPLE_SHIFT	0
> +#define		SENSOR_CONFIG1_TIDDQ_EN_SHIFT	15
> +#define		SENSOR_CONFIG1_TEN_COUNT_SHIFT	24
> +#define		SENSOR_CONFIG1_TEMP_ENABLE	BIT(31)
> +#define SENSOR_CONFIG2				8
> +#define		SENSOR_CONFIG2_THERMA_SHIFT	16
> +#define		SENSOR_CONFIG2_THERMB_SHIFT	0
> +
> +#define SENSOR_PDIV				0x1c0
> +#define		SENSOR_PDIV_T124		0x8888
> +#define SENSOR_HOTSPOT_OFF			0x1c4
> +#define		SENSOR_HOTSPOT_OFF_T124		0x00060600
> +#define SENSOR_TEMP1				0x1c8
> +#define SENSOR_TEMP2				0x1cc
> +
> +#define SENSOR_TEMP_MASK			0xffff
> +#define READBACK_VALUE_MASK			0xff00
> +#define READBACK_VALUE_SHIFT			8
> +#define READBACK_ADD_HALF			BIT(7)
> +#define READBACK_NEGATE				BIT(1)

These don't seem to be aligned in the same way as the field definitions
for the other registers. Was that on purpose? I also think using two
tabs to indent field definitions is somewhat excessive. Another common
pattern I've seen used is:

	#define REGISTER_1_NAME 0x000
	#define  REGISTER_1_FIELD_MASK (0xf << 4)

	#define REGISTER_2_NAME 0x004
	#define  REGISTER_2_FIELD_MASK (0xf << 8)

> +#define FUSE_TSENSOR8_CALIB			0x180
> +#define FUSE_SPARE_REALIGNMENT_REG_0		0x1fc
> +
> +#define FUSE_TSENSOR_CALIB_CP_TS_BASE_MASK	0x1fff
> +#define FUSE_TSENSOR_CALIB_FT_TS_BASE_MASK	(0x1fff << 13)
> +#define FUSE_TSENSOR_CALIB_FT_TS_BASE_SHIFT	13
> +
> +#define FUSE_TSENSOR8_CALIB_CP_TS_BASE_MASK	0x3ff
> +#define FUSE_TSENSOR8_CALIB_FT_TS_BASE_MASK	(0x7ff << 10)
> +#define FUSE_TSENSOR8_CALIB_FT_TS_BASE_SHIFT	10
> +
> +#define FUSE_SPARE_REALIGNMENT_REG_SHIFT_CP_MASK 0x3f
> +#define FUSE_SPARE_REALIGNMENT_REG_SHIFT_FT_MASK (0x1f << 21)
> +#define FUSE_SPARE_REALIGNMENT_REG_SHIFT_FT_SHIFT 21

These are also inconsistent with the above register definitions.

> +
> +#define NOMINAL_CALIB_FT_T124			105
> +#define NOMINAL_CALIB_CP_T124			25

What do FT and CP stand for? Given the _T124 suffix they would seem
likely to change on future SoC generations. Perhaps they should be moved
into a struct tegra_soctherm_soc or similar? The array of t124_tsensors
would be another candidate to put into such a structure.

That's something that could be deferred until support is added for a
next generation.

> +struct tegra_tsensor_configuration {
> +	u32 tall, tsample, tiddq_en, ten_count;
> +	u32 pdiv, tsample_ate, pdiv_ate;

What's the significance of the "ate" suffix?

> +};
> +
> +struct tegra_tsensor {
> +	u32 base;
> +	u32 calib_fuse_offset;
> +	/* Correction values used to modify values read from calibration fuses =
*/
> +	s32 fuse_corr_alpha, fuse_corr_beta;
> +};

Both this structure and the one above use inconsistent grouping of
fields (or at least I can't make out any grouping). Perhaps it would be
more consistent to use one line per field, or group all fields of a data
type in a single line?

> +struct tegra_thermctl_zone {
> +	void __iomem *temp_reg;
> +	int temp_shift;

Should this be unsigned? Also this is a thermal zone, so the temp_
prefix doesn't add any context.

> +static int calculate_shared_calibration(struct tsensor_shared_calibratio=
n *r)
> +{
> +	u32 val;
> +	u32 shifted_cp, shifted_ft;

The above two lines could be collapsed into one.

> +static int calculate_tsensor_calibration(
> +	const struct tegra_tsensor *sensor,
> +	struct tsensor_shared_calibration shared,
> +	u32 *calib
> +)

I think a more idiomatic way to write this would be:

static int
calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
			      struct tsensor_shared_calibration shared,
			      u32 *calib)

While at it, perhaps make shared a const * instead of passing it in by
value?

> +{
> +	u32 val;
> +	s32 actual_tsensor_ft, actual_tsensor_cp;
> +	s32 delta_sens, delta_temp;
> +	s32 mult, div;
> +	s16 therma, thermb;
> +	int err;
> +
> +	err =3D tegra_fuse_readl(sensor->calib_fuse_offset, &val);
> +	if (err)
> +		return err;
> +
> +	actual_tsensor_cp =3D (shared.base_cp * 64) + sign_extend32(val, 12);
> +	val =3D (val & FUSE_TSENSOR_CALIB_FT_TS_BASE_MASK)
> +		>> FUSE_TSENSOR_CALIB_FT_TS_BASE_SHIFT;

I personally prefer the operator at the end of the previous line, but I
guess that's mostly a matter of taste, so I'll leave it up to Eduardo.

> +	actual_tsensor_ft =3D (shared.base_ft * 32) + sign_extend32(val, 12);
> +
> +	delta_sens =3D actual_tsensor_ft - actual_tsensor_cp;
> +	delta_temp =3D shared.actual_temp_ft - shared.actual_temp_cp;
> +
> +	mult =3D t124_tsensor_config.pdiv * t124_tsensor_config.tsample_ate;
> +	div =3D t124_tsensor_config.tsample * t124_tsensor_config.pdiv_ate;

t124_tsensor_config is a pretty long name and repeated fairly often.
It's also one of those things that will likely change in future
generations (judging by the t124_ prefix), so perhaps it should be
stored as a const * somewhere. Perhaps in struct tegra_tsensor, so the
above becomes:

	mult =3D sensor->config->pdiv * sensor->config->tsample_ate;

> +
> +	therma =3D div64_s64_precise((s64) delta_temp * (1LL << 13) * mult,
> +		(s64) delta_sens * div);

There should be no space between the (s64) and the variable in the above
(and below, well, everywhere really). Also I find this difficult to read
because the second line is strangely indented. Can you align it with the
function arguments on the first line, please?

> +	thermb =3D div64_s64_precise(
> +		((s64) actual_tsensor_ft * shared.actual_temp_cp) -
> +		((s64) actual_tsensor_cp * shared.actual_temp_ft),
> +		(s64) delta_sens);

The way you need to wrap this indicates that you should either make
variable names shorter or split this computation up into several steps.

> +
> +	therma =3D div64_s64_precise((s64) therma * sensor->fuse_corr_alpha,
> +		(s64) 1000000LL);
> +	thermb =3D div64_s64_precise((s64) thermb * sensor->fuse_corr_alpha +
> +		sensor->fuse_corr_beta,
> +		(s64) 1000000LL);
> +
> +	*calib =3D ((u16)(therma) << SENSOR_CONFIG2_THERMA_SHIFT) |

Why the parentheses around "therma"?

> +		((u16)thermb << SENSOR_CONFIG2_THERMB_SHIFT);
> +
> +	return 0;
> +}
> +
> +static int enable_tsensor(struct tegra_soctherm *tegra,
> +			  const struct tegra_tsensor *sensor,
> +			  struct tsensor_shared_calibration shared)

Again, shouldn't you pass in "shared" by reference?

> +{
> +	void __iomem *base =3D tegra->regs + sensor->base;
> +	unsigned int val;
> +	u32 calib;
> +	int err;
> +
> +	err =3D calculate_tsensor_calibration(sensor, shared, &calib);
> +	if (err)
> +		return err;
> +
> +	val =3D 0;

There's no need for this, if you...

> +	val |=3D t124_tsensor_config.tall << SENSOR_CONFIG0_TALL_SHIFT;

=2E.. make this "val =3D ...;"

> +	writel(val, base + SENSOR_CONFIG0);
> +
> +	val =3D 0;

Same here.

> +	val |=3D (t124_tsensor_config.tsample - 1) <<
> +		SENSOR_CONFIG1_TSAMPLE_SHIFT;

Now the << operator is at the end of the line, so I think whichever way
you decide it should at least be consistent.

> +/* Translate from soctherm readback format to millicelsius.

Block comments should have the first line empty, like so:

	/*
	 * bla...
	 */

> + * The soctherm readback format in bits is as follows:
> + *   TTTTTTTT H______N
> + * where T's contain the temperature in Celsius,
> + * H denotes an addition of 0.5 Celsius and N denotes negation
> + * of the final value.
> + */
> +static inline long translate_temp(u16 val)

I think it can be left to the compiler to decide whether or not to
inline this particular function.

> +static const int thermctl_temp_offsets[] =3D {
> +	SENSOR_TEMP1, SENSOR_TEMP2, SENSOR_TEMP1, SENSOR_TEMP2
> +};
> +
> +static const int thermctl_temp_shifts[] =3D {
> +	16, 16, 0, 0
> +};

Perhaps these should be in a single array that describes the individual
zones. Something like:

	struct thermctl_zone_desc {
		unsigned int offset;
		unsigned int shift;
	};

	static const struct thermctl_zone_desc zones[] =3D {
		{ SENSOR_TEMP1, 16 },
		...
	};

And perhaps this array should have a t124_ prefix since it could vary
per SoC generation?

> +static int tegra_soctherm_probe(struct platform_device *pdev)
> +{
> +	struct tegra_soctherm *tegra;
> +	struct thermal_zone_device *tz;
> +	struct tsensor_shared_calibration shared_calib;
> +	int i;

Should be unsigned.

> +	int err =3D 0;

I don't think this needs to be initialized.

> +
> +	const struct tegra_tsensor *tsensors =3D t124_tsensors;
> +
> +	tegra =3D devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
> +	if (!tegra)
> +		return -ENOMEM;
> +
> +	tegra->regs =3D devm_ioremap_resource(&pdev->dev,
> +		platform_get_resource(pdev, IORESOURCE_MEM, 0));

Can this please be two separate statements for better readability?

> +	if (IS_ERR(tegra->regs)) {
> +		dev_err(&pdev->dev, "can't get registers");

No need for the message. devm_ioremap_resource() prints one for you on
error.

> +		return PTR_ERR(tegra->regs);
> +	}
> +
> +	tegra->reset =3D devm_reset_control_get(&pdev->dev, "soctherm");
> +	if (IS_ERR(tegra->reset)) {
> +		dev_err(&pdev->dev, "can't get soctherm reset\n");
> +		return PTR_ERR(tegra->reset);
> +	}
> +
> +	tegra->clock_tsensor =3D devm_clk_get(&pdev->dev, "tsensor");
> +	if (IS_ERR(tegra->clock_tsensor)) {
> +		dev_err(&pdev->dev, "can't get clock tsensor\n");

Nit: the wording of this is inconsistent with the reset error.

> +		return PTR_ERR(tegra->clock_tsensor);
> +	}
> +
> +	tegra->clock_soctherm =3D devm_clk_get(&pdev->dev, "soctherm");
> +	if (IS_ERR(tegra->clock_soctherm)) {
> +		dev_err(&pdev->dev, "can't get clock soctherm\n");

Same here.

> +		return PTR_ERR(tegra->clock_soctherm);
> +	}
> +
> +	reset_control_assert(tegra->reset);
> +
> +	err =3D clk_prepare_enable(tegra->clock_soctherm);
> +	if (err) {
> +		reset_control_deassert(tegra->reset);

Is it really useful to deassert in case of failure? After the assertion
of the reset above, all hardware state will be gone and since the device
won't be used, nobody will reinitialize it properly. Taking it out of
reset is useless.

> +	/* Initialize raw sensors */
> +
> +	err =3D calculate_shared_calibration(&shared_calib);
> +	if (err)
> +		goto disable_clocks;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(t124_tsensors); ++i) {
> +		err =3D enable_tsensor(tegra, tsensors + i, shared_calib);
> +		if (err)
> +			goto disable_clocks;
> +	}
> +
> +	writel(SENSOR_PDIV_T124, tegra->regs + SENSOR_PDIV);
> +	writel(SENSOR_HOTSPOT_OFF_T124, tegra->regs + SENSOR_HOTSPOT_OFF);
> +
> +	/* Initialize thermctl sensors */
> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra->thermctl_tzs); ++i) {
> +		struct tegra_thermctl_zone *zone =3D
> +			devm_kzalloc(&pdev->dev, sizeof(*zone), GFP_KERNEL);
> +		if (!zone) {
> +			err =3D -ENOMEM;
> +			--i;

What's up with the i line here? Doesn't that trigger a compiler warning?

Oh wait, that's whitespace highlighting screwing with the --i. One more
reason to prefer i-- where passible. Also I think the more idiomatic way
for this kind of cleanup is to not touch i here, but to do this with a

	while (i--)

later on. See below.

> +			goto unregister_tzs;
> +		}
> +
> +		zone->temp_reg =3D tegra->regs + thermctl_temp_offsets[i];
> +		zone->temp_shift =3D thermctl_temp_shifts[i];
> +
> +		tz =3D thermal_zone_of_sensor_register(
> +			&pdev->dev, i, zone, tegra_thermctl_get_temp, NULL);

This is weirdly wrapped. Better would be:

> +		tz =3D thermal_zone_of_sensor_register(&pdev->dev, i, zone,
> +						     tegra_thermctl_get_temp,
> +						     NULL);

> +unregister_tzs:
> +	for (; i >=3D 0; i--)
> +		thermal_zone_of_sensor_unregister(&pdev->dev,
> +						  tegra->thermctl_tzs[i]);

Like I said above, I think the more idiomatic way would be:

	while (i--)
		thermal_zone_of_sensor_unregister(...);

> +static int tegra_soctherm_remove(struct platform_device *pdev)
> +{
> +	struct tegra_soctherm *tegra =3D platform_get_drvdata(pdev);
> +	int i;

unsigned again.

> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra->thermctl_tzs); ++i) {
> +		thermal_zone_of_sensor_unregister(&pdev->dev,
> +						  tegra->thermctl_tzs[i]);
> +	}
> +
> +	clk_disable_unprepare(tegra->clock_tsensor);
> +	clk_disable_unprepare(tegra->clock_soctherm);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver tegra_soctherm_driver =3D {
> +	.probe =3D tegra_soctherm_probe,
> +	.remove =3D tegra_soctherm_remove,
> +	.driver =3D {
> +		.name =3D "tegra_soctherm",

I think we're primarily using tegra- as prefix for driver names.

> +		.of_match_table =3D tegra_soctherm_of_match,
> +	},
> +};
> +module_platform_driver(tegra_soctherm_driver);
> +
> +MODULE_AUTHOR("Mikko Perttunen <mperttunen@nvidia.com>");
> +MODULE_DESCRIPTION("Tegra SOCTHERM thermal management driver");

Perhaps: "NVIDIA Tegra ..."?

Thierry

--rQ7Ovc9/RBrrr0/1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJVHdAAoJEN0jrNd/PrOhsUIP/iajozwoT78X9GBIZV/paq7Q
2QkETUPFITKc3q9bWOk9CDWY9Z9Yg/eeFXtOI8In9QQe17/kVVa1pRygzf49GOzp
EflP5HpznCi5LjjkV5DP4GRAQpepWX6U8afkVKwnd0fQmQ5xZHMCPqLMt0+FOxUt
EvX2h5TBEiF/kEqDF2ZgtMvz20Pu75BjElFuOUs3r854K0tgAWOA0lPhjAZxKD0d
PqcpETefrCGvta2r3tL8lolCR+fdhegrq05jRteZoBt2h6onPUH8QRUXBnMug0VY
f0ltWOYfHcPpSm4g8crkrYGQQCp3do3qCLrZm1/3ChIzph0IcVDvwaisLkunyRgP
uI6rZKR6ElgWLciHS/g3pOf3RL7nvpkcxg6QFdDdtqSwYMq4LTO3aI6K6Bh+Twz8
MOHrCA8/bpbkja/ANlVJnM6skyOmJrLC/We9dYdyKP12cCkI5XPJzgGaUYNzlc/f
eUaEYnhK3sLDZMbE10XF9ycewYZzdAN2xb9L5/dLxGQIVCLX1MxBbV7B3E/b3oIl
zVKlUnz0uLKdhHVETP2dfaLPGMluc8bfQAVwurzWRNAP7/1/RHULOnEnRJJ2DyoO
STjdt4H2XzyHUvIj/RwSB+Izln2bIZbojeAXC2nNf5DR7Ejg2/3Q86PFHyauXQUL
fVyPNTBoPXOjf8KuPXkZ
=PqwI
-----END PGP SIGNATURE-----

--rQ7Ovc9/RBrrr0/1--
