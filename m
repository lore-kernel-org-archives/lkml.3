Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaA1Huu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:50:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53361 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaA1Hus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:50:48 -0500
Message-ID: <52E7614E.8010903@ti.com>
Date: Tue, 28 Jan 2014 09:50:38 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com>
In-Reply-To: <52E697C0.6000202@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pCIia1f2wkOdMp1h5t0Gj0gRFEppCWOVo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pCIia1f2wkOdMp1h5t0Gj0gRFEppCWOVo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-27 19:30, Ivaylo Dimitrov wrote:
> Hi Tomi,
>=20
> linux-next-20140124 DSS is broken on N900  - display stays black (there=

> is some noise though). I booted the kernel with qemu and it gives the
> following warning:
>=20
> [    0.623779] DSS: set fck to 172800000
> [    0.624237] ------------[ cut here ]------------
> [    0.624298] WARNING: CPU: 0 PID: 1 at
> drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
> [    0.624359] clk rate mismatch: 288000000 !=3D 172800000

That says that the omapdss tries to set the func clock to 172.8 MHz, but
after setting the rate, the clock is at 288 MHz.

I just hit the same warning with beagle-xm yesterday, with v3.13-rc6 +
DSS device tree patches, although it might be a different thing. I see
that the actual clock is lower than what omapdss tries to set, you have
the other way around.

The beagle-xm issue is related to a clk-divider fix I have sent some
time ago:

http://mid.gmane.org/1383736008-22764-1-git-send-email-tomi.valkeinen@ti.=
com

Basically the issue is that omapdss needs to produce very precise pixel
clocks, derived from fck, but the fck rate options are quite limited. So
omapdss tries to find out what kind of rates it could get for the fck,
i.e. it does the clock divider calculations itself that would normally
be left to the clock framework.

That means the omapdss should do rounding the same way as the clock
framework does. But clock framework has no rules about the rounding, so
omapdss easily gets it wrong. And when you add the bug for which I
posted the patch above, it seems the omapdss clock calculations are not
very functional at the moment with fractional clock rates.

However, I think the issue I see with beagle-xm should always result in
lower actual fck than requested, but you see the other way around. So I
wonder if it's something else... N900 clock calculations do initiate
from sdi.c, instead of dpi.c for beagle, but they do look rather
similar, and use the same helper functions from dss.c and dispc.c.

How is the dss clock calculated on n900? Can you attach
debug/clk/clk_summary output?

 Tomi



--pCIia1f2wkOdMp1h5t0Gj0gRFEppCWOVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS52FRAAoJEPo9qoy8lh71xAcP/A7Wq7phKz2s7611nubBgd6O
Uvotnb9896BTPaefhunHHudUdergZb5iZVAeHrOMgT6Nhemppn0BcT25T7nr/4ba
AEtvJOFlMcXbQeTXpoUrDAsTZsLSLPpBNw3jZDuLKciCE4WpYVLWBpR88DyYIblr
z0hgfQmojViUNT+uPs04G02eXHMQQmEbQ28q4+sD16ZAmscH7N2WAj/2YSZgr0BS
Fa34q3D6DoTQ7XBM3oLcrDBdUqkmkdot2fTg/NXT5sFpK6fwk3fURy8D36bSsfJJ
NPFpkYl1BJdklwH7DryAQOXSjIWE8dpqowiKMm7+O42+tZ1eEvbo96yDLKKpMmsU
W0QGI+SUbLyiy5lkrD/8TNz0YrSsqi7RT+o3NrfXJGDxdOfgNciYSZblEG9NRTdK
dg8o228QDeND38tZ/s2PrPrI3TbKUULOe1+BPDYoepei6Ovf/FOkjixqLabeEyQN
2eBoy0nT83rOIAk2rGeWqgoBM37aWHY1BzNmmLa3KiCPdYMe6eTMVhcoaotnmNIt
2wI3N/cmuRPlmU6Tqg3/NypSCFIJgBO/fA464V2VOwPpNMZfwf5Umh4XguVEeqes
r28/CAnPaMLh7c6Vz6sF0Ohq86368v/VVoCKjdtEPJgr32Jh8FtrdfQKn7mupCGC
T+mQ6f7BPlucbc00Swel
=uDYS
-----END PGP SIGNATURE-----

--pCIia1f2wkOdMp1h5t0Gj0gRFEppCWOVo--
