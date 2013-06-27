Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3F0G6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:58:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57293 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3F0G6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:58:50 -0400
Date: Thu, 27 Jun 2013 09:58:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: sleeping while atomic in dwc3_gadget_start
Message-ID: <20130627065837.GL15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130626215256.GC11625@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTKW8p8tUZ/8vLMe"
Content-Disposition: inline
In-Reply-To: <20130626215256.GC11625@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hTKW8p8tUZ/8vLMe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 02:52:56PM -0700, Stephen Boyd wrote:
> Hi,
>=20
> I'm getting the folllowing BUG message on bootup with 3.10-rc5
>=20
> BUG: sleeping function called from invalid context at mm/slub.c:926
> in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper/0
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-gee3e35b-09316-ge78f=
3b35 #643
> [<c0014220>] (unwind_backtrace+0x0/0x120) from [<c001212c>] (show_stack+0=
x10/0x14)
> [<c001212c>] (show_stack+0x10/0x14) from [<c0143750>] (kmem_cache_alloc_t=
race+0x3c/0x210)
> [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210) from [<c00e0c60>] (reque=
st_threaded_irq+0x88/0x11c)
> [<c00e0c60>] (request_threaded_irq+0x88/0x11c) from [<c03bf53c>] (dwc3_ga=
dget_start+0x198/0x200)
> [<c03bf53c>] (dwc3_gadget_start+0x198/0x200) from [<c03f7a5c>] (udc_bind_=
to_driver+0x70/0xd8)
> [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8) from [<c03f7b50>] (usb_gadget=
_probe_driver+0x8c/0xb8)
>=20
> and I suspect this problem was introduced in commit 8698e2acf
> (usb: dwc3: gadget: introduce and use enable/disable irq
> methods). Is there a fix for this problem? Can we just move the
> irq request outside the spinlock?

nice :-)

how about this ?

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b5e5b35..a8e6b8b 100644
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
@@ -1551,41 +1560,33 @@ static int dwc3_gadget_start(struct usb_gadget *g,
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
 	return ret;
 }
=20

--=20
balbi

--hTKW8p8tUZ/8vLMe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy+KdAAoJEIaOsuA1yqRERwwP/0cSNdage29MrLcanPDVGT3E
a2mfeMMR0TDltPRGaYpN8DO1oNFq2MhkEmjyVh0ezp2HRGsgbmXontUXO8LAJjdT
ixOPCBiSVnaYl0PGNXA20ta2/EskmrEPET1bFgG/vrs+NZYyA2ytneurS6I5pPX1
HbYeiDZwR0Y3LVBDtYSZANBrETl4DaROhctN93ERSR3bERJhTnrKU9HmZwutDfKR
FqvVKQ2HfgJU3eBzHUvNjc5XG7/DVwntGNnLmzcSJgHKrQKx861A9H1CdOYFfM6H
4VsY4KrbVbk7xrbvgIfmRZCGXLN7DtrZUx5mIYeqPhnEFuwHDLllNu96Rn4ZBynV
6hCdQtCxQlAwvGCuj8pknnurVq0iCFjEdKrrIrK/S2GFiqxrT81gjUCZg1Q7tARl
+bsFHff/hq2P8c7kgVRLSfhWOCMPZc1e8xs88ZuU785ExkLwU/hQnQu1TARtDh8l
Sk23/aAu5sZGa0f3q6oc41BNm3SzAIpYBs0aEKoraLyDjMf8bgaE5KpcuKxiZnyU
KSvmpCdnF0xoC2J61j1NSdF+2BwJ4FtQrPfKv4CU06y+AI/8HM5ZnAy5f9h04MnB
bcOh6g6HuDrnREqlq/YFQbf54HiVby5ngfO1fZeIEoQ8RN1ThGkR2VivXuzhv8ye
32LyD+jGWCQK3mIAvrxc
=8XSH
-----END PGP SIGNATURE-----

--hTKW8p8tUZ/8vLMe--
