Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaLDNWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:22:09 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42292 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLDNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:22:07 -0500
Date: Thu, 4 Dec 2014 14:22:02 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
Message-ID: <20141204132200.GC7262@ulmo.nvidia.com>
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
 <5480522A.5010900@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <5480522A.5010900@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2014 at 03:23:06PM +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 12/4/2014 3:06 PM, Thierry Reding wrote:
>=20
> >From: Thierry Reding <treding@nvidia.com>
>=20
> >Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> >failure") broke platforms that rely on deferred probing to order probing
> >of PHY and host controller drivers. The reason is that the commit simply
> >propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
> >PHY has been registered yet for a given device tree node. The only case
> >in which -EPROBE_DEFER would now be returned is if try_module_get() did
> >fail, which does not make sense.
>=20
> >The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
> >registered yet. The only condition under which it makes sense to return
> >-ENODEV is if the device tree node representing the PHY has been
> >disabled (via the status property) because in that case the PHY will
> >never be registered.
>=20
> >This patch addresses the problem by making __of_usb_find_phy() return an
> >appropriate error code while keeping in line with the above-mentioned
> >commit to propagate error codes rather than overwriting them. At the
> >same time the check for a valid PHY is decoupled from the check for the
> >try_module_get() call and a separate error code is returned if the
> >latter fails.
>=20
> >Signed-off-by: Thierry Reding <treding@nvidia.com>
> >---
> >  drivers/usb/phy/phy.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> >diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> >index b4066a001ba0..2f9735b35338 100644
> >--- a/drivers/usb/phy/phy.c
> >+++ b/drivers/usb/phy/phy.c
> [...]
> >@@ -190,10 +193,13 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct=
 device *dev,
> >  	spin_lock_irqsave(&phy_lock, flags);
> >
> >  	phy =3D __of_usb_find_phy(node);
> >-	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> >-		if (!IS_ERR(phy))
> >-			phy =3D ERR_PTR(-EPROBE_DEFER);
> >+	if (IS_ERR(phy)) {
> >+		devres_free(ptr);
> >+		goto err1;
> >+	}
> >
> >+	if (!try_module_get(phy->dev->driver->owner)) {
> >+		phy =3D ERR_PTR(-ENODEV);
> >  		devres_free(ptr);
> >  		goto err1;
> >  	}
>=20
>    I think devres_free() should now be called in one place, under the new
> 'err2' label.

That'd make things very confusing, though. devres_free() should only be
called on error, whereas both err1 and err0 are shared with the success
case as well. If we were to do what you suggest we'd end up with
something like this:

		...

		phy =3D __of_usb_find_phy(node);
		if (IS_ERR(phy))
			goto err2;

		if (!try_module_get(...)) {
			phy =3D ERR_PTR(-ENODEV);
			goto err2;
		}

		*ptr =3D phy;
		devres_add(dev, ptr);

		get_device(phy->dev);

		goto err1;

	err2:
		devres_free(ptr);

	err1:
		spin_unlock_irqrestore(&phy_lock, flags);

	err0:
		of_node_put(node);

		return phy;
	}

That's pretty spaghetti-like.

Thierry

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUgF/4AAoJEN0jrNd/PrOhJaAP/i4hhUqO2AaBcdSPU9nsr9Ej
vYj/H9UWJpp5dcG+wZ6NPjZiLdI8I8pFFHGoSFWuCJwRYlKN97WX5Pq0wbDMgLpY
c6SSC9WY3Qvqyv+xx/7PBQjyafsjSv80tpwd/o38lh6ByEHXf4laSN5ySAyZf/HL
3fK9okZQ3Kiwr2dmV0EskB44877Yb5zviN71ULzLe2dj9j+iLXndH6wX/Rdikzxv
evVnghC6/uMnDCY3lhBHLGWevud5qnSQhWcWCVzYhJux9vu7CMOIyrAR6mkRyirb
MV5Bhlw3CAes82ezW6LQ+y2lZqJkWizsgsL12BHmdZYq9TCOpr2ieXuNUsJ0LE5C
ukigDz1YKNWi/0/JwC5944M2BiQdj7UEpRzvnR1V3GshaKCIQP/H1RnIWfSHK0mC
V7Ccya7RMVvmJUfPNvy6sLz0Myj2uf2NH7EHtbtb/vsoCpmjjRdKXf1IExdW1eeL
0j687Mb0qgn0x8yM7SXDkmkDvyR4+v+Z0x3end1maBRdLOBIK4GiVxGls+z9wqno
mjR7Lv8C3CWe3z3COKlZK5AQFVYkL+sQap0oB+16W/cVFDF8fx1YOrzqjiCRo6gl
MPe8QIoUGkgreV7hJx9CWe5LfxzoyuZ1hoCv/lDQLsipfU1goHvRaNpG+rHKSOdS
x4PVS2iNJPHYBwpIZkin
=JANr
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
