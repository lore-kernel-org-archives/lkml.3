Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaDWWnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:43:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaDWWnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:43:20 -0400
Date: Thu, 24 Apr 2014 08:43:05 +1000
From: NeilBrown <neilb@suse.de>
To: Nishanth Menon <nm@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <marcel@holtmann.org>, <gustavo@padovan.org>,
        <johan.hedberg@gmail.com>, <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140424084305.20c7f301@notabene.brown>
In-Reply-To: <5357DDA8.4040206@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-10-git-send-email-balbi@ti.com>
	<5357DDA8.4040206@ti.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r2e.+PpvZfTEp5g4Q7HeCXI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r2e.+PpvZfTEp5g4Q7HeCXI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 10:35:04 -0500 Nishanth Menon <nm@ti.com> wrote:

> On 04/23/2014 09:58 AM, Felipe Balbi wrote:
> > nobody passes a DTR_gpio to this driver, so
> > this code is not necessary.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
>=20
> Niel,
> this seems to revert the functionality introduced in
> commit 9574f36fb801035f6ab0fbb1b53ce2c12c17d100
> (OMAP/serial: Add support for driving a GPIO as DTR.)
>=20
> would you like to Ack this change?

I have a couple of out-of-tree drivers that use this support.

I hope to get back to working on that code one day and even get those drive=
rs
upstream.  So I would really prefer this code to remain if it isn't causing
any actual problems.

Of course, I can always re-submit it when I need it again, but that it just
extra work all around.

Sorry that I have pushed those drivers already, but sometimes life gets in
the way :-)

Thanks,
NeilBrown


>=20
> >  drivers/tty/serial/omap-serial.c | 39 --------------------------------=
-------
> >  1 file changed, 39 deletions(-)
> >=20
> > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap=
-serial.c
> > index b46aaf3..6654682 100644
> > --- a/drivers/tty/serial/omap-serial.c
> > +++ b/drivers/tty/serial/omap-serial.c
> > @@ -163,10 +163,6 @@ struct uart_omap_port {
> >  	u8			wakeups_enabled;
> >  	u32			features;
> > =20
> > -	int			DTR_gpio;
> > -	int			DTR_inverted;
> > -	int			DTR_active;
> > -
> >  	struct serial_rs485	rs485;
> >  	int			rts_gpio;
> > =20
> > @@ -694,16 +690,6 @@ static void serial_omap_set_mctrl(struct uart_port=
 *port, unsigned int mctrl)
> >  	serial_out(up, UART_MCR, up->mcr);
> >  	pm_runtime_mark_last_busy(up->dev);
> >  	pm_runtime_put_autosuspend(up->dev);
> > -
> > -	if (gpio_is_valid(up->DTR_gpio) &&
> > -	    !!(mctrl & TIOCM_DTR) !=3D up->DTR_active) {
> > -		up->DTR_active =3D !up->DTR_active;
> > -		if (gpio_cansleep(up->DTR_gpio))
> > -			schedule_work(&up->qos_work);
> > -		else
> > -			gpio_set_value(up->DTR_gpio,
> > -				       up->DTR_active !=3D up->DTR_inverted);
> > -	}
> >  }
> > =20
> >  static void serial_omap_break_ctl(struct uart_port *port, int break_st=
ate)
> > @@ -847,9 +833,6 @@ static void serial_omap_uart_qos_work(struct work_s=
truct *work)
> >  						qos_work);
> > =20
> >  	pm_qos_update_request(&up->pm_qos_request, up->latency);
> > -	if (gpio_is_valid(up->DTR_gpio))
> > -		gpio_set_value_cansleep(up->DTR_gpio,
> > -					up->DTR_active !=3D up->DTR_inverted);
> >  }
> > =20
> >  static void
> > @@ -1672,28 +1655,6 @@ static int serial_omap_probe(struct platform_dev=
ice *pdev)
> >  	if (IS_ERR(base))
> >  		return PTR_ERR(base);
> > =20
> > -	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
> > -	    omap_up_info->DTR_present) {
> > -		ret =3D devm_gpio_request(&pdev->dev, omap_up_info->DTR_gpio,
> > -				"omap-serial");
> > -		if (ret < 0)
> > -			return ret;
> > -		ret =3D gpio_direction_output(omap_up_info->DTR_gpio,
> > -					    omap_up_info->DTR_inverted);
> > -		if (ret < 0)
> > -			return ret;
> > -	}
> > -
> > -	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
> > -	    omap_up_info->DTR_present) {
> > -		up->DTR_gpio =3D omap_up_info->DTR_gpio;
> > -		up->DTR_inverted =3D omap_up_info->DTR_inverted;
> > -	} else {
> > -		up->DTR_gpio =3D -EINVAL;
> > -	}
> > -
> > -	up->DTR_active =3D 0;
> > -
> >  	up->dev =3D &pdev->dev;
> >  	up->port.dev =3D &pdev->dev;
> >  	up->port.type =3D PORT_OMAP;
> >=20
>=20
>=20


--Sig_/r2e.+PpvZfTEp5g4Q7HeCXI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1hB+Tnsnt1WYoG5AQJudw//fMcJIfOhr28LqdTNf4kM6D43LxeC3Dvz
BOH3HqYpK45Jthy+Cr+igWbJpaU5Wmc6RVfG1ZPgIprU+gVdXuXe+Up0iC57R0tT
7NemN5BCxYqCVsmDbOpRv485oz3r04LjMbenzDqaqE/s3KYvdNJJbHdXbxjAFn3w
9p8MsFJBga+T0TjSJAH9SdprPB22fe6x/o+WqcKOsLcEodpWHjkKK1Rj65P1jKii
40OTGHcKYYrO5HGwdd8JJWA0oawRgh1DE9S3pAGmZz4a+ocVOSQDMs6gABaV5KqL
v/9/0sQ5XmL0i6R5n6PCt21Kgt3Di5wvUUoMeGI2YP4TU5fqqsHQnVuuLi+wCHHy
4Bmxf2h8Zo1+5slTkg04g+hRGUB37x9CnRMdbe0DuDJnwyNQDJn0tMOcUNvihoy1
BqUjCtE52vzPtu3ZX9GKT5eUaG+bpwKGGkDAjvbnTXNMdnKNRSV5Ns+5q1AM2r3r
9gVYB87Y6qGnBQIlnot2zvDCzJ2hlzCvNq2t/DJoSyftXzOXc9JgyAsFDug0DN6t
RaG/hF6IDbEskwLMrVAlPG7PoSSR39FN9ELLscAeon0W04l13bp+rL6lfiPXLzbi
OhMHuUEsLI/EUf496CZHzSLMXBHpFVL++XhNJecNoQ3mDFd0VA2YuzVoCAhTe3c3
BI1lgofwgdc=
=cyuG
-----END PGP SIGNATURE-----

--Sig_/r2e.+PpvZfTEp5g4Q7HeCXI--
