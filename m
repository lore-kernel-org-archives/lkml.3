Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAXTJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:09:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40655 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaAXTJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:09:49 -0500
Date: Fri, 24 Jan 2014 13:08:31 -0600
From: Felipe Balbi <balbi@ti.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Odd 'unable to find transceiver' messages from USB with
 v3.13-3260-g03d11a0 and later
Message-ID: <20140124190831.GA6449@saruman.home>
Reply-To: <balbi@ti.com>
References: <CA+5PVA7P=3b6oGG4pwR-q-Uy+V2hu5N-f5-fO4NdsB8ytvLz7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <CA+5PVA7P=3b6oGG4pwR-q-Uy+V2hu5N-f5-fO4NdsB8ytvLz7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 24, 2014 at 08:47:07AM -0500, Josh Boyer wrote:
> We've had a report [1] of the USB layer throwing out 'unable to find
> transceiver' messages during boot with the 3.14 merge window kernels.
> I've seen this on my personal machine as well and included the dmesg
> section below.  This does not happen with the 3.13 kernel.
>=20
> There are only a handful of files in git that have that error, but I
> haven't seen anything that immediately strikes me as causing this.
> From the dmesg output it looks like it is spit out right before a host
> controller is registered?  USB seems to be still working OK in my
> minimal testing, so the error message is confusing.
>=20
> Thoughts?

looks like it was caused because of this commit:

commit 1ae5799ef63176cc75ec10e545cb65f620a82747
Author: Valentine Barshak <valentine.barshak@cogentembedded.com>
Date:   Wed Dec 4 01:42:22 2013 +0400

    usb: hcd: Initialize USB phy if needed
   =20
    This adds external USB phy support to USB HCD driver that
    allows to find and initialize external USB phy, bound to
    the HCD, when the HCD is added.
    The usb_add_hcd function returns -EPROBE_DEFER if the USB
    phy, bound to the HCD, is not ready.
    If no USB phy is bound, the HCD is initialized as usual.
   =20
    Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 7527c8e..d3a9bcd 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2589,6 +2589,24 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	int retval;
 	struct usb_device *rhdev;
=20
+	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
+		struct usb_phy *phy =3D usb_get_phy_dev(hcd->self.controller, 0);
+
+		if (IS_ERR(phy)) {
+			retval =3D PTR_ERR(phy);
+			if (retval =3D=3D -EPROBE_DEFER)
+				return retval;
+		} else {
+			retval =3D usb_phy_init(phy);
+			if (retval) {
+				usb_put_phy(phy);
+				return retval;
+			}
+			hcd->phy =3D phy;
+			hcd->remove_phy =3D 1;
+		}
+	}
+
 	dev_info(hcd->self.controller, "%s\n", hcd->product_desc);
=20
 	/* Keep old behaviour if authorized_default is not in [0, 1]. */

usb_get_phy_device() will pr_err() when a PHY isn't found. Looks like
that should be pr_debug() since everything still works even without a
PHY.

--=20
balbi

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS4rovAAoJEIaOsuA1yqRE9n4P+QH4jHuBjfUPCN3t2zcyNgVR
LZSzIQTTNt28qYLFbBXlLhAbROaKQyMmfhuUac/wNMVDkcdq55jRYxa8X0ymmUdk
v3ALrYgTJy2bSKriEQ0w1Rstt5LkWfNPxbnV7hmUggIshdaskofkY4HKHQB74lpe
cQ3aYP87Mafty7G1jyjNR80fDghHsNTxF/kXwuPdx5EvO2ebyOQc3G5QpsleZ3Jv
SIjberURNEW/2kTOC1dT/lAr5kN06yGbWLyXEIg0n19EmKS2KMPZjMd77lxMdtbz
xTN8lCVZo3ay3FXz6UUdKsegVwD4fDddRl5Acfm3uS8zGziAHDp01o9q6oCQ3wle
gYlOeR15/AjrmHLPNoAYJevPqzvPCQatE1/UKRaUGGB2j/K0bhYWE+s7rcDRV2BN
s972no/NQLEf3zHsoxqZJ6TCmrZA9yzS8lTCYVG1mccWuwYPJqbeF8UZW01MGmFP
hFYJfdzV4QtdOL8JiTo8vQ1cARe8GFt1LzKAxT9y3ZMuCLkbek2EhurNrh5MPFHW
3l9RCCZeem/IGZIUf2euxstB0A0e1jmQeUnbp0RisBA1Ofk2VFnz7wwfwAI7iMs0
hIz2Zwyde5YfeCQoUvNPcem/FJ/BfswgA+eEgsqGa5AqZNP+Pc/yEQ644f76aUYU
osCk29xyKVCI7s+Sx9g9
=gY8u
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
