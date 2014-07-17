Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaGQHkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:40:12 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64088 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaGQHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:40:08 -0400
Date: Thu, 17 Jul 2014 09:39:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v4 1/8] of: Add NVIDIA Tegra SATA controller binding
Message-ID: <20140717073956.GA18640@ulmo>
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com>
 <1405510814-31928-1-git-send-email-mperttunen@nvidia.com>
 <53C666E5.6030009@redhat.com>
 <20140716131306.GB23384@ulmo>
 <53C6908A.2050200@redhat.com>
 <20140716195136.GB5212@mithrandir>
 <53C77263.7050903@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <53C77263.7050903@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 08:51:15AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 07/16/2014 09:51 PM, Thierry Reding wrote:
> > On Wed, Jul 16, 2014 at 04:47:38PM +0200, Hans de Goede wrote:
> >> Hi,
> >>
> >> On 07/16/2014 03:13 PM, Thierry Reding wrote:
> >>> On Wed, Jul 16, 2014 at 01:49:57PM +0200, Hans de Goede wrote:
> >>>> Hi,
> >>>>
> >>>> On 07/16/2014 01:40 PM, Mikko Perttunen wrote:
> >>>>> This patch adds device tree binding documentation for the SATA
> >>>>> controller found on NVIDIA Tegra SoCs.
> >>>>>
> >>>>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> >>>>> ---
> >>>>> v4: clarify mandatory clock order
> >>>>
> >>>> Thanks this and the new v4 of "ata: Add support for the Tegra124 SAT=
A controller"
> >>>> both look good to me. So these 2 + v3 for the rest of the series are:
> >>>>
> >>>> Acked-by: Hans de Goede <hdegoede@redhat.com>
> >>>
> >>> Like I said in my reply to PATCH v3 7/8, I think this mandatory clock
> >>> order is a mistake.
> >>
> >> We've plenty of other dt bindings where things need to be specified in
> >> a certain order, e.g. registers. So I don't really see what the problem
> >> is here.
> >=20
> > Like I said, the clock-names exists so that drivers can request a clock
> > by name. Therefore the order in which they are listed doesn't matter.
> > The only thing that matters is that the entries in clocks and
> > clock-names match up.
>=20
> Ok so I've been think about this, and about the unbalance I've noticed
> between tegra_ahci_power_on which does everything DIY and tegra_ahci_powe=
r_off
> which uses ahci_platform_disable_resources() in v3 and later.
>=20
> Really only the "sata" clock needs special handling, so I think the follo=
wing
> solution is best:
>=20
> 1) Drop the clock ordering requirement and the clk enum
>=20
> 2) Make ahci_tegra.c do a devm_clk_get(dev, "sata"), so that it gets its
> own handle to the sata-clk (store this in tegra_ahci_priv). no need to
> get all the other clks which need no special handling
>=20
> 3) Start using ahci_platform_enable_resources() in tegra_ahci_power_on,
> so it would look something like this:
>=20
> static int tegra_ahci_power_on(struct ahci_host_priv *hpriv)
> {
> 	struct tegra_ahci_priv *tegra =3D hpriv->plat_data;
> 	int ret;
>=20
> 	ret =3D regulator_bulk_enable(ARRAY_SIZE(tegra->supplies),
> 				    tegra->supplies);
> 	if (ret)
> 		return ret;
>=20
> 	ret =3D tegra_powergate_sequence_power_up(TEGRA_POWERGATE_SATA,
> 						tegra->sata_clk,
> 						tegra->sata_rst);
> 	if (ret)
> 		goto disable_regulators;
>=20
> 	reset_control_deassert(tegra->sata_cold_rst);
> 	reset_control_deassert(tegra->sata_oob_rst);
>=20
> 	ret =3D ahci_platform_enable_resources(hpriv);
> 	if (ret)
> 		goto powergate_sequence_power_off;
>=20
> 	return 0;
> ...
>=20
> This will make tegra_ahci_power_on and tegra_ahci_power_off symmetrical
> which is something I always like to see in functions like this.
>=20
> I realize that this changes the reset-deassert vs clock enabling ordering,
> if this is an issue please add reset support to libahci-platform.c I beli=
eve
> that is something which we will need to do soonish anyways (reset control=
lers
> are popping up everywhere in newer SoCs).

I think we could safely move the reset deassert after the call to
ahci_platform_enable_resources().

> This will nicely reduce the amount of code and also greatly simplify the =
error
> return path of tegra_ahci_power_on.

Agreed, htat sounds like it could work.

> This means that the sata_clk will get enabled twice, but that is harmless
> as long as we disable it twice too. This means that we need to add an
> extra disable to tegra_ahci_power_off because tegra_powergate_power_off
> seems to not do this (unlike power-on, which is rather unsymmetrical
> it would be nice to fix this).

We've never had a need for it because the exact power down sequence
isn't nearly as important. But I guess we could add a new function
tegra_powergate_sequence_power_down() that takes care of disabling the
clock and asserting the reset.

One other thing that I've been thinking about is whether it would make
sense to make the ahci_platform library use a list of clock names that
it should request. This would better mirror the clock bindings
convention and allow drivers (such as the Tegra one) to take ownership
of clocks that need special handling while at the same time leaving it
to the helpers to do the bulk of the work.

One way I can think of to handle this would be by adding a struct
ahci_platform_resources * parameter to ahci_platform_get_resources(),
sowewhat like this:

	struct ahci_platform_resources {
		const char *const *clocks;
		unsigned int num_clocks;

		const char *const *resets;
		unsigned int num_resets;
	};

	struct ahci_host_priv *ahci_platform_get_resources(struct platform_device =
*pdev,
							   const struct ahci_platform_resources *res)
	{
		...

		for (i =3D 0; i < res->num_clocks; i++) {
			clk =3D clk_get(&pdev->dev, res->clocks[i]);
			...
		}

		...

		for (i =3D 0; i < res->num_resets; i++) {
			rst =3D reset_control_get(&pdev->dev, res->resets[i]);
			...
		}

		...
	}

And I guess the same could be done for regulators (and even phys). The
Tegra driver for instance could then do this:

	static const char *const tegra_ahci_clocks[] =3D {
		"sata-oob", "cml1", pll_e",
	};

	static const char *const tegra_ahci_resets[] =3D {
		"sata-oob", "sata-cold",
	};

	static const struct ahci_platform_resources tegra_ahci_resources =3D {
		.num_clocks =3D ARRAY_SIZE(tegra_ahci_clocks),
		.clocks =3D tegra_ahci_clocks,
		.num_resets =3D ARRAY_SIZE(tegra_ahci_resets),
		.resets =3D tegra_ahci_resets,
	};

	...

	struct tegra_ahci {
		struct ahci_host_priv *host;
		struct reset_control *rst;
		struct clk *clk;
		...
	};

	...

	static int tegra_ahci_probe(struct platform_device *pdev)
	{
		struct tegra_ahci *ahci;

		...

		ahci =3D devm_kzalloc(&pdev->dev, sizeof(*ahci), GFP_KERNEL);
		if (!ahci)
			return -ENOMEM;

		ahci->host =3D ahci_platform_get_resources(pdev, &tegra_ahci_resources);
		if (IS_ERR(ahci->host)) {
			...
		}

		...

		platform_set_drvdata(pdev, ahci);
	}

Does that sound reasonable?

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx33MAAoJEN0jrNd/PrOhBTYP/RZPj1/fgwraIuvG9mlNH2hG
FRBixAOOWX2WzAYWLsKh73hJGlCG5HlkzH/MZCWei/FRyunTIi62kUn7ZstIE+Jw
lV/ik2xESWxvYAFSAgUQcCycMTlAH/7VM9yAzr+OEohRsPKzqVaiP+7pkR1f1u7w
1M3YjxjLMnIISYMP66mBYpozTFIv5iBPRlS4u2OQEuZM9Kd00M/xx3hlbT+Lql4A
FY0J/OkWu4F7j41Aw1LaVnBV/BzP2Yte54g4jnMRlj3mdpMhdehZE7b5tdFKkSs1
pQCW1aV7dmXBpEowaL3rV/QlleGP7PYvh4jgv6/ulJvc6t862A0FPRiKz0Z6ZtAT
sJSuOCnbxQKj0EwMqV5QlV9ABa7NHor/5dYbjvQDjFhhFxwfYbJZvnCK3Th9A9EB
4dHk75lv0UAd9tJx/Hng+t+9BI1XzzIc6tlqfV1aCQrQCqYXj/ORu+WEeuWgy5rt
7N389Z54Qva5z1t4vUCDNzrEaPl1OTf5FLk/xJ9kb5F2vcMB9PoSuCZ48de7tOi3
qL/we1byCdJrudh0QwyY24vkIZDQ1m4Ve/V06h91PuOjyrpzBJT0o8xaQwB2Xh0K
1NI9t7lJ4JcI6Padt+esCaoOGlnxx8HQPLPYWO/OZi+hojUjY7T8uyT4m0lgUN1f
cwfyFkl06k1Nv+hE600s
=DSw9
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
