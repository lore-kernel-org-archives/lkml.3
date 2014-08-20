Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaHTHbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:31:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36577 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaHTHbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:31:17 -0400
Date: Wed, 20 Aug 2014 09:31:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        =?utf-8?B?R2HDq2w=?= PORTAY <gael.portay@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas FERRE <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 3/3] ARM: at91/tclib: mask interruptions at shutdown and
 probe
Message-ID: <20140820073111.GH13793@ulmo>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
 <1408486072-19268-4-git-send-email-gael.portay@gmail.com>
 <776D4128-09AC-418C-A710-28A2522D1D63@jcrosoft.com>
 <20140820010130.10974326@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Z7/5fzWRHDJ0o7Q"
Content-Disposition: inline
In-Reply-To: <20140820010130.10974326@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Z7/5fzWRHDJ0o7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 01:01:30AM +0200, Boris BREZILLON wrote:
> Hi Jean-Christophe,
>=20
> On Wed, 20 Aug 2014 06:11:17 +0800
> Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
>=20
> > Hi,
> >=20
> > 	This is a bit weird as the clock of the TC should be off and the irq f=
ree
> >=20
> > 	so this should never happened we need to investigate more why this app=
end
>=20
> I may have found the source of this bug.
>=20
> As Gael stated, when you're kexec-ing a new kernel your previous kernel
> could be using the tbc_clksrc driver (and especially the clkevent
> device). Thus the kernel might have planned a timer event and then been
> asked to shutdown the machine (requested by the kexec code).
> In this case the AIC interrupt connected to the TC Block is disabled
> but not the interrupts within the TCB IP (IDR registers), possibly
> leaving a pending interrupt before booting the new kernel.
>=20
> When the tcb_clksrc driver is loaded by the new kernel it enables the
> interrupt line by calling setup_irq [1] while the clockevent device is
> not registered yet [2]. Thus the event_handler is still NULL when the
> AIC line connected to the TCB is unmasked. Remember that an interrupt
> is still pending on this HW block, which will lead to an immediate call
> to the ch2_irq handler, which tries to call the event_handler, which in
> turns is NULL because clkevent device registration has not taken place
> at this moment =3D> Kernel panic.
> ITOH, we can't register the clkevent device before the irq handler is
> set up, because we should be ready to handle clkevent request at the
> time clockevents_config_and_register is called.
>=20
> This leaves two solution:
>  1) disable the TCB irqs (using TCB IDR registers) before calling
>  setup_irq in the tcb_clksrc driver
>  2) disable the TCB irqs at the tclib level (as proposed by Gael)
>=20
> I prefer solution #2 because it fixes the bug for all TCB users (not
> just the tcb_clksrc driver).

Wouldn't a more proper fix be to only enable the IRQ (setup_irq()) once
everything has properly been set up? That's certainly how all other
drivers are doing this. Generally I think it's best to assume that an
interrupt can fire at any point after it's been enabled, so everything
should be set up prior to enabling it.

Also, does anyone know why this driver uses setup_irq() rather than the
more idiomatic request_irq()?

Thierry

--+Z7/5fzWRHDJ0o7Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9E6/AAoJEN0jrNd/PrOhiaQP/1B/JBX0jF8UpnyIkHbWtUqi
w+nHLWZ7+V6KspwZsj82aZFouqly8ddFopPOFMrKnmGlgYCFt7zHMV7dvghnqqov
3l3/fyQe/Sh06MqwqOG0DcN20GjKTJeJd8IlaI7gX1NmpyiU5JeHKSlBJwqmUHZ4
fRx957+CmrZbfneckwX8fsufAS3MaAHpU+wKQ9Xoh/u/B0vy3yOi0+hJla7wJ+li
+92jGda4dgcdWCGNl/rcSB2iuazetYJEj6HGaPv28x4WaOrrv/rrHTAfHofLhH6O
F5dVnlIYvObsnGkeSxHxbuq5IzN7ggd2VM1kKRdG/HY5/wK7GiDSLFFuNNJNvx7C
b9M2NOY24leksN4Yv08ALC0v2WXbFaykKRpvFZh7qcuWsVH3lt9/m3+VpxQrT2Fv
NL3/C5XUEKwqtSx3fuH8l6F81Edh12LGWa+GOWOS32n3OMiw723dkFELh5nY43KX
DJrYmi/8ZwWSZ2nQlJGIl756EQBj7YH+wSU2OdzN6GdnJR044sJ8d8m/J/vBexew
jzvwyjIQuHkJ7UUW0dvtH4D+jj+duaQLDVDnOq1atZ043VlkgIQGsJYw3y9uJDZ/
wXCeAw9EuTcaJRbN5q5bVumD+lXZWDAIcKEUdjcnI+I/W81FTjGnWuorDh9nDuMw
hJXrNVIalsRy3wuFxBKG
=IadM
-----END PGP SIGNATURE-----

--+Z7/5fzWRHDJ0o7Q--
