Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3FGTLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:11:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43888 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab3FGTLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:11:03 -0400
Message-ID: <51B2303B.8090200@ti.com>
Date: Fri, 7 Jun 2013 15:10:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] thermal: ti-soc-thermal: freeze FSM while computing
 trend
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com> <1369840066-20357-4-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1369840066-20357-4-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2BPOGKOHCGHKXQTERSEIA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2BPOGKOHCGHKXQTERSEIA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 29-05-2013 11:07, Eduardo Valentin wrote:
> In order to read the history buffer, it is required to
> freeze BG FSM. This patch adds the missing piece of code
> to freeze the FSM and also a contention area to avoid
> other parts of the code to access the DTEMPs.
>=20
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/ther=
mal/ti-soc-thermal/ti-bandgap.c
> index f20c1cf..be9dba5 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -992,9 +992,12 @@ int ti_bandgap_get_trend(struct ti_bandgap *bgp, i=
nt id, int *trend)
>  		goto exit;
>  	}
> =20
> +	spin_lock(&bgp->lock);
> +
>  	tsr =3D bgp->conf->sensors[id].registers;
> =20
>  	/* Freeze and read the last 2 valid readings */
> +	RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 1);
>  	reg1 =3D tsr->ctrl_dtemp_1;
>  	reg2 =3D tsr->ctrl_dtemp_2;
> =20
> @@ -1008,22 +1011,26 @@ int ti_bandgap_get_trend(struct ti_bandgap *bgp=
, int id, int *trend)
>  	/* Convert from adc values to mCelsius temperature */
>  	ret =3D ti_bandgap_adc_to_mcelsius(bgp, temp1, &t1);
>  	if (ret)
> -		goto exit;
> +		goto unfreeze;
> =20
>  	ret =3D ti_bandgap_adc_to_mcelsius(bgp, temp2, &t2);
>  	if (ret)
> -		goto exit;
> +		goto unfreeze;
> =20
>  	/* Fetch the update interval */
>  	ret =3D ti_bandgap_read_update_interval(bgp, id, &interval);
>  	if (ret || !interval)
> -		goto exit;
> +		goto unfreeze;
> =20
>  	*trend =3D (t1 - t2) / interval;
> =20
>  	dev_dbg(bgp->dev, "The temperatures are t1 =3D %d and t2 =3D %d and t=
rend =3D%d\n",
>  		t1, t2, *trend);
> =20
> +unfreeze:
> +	RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 0);
> +unlock:

This label is unused. I will repost this patch only without this label.

> +	spin_unlock(&bgp->lock);
>  exit:
>  	return ret;
>  }
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2BPOGKOHCGHKXQTERSEIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGyMEAACgkQCXcVR3XQvP0wGwD+OWGAb5mIEG7bhmGfVI0PI5Yc
N3UqfVa8itJp7VcFykkBAONXX5QswH0oEMGTNHIJxRGlGz2ZiN0hm/YPZUaV+TNH
=z+dS
-----END PGP SIGNATURE-----

------enig2BPOGKOHCGHKXQTERSEIA--
