Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbbAFOS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:18:29 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38506 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbAFOS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:18:27 -0500
Date: Tue, 6 Jan 2015 15:18:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: gnurou@gmail.com, bskeggs@redhat.com, martin.peres@free.fr,
        seven@nimrod-online.com, samuel.pitoiset@gmail.com,
        nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/11] memory: tegra: add mc flush support
Message-ID: <20150106141821.GJ31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-3-git-send-email-vinceh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JsihDCElWRmQcbOr"
Content-Disposition: inline
In-Reply-To: <1419331204-26679-3-git-send-email-vinceh@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JsihDCElWRmQcbOr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2014 at 06:39:55PM +0800, Vince Hsu wrote:
> The flush operation of memory clients is needed for various IP blocks in
> the Tegra SoCs to perform a clean reset.
>=20
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>  drivers/memory/tegra/mc.c | 21 +++++++++++++++++++++
>  include/soc/tegra/mc.h    | 23 ++++++++++++++++++++++-
>  2 files changed, 43 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
> index fe3c44e7e1d1..a2928b4b26fe 100644
> --- a/drivers/memory/tegra/mc.c
> +++ b/drivers/memory/tegra/mc.c
> @@ -62,6 +62,27 @@ static const struct of_device_id tegra_mc_of_match[] =
=3D {
>  };
>  MODULE_DEVICE_TABLE(of, tegra_mc_of_match);
> =20
> +int tegra_mc_flush(struct tegra_mc *mc, unsigned int swgroup, bool enabl=
e)
> +{
> +	int i;
> +	const struct tegra_mc_hr *client;
> +
> +	if (!mc || !mc->soc->hr_clients ||
> +			!mc->soc->ops || !mc->soc->ops->flush)
> +		return -EINVAL;;
> +
> +	client =3D mc->soc->hr_clients;
> +
> +	for (i =3D 0; i < mc->soc->num_hr_clients; i++, client++) {
> +		if (swgroup =3D=3D client->swgroup) {
> +			return mc->soc->ops->flush(mc, client, enable);
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(tegra_mc_flush);

Like Lucas already mentioned in response to another patch, having a
boolean "enable" argument is suboptimal here. Now according to
documentation the proper reset sequence for clients is something like
this:

	1) set the FLUSH_ENABLE bit for the client
	2) poll the FLUSH_DONE bit for the client
	3) assert reset to the client using the CAR
	4) deassert reset to the client using the CAR
	5) clear the FLUSH_ENABLE bit for the client

This is really inconvenient because we can't flush the client using a
single operation. So I think we'll need two functions here, something
like: tegra_mc_flush_enable/disable(), or tegra_mc_flush_{,de}assert().
Or maybe even: tegra_mc_reset_{,de}assert() to mirror the reset
controller API. I suppose we could even export it using the reset
controller framework.

Doing so would allow us to have power domain DT nodes like this:

	pmc@0,7000e400 {
		power-domains {
			...

			gpu {
				resets =3D <&tegra_car 184>,
					 <&mc TEGRA_SWGROUP_GPU>;
				reset-names =3D "module", "client";
			};

			...
		};
	};

The PMC driver could then grab the "module" and "client" resets and do
something like this:

	reset_control_assert(powergate->rst_client);
	reset_control_assert(powergate->rst_module);
	reset_control_deassert(powergate->rst_module);
	reset_control_deassert(powergate->rst_client);

Optionally the above could be extended with a reset_control_status()-
loop. Alternatively reset_control_assert() would block until the
FLUSH_DONE bit is set.

Stephen, Peter, any thoughts on the above?

Thierry

--JsihDCElWRmQcbOr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq+6tAAoJEN0jrNd/PrOhB/kP/2Aw0TEJzxlWt8h14bn0gjPZ
n0OukPqC+aiYjYfrly/EW8xxo7hL3DAza9YqATtjfk3rKivt/meK9XGo3SlfyPA5
TaeMZ4M1lhCrUmFcpFGytoCo2eHYbkUXJUkx1YO/Lo57z8XQ0nmAR8MQstGPbirj
HUrA1PRHMvK3EYmUsrWP6GWmeGXByab/XkjG6EBKAmfyuFHL21yyBDksFJ7BCTfM
jkrZmb8AykDISBNLI4yKc1XTz9nIauRpnjYTMBUxzd/f7mhlNNGoiLcd86jBir4s
rUWWzRCoJK9wCFj/mhj3mnbdmUL7ObqjKzcDBtakzzc5yInSieQ2EHZI7HnBMf4F
ZawwL3dLh+RRT8sQInchV4i4WDbPdVGL17SPGvdwkGTBne9ouqLep5UQB4s6qDCZ
sR8+ZK3RkFCkRQakbp8N+AyVVhb8Uk9aKXetVamc2ZZC0Ebf6lcbar2gA5Zqz5Uk
OXw6onPkQ1ljTwbitEwY8RAiIogJ86UyZpxI377lXY8kVEoUKEko9I+kvQgoX/p9
UkbxIlIX3Zm1uKef2Q4sIJERFZ3RtLLvgcjmBPZ8wPB7jb083XJ7hUmd4lbrJxon
NoQvaU/VzOVZODBF6ViEBxT1Niq+8zfXzJpEicPmTQ0NWgbuVQfCw+4UGpmPeeqq
TBNCEmhrz2LJIphc6WoS
=LQP1
-----END PGP SIGNATURE-----

--JsihDCElWRmQcbOr--
