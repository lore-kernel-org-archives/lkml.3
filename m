Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaHTJsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:48:15 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40372 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaHTJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:48:12 -0400
Date: Wed, 20 Aug 2014 11:48:08 +0200
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
Message-ID: <20140820094807.GE15414@ulmo>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
 <1408486072-19268-4-git-send-email-gael.portay@gmail.com>
 <776D4128-09AC-418C-A710-28A2522D1D63@jcrosoft.com>
 <20140820010130.10974326@bbrezillon>
 <20140820073111.GH13793@ulmo>
 <20140820101422.3e8da816@bbrezillon>
 <20140820082818.GB15414@ulmo>
 <20140820110625.17f77c9f@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <20140820110625.17f77c9f@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 11:06:25AM +0200, Boris BREZILLON wrote:
> On Wed, 20 Aug 2014 10:28:20 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Wed, Aug 20, 2014 at 10:14:22AM +0200, Boris BREZILLON wrote:
> > > Hi Thierry,
> > >=20
> > > On Wed, 20 Aug 2014 09:31:13 +0200
> > > Thierry Reding <thierry.reding@gmail.com> wrote:
> > >=20
> > > > On Wed, Aug 20, 2014 at 01:01:30AM +0200, Boris BREZILLON wrote:
> > > > > Hi Jean-Christophe,
> > > > >=20
> > > > > On Wed, 20 Aug 2014 06:11:17 +0800
> > > > > Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> > > > >=20
> > > > > > Hi,
> > > > > >=20
> > > > > > 	This is a bit weird as the clock of the TC should be off and t=
he irq free
> > > > > >=20
> > > > > > 	so this should never happened we need to investigate more why =
this append
> > > > >=20
> > > > > I may have found the source of this bug.
> > > > >=20
> > > > > As Gael stated, when you're kexec-ing a new kernel your previous =
kernel
> > > > > could be using the tbc_clksrc driver (and especially the clkevent
> > > > > device). Thus the kernel might have planned a timer event and the=
n been
> > > > > asked to shutdown the machine (requested by the kexec code).
> > > > > In this case the AIC interrupt connected to the TC Block is disab=
led
> > > > > but not the interrupts within the TCB IP (IDR registers), possibly
> > > > > leaving a pending interrupt before booting the new kernel.
> > > > >=20
> > > > > When the tcb_clksrc driver is loaded by the new kernel it enables=
 the
> > > > > interrupt line by calling setup_irq [1] while the clockevent devi=
ce is
> > > > > not registered yet [2]. Thus the event_handler is still NULL when=
 the
> > > > > AIC line connected to the TCB is unmasked. Remember that an inter=
rupt
> > > > > is still pending on this HW block, which will lead to an immediat=
e call
> > > > > to the ch2_irq handler, which tries to call the event_handler, wh=
ich in
> > > > > turns is NULL because clkevent device registration has not taken =
place
> > > > > at this moment =3D> Kernel panic.
> > > > > ITOH, we can't register the clkevent device before the irq handle=
r is
> > > > > set up, because we should be ready to handle clkevent request at =
the
> > > > > time clockevents_config_and_register is called.
> > > > >=20
> > > > > This leaves two solution:
> > > > >  1) disable the TCB irqs (using TCB IDR registers) before calling
> > > > >  setup_irq in the tcb_clksrc driver
> > > > >  2) disable the TCB irqs at the tclib level (as proposed by Gael)
> > > > >=20
> > > > > I prefer solution #2 because it fixes the bug for all TCB users (=
not
> > > > > just the tcb_clksrc driver).
> > > >=20
> > > > Wouldn't a more proper fix be to only enable the IRQ (setup_irq()) =
once
> > > > everything has properly been set up? That's certainly how all other
> > > > drivers are doing this. Generally I think it's best to assume that =
an
> > > > interrupt can fire at any point after it's been enabled, so everyth=
ing
> > > > should be set up prior to enabling it.
> > >=20
> > > Sure. And, AFAIK, another common practice is to disable all interrupts
> > > and acknowledge all pending interrupts before registering a new irq
> > > handler to avoid inheriting peripheral dirty state from previous usage
> > > (either the bootloader, or the previous kernel when using kexec).
> >=20
> > Discarding all pending interrupts may not always be what we want. And
> > masking interrupts prior to registering the handler isn't always going
> > to work either (shared interrupts), so device drivers should always set
> > things up in the correct order.
> >=20
>=20
> I meant disabling/acknowledging interrupts within the HW block not
> the interrupt line connected to the interrupt controller (which indeed
> can be shared among several peripherals).
> The TCB IP provides SR (Status Register) to acknowledge interrupts at
> the TCB level and IER/IDR/ISR (Interrupt Enable/Disable/Status
> Register) to manipulate TCB interrupts.

But when you share interrupts, then when an incoming interrupt will
cause all handlers to be called, so you still need to set it up
properly.

Thierry

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9G7XAAoJEN0jrNd/PrOh1ywP/1AkYRnb2Kf3sksAxSFQYLia
nUNB84b5AmuBGUlHbykkDLiWcbbefJzBwzcvJIK9glFrG8dd99dzw66fgi/Y6Lls
KyMlhsBM2nJQVMGszPSMZofSuqeUGT8w7KtEJPd6vh5JS6hX8ivSlnWZn9pUYaCJ
mrvn/ukCUdfU2nDFCAH8gIsBazxEQuPZjaIVpX85bfR3m5Hd74bTwmMpumxzjFwQ
iB+geKi1MuXiANKgOXWQSiDM5ngWREeTRIlhsTvsyP25Pk+MFNHEjNjJX5buOO8l
gstpkskqkfADRs9mCPDU7J26V7jaC27EVRUltJnMK27omR2dupVUfdy/gYqz7M/3
MhC6pvBUvBeXcfGBrcvAKaqJo2cCJhpE081R4M6ymT5caAwTOeMtHlZNzYtzByiH
wA+XthK+Q2Z3JV7fJpMWG1WO47B3PcjQZGG5oN3UtwtFUB0sY8co/LwDY/qp7obg
2GjalSroLpxV7Xs5oCZQWcD7UR+ohkk45vyLWvT1VTyHPCJoJh5W7AWrW8rCOO88
rH6J/sl9gY/ArtWC29qdiGbbtUVMeI1b6lKOQybjKdxjfXzk4k+e/cNsrAFGHnFm
xMU7JBqtVE/1rJgyJbH5QtthXMlSXgJJjyW1/ot4hhJI/tBwa3bziYkMaYCn36OD
MFoA9f/cmA0YB/RE0BMR
=nCVB
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
