Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbaGXOmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:42:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60774 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758976AbaGXOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:42:42 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state
Date: Thu, 24 Jul 2014 17:01:02 +0200
Message-ID: <2043223.I5LvKcR9SD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724134241.GZ6758@twins.programming.kicks-ass.net>
References: <12684812.i3F8JrYCl0@vostro.rjw.lan> <20140724134241.GZ6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3037520.4Vi3rT9msu"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3037520.4Vi3rT9msu
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, July 24, 2014 03:42:41 PM Peter Zijlstra wrote:
> On Wed, Jul 23, 2014 at 10:46:26PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >=20
> > The "freeze" sleep state, also known as suspend-to-idle, is entered=

> > without taking nonboot CPUs offline, right after devices have been
> > suspended.  It works by waiting for at least one wakeup source obje=
ct
> > to become "active" as a result of handling a hardware interrupt.
> >=20
> > Of course, interrupts supposed to be able to wake up the system fro=
m
> > suspend-to-idle cannot be disabled by suspend_device_irqs() and the=
ir
> > interrupt handlers must be able to cope with interrupts coming afte=
r
> > all devices have been suspended.  In that case, they only need to
> > call __pm_wakeup_event() for a single wakeup source object without
> > trying to access hardware (that will be resumed later as part of
> > the subsequent system resume).
> >=20
> > Make PCIe PME interrupts work this way.
> >=20
> > Register an additional wakeup source object for each PCIe PME
> > service device.  That object will be used to generate wakeups from
> > suspend-to-idle.
> >=20
> > Add IRQF_NO_SUSPEND to PME interrupt flags.  This will make
> > suspend_device_irqs() to ignore PME interrupts, but that's OK,
> > because the PME interrupt handler is suspend-aware anyway and
> > can cope with interrupts coming during system suspend-resume.
> >=20
> > For each PCIe port with PME service during the "prepare" phase of
> > system suspend walk the bus below it and see if any devices on that=

> > bus are configured for wakeup.  If so, mark the port as one that ca=
n
> > be used for system wakeup signaling and handle it differenty going
> > forward.
> >=20
> > Namely, while suspending its PME service, do not disable the PME
> > interrupt, but only set a "suspended" flag for the PME service to
> > make the interrupt handler behave in a special way, which is to cal=
l
> > __pm_wakeup_event() with the service's wakeup source object as the
> > first argument whenever the interrupt is triggered.
> >=20
> > The "suspended" flag is cleared while resuming the PME service and
> > the "wakeup" flag is cleared at the "complete" stage of system
> > resume.
> >=20
> > This change allows Wake-on-LAN to be used for wakeup from
> > suspend-to-idle on my MSI Wind tesbed netbook.
> >=20
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
>=20
> > -=09ret =3D request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED, "PCIe =
PME", srv);
> > +=09ret =3D request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED | IRQF_=
NO_SUSPEND,
> > +=09=09=09  "PCIe PME", srv);
>=20
> So with this patch on:
>=20
>   http://marc.info/?l=3Dlinux-kernel&m=3D140620918218199

ACK for this one (already sent in that thread).

> This will not work on my machine, because aerdrv is requesting the sa=
me
> irq.

AER is PCIe error reporting service.

> Now I've not a f'cking clue what aerdrv is, and whether it too wants
> NO_SUSPEND on or not.
>=20
> But if I make it also request NO_SUSPEND it all starts working.

I think we should make all PCIe port services (there may be hotplug too=
)
use IRQF_NO_SUSPEND which will solve this particular problem, but there=
's
more to that (for example, ACPI SCI which in theory may be shared).

I guess it's time to revisit that thing, but that's a separate issue, o=
f
course.

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart3037520.4Vi3rT9msu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJT0R+0AAoJEILEb/54YlRxh1wP/RNgqYA/tpZkJacjOZkHulgH
FfsNnC0Zd1S+3XciKvunlnGKJBT4B072kMjS9nmd1+sFbWfACleE9jDc8opRNOH3
p/UVNbeUAoadB+qf146gYTZpLk1JPXqlkMLvTIthaenB4MFW90LckBPWcyMsCi3/
+3jrOtATRXwL433md4co5nEptg6AMs+3/mZMdKUdrFyJ4y7Vb63f+HnuppSjZjap
EQUFv/I2mMOSXx38G+pydOKtRlgPWTqUzrN5k9XV2rJHnIKjCcfb/hYopjto38a4
KUq+6Dzp7/sTgXGtt3PPNLIxFdQNA6IB2AQK1VrJBim5sLOtsRtr25oh1Z0ci8Ed
XHfbpqQfHjFnWEbWBPFEEvd18ZlgF+DkPaQweGK0i6YlHEDNYXL5CmPCRmUVrjYS
qEY8UlWrwrzS5God8DV5w5RJF+ggnO/fByJEDf4GroyivR+vDPkf2Vge2XOdD+wm
fCaXbPJfmUIqIsqiuVqpOVJoKvc0BIl81rqjegqf8tP4s4bno4B9YVPFbVNLW3cc
wXNEQky+UWmOG7fzbAtEzaX9+RST31TONSMDtgVR2InB44QWcOt2RBl6W+Xdn/4m
3MzFrivKZb3ZXY+vYDNqueiy0lVrEuZz2x5QmUn3jhAf/tiqyND+EKtc28KpWBWk
mfFotye5QpBgYNo1IiBC
=4ONd
-----END PGP SIGNATURE-----

--nextPart3037520.4Vi3rT9msu--

