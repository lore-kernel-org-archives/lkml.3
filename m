Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbbABQtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:49:46 -0500
Received: from smtp1-out.insa-rennes.fr ([193.52.94.24]:29369 "EHLO
	smtp1-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbbABQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:49:45 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 11:49:44 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EABHJplQKBQEl/2dsb2JhbABcg1hYxiyFeQKBGwEBAQEBfYQNAQV4ARALGAkWDwkDAgECAUUGAQwBBwEBySgBAQEBAQEBAwEBAQEBAQEBGo1qgSwKVwcJhCAFj2CBJ02GQYR3IYspAoQRboEEgT8BAQE
Message-ID: <54A6C9B5.4050904@supelec.fr>
Date: Fri, 02 Jan 2015 17:39:17 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>
CC: linux-man <linux-man@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] adjtimex: PPM scaling is by 2^-16
References: <54A2DEAD.2050708@supelec.fr> <20150102024118.GA8293@unpythonic.net> <20150102062920.GB4221@localhost.localdomain>
In-Reply-To: <20150102062920.GB4221@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WDed7UlwH7WVSfpFJjjlwGMbi74ANGlTd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WDed7UlwH7WVSfpFJjjlwGMbi74ANGlTd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

Le 02/01/2015 07:29, Richard Cochran a =E9crit :
> On Thu, Jan 01, 2015 at 08:41:20PM -0600, Jeff Epler wrote:
>> Like Laurent Georget, I found by reading ntpd source
>> the scale is 2^16 (i.e., 1 ~=3D 1.5e-5 ppm, 65536 =3D 1ppm)
>=20
> Yep, you wont find this documented in prose anywhere, not even at
> ntp.org.
>=20
>> -    long freq;        /* Frequency offset, as scaled PPM
>> +    long freq;        /* Frequency offset, in units of 2^-16 PPM
>>                           (parts per million) */
>=20
> This wording is correct.
>=20
> IMHO, it is more understandable when you explain that this field is a
> fixed point number, with a 16 bit binary fraction. For example, see
> the comment in the function, ppb_to_scaled_ppm(), in
> Documentation/ptp/testptp.c.
>=20

Ah, ok, I finally understood what you meant by "fractional part".
Perhaps we could explicit it in the man page like in the following patch?=

---
 man2/adjtimex.2 | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 18823c8..ff4b23e 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -54,9 +54,8 @@ struct timex {
     long offset;      /* Time offset; nanoseconds, if STA_NANO
                          status flag is set, otherwise
                          microseconds */
-    long freq;        /* Frequency offset, as scaled PPM
-                         (parts per million) */
-.\" FIXME What is the scaling unit of timex.freq?  2^16 ?
+    long freq;        /* Frequency offset, in units of 2^-16 PPM
+                         (parts per million) (see NOTES below) */
     long maxerror;    /* Maximum error (microseconds) */
     long esterror;    /* Estimated error (microseconds) */
     int  status;      /* Clock command/status */
@@ -72,13 +71,13 @@ struct timex {
                          flag is set, otherwise microseconds */
     long tick;        /* Microseconds between clock ticks */
     long ppsfreq;     /* PPS (pulse per second) frequency
-                         (scaled PPM, read-only) */
+                         (2^-16 PPM (see NOTES), read-only) */
     long jitter;      /* PPS jitter (read-only); nanoseconds, if
                          STA_NANO status flag is set, otherwise
                          microseconds */
     int  shift;       /* PPS interval duration
                          (seconds, read-only) */
-    long stabil;      /* PPS stability (scaled PPM, read-only) */
+    long stabil;      /* PPS stability (2^-16 PPM (see NOTES),
read-only) */
     long jitcnt;      /* PPS jitter limit exceeded (read-only) */
     long calcnt;      /* PPS calibration intervals (read-only) */
     long errcnt;      /* PPS calibration errors (read-only) */
@@ -343,6 +342,18 @@ and the caller does not have sufficient privilege.
 Under Linux, the
 .B CAP_SYS_TIME
 capability is required.
+.SH NOTES
+In struct
+.IR timex ,
+.IR freq ,
+.IR ppsfreq ,
+and
+.I stabil
+are PPM (parts per million) with a 16-bits fractional part, which means
that a
+value of 1 in one of those fields actually means 2^-16 PPM, and
2^16=3D65535 is
+1 PPM. This is the case for both input values (in the case of
+.IR freq )
+and output values.
 .SH CONFORMING TO
 .BR adjtimex ()
 is Linux-specific and should not be used in programs
--=20
2.0.4

Laurent


--WDed7UlwH7WVSfpFJjjlwGMbi74ANGlTd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlSmycEACgkQRTidSplJch5ENAD/XdF79IWLTef6IXyP+hQPbxXY
wnKiNh0fd40LNtvmOfYBALic0bJ/hEkxBUYjhf1H7xBnWYAlaJ1XJZttb6weCVgX
=Oe0Q
-----END PGP SIGNATURE-----

--WDed7UlwH7WVSfpFJjjlwGMbi74ANGlTd--
