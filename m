Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3LBMD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:03:59 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44703 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3LBMD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:03:57 -0500
Date: Mon, 2 Dec 2013 13:03:01 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Meelis Roos <mroos@linux.ee>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] OF: base: match each node compatible against all given
 matches first
Message-ID: <20131202120300.GA12793@ulmo.nvidia.com>
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 07:36:25PM +0100, Sebastian Hesselbarth wrote:
> Currently, of_match_node compares each given match against all node's
> compatible strings with of_device_is_compatible.
>=20
> To achieve multiple compatible strings per node with ordering from
> specific to generic, this requires given matches to be ordered from
> specific to generic. For most of the drivers this is not true and also
> an alphabetical ordering is more sane there.
>=20
> Therefore, this patch modifies of_match_node to match each of the node's
> compatible strings against all given matches first, before checking the
> next compatible string. This implies that node's compatibles are ordered
> from specific to generic while given matches can be in any order.
>=20
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/of/base.c |   47 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 15 deletions(-)

Hi Sebastian,

I think you're one in a long line of people attempting to fix this. I
tried myself over a year ago (commit 107a84e61cdd 'of: match by
compatible property first') but it caused a subtle regression late in
the release cycle and was reverted (commit bc51b0c22ceb 'Revert "of:
match by compatible property first").

Only recently there was another attempt [0] but it's pretty much
equivalent to what I did back then.

That said, I think you might actually have nailed it with this patch.
=46rom what I remember all earlier attempt failed because they didn't
match all compatible/name/type combinations properly. I'm adding a few
people on Cc who were involved with the other patches, perhaps they can
give your patch a spin and see if it fixes things for them.

Thierry

[0]: https://lkml.org/lkml/2013/10/3/585

> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 7d4c70f..183a9c7 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -713,23 +713,37 @@ static
>  const struct of_device_id *__of_match_node(const struct of_device_id *ma=
tches,
>  					   const struct device_node *node)
>  {
> +	const char *cp;
> +	int cplen, l;
> +
>  	if (!matches)
>  		return NULL;
> =20
> -	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
> -		int match =3D 1;
> -		if (matches->name[0])
> -			match &=3D node->name
> -				&& !strcmp(matches->name, node->name);
> -		if (matches->type[0])
> -			match &=3D node->type
> -				&& !strcmp(matches->type, node->type);
> -		if (matches->compatible[0])
> -			match &=3D __of_device_is_compatible(node,
> -							   matches->compatible);
> -		if (match)
> -			return matches;
> -		matches++;
> +	cp =3D __of_get_property(node, "compatible", &cplen);
> +	if (!cp)
> +		return NULL;
> +
> +	while (cplen > 0) {
> +		const struct of_device_id *m =3D matches;
> +
> +		while (m->name[0] || m->type[0] || m->compatible[0]) {
> +			int match =3D 1;
> +			if (m->name[0])
> +				match &=3D node->name
> +					&& !strcmp(m->name, node->name);
> +			if (m->type[0])
> +				match &=3D node->type
> +					&& !strcmp(m->type, node->type);
> +			if (m->compatible[0])
> +				match &=3D !of_compat_cmp(cp, m->compatible,
> +							strlen(m->compatible));
> +			if (match)
> +				return m;
> +			m++;
> +		}
> +		l =3D strlen(cp) + 1;
> +		cp +=3D l;
> +		cplen -=3D l;
>  	}
>  	return NULL;
>  }
> @@ -739,7 +753,10 @@ const struct of_device_id *__of_match_node(const str=
uct of_device_id *matches,
>   *	@matches:	array of of device match structures to search in
>   *	@node:		the of device structure to match against
>   *
> - *	Low level utility function used by device matching.
> + *	Low level utility function used by device matching. Matching order
> + *	is to compare each of the node's compatibles with all given matches
> + *	first. This implies node's compatible is sorted from specific to
> + *	generic while matches can be in any order.
>   */
>  const struct of_device_id *of_match_node(const struct of_device_id *matc=
hes,
>  					 const struct device_node *node)
> --=20
> 1.7.10.4
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnHb0AAoJEN0jrNd/PrOhzq4P/ReV2xZqzQNmIpgpA6qXNTKs
hhYJHDYklCWOQFhoiDE3znSPqTJgaX8uQ+bA9TkPi7KsRFOrkukEmoM/7sFdNISd
Nokkw5FmZ/r7pM8xkb32RlbBN+l8VNlEwxgpRaDgPMKM3TpfAtlSppINrlaua43j
7/mnwRMKaW3HpmBl/FQqZF047xy3r6FbU0TkKqkZuZ0wQzykm7Wjy/gkBMIfwAqT
dGNxS+TR/eX//+IaFJ6l+KajZ5erGTBg5YmktAwoGRWN2owvhN056BD2kNhWyIqP
HpHkMnKxO3+CaiiP6VTznvm0cpMW8FqXdzVrqoFVoQqoywCQJO0k9xckf9LZIdO7
/4YBxxJ+JQqJtyzf0tXpwqJzT/hBSc8/YSAImasvDU2SUZFSMVxsz5Q1kWWirBOW
yYlMwGNiTqm0OVGshOlg1zg7hHd/eQdzSp49VFdFfpzeeCE6/5vLLAb32cc46PBa
4C/8nlOZcfRSuKboriDNg72y3UI9Nvtg4IwCeAFYGwYniMkmRWinfGo/1yjjtVOW
0V3GB8AeWAwJ+8PhT7joOk/X7XHlv3A/cSsGRDdPMDpezQFLcz2L+lCc5An79+g7
VhVMl9b1/hQIwIZOiGUvwcilpBCYw5Vvm8Or3Y32yy+HfCG40lE5TrfPypYccmMc
5JBpF/tRregc8Ur2Oki5
=gNxC
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
