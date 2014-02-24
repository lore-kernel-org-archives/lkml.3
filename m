Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaBXUvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:51:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48467 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaBXUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:51:07 -0500
Date: Mon, 24 Feb 2014 21:50:58 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] regulator: core: Fix ops->enable/disable usage
Message-ID: <20140224205058.GA18317@pengutronix.de>
References: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
 <20140223051209.GK25940@sirena.org.uk>
 <CAOMZO5BPvCcx_f09Khuw8MVxrR18fnv9e1xeuJ0c_8G22AR53g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <CAOMZO5BPvCcx_f09Khuw8MVxrR18fnv9e1xeuJ0c_8G22AR53g@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:34:53 up 184 days,  6:05, 46 users,  load average: 0.12, 0.07,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fabio,

On Mon, Feb 24, 2014 at 02:23:50PM -0300, Fabio Estevam wrote:
> On Sun, Feb 23, 2014 at 2:12 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Thu, Feb 20, 2014 at 05:36:02PM +0100, Markus Pargmann wrote:
> >> Hi,
> >>
> >> These two patches replace all ops->enable/disable by
> >> _regulator_do_disable/enable function calls. These wrappers also handl=
e gpio
> >> regulators.
> >
> > Applied both, thanks.
>=20
> With these two patches applied I get the following error on
> mx6qsabresd running today's linux-next:
>=20
> vdd1p1: failed to enable
> anatop_regulator regulator-1p1.2: failed to register vdd1p1
> anatop_regulator: probe of regulator-1p1.2 failed with error -22
> vdd3p0: failed to enable
> anatop_regulator regulator-3p0.3: failed to register vdd3p0
> anatop_regulator: probe of regulator-3p0.3 failed with error -22
> vdd2p5: failed to enable
> anatop_regulator regulator-2p5.4: failed to register vdd2p5
> anatop_regulator: probe of regulator-2p5.4 failed with error -22
> vddarm: 725 <--> 1450 mV at 1100 mV
> vddpu: 725 <--> 1450 mV at 1100 mV
> vddsoc: 725 <--> 1450 mV at 1175 mV
> ....
>=20
> pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
> pfuze100-regulator 1-0008: FAB: 0, FIN: 0
> SW1AB: failed to enable
> pfuze100-regulator 1-0008: register regulatorSW1AB failed
> pfuze100-regulator: probe of 1-0008 failed with error -22
>=20
>=20
> Reverting these two patches the regulators probe successfully.
>=20
> Any ideas?

Thanks, I just searched for the reason and found it. My patches do not
handle dummy regulators correctly:

_regulator_do_enable() line 1764:
        if (rdev->ena_pin) {
                ret =3D regulator_ena_gpio_ctrl(rdev, true);
                if (ret < 0)
                        return ret;
                rdev->ena_gpio_state =3D 1;
        } else if (rdev->desc->ops->enable) {
                ret =3D rdev->desc->ops->enable(rdev);
                if (ret < 0)
                        return ret;
        } else {
                return -EINVAL;
        }

The only situation where this returns -EINVAL is a dummy regulator that
is not always_on. As it doesn't make sense to have a dummy regulator
that is not always_on, I will add a check for exactly this situation to
the regulator_register function and drop the "return -EINVAL" above.

Regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTC7CyAAoJEEpcgKtcEGQQuycP/RLA9jVO3IyGp8YTaPJRJXkN
Ht0V4ClglKGTQ/FlalQaCtb5K7aJhqDVUaYjW3kuPGtMT9dwx34PA3+unU//3ugi
fV4IDUlWs3U8RuIEGROPwQAk+q/22HiO51e0K2KFAW7LNWaG15LwaFNYY4rDylVl
RxqdSBcKOWINiSgPPf97fcMNTLOhdPgrmUgRjeBnsTGpF7DrimdrTfyaxiAkKj9s
z4Beot+P4CstrzuCc5zhvgcaTczS1zHaQoyw0rLPjN8L0oPX2bPiMaxdpZY3QzDX
gx6jj1cPfhEGy+JOsFvzhKI4xHK7Jj9ie4nnBwiwZdnaNasaii9Nuc6W19mznoa2
CIvY5b0fqju3szOZh3t5eyQ0txaoxZBWZ7Zo25SwixwbpPVz6aK68X/4INxaqVrw
rnMy4Pb6LsloEHQ0+wQJmcYZjjVfsA6l6Ji10pvUcht6zquuGrqKT1+WfRrm03Dg
OFzcg6YEY6scMUMwtWEsgmWq9q1M33DJJiwqvlrf8hl7bPNNsDj4ixVddiY53Nhn
xaMAaGE6tP/9EJqa8Z+BgROgl40dQVV6pBl6JSEURPuDBEFTKPxyLLrrXlJ34WU+
4PHQ7SXGmFCaX/plD7OS9VO0Tl75SldnF9wztlctzCS2Y4Xtob3JoH4kJfG6Qu1E
nkuLP6fLCSm3Lo1L+wN4
=tj9x
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
