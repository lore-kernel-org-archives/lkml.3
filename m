Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbaGWN73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:59:29 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56582 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaGWN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:59:25 -0400
Date: Wed, 23 Jul 2014 15:59:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140723135918.GC14263@ulmo.nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
 <20140723070949.GB15759@ulmo.nvidia.com>
 <53CFAC22.40106@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <53CFAC22.40106@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 03:35:46PM +0300, Tuomas Tynkkynen wrote:
> On 23/07/14 10:09, Thierry Reding wrote:
> > On Mon, Jul 21, 2014 at 06:39:00PM +0300, Tuomas Tynkkynen wrote:
[...]
> >> diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegr=
a124-cpufreq.c
[...]
> >> +	cpu_clk =3D of_clk_get_by_name(cpu_dev->of_node, "cpu_g");
> >> +	if (IS_ERR(cpu_clk))
> >> +		return PTR_ERR(cpu_clk);
[...]
> >> +	pllp_clk =3D of_clk_get_by_name(cpu_dev->of_node, "pll_p");
> >> +	if (IS_ERR(pllp_clk)) {
> >> +		ret =3D PTR_ERR(pllp_clk);
> >> +		goto out_put_pllx_clk;
> >> +	}
> >=20
> > Can the above not be devm_clk_get(cpu_dev, "...") so that you can remove
> > all the clk_put() calls in the cleanup code below?
>=20
> That would allocate the clks under the cpu_dev's devres list, i.e. all the
> clk_puts wouldn't happen when the cpufreq driver goes away, but only when
> cpu_dev itself goes away.

I don't think so. devres_release_all() is called on driver detach as
well.

> > But is there even a reason why we need that? Couldn't we make the
> > driver's .remove() undo what .probe() did so that the driver can be
> > unloaded?
>=20
> I guess that could be done, though to fully undo everything the regulator
> voltage would also need to be saved/restored.

That would certainly be my prefered approach. that way the driver can
simply be unloaded, leaving the CPU in the same state as it was after
boot.

> > Otherwise it probably makes more sense not to use a driver (and dummy
> > device) at all as Viresh already mentioned.
> >=20
>=20
> The dummy platform device is only required for probe deferral, if that
> could be solved in a different way then yes.

I don't think it can. Probe deferral is pretty closely tied to devices
so it's unlikely to ever get implemented for regular initcalls. And in
this case I really think making the driver removable is a good thing.

> >> +};
> >> +
> >> +static const struct of_device_id soc_of_matches[] =3D {
> >> +	{ .compatible =3D "nvidia,tegra124", },
> >> +	{}
> >> +};
> >> +
> >> +static int __init tegra_cpufreq_init(void)
> >> +{
> >> +	int ret;
> >> +	struct platform_device *pdev;
> >> +
> >> +	if (!of_find_matching_node(NULL, soc_of_matches))
> >> +		return -ENODEV;
> >=20
> > I think this could be of_machine_is_compatible() since there's only a
> > single entry in the match table. If there's a good chance that we may
> > end up with more entries, perhaps now would be a good time to add an
> > of_match_machine() function?
>=20
> I think this driver should work on Tegra132 without modifications.
> of_match_machine() does sound useful for some of the other cpufreq
> drivers as well and likely for your soc_is_tegra() from the PMC
> series as well.

Yes, indeed. I'll give it a shot if you don't beat me to it with this
series.

Thierry

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTz7+2AAoJEN0jrNd/PrOh+8QQAIc/DP10tF6BRPMbqKvsvKyp
v7Wfj5fN9DRs9HYH/QPquxC1rt+GK2TCWMx/D9SbaIBakvwjMBQuLuPCr6dAC3L5
2xx7REzr83DKtXtb92j3i6AA53fw2bmh4k1kwBK9hiRIKPV8K89LoPK3s9bLU0ws
ra8+LBmtwq6ZpKBJ59vWHQxdV0hk8tQu78z1/VWs+neOt2mvoOZ1cKO/gMVvYso7
Ryb1C6MYjNrkqTLNsj1NDkdhEsGSErc0nTjYsZHLGGTWp0hR/LmkPbhcdF/WbuAq
RW61E+3+3ky+P9S/EPKm8wP14zS9RAxh5DNgOfoG1LYWWruzu87XdCxtPgqML8gH
7mGMvtbjTUSnD3NDMxjzGOW2CUCFhwehNJzws4H2JX1c/P6fapGkAoniAgHPuowq
hF4BBVWdC4F9H4lBCPRBDYPH0B5X9dbdvHHIrKsDm9GETWqnyeO4hSJ+kjp9WHUF
zRH7azliBlbdBsWU4UWd/SV7O+NQqYbAO5AyGMPX9Ji5iFISTKi2mhFy5YCubIQM
FheuX+Ehp/3Mx1n9B3hQlufO5/1nn0mw0aHRRamSJOZxWicUQqpwCLztVLGjNwjM
Oqe3AhtpX/m4uetKbip9OAsyPo29Yot0pypdTEQpscqhcup5bprCiRzxjAxec/qb
yeuhwhVidhQXbn4vHCQ9
=i8Iv
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
