Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaHTI22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:28:28 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:47056 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaHTI2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:28:25 -0400
Date: Wed, 20 Aug 2014 10:28:20 +0200
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
Message-ID: <20140820082818.GB15414@ulmo>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
 <1408486072-19268-4-git-send-email-gael.portay@gmail.com>
 <776D4128-09AC-418C-A710-28A2522D1D63@jcrosoft.com>
 <20140820010130.10974326@bbrezillon>
 <20140820073111.GH13793@ulmo>
 <20140820101422.3e8da816@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20140820101422.3e8da816@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 10:14:22AM +0200, Boris BREZILLON wrote:
> Hi Thierry,
>=20
> On Wed, 20 Aug 2014 09:31:13 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Wed, Aug 20, 2014 at 01:01:30AM +0200, Boris BREZILLON wrote:
> > > Hi Jean-Christophe,
> > >=20
> > > On Wed, 20 Aug 2014 06:11:17 +0800
> > > Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> > >=20
> > > > Hi,
> > > >=20
> > > > 	This is a bit weird as the clock of the TC should be off and the i=
rq free
> > > >=20
> > > > 	so this should never happened we need to investigate more why this=
 append
> > >=20
> > > I may have found the source of this bug.
> > >=20
> > > As Gael stated, when you're kexec-ing a new kernel your previous kern=
el
> > > could be using the tbc_clksrc driver (and especially the clkevent
> > > device). Thus the kernel might have planned a timer event and then be=
en
> > > asked to shutdown the machine (requested by the kexec code).
> > > In this case the AIC interrupt connected to the TC Block is disabled
> > > but not the interrupts within the TCB IP (IDR registers), possibly
> > > leaving a pending interrupt before booting the new kernel.
> > >=20
> > > When the tcb_clksrc driver is loaded by the new kernel it enables the
> > > interrupt line by calling setup_irq [1] while the clockevent device is
> > > not registered yet [2]. Thus the event_handler is still NULL when the
> > > AIC line connected to the TCB is unmasked. Remember that an interrupt
> > > is still pending on this HW block, which will lead to an immediate ca=
ll
> > > to the ch2_irq handler, which tries to call the event_handler, which =
in
> > > turns is NULL because clkevent device registration has not taken place
> > > at this moment =3D> Kernel panic.
> > > ITOH, we can't register the clkevent device before the irq handler is
> > > set up, because we should be ready to handle clkevent request at the
> > > time clockevents_config_and_register is called.
> > >=20
> > > This leaves two solution:
> > >  1) disable the TCB irqs (using TCB IDR registers) before calling
> > >  setup_irq in the tcb_clksrc driver
> > >  2) disable the TCB irqs at the tclib level (as proposed by Gael)
> > >=20
> > > I prefer solution #2 because it fixes the bug for all TCB users (not
> > > just the tcb_clksrc driver).
> >=20
> > Wouldn't a more proper fix be to only enable the IRQ (setup_irq()) once
> > everything has properly been set up? That's certainly how all other
> > drivers are doing this. Generally I think it's best to assume that an
> > interrupt can fire at any point after it's been enabled, so everything
> > should be set up prior to enabling it.
>=20
> Sure. And, AFAIK, another common practice is to disable all interrupts
> and acknowledge all pending interrupts before registering a new irq
> handler to avoid inheriting peripheral dirty state from previous usage
> (either the bootloader, or the previous kernel when using kexec).

Discarding all pending interrupts may not always be what we want. And
masking interrupts prior to registering the handler isn't always going
to work either (shared interrupts), so device drivers should always set
things up in the correct order.

> This being said, I really think we should leave the HW in a clean state
> when shutdown is called. And disabling interrupts at the tclib level
> (in a shutdown callback) ensure that.

Yes, cleaning up the hardware and disabling interrupts upon shutdown
seems like a good idea to me in addition to the above.

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9FwiAAoJEN0jrNd/PrOhTZEP/3ZqJHgsTL1+5u3ZkjcY9CWK
5OecAfzV8/RxiMNDYIQTmom/H2Vse1a2NkSubvRv72KkOzdtMzJjZjT0RiHzeUZj
TchyHow+b7SyU+78sakOi8cYEyrf/fogslSzRnHKrbsuh42kHzZC/zgyXEyPUH16
NygrDbZgA7b337EdXUjCgU5ZF0spwAQlrZ2k8PfKorHB8QoKJde1epPr5V+nqomI
/qswi1fK+QQmuxcqlR1BnZkR/FrM2M4HGM8Ondyr/sTCQW5y37TSZYZyyVnYcgqQ
gptv0PqJUP5nxKu4eka42JUIogNS4+JqE7BCROFr/ATisERWOdGwU5GoUDB2zlfv
09I2tnQaTh/Kd0GC6Hds2JIL+h5qvobCYTN0MI6OHlGbcFAf8MMF7jC4JrnwvbtT
UyynfkFIx4QgQO8peaFUC8kss+PTQGXcnaAPMJ2HCRpgLv7YWhpXuYp9lRfb+czd
d2aP1uttszm7MYpmg8znyX/qHzGjGqP2H02bnBjedOHM8bcX6nEpYyIFEp6MiSQ7
X1jJdgGgtIXnChq43V8Kkc/Uerbo3v8Lu9Di1A6dTL2fWA4C4p3O88eEBiG40c8D
3XBqJYfzmunPbkF2MW1a6Gar48eEuzOKXY0ml6npGrBWOBmSWOlGcX8ZCjVIC6lq
6tUrtGQtFOQR6UfCy2c2
=XFL4
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
