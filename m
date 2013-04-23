Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3DWNu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:50:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3DWNuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:50:54 -0400
Message-ID: <517691AD.304@pengutronix.de>
Date: Tue, 23 Apr 2013 15:50:37 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de> <51768885.4080301@pengutronix.de> <20130423134448.GG27475@S2101-09.ap.freescale.net>
In-Reply-To: <20130423134448.GG27475@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2POPSSKFOUUVXOLANBGNT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2POPSSKFOUUVXOLANBGNT
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 04/23/2013 03:44 PM, Shawn Guo wrote:
> On Tue, Apr 23, 2013 at 03:11:33PM +0200, Marc Kleine-Budde wrote:
>> On 04/23/2013 03:08 PM, Marc Kleine-Budde wrote:
>>> The commit
>>>
>>>     77cc982 clocksource: use clockevents_config_and_register() where =
possible
>>>
>>> switches from manually calculating min_delta_ns (and others) and
>>> clockevents_register_device() to automatic calculation via
>>> clockevents_config_and_register(). During this conversation the "+ 1"=
 in
>>>
>>>     min_delta_ns =3D clockevent_delta2ns(1, &clkevt.clkevt) + 1;
>>>
>>> was lost. This leads to problems with schedule_delayed_work() with a =
delay of
>>> "1". Resulting in the work not scheduled in time.
>>>
>>> This patch fixes the problem by increasing the min_delta to "2" ticks=
=2E
>>>
>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>
>> The problem appears on at91sam9263. This patch successfully fixes the
>> problem and applies to current linus/master (post v3.9-rc8).
>=20
> Thanks for the fixing, Marc.
>=20
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Thanks. The downside of my RFC Patch is, that min_delta_ns is increased
from 30518 to 61035:

good: setup_clkevents: shift=3D32 mult=3D140737 min=3D30518 max=3D1999976=
422
bad:  setup_clkevents: shift=3D32 mult=3D140737 min=3D30517 max=3D1999976=
422
RFC:  setup_clkevents: shift=3D32 mult=3D140737 min=3D61035 max=3D1999976=
422

To keep the original min_delta_ns value of 30518, a rather hackish
option would be this:

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_c=
lksrc.c
index 8a61872..30e0a68 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -198,6 +198,7 @@ static void __init setup_clkevents(struct atmel_tc *t=
c, int clk32k_divisor_idx)
        clkevt.clkevt.cpumask =3D cpumask_of(0);

        clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff)=
;
+       clkevt.clkevt.min_delta_ns =3D clockevent_delta2ns(1, &clkevt.clk=
evt) + 1;

        setup_irq(irq, &tc_irqaction);
 }

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2POPSSKFOUUVXOLANBGNT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlF2kbAACgkQjTAFq1RaXHPqxQCgjIvkTaDZyv8H89aYCSasKgBk
vlsAoIZ5d7/qLhxBXq2phCBqEOU7vbTq
=XCSd
-----END PGP SIGNATURE-----

------enig2POPSSKFOUUVXOLANBGNT--
