Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaF1WfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 18:35:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48805 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbaF1WfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 18:35:04 -0400
Message-ID: <1403994888.23472.116.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH rt] Fix latency histogram after "hrtimer: Set expiry time
 before switch_hrtimer_base()"
From: Ben Hutchings <ben@decadent.org.uk>
To: Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, stable-rt@vger.kernel.org
Date: Sat, 28 Jun 2014 23:34:48 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Mn/v6VLcmwGfa1i9Iazs"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mn/v6VLcmwGfa1i9Iazs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In an rt-kernel with CONFIG_MISSED_TIMER_OFFSETS_HIST enabled,
__hrtimer_start_range_ns() now crashes, as new_base is not assigned
before it is used.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Carsten Emde <C.Emde@osadl.org>
Cc: stable-rt@vger.kernel.org
---
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


--=-Mn/v6VLcmwGfa1i9Iazs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU69DDee/yOyVhhEJAQreVw//ax/0bdMfIVtqFn8V8e0mcyz7HS8ngvKc
/sw0ZipnNkUeOye0pY4OIJNdPls/9F54/bpdQF0fnitdS9KwizaUunC7K7D1hwtC
hJH3rxGPvRhzt3Yfd0m0CcT9iVMBjjohQU4UbrNnaaxWBB2TPqaxIV9mVqvCtR6Z
pBL/lXiHDtmffVNRdjRdySqhiZ5V28GW/Kx4/cshbPhodz6b8KojSmgcGHsjKkRW
EttgPWA6pG8dBUbr0JNJDDX+ldnLWK1WO2d4fForeuLilYFa0dmhSAmPQIWBHkel
wvwcJGmLMg/bM+Lzt5sLzxIQxteWvyZpiPS6xPTxl6ROG69IWfaRFF56Nsx25hs7
6d/7p5ZIBf/cWfARbOq3BCiTaesevDsjOVc/yuj8yXBGMDxinKOYb/PVSMCqi8kE
XBd96LZTACPRwz6Ez4jS2uIPBhDoMlxqPffG67zwaPchDpuhT0HojDShlEg0ieiW
eJc8AAb5U73Zhg/90R1pl135E0C9e+U3OJgcYQ7sru/cEqGnPqphE/ESQrP9y9Ye
nOKCTKTO/W1FX/Ck5n9E8SK6S2mezG8c/QwBfdTbmytu6i37Xs1VYOJqMk8mE5pV
aJZsTP4HUYDHztEqRWvMPH6A8iiORG4BD4rgc1IiDnPvz6RrMv4UZxFWMfclIlzq
6WDf6k/FqfQ=
=cWwo
-----END PGP SIGNATURE-----

--=-Mn/v6VLcmwGfa1i9Iazs--
