Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaE2JBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:01:40 -0400
Received: from ozlabs.org ([103.22.144.67]:39452 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933696AbaE2JBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:01:39 -0400
Date: Thu, 29 May 2014 19:01:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: linux-next: build failure after merge of the usb tree
Message-ID: <20140529190129.6d3272fd@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/DyuxjfIDecD/uNg=Z_3512X"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DyuxjfIDecD/uNg=Z_3512X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (sparc64 defconfig)
failed like this:

drivers/usb/core/hub.c: In function 'port_event':
drivers/usb/core/hub.c:4853:2: error: implicit declaration of function 'hub=
_handle_remote_wakeup' [-Werror=3Dimplicit-function-declaration]

Caused by commits af376a461cf0 ("usb: refactor port handling in
hub_events()") and 7e73be227b15 ("usb: hub_handle_remote_wakeup()
depends on CONFIG_PM_RUNTIME=3Dy") This build has CONFIG_PM not set ...

I have added this fix patch for today (there is probably a better way):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 May 2014 18:55:06 +1000
Subject: [PATCH] usb: hub_handle_remote_wakeup() only exists for CONFIG_PM=
=3Dy

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/core/hub.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5672752bfd2c..879b66e13370 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3977,6 +3977,12 @@ EXPORT_SYMBOL_GPL(usb_disable_ltm);
 void usb_enable_ltm(struct usb_device *udev) { }
 EXPORT_SYMBOL_GPL(usb_enable_ltm);
=20
+static int hub_handle_remote_wakeup(struct usb_hub *hub, unsigned int port,
+		u16 portstatus, u16 portchange)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_PM */
=20
=20
--=20
2.0.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/DyuxjfIDecD/uNg=Z_3512X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThvduAAoJEMDTa8Ir7ZwV+GwP/2GAzAZPnZqIKI48dUVm46xz
NeKOVzaHoMAHFua3ikCTGHzJik7+NVe2edcxFZ+DeqnvJTx/qb69tHJ70sv+vvAO
jTStoLP/54+vaM/ybFWyA6lYRo2qkCWdnh7PmT0STdhHwUd3qJHLkYq8+ehN/UQH
fq5H6cIaMBN0a/hDGwSHqOsxlCbJn0ciAjb+DgUq+HwOxLpmimXaSci7dpF8fgGF
Wm2t5ntv5u8/w07Lq86dUtge9AnCDnhsSPbTLSYvYKRABuabU26SMFzp8mUAQ/Ec
bsa2DhGN547N0FQnsePObePwpvXFmTW7MyHJhrN0XQKZXnLRu6eKNYz3seazxD2z
ZIynpo/q8x0uNwd72E5sjvp/sMRNxq0tHADemz8lKFnslQRATswYev7upgfHPWV7
s4RM8Fl/tOVvdpngwwtOqnhvKasNesUhgSnLfPRNdsaMwjIsu1GYskACCwAqvVzV
BiLWTbmHuMEH5YFiRp6pGPKyj3SCmyjdftEhDEWEiihXvEW9G/L71WDQ8jCcTlDz
LnxNejE3aItuj3xaKKRLeuvQox8bp6xIjdBifjaW07clComPk4ddxPfeZ4GLbrLF
T8PMJBSXD+xzTd2KUPdbolBJ3f+dJ9SX1H/y2Cy2nCDkmZi1UdgrMjpoBe7xn3L8
nW4ksvM66/ajYKxdhSCh
=JlWu
-----END PGP SIGNATURE-----

--Sig_/DyuxjfIDecD/uNg=Z_3512X--
