Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3AUJ2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:28:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3AUJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:28:47 -0500
Date: Mon, 21 Jan 2013 20:28:31 +1100
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] usb: musb: fix context save over suspend.
Message-ID: <20130121202831.40a09bbc@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OLteVNqqJ2YwmkQ1L8SYH52"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OLteVNqqJ2YwmkQ1L8SYH52
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



The standard suspend sequence involves runtime_resuming
devices before suspending the system.
So just saving context in runtime_suspend and restoring it
in runtime resume isn't enough.  We  must also save in "suspend"
and restore in "resume".

Without this patch, and OMAP3 system with off_mode enabled will find
the musb port non-functional after suspend/resume.  With the patch it
works perfectly.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index fd34867..b6ccc02 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2225,6 +2225,7 @@ static int musb_suspend(struct device *dev)
 	}
=20
 	spin_unlock_irqrestore(&musb->lock, flags);
+	musb_save_context(musb);
 	return 0;
 }
=20
@@ -2234,6 +2235,8 @@ static int musb_resume_noirq(struct device *dev)
 	 * unless for some reason the whole soc powered down or the USB
 	 * module got reset through the PSC (vs just being disabled).
 	 */
+	struct musb	*musb =3D dev_to_musb(dev);
+	musb_restore_context(musb);
 	return 0;
 }
=20

--Sig_/OLteVNqqJ2YwmkQ1L8SYH52
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUP0KPznsnt1WYoG5AQJUAQ//Uk82am41zm12mW/ARcn9cHlznzOpscuF
0BzinOxCLCAGHPi6rFo6nTPnfViIlyUgpbOtLk1gQgwO/9muzRYvQzjFagJcLj4U
Q8kWOObEHf0JNXL08jA4uk02xTkoTsoDfXzDMFEUblAVk8KqVj7lyTXR4uWzyMNE
pXNms8cCOQXakga1RFlQgR06Y0ieq1j/ZIeCTGOxKa7Dp31jaBpF+uajZkKuGE51
T6N9sCfjq03rUu+eZHZFi6n9CMEjruVe0Cco+0nyCy9x7iUpJIdrFsJKKfji9X69
OkoMWvFj9dnfYBrogLXhQIAiBTnl76LVOdPxS9KhGa9NtMKD+1oS8nCihuR/QpvS
A4eqLPpMUsEyaPq+/qBiQMis+7DDz00sI10e2mUcnZBAIILkMq4NQSlvpDCnIMFX
mBjFlfJLLgIRRDojoCqNWXVj4nlxNmO0XWHPMu/UYEgcUIsYGjrcArE0GVsI8EpF
BYK/BrkIdxbcvdUsqdlH2e+HZHlwWzFsv/guXmsGYA8JMyb40EyowXFzVFvYGW2V
YeYofmLXSNW2dLg+8pp7Kc2AeAfnYD+8pa9PPeuBsjS20bTFD9CY/Pm5B7+YY4EG
+wnXpIeyP0NvHjhNX64Nt9lG5Q1MF70f226QzywhGQtjBGNgB3gGBXqmJzv6sm4i
+7CUlU9TybU=
=kx3g
-----END PGP SIGNATURE-----

--Sig_/OLteVNqqJ2YwmkQ1L8SYH52--
