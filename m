Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaJ0QkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:40:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaJ0Qj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:39:59 -0400
Date: Mon, 27 Oct 2014 11:38:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Romain Perier <romain.perier@gmail.com>
CC: <heiko@sntech.de>, <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <johan@kernel.org>, <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <balbi@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1 01/10] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141027163840.GA14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 04:26:46PM +0000, Romain Perier wrote:
> As discussed on the mailing list, it makes more sense to rename this prop=
erty
> to "system-power-controller". Problem being that the word "source" usuall=
y tends
> to be used for inputs and that is out of control of the OS. The poweroff
> capability is an output which simply turns the system-power off. Also, th=
is
> property might be used by drivers which power-off the system and power ba=
ck on
> subsequent RTC alarms. This seems to suggest to remove "poweroff" from the
> property name and to choose "system-power-controller" as the more generic=
 name.
> This patchs adds the required renaming changes and defines an helper func=
tion
> which is compatible with both properties, the old one prefixed by a vendo=
r name
> and the new one without any prefix.
>=20
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  include/linux/of.h | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 27b3ba1..c1ed2a5 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -867,14 +867,33 @@ static inline int of_changeset_update_property(stru=
ct of_changeset *ocs,
>  extern int of_resolve_phandles(struct device_node *tree);
> =20
>  /**
> - * of_system_has_poweroff_source - Tells if poweroff-source is found for=
 device_node
> + * of_is_system_power_controller - Tells if the property for controlling=
 system
> + * power is found in device_node.
>   * @np: Pointer to the given device_node
>   *
>   * return true if present false otherwise
>   */
> -static inline bool of_system_has_poweroff_source(const struct device_nod=
e *np)
> -{
> -	return of_property_read_bool(np, "poweroff-source");
> +static inline bool of_is_system_power_controller(const struct device_nod=
e *np)
> +{
> +	struct property *pp;
> +	unsigned long flags;
> +	char *sep;
> +	bool found =3D false;
> +
> +	raw_spin_lock_irqsave(&devtree_lock, flags);
> +	for_each_property_of_node(np, pp) {
> +		if (of_prop_cmp(pp->name, "system-power-controller") =3D=3D 0) {
> +			found =3D true;
> +			break;
> +		}
> +		sep =3D strchr(pp->name, ',');
> +		if (sep && sep - pp->name && of_prop_cmp(sep + 1, "system-power-contro=
ller") =3D=3D 0) {
> +			found =3D true;
> +			break;
> +		}
> +	}
> +	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> +	return found;
>  }
> =20
>  #endif /* _LINUX_OF_H */

I think you still need to support poweroff-source since it has been
released on a stable kernel. Perhaps add a warning message telling users
it's deprecated and asking them to switch over to
system-power-controller ? Still, simply removing it isn't very nice.

--=20
balbi

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnUQAAoJEIaOsuA1yqREykcP/17WeGaNRLnzPysmdrRd0aG2
Uuj4lMvYp8V4vxXQKDBuywISe/JgiqiS3KTSb6qbqmfObpqdRbTmPxaPoC0VpaKT
Cd2x/fDqfiDF+Q9Ask5TD4FajTUzEU4V7S/Xhprjyv4+8Hc+uIoLJFwMs3TTlhhB
P55JZXo0BjtTg/WU1l2kVo3CZ592GYyqBlwlG5i1klyAn+5qX/hGTu8PZc+8yhOW
lXevpzblHj6bcgosK0zFQ73RUTGc767kxEV6tS9CucHWjU/Ib2M5d0zo9RIEQDMf
wvNHVCy51JHzEcYDOKMdShv/q/kG5tgrnmPhEomOIDvY1edIos8204xMq0AI75yw
6KM+FZp1TixmIFPruBeipF/kTdowknRzDd8ZpAT9uwPNwOUkAzFf6v6XtuB97I3k
zTsVWaa1F+ao2Mhd2ZCBJJgIJ8RvBB2m4wcQ3q8oq9K77XWrnXSnjPcNVLNbuYZB
tEQRBcO3eSkAgMsRZrRjdk9nkDx8GVNn2nnxDGDKZbIYTEyLqDT6I1Bn9PsdGxR2
b889nBP4gKuqfNTd2zXJexSZqt2uB7q9iVmzL/nz5r7hEk2rc7Y2Tygye/VusVtr
fHoqjqblMYiBIV0R5iawJonC1seTpyKweOYKEFiyNy92keStoTxSCIb6cnu9yl9h
UlEC6LfKctEgnvCZZXif
=PLaD
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
