Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaLBLPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:15:10 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:38884 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbaLBLPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:15:06 -0500
Date: Tue, 2 Dec 2014 12:15:02 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-pm@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] PM / devfreq: tegra: add devfreq driver for Tegra
 Activity Monitor
Message-ID: <20141202111501.GE6135@ulmo>
References: <1416832111-367-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416832111-367-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Content-Disposition: inline
In-Reply-To: <1416832111-367-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 01:28:17PM +0100, Tomeu Vizoso wrote:
> The ACTMON block can monitor several counters, providing averaging and fi=
ring
> interrupts based on watermarking configuration. This implementation monit=
ors
> the MCALL and MCCPU counters to choose an appropriate frequency for the
> external memory clock.
>=20
> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
> Perttunen <mikko.perttunen@kapsi.fi>.
>=20
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>=20
> ---
>=20
> v2:	* Use devfreq
> ---
>  drivers/devfreq/Kconfig         |  10 +
>  drivers/devfreq/Makefile        |   1 +
>  drivers/devfreq/tegra-devfreq.c | 718 ++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 729 insertions(+)
>  create mode 100644 drivers/devfreq/tegra-devfreq.c
>=20
> diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
> index faf4e70..4aab799 100644
> --- a/drivers/devfreq/Kconfig
> +++ b/drivers/devfreq/Kconfig
> @@ -87,4 +87,14 @@ config ARM_EXYNOS5_BUS_DEVFREQ
>  	  It reads PPMU counters of memory controllers and adjusts the
>  	  operating frequencies and voltages with OPP support.
> =20
> +config ARM_TEGRA_DEVFREQ
> +       tristate "Tegra DEVFREQ Driver"
> +       depends on ARCH_TEGRA_124_SOC

I think ACTMON exists at least on Tegra30 and Tegra114 as well and it
would be surprising if it didn't exist on Tegra132, so perhaps make this
dependency simply ARCH_TEGRA?

> +       select DEVFREQ_GOV_SIMPLE_ONDEMAND
> +       select PM_OPP
> +       help
> +         This adds the DEVFREQ driver for the Tegra family of SoCs.
> +         It reads ACTMON counters of memory controllers and adjusts the
> +         operating frequencies and voltages with OPP support.
> +
>  endif # PM_DEVFREQ
> diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
> index 16138c9..0ea991f 100644
> --- a/drivers/devfreq/Makefile
> +++ b/drivers/devfreq/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+=3D governor_userspa=
ce.o
>  # DEVFREQ Drivers
>  obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+=3D exynos/
>  obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+=3D exynos/
> +obj-$(CONFIG_ARM_TEGRA_DEVFREQ)		+=3D tegra-devfreq.o
> diff --git a/drivers/devfreq/tegra-devfreq.c b/drivers/devfreq/tegra-devf=
req.c
> new file mode 100644
> index 0000000..3479096
> --- /dev/null
> +++ b/drivers/devfreq/tegra-devfreq.c
> @@ -0,0 +1,718 @@
> +/*
> + * A devfreq driver for NVIDIA Tegra SoCs
> + *
> + * Copyright (c) 2014 NVIDIA CORPORATION. All rights reserved.
> + * Copyright (C) 2014 Google, Inc
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License =
for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
[...]
> +/* activity counter is incremented every 256 memory transactions, and ea=
ch

Proper block-comments should be:

	/*
	 * activity counter...
	 * ...
	 */

Also it's a sentence, therefore should start with a capital 'A'.

> + * transaction takes 4 EMC clocks for Tegra124; So the COUNT_WEIGHT is
> + * 4 * 256 =3D 1024.
> + */
> +#define ACTMON_COUNT_WEIGHT					0x400
> +
> +/*
> + * ACTMON_AVERAGE_WINDOW_LOG2: default value for @DEV_CTRL_K_VAL, which
> + * translates to 2 ^ (K_VAL + 1). ex: 2 ^ (6 + 1) =3D 128
> + */
> +#define ACTMON_AVERAGE_WINDOW_LOG2			6
> +#define ACTMON_SAMPLING_PERIOD				12 /* ms */
> +#define ACTMON_DEFAULT_AVG_BAND				6  /* 1/10 of % */
> +
> +#define KHZ							1000
> +
> +/* Assume that the bus is saturated if the utilization is 25% */
> +#define BUS_SATURATION_RATIO					25
[...]
> +static void tegra_actmon_configure_device(struct tegra_devfreq *tegra,
> +					  struct tegra_devfreq_device *dev)
> +{
> +	u32 val;
> +
> +	dev->avg_band_freq =3D tegra->max_freq * ACTMON_DEFAULT_AVG_BAND / KHZ;
> +	dev->target_freq =3D tegra->cur_freq;
> +
> +	dev->avg_count =3D tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
> +	writel(dev->avg_count, dev->regs + ACTMON_DEV_INIT_AVG);
> +
> +	tegra_devfreq_update_avg_wmark(dev);
> +	tegra_devfreq_update_wmark(tegra, dev);
> +
> +	writel(ACTMON_COUNT_WEIGHT, dev->regs + ACTMON_DEV_COUNT_WEIGHT);
> +	writel(ACTMON_INTR_STATUS_CLEAR, dev->regs + ACTMON_DEV_INTR_STATUS);
> +
> +	val =3D 0;

You could initialize this to 0 and then save this one line.

> +	val |=3D ACTMON_DEV_CTRL_ENB_PERIODIC |
> +	       ACTMON_DEV_CTRL_AVG_ABOVE_WMARK_EN |
> +	       ACTMON_DEV_CTRL_AVG_BELOW_WMARK_EN;
> +	val |=3D (ACTMON_AVERAGE_WINDOW_LOG2 - 1)
> +		<< ACTMON_DEV_CTRL_K_VAL_SHIFT;
> +	val |=3D (ACTMON_BELOW_WMARK_WINDOW - 1)
> +		<< ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_NUM_SHIFT;
> +	val |=3D (ACTMON_ABOVE_WMARK_WINDOW - 1)
> +		<< ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_NUM_SHIFT;
> +	val |=3D ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN |
> +	       ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
> +
> +	writel(val, dev->regs + ACTMON_DEV_CTRL);
> +
> +	actmon_write_barrier(tegra);
> +
> +	val =3D readl(dev->regs + ACTMON_DEV_CTRL);
> +	val |=3D ACTMON_DEV_CTRL_ENB;
> +	writel(val, dev->regs + ACTMON_DEV_CTRL);
> +
> +	actmon_write_barrier(tegra);
> +}
> +
> +static int tegra_devfreq_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev;
> +	struct tegra_devfreq *tegra;
> +	struct tegra_devfreq_device *actmon_dev;
> +	unsigned int i;
> +	u32 val;
> +
> +	pdev =3D container_of(dev, struct platform_device, dev);
> +	tegra =3D platform_get_drvdata(pdev);

This is equivalent to just:

	struct tegra_devfreq *tegra =3D dev_get_drvdata(dev);

which you can then simply put at the top of the local variable
declarations.

> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra->devices); i++) {
> +		actmon_dev =3D &tegra->devices[i];
> +
> +		val =3D readl(actmon_dev->regs + ACTMON_DEV_CTRL);
> +		val &=3D ~ACTMON_DEV_CTRL_ENB;
> +		writel(val, actmon_dev->regs + ACTMON_DEV_CTRL);
> +
> +		writel(ACTMON_INTR_STATUS_CLEAR,
> +		       actmon_dev->regs + ACTMON_DEV_INTR_STATUS);

Why do you need to clear pending interrupts on suspend? Isn't this going
to cause pending ones to be missed upon resume?

> +
> +		actmon_write_barrier(tegra);
> +	}
> +
> +	return 0;
> +}
> +
> +static int tegra_devfreq_resume(struct device *dev)
> +{
> +	struct platform_device *pdev;
> +	struct tegra_devfreq *tegra;
> +	struct tegra_devfreq_device *actmon_dev;
> +	unsigned int i;
> +
> +	pdev =3D container_of(dev, struct platform_device, dev);
> +	tegra =3D platform_get_drvdata(pdev);

Same here. And in a few other places as well.

> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra->devices); i++) {
> +		actmon_dev =3D &tegra->devices[i];
> +
> +		tegra_actmon_configure_device(tegra, actmon_dev);
> +	}
> +
> +	return 0;
> +}

You'll want to protect the tegra_devfreq_{suspend,resume}() with an
#ifdef CONFIG_PM_SLEEP to avoid potential build warnings (in randconfig
builds for example).

These are also somewhat oddly placed. Perhaps move them below
tegra_devfreq_remove() for more natural ordering?

> +static int tegra_devfreq_probe(struct platform_device *pdev)
> +{
> +	struct tegra_devfreq *tegra;
> +	struct tegra_devfreq_device *dev;
> +	struct resource *res;
> +	unsigned long max_freq;
> +	unsigned int i;
> +	int irq;
> +	int err;
> +
> +	tegra =3D devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
> +	if (!tegra)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&tegra->lock);
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "Failed to get regs resource\n");
> +		return -ENODEV;
> +	}

No need for this check, devm_ioremap_resource() does it for you.

> +
> +	tegra->regs =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(tegra->regs)) {
> +		dev_err(&pdev->dev, "Failed to get IO memory\n");

No need for the error message either.

> +		return PTR_ERR(tegra->regs);
> +	}
> +
> +	tegra->reset =3D devm_reset_control_get(&pdev->dev, "actmon");
> +	if (IS_ERR(tegra->reset)) {
> +		dev_err(&pdev->dev, "Failed to get reset\n");
> +		return PTR_ERR(tegra->reset);
> +	}
> +
> +	tegra->clock =3D devm_clk_get(&pdev->dev, "actmon");
> +	if (IS_ERR(tegra->clock)) {
> +		dev_err(&pdev->dev, "Failed to get actmon clock\n");
> +		return PTR_ERR(tegra->clock);
> +	}
> +
> +	tegra->emc_clock =3D devm_clk_get(&pdev->dev, "emc");
> +	if (IS_ERR(tegra->emc_clock)) {
> +		dev_err(&pdev->dev, "Failed to get emc clock\n");
> +		return PTR_ERR(tegra->emc_clock);
> +	}
> +
> +	err =3D of_init_opp_table(&pdev->dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to init operating point table\n");
> +		return err;
> +	}
> +
> +	tegra->rate_change_nb.notifier_call =3D tegra_actmon_rate_notify_cb;
> +	err =3D clk_notifier_register(tegra->emc_clock, &tegra->rate_change_nb);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"Failed to register rate change notifier\n");
> +		return err;
> +	}
> +
> +	reset_control_assert(tegra->reset);
> +
> +	err =3D clk_prepare_enable(tegra->clock);
> +	if (err) {
> +		reset_control_deassert(tegra->reset);

I'm not so sure if it makes much sense to deassert reset when the driver
fails to probe.

> +		return err;
> +	}
> +
> +	reset_control_deassert(tegra->reset);
> +
> +	max_freq =3D clk_round_rate(tegra->emc_clock, ULONG_MAX);
> +	tegra->max_freq =3D max_freq / KHZ;
> +
> +	clk_set_rate(tegra->emc_clock, max_freq);
> +
> +	tegra->cur_freq =3D clk_get_rate(tegra->emc_clock) / KHZ;
> +
> +	writel(ACTMON_SAMPLING_PERIOD - 1,
> +	       tegra->regs + ACTMON_GLB_PERIOD_CTRL);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(actmon_device_configs); i++) {
> +		dev =3D tegra->devices + i;
> +		dev->config =3D actmon_device_configs + i;
> +		dev->regs =3D tegra->regs + dev->config->offset;
> +
> +		tegra_actmon_configure_device(tegra, tegra->devices + i);

The second parameter can simply be "dev" here, can't it?

> +	}
> +
> +	err =3D devfreq_add_governor(&tegra_devfreq_governor);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to add governor\n");
> +		return err;
> +	}
> +
> +	tegra_devfreq_profile.initial_freq =3D clk_get_rate(tegra->emc_clock);
> +	tegra->devfreq =3D devm_devfreq_add_device(&pdev->dev,
> +						 &tegra_devfreq_profile,
> +						 "tegra",
> +						 NULL);
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	err =3D devm_request_threaded_irq(&pdev->dev, irq, actmon_isr,
> +					actmon_thread_isr, IRQF_SHARED,
> +					"tegra-devfreq", tegra);
> +	if (err) {
> +		dev_err(&pdev->dev, "Interrupt request failed\n");
> +		return err;
> +	}
> +
> +	platform_set_drvdata(pdev, tegra);
> +
> +	return 0;
> +}
> +
> +static int tegra_devfreq_remove(struct platform_device *pdev)
> +{
> +	struct tegra_devfreq *tegra =3D platform_get_drvdata(pdev);
> +
> +	clk_notifier_unregister(tegra->emc_clock, &tegra->rate_change_nb);
> +
> +	clk_disable_unprepare(tegra->clock);
> +
> +	return 0;
> +}

You'll need to be wary about using devm_request_threaded_irq(). You have
to make sure that the interrupt handler isn't accessing any data that
could be freed via the devres mechanism before the IRQ is freed. Given
that devres frees resources in the opposite order than they were
allocated, and given that you request the interrupt last it /should be/
safe.

Then again you do disable and unprepare the clock, so if you were to
access registers from the interrupt handler (called after clock disable
and before IRQ free) you could possibly cause a hang.

Often the simplest is to just explicitly call devm_free_irq() in your
=2Eremove().

> +static SIMPLE_DEV_PM_OPS(tegra_devfreq_pm_ops,
> +			 tegra_devfreq_suspend,
> +			 tegra_devfreq_resume);
> +
> +static struct of_device_id tegra_devfreq_of_match[] =3D {
> +	{ .compatible =3D "nvidia,tegra124-actmon" },
> +	{ },
> +};
> +
> +static struct platform_driver tegra_devfreq_driver =3D {
> +	.probe	=3D tegra_devfreq_probe,
> +	.remove	=3D tegra_devfreq_remove,
> +	.driver =3D {
> +		.name		=3D "tegra-devfreq",
> +		.owner		=3D THIS_MODULE,

No need for this with module_platform_driver().

> +		.of_match_table =3D tegra_devfreq_of_match,
> +		.pm		=3D &tegra_devfreq_pm_ops,

Also you use tabs and spaces inconsistently here. I'd just get rid of
any attempt to align these and simply use a single space on either side
of the '=3D'.

> +	},
> +};
> +module_platform_driver(tegra_devfreq_driver);
> +
> +MODULE_LICENSE("GPL");

According to the header comment this should be "GPL v2".

> +MODULE_DESCRIPTION("Tegra devfreq driver");
> +MODULE_AUTHOR("Tomeu Vizoso <tomeu.vizoso@collabora.com>");
> +MODULE_DEVICE_TABLE(of, tegra_devfreq_of_match);

I think it's more common to have this immediately below the OF match
table.

Thierry

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfZ81AAoJEN0jrNd/PrOhHCQP/RVroDKTQQHJw1dxjqii37qN
kxasM9rt/J5xnzq2f3PQWXv3fenkmC567FuyDHFD3tV5Zs0FeaWpZLM2f5ElqYMF
3fwNW1hfljrflOcJaahQHsPDoEDRZr4Vn4h6I+gFB3e62dc9Yd8j3E7n6kGBiC28
0dqFUWfnPUBcqwfLHBXoFHe9G3SsGYjLvOxWLB9/9ZznmUDnYzDl4xudD2H0jgTk
0niWyEVa+JKTHx5NVOeAI+opvraFE+BqC4nf2QPBMg9ooiF3Tq3mymQl7cCqqzjJ
InmYyqYYgqT1o92KfHyuV7Mup8akwuPxQ/rhgffrxsl+Kmn13cD0kkkf+Yb/7aUH
c0bFpI+Uhy4P1jwgGfC1n5J+Zdq7Tut5GHk8txdlZPCiLPSeK+osQjxKjo/lf8lV
EMIUxtXB7IVIRSBjZ9Xqr/pCCrU/gQry6DaxuckXoXulOtMeT3jIt700RN0lHpLL
qTtP6u/jZdGsRF4BNUg/7kY/0QCoWXIc9MGNqFrcn+95uiPkb7ILTRhJ2V7Bfn7F
PpB1KdRZvvMEZ1o6qiFUd0FfIXfso9pMwIHpn7XM6y8kakIa0v5mVYHW8koru+Aa
w7JTmtXH/DcrHNJPvuBBFSUKdi2OEvLKY8v2xi90WhoKrOiFJTvmX21FeRZZiCiJ
c6KSZ6XF9Atd6meVCX0l
=I9qC
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--
