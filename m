Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab3FTPBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:01:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45100 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3FTPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:01:17 -0400
Message-ID: <51C31926.3060400@pengutronix.de>
Date: Thu, 20 Jun 2013 17:00:54 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, John Stultz <john.stultz@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Andres Salomon <dilinger@queued.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de> <alpine.LFD.2.02.1304251618590.21884@ionos> <51794385.1030308@pengutronix.de>
In-Reply-To: <51794385.1030308@pengutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2QNSWXQJJHGMCAVOSVDEE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QNSWXQJJHGMCAVOSVDEE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello Thomas,

On 04/25/2013 04:53 PM, Marc Kleine-Budde wrote:
> On 04/25/2013 04:21 PM, Thomas Gleixner wrote:
>> On Tue, 23 Apr 2013, Marc Kleine-Budde wrote:
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
>>
>> Errm. How is schedule_delayed_work() related to this?

Coming back to the this problem after some time.

I'm on at91sam9263 (armv5) using latest linus/master (v3.10-rc6-84-gc0691=
14).
I can illustrate the problem running cyclictest.

Here's the output of unpatched linus/master:

> root@halo22:~ cyclictest -i 10000 -n -t 4
> policy: other/other: loadavg: 0.10 0.19 0.10 2/31 133
>=20
> T: 0 (  130) P: 0 I:10000 C:  30767 Min:     57 Act:  165 Avg:909453 Ma=
x: 201897444
> T: 1 (  131) P: 0 I:10500 C:  29302 Min:     68 Act:  144 Avg:906651 Ma=
x: 204005666
> T: 2 (  132) P: 0 I:11000 C:  27970 Min:     79 Act:  188 Avg:905068 Ma=
x: 204008666
> T: 3 (  133) P: 0 I:11500 C:  26754 Min:     52 Act:  132 Avg:904438 Ma=
x: 203665111

Cyclictest runs for about two seconds, but then shows no output for
about two seconds, then it runs again, then stops and so on...

With my patch applied, the numbers are back to normal:

> root@halo22:~ cyclictest -i 10000 -n -t 4
> policy: other/other: loadavg: 0.34 0.15 0.06 2/32 109
>=20
> T: 0 (  106) P: 0 I:10000 C:    292 Min:    112 Act:  208 Avg:  189 Max=
:    1715
> T: 1 (  107) P: 0 I:10500 C:    277 Min:    107 Act:  198 Avg:  201 Max=
:    1464
> T: 2 (  108) P: 0 I:11000 C:    265 Min:    104 Act:  148 Avg:  195 Max=
:    1530
> T: 3 (  109) P: 0 I:11500 C:    252 Min:    113 Act:  205 Avg:  167 Max=
:     269

Cyclictest keeps running without 2 second stops.

Is my patch a valid solution to the problem? If so, I'll write more=20
specific commit message.

regards,
Marc

---

The commit

    77cc982 clocksource: use clockevents_config_and_register() where poss=
ible

switches from manually calculating min_delta_ns (and others) and
clockevents_register_device() to automatic calculation via
clockevents_config_and_register(). During this conversation the "+ 1" in

    min_delta_ns =3D clockevent_delta2ns(1, &clkevt.clkevt) + 1;

was lost. This leads to problems with schedule_delayed_work() with a dela=
y of
"1". Resulting in the work not scheduled in time.

This patch fixes the problem by increasing the min_delta to "2" ticks.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/clocksource/tcb_clksrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_c=
lksrc.c
index 8a61872..7cf6dc7 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -197,7 +197,7 @@ static void __init setup_clkevents(struct atmel_tc *t=
c, int clk32k_divisor_idx)
=20
 	clkevt.clkevt.cpumask =3D cpumask_of(0);
=20
-	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
+	clockevents_config_and_register(&clkevt.clkevt, 32768, 2, 0xffff);
=20
 	setup_irq(irq, &tc_irqaction);
 }
-- 1.8.2.rc2

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2QNSWXQJJHGMCAVOSVDEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlHDGSYACgkQjTAFq1RaXHOPiQCeLe8ZthRwRbaN+80qdw0hyEqn
TZMAniE6gGCSqXyuDSSMI6S+/72Bj1ft
=nSdO
-----END PGP SIGNATURE-----

------enig2QNSWXQJJHGMCAVOSVDEE--
