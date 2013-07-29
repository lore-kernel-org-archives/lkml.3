Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3G2OCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:02:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44089 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3G2OCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:02:38 -0400
Date: Mon, 29 Jul 2013 17:01:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb: gadget: mv_u3d_core: fix violation of locking
 discipline in mv_u3d_ep_disable()
Message-ID: <20130729140137.GD13978@radagast>
Reply-To: <balbi@ti.com>
References: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru>
 <20130725173017.GK25415@radagast>
 <51F2950D.3070103@ispras.ru>
 <20130729125250.GB13938@radagast>
 <51F66B0E.40408@ispras.ru>
 <20130729135212.GC13978@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <20130729135212.GC13978@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 04:52:12PM +0300, Felipe Balbi wrote:
> On Mon, Jul 29, 2013 at 05:15:58PM +0400, Alexey Khoroshilov wrote:
> > On 07/29/2013 04:52 PM, Felipe Balbi wrote:
> > > Hi,
> > >
> > > On Fri, Jul 26, 2013 at 07:26:05PM +0400, Alexey Khoroshilov wrote:
> > >> On 07/25/2013 09:30 PM, Felipe Balbi wrote:
> > >>> On Wed, Jul 24, 2013 at 12:20:17AM +0400, Alexey Khoroshilov wrote:
> > >>>> mv_u3d_nuke() expects to be calles with ep->u3d->lock held,
> > >>>> because mv_u3d_done() does. But mv_u3d_ep_disable() calls it
> > >>>> without lock that can lead to unpleasant consequences.
> > >>>>
> > >>>> Found by Linux Driver Verification project (linuxtesting.org).
> > >>>>
> > >>>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > >>> which commit introduced the bug ? Which kernels are affected by thi=
s bug ?
> > >> The bug is present from the very beginning: commit 3d4eb9d of 15 Jun=
e 2012.
> > >> So it is in the mainline since v3.5.
> > > Alright, do you want to have the same fix in stable kernels ? Is it
> > > necessary at all or do we consider it 'never worked before' and send =
it
> > > in the next merge window ?
> >=20
> > It is a tricky point. From one point of view it 'never worked before',
> > but as far as the bug leads to a data race with unpredictable
> > consequences I would prefer to have it fixed within 3.11 timeframe.
>=20
> Alright, I have already sent my pull request for v3.11-rc3, so once -rc4
> is tagged (in about a week) I'll send this patch.

BTW, I just found another bug in mv_u3d_core.c, here's a patch:

=46rom f6bb304cff095219ecfa6daa082ea834a9cf52bf Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Mon, 29 Jul 2013 16:58:29 +0300
Subject: [PATCH] usb: gadget: mv_u3d_core: don't call ->disconnect() from
 stop_activity()

mv_u3d_stop_activity() should not be calling ->disconnect()
directly as udc-core will already handle that for us.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Completely untested. It's clear that mv u3d driver
shouldn't be calling gadget_driver->disconnect()
at that time, but perhaps there are other bugs in the
driver which this will uncover.

 drivers/usb/gadget/mv_u3d_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_c=
ore.c
index 7acbca9..948f77a 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -1397,13 +1397,6 @@ void mv_u3d_stop_activity(struct mv_u3d *u3d, struct=
 usb_gadget_driver *driver)
 	list_for_each_entry(ep, &u3d->gadget.ep_list, ep.ep_list) {
 		mv_u3d_nuke(ep, -ESHUTDOWN);
 	}
-
-	/* report disconnect; the driver is already quiesced */
-	if (driver) {
-		spin_unlock(&u3d->lock);
-		driver->disconnect(&u3d->gadget);
-		spin_lock(&u3d->lock);
-	}
 }
=20
 static void mv_u3d_irq_process_error(struct mv_u3d *u3d)
--=20
1.8.3.4.840.g6a90778

--=20
balbi

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9nXBAAoJEIaOsuA1yqREE8kP/A4jZoVKibwNEvRXq1n+ZkSA
6+6jm3Q99cEFIGTwxhkjbxBbYhGVz2tbHg/DgZp0x7T5zJJ5IoP2frxN7VcP7R+a
S1+5mB5nVQJ2VxZgJTIZ0hynT27eQI/AafDcb1sQDprn8vVeQmbCLvO9rxZhWIxb
rzfqwhKeGpGiHZ5MNiqZm5obsXVD991nODABWcQNURKYFaTzPVhFs/NGkey3TmCe
Y/JMUWsv52V8b67vx4eEOGAX9P7xdUNoFTq3gUS5hhvoJDCR5tTg9Bu9rl/H2PhY
o4emKbJSBWKe5KQ8M1biFJkuWgyenDPIR2Mql0CIUY3SHBzuIAA++T+Q7DCY71FL
q5mASbNKAXYJIufE9On7OEiSOdaPp5oHDgH2dZDNTllcdjejoG6sqfCDTt+Xq6Cg
FBbsuxqMm0L/WR9wgVuDIM5NAlry231J82kstwZaqDMDFZ7md+GgmfPeZLGP9LXZ
zCVMzJ6+xFAv2VtCF5o+urnTM8fWgSsCa0khiJhNT2C8G4xynoSv6YJrrBGdWsaR
MdkX6FSRqayaU//zWMBD9IQtRfo+WNQ5xHrmxj8t6CytKHlcPy3I9ePfB8tF0L8c
Hm5XEMB4QICH/gaxEzJASnThvc4PMUl6UUk0e4njFhPIpKVCpfGsX+l1SxscI7YX
WXl1Uga8NUwSRV1CCWaz
=GnKW
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
