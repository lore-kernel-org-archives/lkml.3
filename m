Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbaGXNmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:42:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:42350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbaGXNmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:42:51 -0400
Date: Thu, 24 Jul 2014 15:42:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Make PCIe PME interrupts wake up from "freeze"
 sleep state
Message-ID: <20140724134241.GZ6758@twins.programming.kicks-ass.net>
References: <12684812.i3F8JrYCl0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pA3GpxlsFRhNUARh"
Content-Disposition: inline
In-Reply-To: <12684812.i3F8JrYCl0@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pA3GpxlsFRhNUARh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 10:46:26PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> The "freeze" sleep state, also known as suspend-to-idle, is entered
> without taking nonboot CPUs offline, right after devices have been
> suspended.  It works by waiting for at least one wakeup source object
> to become "active" as a result of handling a hardware interrupt.
>=20
> Of course, interrupts supposed to be able to wake up the system from
> suspend-to-idle cannot be disabled by suspend_device_irqs() and their
> interrupt handlers must be able to cope with interrupts coming after
> all devices have been suspended.  In that case, they only need to
> call __pm_wakeup_event() for a single wakeup source object without
> trying to access hardware (that will be resumed later as part of
> the subsequent system resume).
>=20
> Make PCIe PME interrupts work this way.
>=20
> Register an additional wakeup source object for each PCIe PME
> service device.  That object will be used to generate wakeups from
> suspend-to-idle.
>=20
> Add IRQF_NO_SUSPEND to PME interrupt flags.  This will make
> suspend_device_irqs() to ignore PME interrupts, but that's OK,
> because the PME interrupt handler is suspend-aware anyway and
> can cope with interrupts coming during system suspend-resume.
>=20
> For each PCIe port with PME service during the "prepare" phase of
> system suspend walk the bus below it and see if any devices on that
> bus are configured for wakeup.  If so, mark the port as one that can
> be used for system wakeup signaling and handle it differenty going
> forward.
>=20
> Namely, while suspending its PME service, do not disable the PME
> interrupt, but only set a "suspended" flag for the PME service to
> make the interrupt handler behave in a special way, which is to call
> __pm_wakeup_event() with the service's wakeup source object as the
> first argument whenever the interrupt is triggered.
>=20
> The "suspended" flag is cleared while resuming the PME service and
> the "wakeup" flag is cleared at the "complete" stage of system
> resume.
>=20
> This change allows Wake-on-LAN to be used for wakeup from
> suspend-to-idle on my MSI Wind tesbed netbook.
>=20
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---

> -	ret =3D request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED, "PCIe PME", sr=
v);
> +	ret =3D request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED | IRQF_NO_SUSPE=
ND,
> +			  "PCIe PME", srv);

So with this patch on:

  http://marc.info/?l=3Dlinux-kernel&m=3D140620918218199

This will not work on my machine, because aerdrv is requesting the same
irq.

Now I've not a f'cking clue what aerdrv is, and whether it too wants
NO_SUSPEND on or not.

But if I make it also request NO_SUSPEND it all starts working.

--pA3GpxlsFRhNUARh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0Q1RAAoJEHZH4aRLwOS6Js0QAK0M1pt+tZBZdosexF3cngC3
23DE6c7i2kKjRIl7bmL849y5RwCfQPaJ5ZjPaCaOav4jbRcQ63slzFjM+yLuaGB7
M4Bbd5uLneGcJ9b0lbAD5vDRbvQ36mV1rnS1yiOXY27YfVsYNtKjz0oJ790XFupf
PqUvnlOkq2OxTBccxfL9n6UtvoLJuNJ4ypN9P1i10k+vcmUNfYxwe01so2vuaMgX
xtIGi3ZxlXH1C+Gt3j0OfCmki3xFZY6qn/LqPw6zCikg48BG5ZRwdh8F8G6vIF2c
oUSMGmO903yUfh86Q4l7RXp2HFAYGXF4m9fW7yN/2hvFg1CBXixZIC9WIkYIGe82
4c7fxTUGB5gP+zFwjQjvSEf1FuDgsjmmw4vi1xsM2U96k7eUnlFjAcCIbY1kNCbp
I1+npim6PlALwMU5BUbtIRUwJCD9iBeiTWtb5Hyhe55eVeIzHXvE6vkIhLxj1a0f
6uqEmRDdbpFPdhlOQoWjoQKlWbp9BbZWKjOhEOUztnE6TY9oC0VQUSO/czvZmkpN
n2op85Mn6jhDbb6M7sD8R8MupBxRMU6gdnWXSpxIMqYkybzamzQO2WUG4RiGzn0I
QRyv56IgeDn5uR6W2cCvbJTVCPpZyCftBvlccWxP3Z6bXar2AuEqPWv3P5qojTYJ
U5vXIGEch1As71qgtuim
=ngW2
-----END PGP SIGNATURE-----

--pA3GpxlsFRhNUARh--
