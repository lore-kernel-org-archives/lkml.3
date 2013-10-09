Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3JIMnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:43:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51613 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3JIMnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:43:23 -0400
Message-ID: <52554F66.5080405@ti.com>
Date: Wed, 9 Oct 2013 15:43:18 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: "Kristo, Tero" <t-kristo@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: Rounding issue in drivers/clk/clk-divider.c
References: <52540604.9000100@ti.com>
In-Reply-To: <52540604.9000100@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="ie6sw1xaSmD5SQQS2GA64BJAbqQdxXfvv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ie6sw1xaSmD5SQQS2GA64BJAbqQdxXfvv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 08/10/13 16:17, Tomi Valkeinen wrote:
> Hi,
>=20
> I'm seeing the following issue on omap3 with dpll4_m4 clock. dpll4_m4's=

> parent is a PLL set to 864000000 and dpll4_m4 is a divider, handled by
> clk-divider.c.
>=20
> Now, if I call clk_round_rate(dpll4_m4, 143999999), I get 123428571
> which is correct. However, if I call clk_round_rate(dpll4_m4,
> 123428571), I would presume to get the same answer, 123428571, as that
> was already "verified" by the previous clk_round_rate() call. However, =
I
> get 108000000.
>=20
> So, if I have the following code:
>=20
> rate =3D clk_round_rate(dpll4_m4, 143999999);
> /* rate is 123428571 */
> clk_set_rate(dpll4_m4, rate);
>=20
> the resulting rate is 108000000.

I continued testing with this, and with the following RFC patch I get
consistent rates:

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8d3009e..ba20314 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -115,7 +115,7 @@ static unsigned long clk_divider_recalc_rate(struct c=
lk_hw *hw,
 		return parent_rate;
 	}
=20
-	return parent_rate / div;
+	return DIV_ROUND_UP(parent_rate, div);
 }
=20
 /*
@@ -207,7 +207,7 @@ static long clk_divider_round_rate(struct clk_hw *hw,=
 unsigned long rate,
 	int div;
 	div =3D clk_divider_bestdiv(hw, rate, prate);
=20
-	return *prate / div;
+	return DIV_ROUND_UP(*prate, div);
 }
=20
 static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -218,7 +218,7 @@ static int clk_divider_set_rate(struct clk_hw *hw, un=
signed long rate,
 	unsigned long flags =3D 0;
 	u32 val;
=20
-	div =3D parent_rate / rate;
+	div =3D DIV_ROUND_UP(parent_rate, rate);
 	value =3D _get_val(divider, div);
=20
 	if (value > div_mask(divider))


Now clk_round_rate for this clock returns the following:

144000000 -> 144000000
143999999 -> 123428572
123428572 -> 123428572
123428571 -> 108000000

So now multiple nested calls to clk_round_rate return consistent values, =
and
calling clk_set_rate with the rate returned by clk_round_rate will not mo=
dify
the rate.

I believe the patch is missing pieces, at least for clk_divider_bestdiv()=
 for
the case when CLK_SET_RATE_PARENT is set. Also, 864000000 / 7 =3D 1234285=
71.4...,
so in reality 123428571 would be a better answer than 123428572. But roun=
ding
to 123428572 makes things work consistently.

However, even if the patch fixes the issue for me, I'm a bit confused on =
the
clock rate rounding. How should it happen? Is it even defined how the rat=
e is
rounded?

In my particular use case I want to iterate the possible clock rates, so =
that I
can find the best one to use. I do it with this kind of code:

/* start with the max rate my IP allows */
rate =3D max_allowed_fck;
while (true) {
	rate =3D clk_round_rate(rate);
	test_rate(rate);
	/* -1, so that the next round will return the next lowest rate */
	rate -=3D 1;
}

The code above presumes that the clk_round_rate will round down, but I do=
n't
see the rounding explicitly specified in any documentation. Is that kind =
of
code valid?

Another use case I have is to set the clock rate to something which is hi=
gher
than what I need. I.e. I know that I need at least 100MHz clock so that t=
he IP
performs the job quickly enough. If I call clk_round_rate(100M), I'll get=
 a
lower clock, not higher. So in this case I'd actually like the rounding t=
o be
up. And if the rate is rounded down, I have no idea what rate should I us=
e to
get at least 100MHz.

Am I doing something silly here? =3D) Should there be multiple clk_round_=
rate
versions, for different roundings?

 Tomi



--ie6sw1xaSmD5SQQS2GA64BJAbqQdxXfvv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVU9mAAoJEPo9qoy8lh71Kh8P/RM3QSJcmEGXt00bUATP32hY
wewgrTFyDFwUCo+6CkOscWfQ5BWFF4tDir+BXvbxZ55QjVSdw9RJj1n25Z+sqNA+
p3ENZmzLYSBTrBHQddvpuQ8s2vCpcV0KIbEBTR9U732xBhrQ5JR9BUNwH1PVI90f
F2fQk1AxmxNdU90SjcZjCZUmHJaj6tsIYmTVOvXp8P7Kam+cgr7i1x4tRJqmlA/Y
gF13okqJ4myZi0aRyTLh7Av6xH3Z2JZmTVxAQ7Gj527UocASQFdqHidVWnY6Fxol
AVoat2jymoJBIo+jjiizx8v0gEZVU2+YS9SkDv86KARVSCfos5q6FgIFGxS264Fz
R9zzNVPc7Nay0yC0Mse0Fs0bPgXycgmXKjZcXqq/wVBv04zgToKvet4e7CqO8ipd
PX4Ylie4jxKEhmFy07YOWMEi3FcxlsvY0wZa9yxBDdQqAcvf7tQ7vTEfEauC2yMA
YEX8aBE4DTnEJz29KIfAj16g29MgZ91a9KeXcGYIQsxrryGWPcDA1utUYVdURy3j
ojz+R5VP7hxZwaYrgmE9bTYbnGkLr/XkCb8bwBuLlIstM7duw3wuPSN34WyUOfWr
zBiGsMBJ4z164L0UTRkML3T8YvgpiDWiUda+ZKspH+1paGBmMNvWJp1PyIRfLUvo
OyCp0XZGJdA8HyZjl1wK
=bxhj
-----END PGP SIGNATURE-----

--ie6sw1xaSmD5SQQS2GA64BJAbqQdxXfvv--
