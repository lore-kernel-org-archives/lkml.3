Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaAaKwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:52:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaAaKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:52:09 -0500
Message-ID: <52EB804C.2090506@canonical.com>
Date: Fri, 31 Jan 2014 10:51:56 +0000
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: David Herrmann <dh.herrmann@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: drm/cirrus: Ignore busy mem region when mapping VRAM
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4otp4OKUwtbfHngkbhnm3uQFJiIJE7oEl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4otp4OKUwtbfHngkbhnm3uQFJiIJE7oEl
Content-Type: multipart/mixed;
 boundary="------------010803070202010207090600"

This is a multi-part message in MIME format.
--------------010803070202010207090600
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

I know this is a gross hack but something like that currently is required=
 to
avoid a KVM guest booted from graphical grub mode (so simplefb is taking =
effect)
getting into a state where there is no framebuffer in use at all (since s=
implefb
was removed but cirrus fails to acquire VRAM resources which are held by =
the
platform device). _Guests in that stage appear to be frozen but can be re=
ached
via network login with no problems.

It would be possible to release the mem region in the simplefb driver whe=
n
unmapping but that sounds equally bad. Is someone already looking into so=
me
better solution here? Should the platform device be removed or what would=
 be a
good way to go forward here?

-Stefan

--

=46rom 5eaa87a69bb40ffeec759b6e5aeec1a26bba1680 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 29 Jan 2014 16:45:12 +0000
Subject: [PATCH] drm/cirrus: Ignore busy mem region when mapping VRAM

Since 29d274b8d3e2404cd1832b3a999b12f9d1e1d895 ("x86/simplefb: Mark
framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning")
the messages for real hw drivers mapping the same region as the simple-
framebuffer are gone. But now the cirrus drm driver will always fail
to initialize its VRAM because the region is busy. Removing the
conflicting framebuffer only can stop simplefb from using the memory
and unmap it but it is the platform device which has the region assined
to itself.
As the comment of the above patch indicates there is currently no sane
way to get rid of the platform device. So at least for now accept that
the region can appear busy. It is usuable nonetheless.
This will fix VMs using the cirrus gfx emulation to appear locked up
when booting from GRUB gfx mode.

BugLink: http://bugs.launchpad.net/bugs/1269401

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/cirrus/cirrus_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c
b/drivers/gpu/drm/cirrus/cirrus_main.c
index 557d094..9f0193f 100644
--- a/drivers/gpu/drm/cirrus/cirrus_main.c
+++ b/drivers/gpu/drm/cirrus/cirrus_main.c
@@ -101,8 +101,15 @@ static int cirrus_vram_init(struct cirrus_device *cd=
ev)

 	if (!request_mem_region(cdev->mc.vram_base, cdev->mc.vram_size,
 				"cirrusdrmfb_vram")) {
-		DRM_ERROR("can't reserve VRAM\n");
-		return -ENXIO;
+		/*
+		 * With the simple-framebuffer now marking the region
+		 * busy there is no way of this succeeding with having
+		 * the framebuffer active. Getting here means the old
+		 * one has been kicked and the region is unmapped but
+		 * there is no way to eject the platform device to get
+		 * the request_region undone.
+		 */
+		DRM_ERROR("can't reserve VRAM (ignored)\n");
 	}

 	return 0;
--=20
1.8.3.2

--------------010803070202010207090600
Content-Type: text/x-diff;
 name="0001-drm-cirrus-Ignore-busy-mem-region-when.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-drm-cirrus-Ignore-busy-mem-region-when.patch"

=46rom 5eaa87a69bb40ffeec759b6e5aeec1a26bba1680 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 29 Jan 2014 16:45:12 +0000
Subject: [PATCH] drm/cirrus: Ignore busy mem region when mapping VRAM

Since 29d274b8d3e2404cd1832b3a999b12f9d1e1d895 ("x86/simplefb: Mark
framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning")
the messages for real hw drivers mapping the same region as the simple-
framebuffer are gone. But now the cirrus drm driver will always fail
to initialize its VRAM because the region is busy. Removing the
conflicting framebuffer only can stop simplefb from using the memory
and unmap it but it is the platform device which has the region assined
to itself.
As the comment of the above patch indicates there is currently no sane
way to get rid of the platform device. So at least for now accept that
the region can appear busy. It is usuable nonetheless.
This will fix VMs using the cirrus gfx emulation to appear locked up
when booting from GRUB gfx mode.

BugLink: http://bugs.launchpad.net/bugs/1269401

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/cirrus/cirrus_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c b/drivers/gpu/drm/cirru=
s/cirrus_main.c
index 557d094..9f0193f 100644
--- a/drivers/gpu/drm/cirrus/cirrus_main.c
+++ b/drivers/gpu/drm/cirrus/cirrus_main.c
@@ -101,8 +101,15 @@ static int cirrus_vram_init(struct cirrus_device *cd=
ev)
=20
 	if (!request_mem_region(cdev->mc.vram_base, cdev->mc.vram_size,
 				"cirrusdrmfb_vram")) {
-		DRM_ERROR("can't reserve VRAM\n");
-		return -ENXIO;
+		/*
+		 * With the simple-framebuffer now marking the region
+		 * busy there is no way of this succeeding with having
+		 * the framebuffer active. Getting here means the old
+		 * one has been kicked and the region is unmapped but
+		 * there is no way to eject the platform device to get
+		 * the request_region undone.
+		 */
+		DRM_ERROR("can't reserve VRAM (ignored)\n");
 	}
=20
 	return 0;
--=20
1.8.3.2


--------------010803070202010207090600--

--4otp4OKUwtbfHngkbhnm3uQFJiIJE7oEl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS64BWAAoJEOhnXe7L7s6j1ukQAJwBIpB1hxUQXe6C2r7j6Fn2
xJ/4BU2orNdXPzHPyIjZ2dHl6nKQlZlInhiIRH10YrOeE0XQf8m3DjNTnb+k5aDq
BzrbP4DLtM8sIL+yKUfODplikVD4Fgz8XOosrEDC0/L0KXqBFIKihQ6dHM9JxGBp
fLJgNbtqRuBIysZw4I+Xd+nJIaU+fyM78cRvC1awbAmKj0q+OBHWug+JY1RzWKlP
YgWydy3xj513PVR1SSmBYWSRypaPbObzmS829aKtbZviM9kfnrqiU9neH/qvUumk
8mwwpu+ogoBE64oW9cfiK/2yashWfyPMp1ccqdgfiaao6ZdwbCCjcRmiY1hSqgt1
uYkEX3hSTGPaKIquUEYCzAsVV7bHDNdoP29AX1Ai+XjwArtMCX7YCi19eowvDC4C
0jXkv+zzCM9JOu7HKz9E2fHL5qYuopc2RNSZdJ8+VVJt/8VdO51ZWkXxKgR87sNf
78GpH7CZFkhgmXaXRUgH6pm4EIwql1B8p3ppfCijmCxlRzvC8dhorbmeZLRyELp1
KSvTH80s2kMc6tvf5F9T5MW1M6ci4DZNIekNb2Sb4rMOMtvj7z28CyUC3b4t8/cd
hyOgaT0mfSIhIquuRFpaipZHp80cxZwCbyv/VgeNDmGpvW7Ol8JgpjeNQeWZUjmB
04KGtYF76YIpNvUeAjrP
=UKoF
-----END PGP SIGNATURE-----

--4otp4OKUwtbfHngkbhnm3uQFJiIJE7oEl--
