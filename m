Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3J1JjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:39:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39853 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab3J1JjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:39:06 -0400
Message-ID: <526E30B5.9080306@ti.com>
Date: Mon, 28 Oct 2013 11:39:01 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: "Kristo, Tero" <t-kristo@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: Rounding issue in drivers/clk/clk-divider.c
References: <52540604.9000100@ti.com> <52554F66.5080405@ti.com>
In-Reply-To: <52554F66.5080405@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="C0x4dSDUBLwvc2OEXsfDRnA05xcnKajO1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--C0x4dSDUBLwvc2OEXsfDRnA05xcnKajO1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Ping.

 Tomi

On 09/10/13 15:43, Tomi Valkeinen wrote:
> Hi,
>=20
> On 08/10/13 16:17, Tomi Valkeinen wrote:
>> Hi,
>>
>> I'm seeing the following issue on omap3 with dpll4_m4 clock. dpll4_m4'=
s
>> parent is a PLL set to 864000000 and dpll4_m4 is a divider, handled by=

>> clk-divider.c.
>>
>> Now, if I call clk_round_rate(dpll4_m4, 143999999), I get 123428571
>> which is correct. However, if I call clk_round_rate(dpll4_m4,
>> 123428571), I would presume to get the same answer, 123428571, as that=

>> was already "verified" by the previous clk_round_rate() call. However,=
 I
>> get 108000000.
>>
>> So, if I have the following code:
>>
>> rate =3D clk_round_rate(dpll4_m4, 143999999);
>> /* rate is 123428571 */
>> clk_set_rate(dpll4_m4, rate);
>>
>> the resulting rate is 108000000.
>=20
> I continued testing with this, and with the following RFC patch I get
> consistent rates:
>=20
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 8d3009e..ba20314 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
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
>=20
> Now clk_round_rate for this clock returns the following:
>=20
> 144000000 -> 144000000
> 143999999 -> 123428572
> 123428572 -> 123428572
> 123428571 -> 108000000
>=20
> So now multiple nested calls to clk_round_rate return consistent values=
, and
> calling clk_set_rate with the rate returned by clk_round_rate will not =
modify
> the rate.
>=20
> I believe the patch is missing pieces, at least for clk_divider_bestdiv=
() for
> the case when CLK_SET_RATE_PARENT is set. Also, 864000000 / 7 =3D 12342=
8571.4...,
> so in reality 123428571 would be a better answer than 123428572. But ro=
unding
> to 123428572 makes things work consistently.
>=20
> However, even if the patch fixes the issue for me, I'm a bit confused o=
n the
> clock rate rounding. How should it happen? Is it even defined how the r=
ate is
> rounded?
>=20
> In my particular use case I want to iterate the possible clock rates, s=
o that I
> can find the best one to use. I do it with this kind of code:
>=20
> /* start with the max rate my IP allows */
> rate =3D max_allowed_fck;
> while (true) {
> 	rate =3D clk_round_rate(rate);
> 	test_rate(rate);
> 	/* -1, so that the next round will return the next lowest rate */
> 	rate -=3D 1;
> }
>=20
> The code above presumes that the clk_round_rate will round down, but I =
don't
> see the rounding explicitly specified in any documentation. Is that kin=
d of
> code valid?
>=20
> Another use case I have is to set the clock rate to something which is =
higher
> than what I need. I.e. I know that I need at least 100MHz clock so that=
 the IP
> performs the job quickly enough. If I call clk_round_rate(100M), I'll g=
et a
> lower clock, not higher. So in this case I'd actually like the rounding=
 to be
> up. And if the rate is rounded down, I have no idea what rate should I =
use to
> get at least 100MHz.
>=20
> Am I doing something silly here? =3D) Should there be multiple clk_roun=
d_rate
> versions, for different roundings?
>=20
>  Tomi
>=20
>=20



--C0x4dSDUBLwvc2OEXsfDRnA05xcnKajO1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSbjC1AAoJEPo9qoy8lh71/xUP/2323Gksd1Mdfzzpfoj9m/N8
L/Gp72EuGm/Msb5Xy4/JB+L0zG61Wjodpj86HQsuqz+SPsqyMQZgYSe9zT117TsQ
GBtq3VOg77mA+MbMo9UjKi/gYyUiI1pZPcboO8mRhYeqizOm+8YvulNioz9vP0kL
8TRPA82NeVCN52Hq3BWYv6ukDpXbfA1KtHdVd4LaeU6LtzGFLB+rkkFnAcaV/64+
hOd7CTpbgk+Hi2/wa7XmOWCsJmTuW+B0oIXGcPJgY16GjCFfX8/uL2CJ+aFHsIXH
H+3sZhWd/4KYHBzWJwNZ+RX2jH8k3VzSaNWZaM5xNope6Vtr5SgDMt81fODlsRu8
m83zYf8SKB+IzcMEWgXMfuUn59MIj11I3iJ/tiD57ZR1N7u2DDDu80VmiqLQk38X
aiqK80P+ygxv1AVYIl5vab2clxtUfLg5pVIbW7b/bozWeKt7mc3LfAvWRCyPj7kM
SMTcvDA42TYNroZyi2e3hULAHfcNC6zmDVz2VfaBsaB8RcB694FWIDhjHlpiyx3M
vFe8Z2UqnwM/k9Pw+QwLWvUDZoSf2d2J/h6+yNz+OI0lyHNOxYDgcTZbjP/XNDVS
j9V2OWB5LFkfMU9MhjUq02mgOHXMhdHd2Qr2K9exMEkZR33jBG4r/aAG8Aais43B
D2inE05YBM/3pkELgg9N
=tQ2u
-----END PGP SIGNATURE-----

--C0x4dSDUBLwvc2OEXsfDRnA05xcnKajO1--
