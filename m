Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3GWKCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:02:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36928 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab3GWKCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:02:06 -0400
Message-ID: <51EE5483.7000201@ti.com>
Date: Tue, 23 Jul 2013 13:01:39 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] omapfb: In omapfb_probe return -EPROBE_DEFER when display
 driver is not loaded yet
References: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com> <20130713182733.GA25019@amd.pavel.ucw.cz>
In-Reply-To: <20130713182733.GA25019@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2JWKLFOMQSOGHRIJDIVLT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2JWKLFOMQSOGHRIJDIVLT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 13/07/13 21:27, Pavel Machek wrote:
> On Wed 2013-07-10 15:08:59, Pali Roh=E1r wrote:
>> * On RX-51 probing for acx565akm driver is later then for omapfb which=
 cause that omapfb probe fail and framebuffer is not working
>> * EPROBE_DEFER causing that kernel try to probe for omapfb later again=
 which fixing this problem
>>
>> * Without this patch display on Nokia RX-51 (N900) phone not working
>>
>> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
>=20
> Tested-by: Pavel Machek <pavel@ucw.cz>

Which kernel version is this? Does it have
dfbc32316c6991010328c21e6046b05bac57eb84 (OMAPFB: defer probe if no displ=
ays)?

Then again, rx51 has tv-output, which probably gets probed early. So omap=
fb
does see one functional display, and starts, even if the LCD is not avail=
able
yet.

> (Actually, do we know which commit broke the ordering? We may want to
> simply revert that one...)

Well, my understand that this is how it's supposed to work. There's no de=
fined
order with the driver probes, and the drivers just have to deal with thei=
r
dependencies not being there yet.

I don't have a perfect solution for this problem for omapfb. omapfb doesn=
't
support dynamically adding displays, so all the displays it uses have to =
be
probed before omapfb. And omapfb doesn't know which displays will be prob=
ed.

The patch below was added for 3.11. Does it fix the issue for you? Perhap=
s it
should be added for 3.10 also.

 Tomi

commit e9f322b4913e5d3e5c5d21dc462ca6f8a86e1df1
Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date:   Thu May 23 16:41:25 2013 +0300

    OMAPFB: use EPROBE_DEFER if default display is not present
   =20
    Currently omapfb returns EPROBE_DEFER if no displays have been probed=
 at
    the time omapfb is probed. However, sometimes some of the displays ha=
ve
    been probed at that time, but not all. We can't return EPROBE_DEFER i=
n
    that case, because then one missing driver would cause omapfb to defe=
r
    always, preventing any display from working.
   =20
    However, if the user has defined a default display, we can presume th=
at
    the driver for that display is eventually loaded. Thus, this patch
    changes omapfb to return EPROBE_DEFER in case default display is not
    found.
   =20
    Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/oma=
p2/omapfb/omapfb-main.c
index 528e453..27d6905 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -2503,7 +2503,7 @@ static int omapfb_probe(struct platform_device *pde=
v)
=20
        if (def_display =3D=3D NULL) {
                dev_err(fbdev->dev, "failed to find default display\n");
-               r =3D -EINVAL;
+               r =3D -EPROBE_DEFER;
                goto cleanup;
        }



------enig2JWKLFOMQSOGHRIJDIVLT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR7lSDAAoJEPo9qoy8lh71/FgQAKLyrva0jQbgw2QXcyn2FS/X
+NhpnYGITQUtXs9W3GcY6edU5hxxEs0tkFcWNGlOkp1AU1HRPnINVEUzDnJ+46+Y
yf1qSsYNC9CfPNkpH2rlBnX5UBcsnEsy4GCuTc6fciKYc6ZJFx3iaCATPZRvjnjQ
NUOKxGM/5kdUflsZy+QMbT4gWLgPZbNbH6fwgaeQ8E851rJlKQ2inYTsHvKhuS4K
yoeSY+72J08+PWs6GrqXr21Viz4QCh72GWOM+KcYugQ7OjVQlFMnDq+FO9WZnvaN
BeIW4DO11oMiCUyKYTeBlhh1R6kg8pSFGl/H+Emt1nZHN91CDcg0wT/ebkOp6Nfg
gUSO1sF8uFkysewROX9Je5LZBKQYTTJh/qaB4i1NRL+6KLe7INSrFl8qCw4jpgXT
wIhpWDofQCbJUQVf3bFzz8ccb8fNyFG1M5FyKWDVExMJckDFIwENLDEWOf2FEC1r
G/1J0mEiTmB7elz8J58QogL7ZLHSIgTT6TJBQhlxUPcXNMphENtnjA4Cng/BWBYy
LCYjp7dpTVa6WXuu6WPSTe3ZTPdtuqHzBrEWqI6qiZ5GbSuTMuyrpXobnzEtV7Uf
bw4DaOnycSOp6M49WKV3DksmlTlCiLXpjj6TuWS9ek7EfCztlY8UatwJwecbGS7n
PRXCtzmC9HfyrRAeXGzo
=2usR
-----END PGP SIGNATURE-----

------enig2JWKLFOMQSOGHRIJDIVLT--
