Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3DWNIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:08:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60542 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3DWNIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:08:21 -0400
Message-ID: <517687AB.1040309@pengutronix.de>
Date: Tue, 23 Apr 2013 15:07:55 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: BUG: Re: [PATCH v2 3/3] clocksource: use clockevents_config_and_register()
 where possible
References: <1357991406-22778-1-git-send-email-shawn.guo@linaro.org> <1357991406-22778-4-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1357991406-22778-4-git-send-email-shawn.guo@linaro.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2EORJKSLMIDNQDJXULRLH"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EORJKSLMIDNQDJXULRLH
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

On 01/12/2013 12:50 PM, Shawn Guo wrote:
> The clockevent core is able to figure out the best mult and shift,
> calculate min_delta_ns and max_delta_ns, with the necessary info passed=

> into clockevents_config_and_register().  Use this combined configure
> and register function where possible to make the codes less error prone=

> and gain some positive diff stat.
>=20
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

[...]

I just bisected a timer problem down to this commit.

> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb=
_clksrc.c
> index 32cb929..8a61872 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -157,7 +157,6 @@ static struct tc_clkevt_device clkevt =3D {
>  		.name		=3D "tc_clkevt",
>  		.features	=3D CLOCK_EVT_FEAT_PERIODIC
>  					| CLOCK_EVT_FEAT_ONESHOT,
> -		.shift		=3D 32,
>  		/* Should be lower than at91rm9200's system timer */
>  		.rating		=3D 125,
>  		.set_next_event	=3D tc_next_event,
> @@ -196,13 +195,9 @@ static void __init setup_clkevents(struct atmel_tc=
 *tc, int clk32k_divisor_idx)
> =20
>  	timer_clock =3D clk32k_divisor_idx;
> =20
> -	clkevt.clkevt.mult =3D div_sc(32768, NSEC_PER_SEC, clkevt.clkevt.shif=
t);
> -	clkevt.clkevt.max_delta_ns
> -		=3D clockevent_delta2ns(0xffff, &clkevt.clkevt);
> -	clkevt.clkevt.min_delta_ns =3D clockevent_delta2ns(1, &clkevt.clkevt)=
 + 1;
                                                                         =
  ^^^^^^

With this patch, the "+ 1" gets lost, resulting in a different
"min_delta_ns".

good:
setup_clkevents: shift=3D32 mult=3D140737 min=3D30518 max=3D1999976422

bad:
setup_clkevents: shift=3D32 mult=3D140737 min=3D30517 max=3D1999976422

This leads to problems with schedule_delayed_work() with a delay of
"1". These worksqueues seem to be hanging for several seconds. I'll
send a RFC patch.

>  	clkevt.clkevt.cpumask =3D cpumask_of(0);
> =20
> -	clockevents_register_device(&clkevt.clkevt);
> +	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
> =20
>  	setup_irq(irq, &tc_irqaction);
>  }
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2EORJKSLMIDNQDJXULRLH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlF2h64ACgkQjTAFq1RaXHOhSQCffo2ENeLddFYL+AWBlqoUx/Ou
enwAnibh2SlS3gkSyPwHZFLi6mXOMdf3
=E61t
-----END PGP SIGNATURE-----

------enig2EORJKSLMIDNQDJXULRLH--
