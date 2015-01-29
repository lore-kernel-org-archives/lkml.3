Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbbA2IJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:09:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55502 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbA2IJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:48 -0500
Message-ID: <54C9EAC3.9040509@ti.com>
Date: Thu, 29 Jan 2015 10:09:39 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "S. Gilles" <sgilles@terpmail.umd.edu>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maik Broemme <mbroemme@plusserver.de>
CC: linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: i915 framebuffer init too slow to find logo
References: <20150129023247.GA10967@number16>
In-Reply-To: <20150129023247.GA10967@number16>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="q0eQ7vntRxq811qSPhVrSQi2OgL34BqWS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--q0eQ7vntRxq811qSPhVrSQi2OgL34BqWS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29/01/15 04:32, S. Gilles wrote:
> Since commit 92b004d1aa9f367c372511ca0330f58216b25703 : prevent use of
> logs after they have been freed, my i915 machine has no logo on boot
> (reverting that commit brings it back on recent trees). My .config
> builds nothing but wireless as =3Dm, so I think this is a genuine false=

> positive (as predicted by the commit). Examining an augmented dmesg,

It's not so much about modules, but when the code tries to use the
logos. Drivers as modules might cause the use of logos to happen later,
but that's only one possible reason.

> it appears that the framebuffer setup is too slow by about 0.3s, which
> I wouldn't really expect from this system/driver.
>=20
> Is this slowness considered worth fixing, or is this issue considered
> too cosmetic? (Or is this just PEBKAC?)
>=20
> Possibly useful information:
>=20
> $ lspci | grep VGA
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Cor=
e Processor Family Integrated Graphics Controller (rev 09)
>=20
> From various printk()s, it looks like the slow portion of
> fb_console_init() is restore_fbdev_mode(), specifically
> drm_mode_set_config_internal(), which takes about 0.45s, while the
> fb_logo_late_init() call happens about 0.15s into that. I can give the
> full details if requested.

When does the driver probe() happen? Does the initialization happen
outside of the probe(), via workqueue or such? If so, then the fix is
valid for your case also, as the work could be ran after the logos have
been freed.

However, it does seem that the fix seems to cause logos to disappear for
many people. I'd be interesting to know how many of those cases were
working by luck, either by

1) an async work being ran fast enough, before the logos had been freed
2) the use of logos happening after the logos had been freed, but if no
one had trashed the logo memory yet, it still works

I don't care so much about the logo myself but people do seem to like
it, so perhaps we need to change the code as Thierry suggested:
allocating memory for the logos and keeping them in memory until someone
uses them the first time, and then free the memory.

 Tomi



--q0eQ7vntRxq811qSPhVrSQi2OgL34BqWS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyerDAAoJEPo9qoy8lh71szMP/05QLKcO6VCmD6ftyD0sCSX0
/SKwkU+QGNp2unCsilVEZxXtlPIEnNf1qb64Osz/V/okErxDHm9Ahu4K3BiDh/i0
ooSk0z/4XhqpshvpTPk+o2gix/luaaoxHPRwju97kg/Q0IgrlFIeciC3d+Uyr2mi
dozO07ujQ1B17Gb3cbselGutF1ZuULhXXEH1D+Tgyg61PAzMLNhtcaUCoLrziNhO
9C6czMYOuLSvabq+h6emxhlgCvGr8Jqllk5Hh3Nu7vMolQqJNxkSh45TGeEcmS9b
T0g5/HBfIMWQ0vcJzXylvaomtCeml/LcTEbl/cG6fpI4kMTUGVYlUNd+yAiCwWBU
FqHkIPr173kodrW2EU1CXQGw07vtLYx7/9IlKYGt97TI8h615GyBDNhaqbGfnP14
/8ii/MfNJOlf4vUHwVTZF02xwEzNO/tKLIDH/R2ZQ6G3ZGy9+BF6lqTkmv14E3sV
vTQ4O18DbaA/Y4Tl5CK1/PZ4KPDoFATX0kFY6pw0j4JbyUJOyG3Zw5OVLPJzU7yL
N4WAXiCfA0y2S6zELG49SYLIT+JIh6mZ9nQXRTwICze8VXHDmA5SAGl1zpat1OGP
6YzKK68noCwPROkrbOwRMiNS2I94zZR8OSEKfgXpTVuQ9pM2NHGzsqhUhw3mOPTf
ed0AQAoFTz5V55KgjU33
=9ijX
-----END PGP SIGNATURE-----

--q0eQ7vntRxq811qSPhVrSQi2OgL34BqWS--
