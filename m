Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaKXNKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:10:49 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47990 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKXNKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:10:47 -0500
Date: Mon, 24 Nov 2014 14:10:41 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, kernel-build-reports@lists.linaro.org
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141124131034.GB4061@ulmo.nvidia.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: multipart/mixed; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2014 at 09:23:36PM +0530, Arjun Sreedharan wrote:
> When __of_usb_find_phy() fails, it returns -ENODEV - its
> error code has to be returned by devm_usb_get_phy_by_phandle().
> Only when the former function succeeds and try_module_get()
> fails should -EPROBE_DEFER be returned.
>=20
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/usb/phy/phy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

This causes a boot regression on at least NVIDIA Dalmore (I boot over
NFS using a USB network adapter).

The commit message is somewhat insufficient because while it explains
what the code does and asserts that it is the right thing to do, it
fails to explain why.

> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> index 045cd30..0310112 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct de=
vice *dev,
> =20
>  	phy =3D __of_usb_find_phy(node);
>  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> -		phy =3D ERR_PTR(-EPROBE_DEFER);
> +		if (!IS_ERR(phy))
> +			phy =3D ERR_PTR(-EPROBE_DEFER);

If we look at this closer, __of_usb_find_phy() return a valid pointer if
a PHY was found or ERR_PTR(-ENODEV) otherwise. But since the phandle has
already been validated, the only reason why __of_usb_find_phy() fails is
because the PHY that the phandle refers to hasn't been registered yet.

Returning -EPROBE_DEFER is the correct thing to do in this situation
because it gives the PHY driver an opportunity to register and the USB
host controller to try probing again. I suppose one could argue that
__of_usb_find_phy() should return ERR_PTR(-EPROBE_DEFER) on failure
instead of ERR_PTR(-ENODEV), since evidently the device does exist, it
just hasn't been registered yet. On the other hand it could happen that
the phandle refers to a device tree node that's status =3D "disabled", in
which case ERR_PTR(-ENODEV) might be appropriate.

Also, -EPROBE_DEFER isn't really the proper error for try_module_get()
failure. Other functions (usb_get_phy() and usb_get_phy_dev()) return
-ENODEV instead, so it'd be more consistent to stick with that. Hence I
propose something like the below instead.

Adding linux-next and kernel-build-reports in case anyone's running into
the same issue.

Thierry

--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=patch
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 2b1039e0f1ac..2f9735b35338 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -59,6 +59,9 @@ static struct usb_phy *__of_usb_find_phy(struct device_no=
de *node)
 {
 	struct usb_phy  *phy;
=20
+	if (!of_device_is_available(node))
+		return ERR_PTR(-ENODEV);
+
 	list_for_each_entry(phy, &phy_list, head) {
 		if (node !=3D phy->dev->of_node)
 			continue;
@@ -66,7 +69,7 @@ static struct usb_phy *__of_usb_find_phy(struct device_no=
de *node)
 		return phy;
 	}
=20
-	return ERR_PTR(-ENODEV);
+	return ERR_PTR(-EPROBE_DEFER);
 }
=20
 static void devm_usb_phy_release(struct device *dev, void *res)
@@ -190,8 +193,13 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct dev=
ice *dev,
 	spin_lock_irqsave(&phy_lock, flags);
=20
 	phy =3D __of_usb_find_phy(node);
-	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
-		phy =3D ERR_PTR(-EPROBE_DEFER);
+	if (IS_ERR(phy)) {
+		devres_free(ptr);
+		goto err1;
+	}
+
+	if (!try_module_get(phy->dev->driver->owner)) {
+		phy =3D ERR_PTR(-ENODEV);
 		devres_free(ptr);
 		goto err1;
 	}

--cmJC7u66zC7hs+87--

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUcy5KAAoJEN0jrNd/PrOh/5AP/2sRna31LH4VCT6ZotXICssI
1/Sv7IR0eKCqWUsBrEnACMd091vICdp4Y7zQEkACBsK7HSSzA/5F8HzAceXAMTsf
ocjcax8HiE1bw5BpUlhLKy88/2hR1S8iek8hQQQYOdSopp6ojLp4iKKlk2OU20n2
7LZAnlHEl5/9JHjQ4qV6qsCI6YF1nGX9C9v3bULF7q8wfANGb2KGX+dKsTa7E/eD
tTfSoljanxMgIs9Las0OQgUXq90euoDHj2cXA8+8VoQbZJDHD7GiAzz7blrg5Lug
SdwUdfZgTfjU5QkGUA7mKDYsbGOUtFZzk+uYzFfonMzStXWjQ5IqY/EOnYBT7QK4
3m5nVbmFH/9Jew3nu3eSimwmSXBiDOA4Y0w9j1fK80BA17r0O3q83PvWkad593Cu
0pyEDpNkJIwGHe4YWTlXfPPWIsXU9igoHQpzNmyUURG1F4eSs/XztqXtnQ8mnrfw
sRlK4h1roptV2hhtP2/espI6qVjot2WjlDMUBq1+oJ96nONTxdNQ9WeNxYIVPAJG
UbYQybWs60101NYyYFrgVpbizqkl0QwA45vFpvpHkHOkErjczctDL79Ol2dGhuuV
Q+SohhAqU+wzK+439MoiM3SYXnJJQqhjw3uabIBmd4HV5wz7TQ0JkO7fcTvI1Ko+
5p+zoANbhHPqQt7rpsC3
=aBfP
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
