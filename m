Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaFVBEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 21:04:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54664 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbaFVBEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 21:04:37 -0400
Message-ID: <1403399065.23472.77.camel@deadeye.wl.decadent.org.uk>
Subject: Latency histogram broken after "hrtimer: Set expiry time before
 switch_hrtimer_base()"
From: Ben Hutchings <ben@decadent.org.uk>
To: Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2014 02:04:25 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DgxBcqBuZ0TkEdYciRyx"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DgxBcqBuZ0TkEdYciRyx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In an rt-kernel with CONFIG_MISSED_TIMER_OFFSETS_HIST enabled,
__hrtimer_start_range_ns() now crashes, as new_base is not assigned
before it is used.

I'm not sure how this should be fixed; is it:

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1108,7 +1108,7 @@ int __hrtimer_start_range_ns(struct hrti
=20
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 	{
-		ktime_t now =3D new_base->get_time();
+		ktime_t now =3D base->get_time();
=20
 		if (ktime_to_ns(tim) < ktime_to_ns(now))
 			timer->praecox =3D now;
--- END ---

or:

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1106,6 +1106,11 @@ int __hrtimer_start_range_ns(struct hrti
 #endif
 	}
=20
+	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
+
+	/* Switch the timer base, if necessary: */
+	new_base =3D switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED)=
;
+
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 	{
 		ktime_t now =3D new_base->get_time();
@@ -1117,11 +1122,6 @@ int __hrtimer_start_range_ns(struct hrti
 	}
 #endif
=20
-	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
-
-	/* Switch the timer base, if necessary: */
-	new_base =3D switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED)=
;
-
 	timer_stats_hrtimer_set_start_info(timer);
=20
 	leftmost =3D enqueue_hrtimer(timer, new_base);
--- END ---

or something else?

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-DgxBcqBuZ0TkEdYciRyx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU6Yrnee/yOyVhhEJAQqhKxAA0fqRU9I+r5DHVYXa/1f9y6sg6ecVNx72
w1JVg/MPUpA+VCIXEJtuHASQEVr82xW/6LGcbvAgjj1HhB/kpQMGS+554USkLHJb
jGqCGQbfZhqIr+Fq5BOxWEkoWWMQaJTHl+YKeMQwvSUcbKxLTczPZI1itxQ0mIQV
qv32ldo7/fs/VxFubBeaOXzz+IuMmjuzmAIp0dQ9ngI3JSxY4pQbLEczao41DdaU
uuzVfLZFShgDjGWJnsVJyLR77OG8oWUZthNDKAmsobp4mpggiuG1P2+J55nLaQYN
N/p1FNZ+C9uGRMQF0pgu5caoJdDi5iniNyVQfWwx7tOtupvSSs7/dHaOpzHCi8SH
x8z2JGLY1Igyh91x/WmdMH8zlr9JEPVee8YL+eRc3Q4lHCBfmFynfGSHavReZxFM
5R3XxpxuV1Ga+Zc5umE0JRMy+ewSmjDMYbguprZzpQbIOPw1EKvUaGo0i2aau5DA
PXe1pP0aaDdT7BJ0VFIu3dch+6zqZArsZsolNG6mF0jUlDIhAKy26rz6OYoW9swY
Gw/PytHPNAd9ojOLpwAioxm8rR/7p2+n9ZkE0l80+PaoW5nOR3/qCn0qQrQFrN6T
o07IA3aXkxGYRda7dJDyo2m8BT8yK6weRJPzXwm6ZZDM6sOzUD7Ela11lzQSrPvt
5nWOgV2LVzc=
=EPgs
-----END PGP SIGNATURE-----

--=-DgxBcqBuZ0TkEdYciRyx--
