Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaA1Isl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:48:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33145 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaA1Isj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:48:39 -0500
Message-ID: <52E76EE0.2060006@ti.com>
Date: Tue, 28 Jan 2014 10:48:32 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <52E7614E.8010903@ti.com>
In-Reply-To: <52E7614E.8010903@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="5UIu2a65WQKuCBfU6p7dn8AL3NQU9TVln"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5UIu2a65WQKuCBfU6p7dn8AL3NQU9TVln
Content-Type: multipart/mixed;
 boundary="------------010608070906040804010603"

This is a multi-part message in MIME format.
--------------010608070906040804010603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-28 09:50, Tomi Valkeinen wrote:
> On 2014-01-27 19:30, Ivaylo Dimitrov wrote:
>> Hi Tomi,
>>
>> linux-next-20140124 DSS is broken on N900  - display stays black (ther=
e
>> is some noise though). I booted the kernel with qemu and it gives the
>> following warning:
>>
>> [    0.623779] DSS: set fck to 172800000
>> [    0.624237] ------------[ cut here ]------------
>> [    0.624298] WARNING: CPU: 0 PID: 1 at
>> drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
>> [    0.624359] clk rate mismatch: 288000000 !=3D 172800000
>=20
> That says that the omapdss tries to set the func clock to 172.8 MHz, bu=
t
> after setting the rate, the clock is at 288 MHz.
>=20
> I just hit the same warning with beagle-xm yesterday, with v3.13-rc6 +
> DSS device tree patches, although it might be a different thing. I see
> that the actual clock is lower than what omapdss tries to set, you have=

> the other way around.
>=20
> The beagle-xm issue is related to a clk-divider fix I have sent some
> time ago:
>=20
> http://mid.gmane.org/1383736008-22764-1-git-send-email-tomi.valkeinen@t=
i.com

I made a somewhat hacky quickfix for beagle. Applying that and the
clk-divider from the link above makes things work for me. However, as I
said, the issue with n900 might be different, but it'd be interesting to
hear if it has any effect.

 Tomi


--------------010608070906040804010603
Content-Type: text/x-diff;
 name="0001-OMAPDSS-DSS-fclk-rate-rounding-test.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-OMAPDSS-DSS-fclk-rate-rounding-test.patch"

=46rom f633a151a01b06a7b86107d93f9f53e05601c02c Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Tue, 28 Jan 2014 10:19:07 +0200
Subject: [PATCH] OMAPDSS: DSS: fclk rate rounding test

---
 drivers/video/omap2/dss/dss.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/video/omap2/dss/dss.c b/drivers/video/omap2/dss/dss.=
c
index 9009f62defd0..de35be6d6e20 100644
--- a/drivers/video/omap2/dss/dss.c
+++ b/drivers/video/omap2/dss/dss.c
@@ -473,8 +473,22 @@ bool dss_div_calc(unsigned long pck, unsigned long f=
ck_min,
 	fckd_stop =3D max(DIV_ROUND_UP(prate * m, fck_hw_max), 1ul);
=20
 	for (fckd =3D fckd_start; fckd >=3D fckd_stop; --fckd) {
+		unsigned long rfclk;
 		fck =3D prate / fckd * m;
=20
+		/* do we get the right rate with this? */
+		rfclk =3D clk_round_rate(dss.dss_clk, fck);
+
+		if (rfclk !=3D fck) {
+			/* no we don't. try rounding the other way */
+			fck +=3D 1;
+
+			rfclk =3D clk_round_rate(dss.dss_clk, fck);
+
+			if (rfclk !=3D fck)
+				DSSERR("mismatch %lu !=3D %lu\n", rfclk, fck);
+		}
+
 		if (func(fck, data))
 			return true;
 	}
--=20
1.8.3.2


--------------010608070906040804010603--

--5UIu2a65WQKuCBfU6p7dn8AL3NQU9TVln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS527gAAoJEPo9qoy8lh712VUP/3/lm5UJfh9ScxQ+REJ9Kq29
ih9oSVKl8IhFN2JAO3B/Xh/aqrwCJmQLrHfy7cGRD/8iRQEVrBktQdkhMdJIXjxv
37NGFmc5WiiuaXekqtDvBRVNHJLpdKFXiiO/7yBNxQjBEBDx/qqhd4ltXSpIrtBI
M3hVJi1o9aRq1ch6iWT3afUoBA1w7SPPU1AEEerKp7WIlC0L7c2afC0Rati66cWO
dD69DMXMScVacYueEEwmfLa4N3UfsZmwYQKX0u4kMPtToBcawRBgP+eS9HA2WVQI
qagiOSIpTzvzhpwJ969PU5yTp1YT/E7xy/ohwG71BWa3b6eDpmVcFW5J/gWafKfX
7hq8tT9z/P/Z5szrteQebklkJnysrmg1nh4ZQi9AVFdg1h/rk8XSGyk+Tn3THg/6
Vum79onQUsdy0Rfk4mp00SN2jjDc3Cye0ytxBm1688DEzFm6BcvbQFSfqn/Si2DK
EgXRSfMxDL5FuOMsDBI9+Th6SdB7s2xW8Nmbg+jH7fU5sKc0LqPw5Xw14je/Cxm7
cbXH3EPa+bRKx99REck8IZKWjn6fc9etXVRn6NZPhsjXW+mmWAPHjXjFT2wNrXvA
fX4fVwI7FaLM6tRT+d/SspVTdz5XwPEMWg4l7cDFqoKxVTZQhs3jcdNFl337A9Fq
xd1aF6g94rvujQGoFNeU
=ZyZY
-----END PGP SIGNATURE-----

--5UIu2a65WQKuCBfU6p7dn8AL3NQU9TVln--
