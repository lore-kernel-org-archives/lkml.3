Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3F1K6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:58:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41647 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3F1K6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:58:21 -0400
Date: Fri, 28 Jun 2013 13:58:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: sleeping while atomic in dwc3_gadget_start
Message-ID: <20130628105805.GN11297@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130626215256.GC11625@codeaurora.org>
 <20130627065837.GL15455@arwen.pp.htv.fi>
 <51CC6F10.3000202@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y4VYWfdFdHwFhC6D"
Content-Disposition: inline
In-Reply-To: <51CC6F10.3000202@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Y4VYWfdFdHwFhC6D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 27, 2013 at 09:57:52AM -0700, Stephen Boyd wrote:
> On 06/26/13 23:58, Felipe Balbi wrote:
> > On Wed, Jun 26, 2013 at 02:52:56PM -0700, Stephen Boyd wrote:
> >> Hi,
> >>
> >> I'm getting the folllowing BUG message on bootup with 3.10-rc5
> >>
> >> BUG: sleeping function called from invalid context at mm/slub.c:926
> >> in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper/0
> >> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-gee3e35b-09316-ge=
78f3b35 #643
> >> [<c0014220>] (unwind_backtrace+0x0/0x120) from [<c001212c>] (show_stac=
k+0x10/0x14)
> >> [<c001212c>] (show_stack+0x10/0x14) from [<c0143750>] (kmem_cache_allo=
c_trace+0x3c/0x210)
> >> [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210) from [<c00e0c60>] (re=
quest_threaded_irq+0x88/0x11c)
> >> [<c00e0c60>] (request_threaded_irq+0x88/0x11c) from [<c03bf53c>] (dwc3=
_gadget_start+0x198/0x200)
> >> [<c03bf53c>] (dwc3_gadget_start+0x198/0x200) from [<c03f7a5c>] (udc_bi=
nd_to_driver+0x70/0xd8)
> >> [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8) from [<c03f7b50>] (usb_gad=
get_probe_driver+0x8c/0xb8)
> >>
> >> and I suspect this problem was introduced in commit 8698e2acf
> >> (usb: dwc3: gadget: introduce and use enable/disable irq
> >> methods). Is there a fix for this problem? Can we just move the
> >> irq request outside the spinlock?
> > nice :-)
> >
> > how about this ?
>=20
> If start fails do you call stop? I believe the answer is no, so we'll
> need to free_irq() somewhere along the error path. Or we can request it
> after the spin_unlock()?

good point here's v2:

=46rom 1a7896c5481646e533ca09ba60918831d9849ed8 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Thu, 27 Jun 2013 10:00:18 +0300
Subject: [PATCH] usb: dwc3: gadget: don't request IRQs in atomic

We cannot request an IRQ with spinlocks held
as that would trigger a sleeping inside
spinlock warning.

Cc: <stable@vger.kernel.org> # v3.10
Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/gadget.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b5e5b35..bb0d312c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1508,6 +1508,15 @@ static int dwc3_gadget_start(struct usb_gadget *g,
 	int			irq;
 	u32			reg;
=20
+	irq =3D platform_get_irq(to_platform_device(dwc->dev), 0);
+	ret =3D request_threaded_irq(irq, dwc3_interrupt, dwc3_thread_interrupt,
+			IRQF_SHARED | IRQF_ONESHOT, "dwc3", dwc);
+	if (ret) {
+		dev_err(dwc->dev, "failed to request irq #%d --> %d\n",
+				irq, ret);
+		goto err0;
+	}
+
 	spin_lock_irqsave(&dwc->lock, flags);
=20
 	if (dwc->gadget_driver) {
@@ -1515,7 +1524,7 @@ static int dwc3_gadget_start(struct usb_gadget *g,
 				dwc->gadget.name,
 				dwc->gadget_driver->driver.name);
 		ret =3D -EBUSY;
-		goto err0;
+		goto err1;
 	}
=20
 	dwc->gadget_driver	=3D driver;
@@ -1551,41 +1560,35 @@ static int dwc3_gadget_start(struct usb_gadget *g,
 	ret =3D __dwc3_gadget_ep_enable(dep, &dwc3_gadget_ep0_desc, NULL, false);
 	if (ret) {
 		dev_err(dwc->dev, "failed to enable %s\n", dep->name);
-		goto err0;
+		goto err1;
 	}
=20
 	dep =3D dwc->eps[1];
 	ret =3D __dwc3_gadget_ep_enable(dep, &dwc3_gadget_ep0_desc, NULL, false);
 	if (ret) {
 		dev_err(dwc->dev, "failed to enable %s\n", dep->name);
-		goto err1;
+		goto err2;
 	}
=20
 	/* begin to receive SETUP packets */
 	dwc->ep0state =3D EP0_SETUP_PHASE;
 	dwc3_ep0_out_start(dwc);
=20
-	irq =3D platform_get_irq(to_platform_device(dwc->dev), 0);
-	ret =3D request_threaded_irq(irq, dwc3_interrupt, dwc3_thread_interrupt,
-			IRQF_SHARED | IRQF_ONESHOT, "dwc3", dwc);
-	if (ret) {
-		dev_err(dwc->dev, "failed to request irq #%d --> %d\n",
-				irq, ret);
-		goto err1;
-	}
-
 	dwc3_gadget_enable_irq(dwc);
=20
 	spin_unlock_irqrestore(&dwc->lock, flags);
=20
 	return 0;
=20
-err1:
+err2:
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
=20
-err0:
+err1:
 	spin_unlock_irqrestore(&dwc->lock, flags);
=20
+err0:
+	free_irq(irq, dwc);
+
 	return ret;
 }
=20
@@ -1599,9 +1602,6 @@ static int dwc3_gadget_stop(struct usb_gadget *g,
 	spin_lock_irqsave(&dwc->lock, flags);
=20
 	dwc3_gadget_disable_irq(dwc);
-	irq =3D platform_get_irq(to_platform_device(dwc->dev), 0);
-	free_irq(irq, dwc);
-
 	__dwc3_gadget_ep_disable(dwc->eps[0]);
 	__dwc3_gadget_ep_disable(dwc->eps[1]);
=20
@@ -1609,6 +1609,9 @@ static int dwc3_gadget_stop(struct usb_gadget *g,
=20
 	spin_unlock_irqrestore(&dwc->lock, flags);
=20
+	irq =3D platform_get_irq(to_platform_device(dwc->dev), 0);
+	free_irq(irq, dwc);
+
 	return 0;
 }
=20
--=20
1.8.2.1


--=20
balbi

--Y4VYWfdFdHwFhC6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzWw9AAoJEIaOsuA1yqRErVgP/i/6/REGD4VQfNjm9M5Qbfaa
UV/c6oalbF0wOX7fcc/Vu0tQdz/RhCiv3+ViWicj0Hn3GKGSIh4ObRCgT0wFKmEC
9QIf34PrEXYZ00fSPKvyaLDuiU6YM+Zdwxql4woHxbH/fwgGneKzl+4eSvCvBRmk
HasvoypSbwPKtgd8AEAdpiIy8+IoXezBJx3q6BP1+hib9w01iBibeIAKA2MOIczg
WXus08QKR+CfNUAogsppdRVH7vq0gLMYyc8WaKdHaIdjtxzJwPZVC4ex8DD+hKEj
gHnB0oizWZzcKHAxciN/KO0lwGirYBEde9mkATIgYmy7hc4p6rog9B0BhxxrIelJ
Zz8nk8KA3Tw5s5qIfu3bm/NgdTz9PqPfl3IefnWgCJnVTlMrKhKW31VoGXyaX3UG
4NwR4oJsg8SlUtSdRblTReVKVthEyhph8TDFKdR4M51ZPePSWaYO7Dx+Us5rOaTr
ewevJ9qEdXAhbreI9rfCxIIQ+XNiLyQ0xdI9HO6/5JteOUozNsgNGiHJUtBogSL2
RF1uLgi0/oYFYqY7F9eKOB1El//Z3KC86QTtbZcli23hQpoWErRnDQJemNSdWecO
73L7clRGaG93D6QbDh2X/jGQeDHUBn5BG34375Mc7H0eZU424SzySYACQeN+jEao
+DoE/6gapD1S54fSLtpa
=Jfil
-----END PGP SIGNATURE-----

--Y4VYWfdFdHwFhC6D--
