Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaBKOS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:18:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49121 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaBKOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:18:54 -0500
Message-ID: <52FA3132.2030400@ti.com>
Date: Tue, 11 Feb 2014 16:18:26 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NmpoQxvq83fPE4tMNWfxvWF5Ps21U0WnA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NmpoQxvq83fPE4tMNWfxvWF5Ps21U0WnA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mike, ping.

 Tomi

On 06/11/13 13:06, Tomi Valkeinen wrote:
> clk-divider.c does not calculate the rates consistently at the moment.
>=20
> As an example, on OMAP3 we have a clock divider with a source clock of
> 864000000 Hz. With dividers 6, 7 and 8 the theoretical rates are:
>=20
> 6: 144000000
> 7: 123428571.428571...
> 8: 108000000
>=20
> Calling clk_round_rate() with the rate in the first column will give th=
e
> rate in the second column:
>=20
> 144000000 -> 144000000
> 143999999 -> 123428571
> 123428572 -> 123428571
> 123428571 -> 108000000
>=20
> Note how clk_round_rate() returns 123428571 for rates from 123428572 to=

> 143999999, which is mathematically correct, but when clk_round_rate() i=
s
> called with 123428571, the returned value is surprisingly 108000000.
>=20
> This means that the following code works a bit oddly:
>=20
> rate =3D clk_round_rate(clk, 123428572);
> clk_set_rate(clk, rate);
>=20
> As clk_set_rate() also does clock rate rounding, the result is that the=

> clock is set to the rate of 108000000, not 123428571 returned by the
> clk_round_rate.
>=20
> This patch changes the clk-divider.c to use DIV_ROUND_UP when
> calculating the rate. This gives the following behavior which fixes the=

> inconsistency:
>=20
> 144000000 -> 144000000
> 143999999 -> 123428572
> 123428572 -> 123428572
> 123428571 -> 108000000
>=20
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/clk-divider.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 8d3009e..43348f3 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -24,7 +24,7 @@
>   * Traits of this clock:
>   * prepare - clk_prepare only ensures that parents are prepared
>   * enable - clk_enable only ensures that parents are enabled
> - * rate - rate is adjustable.  clk->rate =3D parent->rate / divisor
> + * rate - rate is adjustable.  clk->rate =3D DIV_ROUND_UP(parent->rate=
 / divisor)
>   * parent - fixed parent.  No clk_set_parent support
>   */
> =20
> @@ -115,7 +115,7 @@ static unsigned long clk_divider_recalc_rate(struct=
 clk_hw *hw,
>  		return parent_rate;
>  	}
> =20
> -	return parent_rate / div;
> +	return DIV_ROUND_UP(parent_rate, div);
>  }
> =20
>  /*
> @@ -185,7 +185,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, u=
nsigned long rate,
>  		}
>  		parent_rate =3D __clk_round_rate(__clk_get_parent(hw->clk),
>  				MULT_ROUND_UP(rate, i));
> -		now =3D parent_rate / i;
> +		now =3D DIV_ROUND_UP(parent_rate, i);
>  		if (now <=3D rate && now > best) {
>  			bestdiv =3D i;
>  			best =3D now;
> @@ -207,7 +207,7 @@ static long clk_divider_round_rate(struct clk_hw *h=
w, unsigned long rate,
>  	int div;
>  	div =3D clk_divider_bestdiv(hw, rate, prate);
> =20
> -	return *prate / div;
> +	return DIV_ROUND_UP(*prate, div);
>  }
> =20
>  static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,=

> @@ -218,7 +218,7 @@ static int clk_divider_set_rate(struct clk_hw *hw, =
unsigned long rate,
>  	unsigned long flags =3D 0;
>  	u32 val;
> =20
> -	div =3D parent_rate / rate;
> +	div =3D DIV_ROUND_UP(parent_rate, rate);
>  	value =3D _get_val(divider, div);
> =20
>  	if (value > div_mask(divider))
>=20



--NmpoQxvq83fPE4tMNWfxvWF5Ps21U0WnA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+jEyAAoJEPo9qoy8lh71JvAP/3el3FHoHIa2wVeefk0XIVU4
uH6H06h0nWSYoHpNzAM6kyAWYlwdKav3c15GRPrgcJ75gWKEAsDpAcoA8yt5p4hm
/92I5/KX4NVaCmpnm6ldNeBF7bJier8Vb/ghGqx19DIL2NxgaWJQZy9HoC13rAQ4
YGmFsXfgHI7VaR10/n+970m5jR2fIShBOQit4ZCA48t5HlCUJuIOFuncrJHeTHaC
ll/B64YEHLJ+nt1nWLxvGQvZ6D2if/1NF4JcZ+Xw0QzxINCZZiFiNd2bWo6ySLQj
CD9ctqOZg9O9i2p6tCxfx2qly4w3lZ9OHjARC4gKffmsTmromHF17D1vkABAhXe8
2aO059Wf+nzfWyKHHQ+9Nx+W1N6FvaFowv0IEJclT+zHLl0x3GUAKRRmhuMDZr8f
ZIWmcWrlcGjVD6XF4nFXGpad4BpVxmQRLetjcv6i/b8XsBg3RPAQXtWwx5OnVG3F
YUIkFFRlpjlUbwfZsgHh2wX+ZYc/RjNHhlC9qbkm3/vEd9xcM7cV38ZvAxFM1hru
ekv8zNsFLIRQBOMDFJhEBVkHTaJcju97p2Z7hr6cATuiNFlzkquzXpt8UXz88jzs
CICyUqIvYmewOfxCVfG5FMRKF6KIj6fLnz2ycpqSuOguaiZwpMQIaCPZmKZZS4vf
vH+DnKQlsNzy0sEU9iSM
=2W+q
-----END PGP SIGNATURE-----

--NmpoQxvq83fPE4tMNWfxvWF5Ps21U0WnA--
