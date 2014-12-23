Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaLWIsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:48:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbaLWIs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:48:29 -0500
Date: Tue, 23 Dec 2014 19:48:09 +1100
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2a/3] mmc: core: Allow host driver to provide isr for
 card-detect interrupts.
Message-ID: <20141223194809.57dd6f6e@notabene.brown>
In-Reply-To: <CAPDyKFot3ZyeoVf5wWSizw==7bitLAb7btg3ngH6aMWHFdAekw@mail.gmail.com>
References: <20141219230732.7511.28103.stgit@notabene.brown>
 <CAPDyKFot3ZyeoVf5wWSizw==7bitLAb7btg3ngH6aMWHFdAekw@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/by_OAwHUBu+KAfsGFhKxvQP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/by_OAwHUBu+KAfsGFhKxvQP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Dec 2014 16:35:40 +0100 Ulf Hansson <ulf.hansson@linaro.org> wro=
te:

> On 20 December 2014 at 00:07, NeilBrown <neilb@suse.de> wrote:
> > One of the reasons omap_hsmmc doesn't use the slot-gpio library
> > is that it has some non-standard functionality in the card-detect
> > interrupt service routine.
> >
> > To make it possible for omap_hsmmc (and maybe others) to be converted
> > to use slot-gpio, add 'mmc_gpio_request_cd_isr' which provide an
> > alternate isr to be register by the slot-gpio code.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  drivers/mmc/core/slot-gpio.c  |   24 +++++++++++++++++++++++-
> >  include/linux/mmc/slot-gpio.h |    2 ++
> >  2 files changed, 25 insertions(+), 1 deletion(-)
> >
> > This and following are the result of splitting the previous
> > '2/3' into to patches: core and omap_hsmmc as requested.
> >
> > NeilBrown
> >
> >
> > diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
> > index 69bbf2adb329..f56323f5a996 100644
> > --- a/drivers/mmc/core/slot-gpio.c
> > +++ b/drivers/mmc/core/slot-gpio.c
> > @@ -23,6 +23,7 @@ struct mmc_gpio {
> >         struct gpio_desc *cd_gpio;
> >         bool override_ro_active_level;
> >         bool override_cd_active_level;
> > +       irqreturn_t (*cd_gpio_isr)(int irq, void *dev_id);
> >         char *ro_label;
> >         char cd_label[0];
> >  };
> > @@ -156,8 +157,10 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *hos=
t)
> >                 irq =3D -EINVAL;
> >
> >         if (irq >=3D 0) {
> > +               if (ctx->cd_gpio_isr =3D=3D NULL)
>=20
> Please change to:
> if (!ctx->cd_gpio_isr)

will do (though I personally prefer the explicit "NULL" :-).

>=20
> > +                       ctx->cd_gpio_isr =3D mmc_gpio_cd_irqt;
> >                 ret =3D devm_request_threaded_irq(&host->class_dev, irq,
> > -                       NULL, mmc_gpio_cd_irqt,
> > +                       NULL, ctx->cd_gpio_isr,
> >                         IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IR=
QF_ONESHOT,
> >                         ctx->cd_label, host);
> >                 if (ret < 0)
> > @@ -171,6 +174,25 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *hos=
t)
> >  }
> >  EXPORT_SYMBOL(mmc_gpiod_request_cd_irq);
> >
> > +/* Register an alternate interrupt service routine for
> > + * the card-detect GPIO.
> > + */
> > +int mmc_gpio_request_cd_isr(struct mmc_host *host,
> > +                           irqreturn_t (*isr)(int irq, void *dev_id))
> > +{
> > +       struct mmc_gpio *ctx;
> > +       int ret;
> > +
> > +       ret =3D mmc_gpio_alloc(host);
> > +       if (ret < 0)
> > +               return ret;
> > +       ctx =3D host->slot.handler_priv;
> > +       if (ctx->cd_gpio_isr)
> > +               return -EBUSY;
> > +       ctx->cd_gpio_isr =3D isr;
> > +       return 0;
> > +}
>=20
> I decided to queue those patchsets I recently posted which simplifies
> the slot-gpio API. Please re-base this patch on top of my next branch.

OK.

>=20
> Moreover, I actually wonder whether we need to add this API at all.
> After my changes, all you need to do from your host driver ->probe(),
> is to assign your isr routine to ctx->cd_gpio_isr.

'struct mmc_gpio' is local to slot-gpio.c, so code in other files cannot
access the members directly.

If you want to move it to include/linux/mmc/host.h and change
  void *handler_priv;
to
  struct mmc_gpio *gpios;

or similar, then I'll happily update it directly.
What do you think?

NeilBrown


>=20
> > +
> >  /**
> >   * mmc_gpio_request_cd - request a gpio for card-detection
> >   * @host: mmc host
> > diff --git a/include/linux/mmc/slot-gpio.h b/include/linux/mmc/slot-gpi=
o.h
> > index e56fa24c9322..9e55db60deb0 100644
> > --- a/include/linux/mmc/slot-gpio.h
> > +++ b/include/linux/mmc/slot-gpio.h
> > @@ -28,6 +28,8 @@ int mmc_gpiod_request_cd(struct mmc_host *host, const=
 char *con_id,
> >  int mmc_gpiod_request_ro(struct mmc_host *host, const char *con_id,
> >                          unsigned int idx, bool override_active_level,
> >                          unsigned int debounce, bool *gpio_invert);
> > +int mmc_gpio_request_cd_isr(struct mmc_host *host,
> > +                           irqreturn_t (*isr)(int irq, void *dev_id));
> >  void mmc_gpiod_free_cd(struct mmc_host *host);
> >  void mmc_gpiod_request_cd_irq(struct mmc_host *host);
> >
> >
> >
>=20
> Kind regards
> Uffe


--Sig_/by_OAwHUBu+KAfsGFhKxvQP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJksTznsnt1WYoG5AQKuYBAAmwvLQ1oEnbsMfi7ZGzUoRvHu6zND6LQy
7E35AXsPdiDh8I2EWgZqoF9VXHh48OeJWvITHMgnKJOEC1O2VgMr7inh1e+YUAcG
nO+AHCYCu0jwRWbjAwpWPA6RAXYYPULm8G2BoIuYsNNw+WOgFojEpYcXApS3zSL4
H/+bqJIAmbTQ/GdscTOdtD/BNGg+LDC9lOa1z+2KX/kaKch7qfSBsgEyDe30gCgO
l69EjLpS24lda8yj1v3C8Fyp3yibzvvthTujLp0W56VLgz7vHiosIcgkWlDoruNv
H9fpGkV8oQvrER6Le7tmDoZtDc7PJLzGk5hlfJ0/bt+mskPuIpDthc2FbRwuP4R1
d+k9A0yy1c6E2Iz81WgdN3tSRj3Cb2SHg/VscvOxmVXat2TX3ky5plDZybjbYTdS
cC4OhPuZecFg6XTC0Obd2t5qlrDiXiBzLc8Z7b+PXatOTXk/SV6DAD2h8aJpklRd
6ndImI7RtdrlRGrDS64twnl94b58XOTwJxwDoGCL+xAZtQwiItCDUwYJchEkG0rO
9yaE23tZErQx+3aisIFmMD/CtLU3tvvhW2eHOZPgXb+D9ChH68+LNL/ogeTDWT0g
SYgRL0NCXkl6IkwvgECJ4meoV/eJS4fyD4Z/AA5JE5HjeWSgeQ/GsTc7uIwbgR1C
vN1ihsQ8kOo=
=kClY
-----END PGP SIGNATURE-----

--Sig_/by_OAwHUBu+KAfsGFhKxvQP--
