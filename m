Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3BUUCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:02:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3BUUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:02:12 -0500
Message-ID: <1361476966.3827.44.camel@fourier>
Subject: Re: [PATCH] Input: fix Cypress PS/2 Trackpad in Dell XPS12
From: Kamal Mostafa <kamal@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Dudley Du <dudl@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>
Date: Thu, 21 Feb 2013 12:02:46 -0800
In-Reply-To: <20130221195630.GA20344@core.coreip.homeip.net>
References: <1361472955-16759-1-git-send-email-kamal@canonical.com>
	 <20130221195630.GA20344@core.coreip.homeip.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JYDbkyVei1WBi5GkM2sV"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JYDbkyVei1WBi5GkM2sV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-02-21 at 11:56 -0800, Dmitry Torokhov wrote:
> On Thu, Feb 21, 2013 at 10:55:55AM -0800, Kamal Mostafa wrote:
> > Avoid firmware glitch in Cypress PS/2 Trackpad firmware version 11
> > (as observed in Dell XPS12) which prevents driver from recognizing
> > the trackpad.
> >=20
> > BugLink: http://launchpad.net/bugs/1103594
> >=20
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > Cc: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/cypress_ps2.c |   19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cy=
press_ps2.c
> > index 1673dc6..f51765f 100644
> > --- a/drivers/input/mouse/cypress_ps2.c
> > +++ b/drivers/input/mouse/cypress_ps2.c
> > @@ -236,6 +236,13 @@ static int cypress_read_fw_version(struct psmouse =
*psmouse)
> >  	cytp->fw_version =3D param[2] & FW_VERSION_MASX;
> >  	cytp->tp_metrics_supported =3D (param[2] & TP_METRICS_MASK) ? 1 : 0;
> > =20
> > +	/*
> > +	 * Trackpad fw_version 11 (in Dell XPS12) yields a bogus response to
> > +	 * CYTP_CMD_READ_TP_METRICS so do not try to use it. LP: #1103594.
> > +	 */
> > +	if (cytp->fw_version >=3D 11)
> > +		cytp->tp_metrics_supported =3D 0;
> > +
>=20
> Isn't this the only chunk that is actually needed to fix the issue?

No, the other parts are needed also:  The handling of
tp_metrics_supported gets moved so that the default values now get set
first, then overridden only if tp_metrics_supported is true.
Previously, the defaults wouldn't get set if it wasn't true (which was a
bug that never manifested).

 -Kamal


> Thanks.
>=20
> >  	psmouse_dbg(psmouse, "cytp->fw_version =3D %d\n", cytp->fw_version);
> >  	psmouse_dbg(psmouse, "cytp->tp_metrics_supported =3D %d\n",
> >  		 cytp->tp_metrics_supported);
> > @@ -258,6 +265,9 @@ static int cypress_read_tp_metrics(struct psmouse *=
psmouse)
> >  	cytp->tp_res_x =3D cytp->tp_max_abs_x / cytp->tp_width;
> >  	cytp->tp_res_y =3D cytp->tp_max_abs_y / cytp->tp_high;
> > =20
> > +	if (!cytp->tp_metrics_supported)
> > +		return 0;
> > +
> >  	memset(param, 0, sizeof(param));
> >  	if (cypress_send_ext_cmd(psmouse, CYTP_CMD_READ_TP_METRICS, param) =
=3D=3D 0) {
> >  		/* Update trackpad parameters. */
> > @@ -315,18 +325,15 @@ static int cypress_read_tp_metrics(struct psmouse=
 *psmouse)
> > =20
> >  static int cypress_query_hardware(struct psmouse *psmouse)
> >  {
> > -	struct cytp_data *cytp =3D psmouse->private;
> >  	int ret;
> > =20
> >  	ret =3D cypress_read_fw_version(psmouse);
> >  	if (ret)
> >  		return ret;
> > =20
> > -	if (cytp->tp_metrics_supported) {
> > -		ret =3D cypress_read_tp_metrics(psmouse);
> > -		if (ret)
> > -			return ret;
> > -	}
> > +	ret =3D cypress_read_tp_metrics(psmouse);
> > +	if (ret)
> > +		return ret;
> > =20
> >  	return 0;
> >  }
> > --=20
> > 1.7.10.4
> >=20
>=20


--=-JYDbkyVei1WBi5GkM2sV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJRJn1mAAoJEHqwmdxYrXhZisoP/iMSYrvcLaOi/pOtc9qJOksi
yBGVuULmWpQ5h2UnYZ9StgQnsNlp1mcUGfmEILRSHu7Ruv63icixccK55I+GzwWK
ztQdlNiqU9PIPlkpYUPcaov/bEuMfrvDDim2wwFmPZdbSb7BI1Ypn4/WAdjDqbF5
tDyVDWK1ww8BtFupJVH2dndv5LwRypYd3kaNDWJLs2OcHd2NnIUXHtnAq9sCqWYN
hakZHUkEcqZpWMH2t7D7vaeug/KMwb6OmO+9JZ3qilOLYIQMEZlsKOKxoBH0kWEu
Upr8TFcXA1Blv54iOw0me8LIM031fM1HGZwqujvSEZhdu0+RAhglLxtoAVda+ein
MWDo5uQaqRx6MmQW+edmby1ZfhbKZxAaZKiYFmsYJDdll9YHUaTCcDZofmQM5RWi
N4xBuP2s/A40QtazyXZr2krvI6d30V5JYzv5gD/0itrmGFXQigYt61Q6u3XfJPNO
L084FnCB0+ngzQ00jfF+UDBxehef93Mdbi4YoahIX1y+aITaLYMsyQUu9opsA/v4
yFVFtzWmavNxNk+BNNVL031vlL97xGQhnfrT8pbJy1LyIDyeuEn67dTnHkx9s3MC
B0UcPpSkf2WhNv475rE5RRhrxOT4XX2s9ciJvMG8xEhSElHo3QM5/YQNgpQvIeen
IoDaHE5nVCifpkqLl/Ot
=uBV9
-----END PGP SIGNATURE-----

--=-JYDbkyVei1WBi5GkM2sV--

