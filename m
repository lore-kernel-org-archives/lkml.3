Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3F1Bks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:40:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33702 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249Ab3F1Bkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:40:46 -0400
Message-ID: <1372383630.23847.40.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] genirq: Fix can_request_irq() for IRQs without an action
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>, stable@vger.kernel.org,
        709647@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 02:40:30 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qvlGvbDGAoEQXbgJkDyQ"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qvlGvbDGAoEQXbgJkDyQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 02725e7471b8 ('genirq: Use irq_get/put functions'),
inadvertently changed can_request_irq() to return 0 for IRQs that have
no action.  This causes pcibios_lookup_irq() to select only IRQs that
already have an action with IRQF_SHARED set, or to fail if there are
none.  Change can_request_irq() to return 1 for IRQs that have no
action (if the first two conditions are met).

Reported-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
References: http://bugs.debian.org/709647
Tested-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is> (against 3.2)
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org # 2.6.39+
Cc: 709647@bugs.debian.org
---
 kernel/irq/manage.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..dc4db32 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -555,9 +555,9 @@ int can_request_irq(unsigned int irq, unsigned long irq=
flags)
 		return 0;
=20
 	if (irq_settings_can_request(desc)) {
-		if (desc->action)
-			if (irqflags & desc->action->flags & IRQF_SHARED)
-				canrequest =3D1;
+		if (!desc->action ||
+		    irqflags & desc->action->flags & IRQF_SHARED)
+			canrequest =3D 1;
 	}
 	irq_put_desc_unlock(desc, flags);
 	return canrequest;


--=-qvlGvbDGAoEQXbgJkDyQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUczpjue/yOyVhhEJAQoTEhAAtB54E8PoboOTVVfiajISkNCtNcCKIRqa
vQ/RbqY5N50OErw5WcaAJsp/3y8sCBxuh2IT6MLndXv9n1sScD0HGpIEpxiS1jyb
Cv1t2CwEQTt7CC4KMuD4KZYdSnlYMuzkHvISPg3IKv1m6V3ux59+qvJaRZoUButF
FLYysyps2U/sG9YMl/m5XKU08+c2a512mim7wYYNtmboWJZrMCAsbW+VEiZIu4z+
KK8GpGbHncK7587wxc2i26NFNg3KZyV3W3fjuzY+8EczuECRSo/72tqGVMowhrRq
CxGdFUD4/oscQl6ZXpIt+hQw0tzdFRj+SOFOh7znCZD1VWuOSnY8N+7d0Ci7RmBc
grvCzWtqLmXUrTenl+vk4RhHaIJncanxdT6iqZyvjCoYEonw4dkFa1a9S0DvJTbB
lK47qKDU7BvfF+MPe6wtZtQGnjOd1QfSA8GegTnd4V3UMJrtnKDHSVnx8QyOLTUJ
vsUFCszoeE0ErEAxavrLIpwqnVh1BaQ+6NV0kJ5Cdbu3RAMIF3Q6oBNLZGDFERet
pfjSt/OupqiOvTtT6sEQcPnlxnM3IXWgEMjIf7eHC6WCRUjIQ49gC/WVFVnOGHvZ
0zO+NWBMpTCjR85QTrWE/+u7cRlWlL2W2+OAIbhtBLWizYXPnJew5QHdwQRMMQuT
a0iV/S71ueY=
=o2Hx
-----END PGP SIGNATURE-----

--=-qvlGvbDGAoEQXbgJkDyQ--
