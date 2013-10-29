Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab3J2RWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:22:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286Ab3J2RW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:22:28 -0400
Date: Tue, 29 Oct 2013 12:22:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Balaji T K <balajitk@ti.com>,
        Daniel Mack <zonque@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] mmc: omap_hsmmc: Enable SDIO IRQ.
Message-ID: <20131029172229.GA12193@gimli>
Reply-To: <balbi@ti.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
 <1380971830-21492-3-git-send-email-afenkart@gmail.com>
 <20131008161131.GD13128@radagast>
 <CALtMJECWCqBy4UCtuSZ7WtXaizjmgdaxW7pn5uL0ymuXPn=61A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <CALtMJECWCqBy4UCtuSZ7WtXaizjmgdaxW7pn5uL0ymuXPn=61A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 29, 2013 at 04:06:58PM +0100, Andreas Fenkart wrote:
> >> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsm=
mc.c
> >> index 94d6dc8..53beac4 100644
> >> --- a/drivers/mmc/host/omap_hsmmc.c
> >> +++ b/drivers/mmc/host/omap_hsmmc.c
> >> @@ -130,6 +130,7 @@ static void apply_clk_hack(struct device *dev)
> >>  #define TC_EN                        (1 << 1)
> >>  #define BWR_EN                       (1 << 4)
> >>  #define BRR_EN                       (1 << 5)
> >> +#define CIRQ_EN                      (1 << 8)
> >>  #define ERR_EN                       (1 << 15)
> >>  #define CTO_EN                       (1 << 16)
> >>  #define CCRC_EN                      (1 << 17)
> >> @@ -210,6 +211,10 @@ struct omap_hsmmc_host {
> >>       int                     reqs_blocked;
> >>       int                     use_reg;
> >>       int                     req_in_progress;
> >> +     int                     flags;
> >> +#define HSMMC_RUNTIME_SUSPENDED      (1 << 0)        /* Runtime suspe=
nded */
> >> +#define HSMMC_SDIO_IRQ_ENABLED       (1 << 1)        /* SDIO irq enab=
led */
> >> +
> >>       struct omap_hsmmc_next  next_data;
> >>       struct  omap_mmc_platform_data  *pdata;
> >>  };
> >> @@ -490,27 +495,40 @@ static void omap_hsmmc_stop_clock(struct omap_hs=
mmc_host *host)
> >>  static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
> >>                                 struct mmc_command *cmd)
> >>  {
> >> -     unsigned int irq_mask;
> >> +     u32 irq_mask =3D INT_EN_MASK;
> >> +     unsigned long flags;
> >>
> >>       if (host->use_dma)
> >> -             irq_mask =3D INT_EN_MASK & ~(BRR_EN | BWR_EN);
> >> -     else
> >> -             irq_mask =3D INT_EN_MASK;
> >> +             irq_mask &=3D ~(BRR_EN | BWR_EN);
> >
> > is this a bugfix ? should it be sent as a separate patch ?
>=20
> maybe the u32, but otherwise it's just shorter... shall I drop it.

no, now I saw what you did ;-)

> >>
> >>       /* Disable timeout for erases */
> >>       if (cmd->opcode =3D=3D MMC_ERASE)
> >>               irq_mask &=3D ~DTO_EN;
> >>
> >> +     spin_lock_irqsave(&host->irq_lock, flags);
> >
> > why do you need this new locking here ? register acesses are atomic,
> > right ? If you really do need the locking, should it be a separate patch
> > as well ?
>=20
> because host->flags can be accessed from irq context as well

fair point :-)

> >>  static void omap_hsmmc_disable_irq(struct omap_hsmmc_host *host)
> >>  {
> >> -     OMAP_HSMMC_WRITE(host->base, ISE, 0);
> >> -     OMAP_HSMMC_WRITE(host->base, IE, 0);
> >> +     u32 irq_mask =3D 0;
> >> +     unsigned long flags;
> >> +
> >> +     spin_lock_irqsave(&host->irq_lock, flags);
> >> +     /* no transfer running, need to signal cirq if */
> >
> > if... ?
> >
> >> +     if (host->flags & HSMMC_SDIO_IRQ_ENABLED)
> >> +             irq_mask |=3D CIRQ_EN;
> >> +     OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
> >
> > the whole fiddling with STAT and ISE registers look very bogus to me
> > (even on current state before this patch). We shouldn't be clearing
> > pending IRQ events here, right ? We could miss IRQs due to that.
>=20
> sdio_claim_host excludes multiple users and  typical users are using sync=
hronous
> communication, issue a transfer, wait till it's done, then release the ho=
st.
> Hence when we come here, the content of ISE/STAT is a leftover from
> the previous transfer.
> Probably the intent here is to reset the registers in defined state,
> maybe it wasn't needed
> but it doesn't hurt either.
>=20
> It's conservative... I don't like to change it, along the side of my
> sdio irq patches.
> If I did lots of such changes, surely I would create a regression.
>=20
> On the other side If I was up to optimize the driver, then I would do thi=
s.

sure, that was an unrelated comment, just exposing some possible problem
with that approach :-)

> >> @@ -1067,8 +1085,12 @@ static irqreturn_t omap_hsmmc_irq(int irq, void=
 *dev_id)
> >>       int status;
> >>
> >>       status =3D OMAP_HSMMC_READ(host->base, STAT);
> >> -     while (status & INT_EN_MASK && host->req_in_progress) {
> >> -             omap_hsmmc_do_irq(host, status);
> >> +     while (status & (INT_EN_MASK | CIRQ_EN)) {
> >
> > why don't enable CIRQ_EN in INT_EN_MASK directly ?
>=20
> INT_EN_MASK is also used when bootstrapping the card in
> send_init_stream, but there
> you don't want to enable sdio irqs. So I would have to mask it there,
> so this is the smaller
> change.

true, fair enough.

--=20
balbi

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSb+7VAAoJEIaOsuA1yqRE3WMP/20QG0jXuDVKwm6DYI+w61Zd
x6SLspLlHAE8xzNEr5eWxk9BUKCEdRZi5EWhykP2sEZiHyDrFABqJ3dEPfyNwoHm
pWVtbN0Yew4b45TC/sR4SgLfSkcq/EsPemDxyEIvtpP7ERdGVMhM1yK1IrW833Ez
Qld7iXLFDQCwsm8Lj9rgTV0yuE6ohB5G7sSy0TGDHYe5ufmb8uLwAUVj6EpTyh22
W+vXOm8kcDYyRZqJbKQIcN4aS7RzWq9eLLtbYBy6kq33sUg6Cq8EQ/r1T12dQEXp
ZlwXmkb7O2Oo6B8IZNPPqM+mbLUaKRas3iyviOUJLtOGev80AVhKF4j5KCrJ6Yw2
cTGFSfvRfgmx5cgUpICeVPR6+OHYcUH1SKmdA5oXc7UECrlv4t2ZYfZU9CFRfe7U
sU3C/tL+J0aiOOifbdzr2slV/by2kPTe2rBMU8SsuajBq0D81JpHsVaw+AzeBZmw
8VXs9WNfzQv06mQFUf96FR0e0xt/6hojWQBm/1I4AEgRCimOnSfUQOemBmoSBn1k
IiKdRo3YdeEsHqYJHZWApUaFK2jKiyhN+TNV144kP4AeArV6fTCxqbCCD6UTZuS6
5P5isKy7N5ZKMRmkqpg/jUoRn8fUU4mxF1HSQWGst/PDq3ELBA8jzPRE5Hv8jU+p
t2z4bFHgLVkW5XmH1MVv
=NMMz
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
