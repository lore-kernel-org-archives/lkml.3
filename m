Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKKARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:17:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbaKKARv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:17:51 -0500
Date: Tue, 11 Nov 2014 11:17:38 +1100
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH 2/2] mmc: core: reset sdio card properly on resume.
Message-ID: <20141111111738.1e7856ce@notabene.brown>
In-Reply-To: <CAPDyKFrrOozTO5xR8RO=4L8xZ9hLGizH=2mxZE=5zvwMhhgD+w@mail.gmail.com>
References: <20141108000919.5629.55381.stgit@notabene.brown>
	<20141108001411.5629.55298.stgit@notabene.brown>
	<CAPDyKFrrOozTO5xR8RO=4L8xZ9hLGizH=2mxZE=5zvwMhhgD+w@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/oK0KWU+x9eVq04gI5x=.X9S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oK0KWU+x9eVq04gI5x=.X9S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Nov 2014 14:29:19 +0100 Ulf Hansson <ulf.hansson@linaro.org> wro=
te:

> On 8 November 2014 01:14, NeilBrown <neilb@suse.de> wrote:
> > mmc_sdio_power_restore calls
> >         mmc_send_if_cond(host, host->ocr_avail);
> >
> >         ret =3D mmc_send_io_op_cond(host, 0, NULL);
> >
> > between mmc_go_idle() and  mmc_sdio_init_card().
> > mmc_sdio_resume needs to as well, else my libertas sdio wifi
> > device doesn't resume properly from suspend.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  drivers/mmc/core/sdio.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> > index e636d9e99e4a..3f069a6f448f 100644
> > --- a/drivers/mmc/core/sdio.c
> > +++ b/drivers/mmc/core/sdio.c
> > @@ -981,8 +981,12 @@ static int mmc_sdio_resume(struct mmc_host *host)
> >         if (mmc_card_is_removable(host) || !mmc_card_keep_power(host)) {
> >                 sdio_reset(host);
> >                 mmc_go_idle(host);
> > -               err =3D mmc_sdio_init_card(host, host->card->ocr, host-=
>card,
> > -                                       mmc_card_keep_power(host));
> > +               mmc_send_if_cond(host, host->ocr_avail);
>=20
> /s /host->ocr_avail /host->card->ocr
>=20
> I would expect that to work. I do realize that "host->ocr_avail" is
> being used in the ->power_restore() callback, but I think that's wrong
> as well. Could you maybe verify that changing to host->card->ocr works
> in this path as well? That's would of course be a separate patch.

Hi Ulf,
 I made the substitution in mmc_sdio_resume and mmc_sdio_power_restore
and my sdio device continues to work, including after resume.

The  host->card->ocr value is 0x10000, the host->ocr_avail value is 0x18000.

If you like I'll send the two patches formally, but it might be a day or so.

Thanks,
NeilBrown


>=20
> > +               err =3D mmc_send_io_op_cond(host, 0, NULL);
> > +               if (!err)
> > +                       err =3D mmc_sdio_init_card(host, host->card->oc=
r,
> > +                                                host->card,
> > +                                                mmc_card_keep_power(ho=
st));
> >         } else if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(=
host)) {
> >                 /* We may have switched to 1-bit mode during suspend */
> >                 err =3D sdio_enable_4bit_bus(host->card);
> >
> >
>=20
> Kind regards
> Uffe


--Sig_/oK0KWU+x9eVq04gI5x=.X9S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGFVojnsnt1WYoG5AQKEhw/9GNEGBirwJzOzDMMGDazcF3qQC+g6fATM
5OysuTkyzO+Ns5OxB8mYSX/jR0XpiIsJvPW5PPwON7AritpARMiUsGpZJSbk0c8a
pVWCcb0VhokUe2GWMezsJ66n1f8vzUXmVC3Adi5AMqh4hhM007FWyCUAexVvBmru
My3vrIh9JEUC6p3XX03ulvw8kjET6X006YzzgfUILaDQp3ZoGWFYRsGEdKqUE8wf
ZN6jEqRngnlCo1mV9DDm3bjXqXcorQK1PHA+fy1y61ywOpe/meSdJ2uGrT23D9Xp
mrCqvGmvTZuxtT3bjkBGLwrpKPxJ1JS9l56DUoiE9sI5+/P4uB0cK2QuZWMQRszC
ZA0CqBT0xQum3PaXUVBNy96N5izTvKh78P0sA0Fj+VNiH576UwzE9wnWUdbwG+7c
8+ZqDtQdvhx2V2MWocP2p0/QKX1G9xRAfZyirBM+WE6cPZtBBZeEu0qb5QWh9bFy
FM7IvskbRTbXTXt3KYo8QL3kleXHp1Mhu4Z5neknMTYhGC/2e1/lqKh9VXWs1hU9
TyEFsB0NzU/M9Kg7EpQSsnTlDmWnltr593C8T8BdSHKtijEudpuKgVUX80BnwNeD
ieHQLABVR7YhlVkaF8A/og133o/A1J0vnOwnCQUYv9cOUB61EEN4Xsz/t+a6UF3B
Ohwjk9Gpm2o=
=aOyl
-----END PGP SIGNATURE-----

--Sig_/oK0KWU+x9eVq04gI5x=.X9S--
