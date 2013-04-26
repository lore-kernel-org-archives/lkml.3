Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3DZFbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:31:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52422 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab3DZFbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:31:13 -0400
Message-ID: <517A1117.7000501@ti.com>
Date: Fri, 26 Apr 2013 08:31:03 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20130426151027.db71ddf367c85fe0682cbff6@canb.auug.org.au>
In-Reply-To: <20130426151027.db71ddf367c85fe0682cbff6@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3E463DA5528557B4BFCD88B4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig3E463DA5528557B4BFCD88B4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-04-26 08:10, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> After merging the omap_dss2 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/video/ps3fb.c: In function 'ps3fb_mmap':
> drivers/video/ps3fb.c:710:2: error: implicit declaration of function 'v=
m_ioremap_memory' [-Werror=3Dimplicit-function-declaration]
> drivers/video/ps3fb.c:712:2: error: 'offset' undeclared (first use in t=
his function)
>=20
> Caused by commit 6ea19860d6c5 ("fbdev/ps3fb: use vm_iomap_memory()").
>=20
> I have used the omap_dss2 tree from next-20130424 for today.
>=20

Thanks. Updated patch below. I couldn't right away find where to download=
 a
ppc64 toolchain, so not compile tested...

 Tomi


=46rom 11bd5933abe033fb7a3a0d1f1bd2cb4b6df8143f Mon Sep 17 00:00:00 2001
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Thu, 18 Apr 2013 07:52:42 +0300
Subject: [PATCH] fbdev/ps3fb: use vm_iomap_memory()

Use vm_iomap_memory() instead of [io_]remap_pfn_range().
vm_iomap_memory() gives us much simpler API to map memory to userspace,
and reduces possibilities for bugs.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/ps3fb.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 920c27b..d9f08c6 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -705,21 +705,15 @@ static int ps3fb_pan_display(struct fb_var_screenin=
fo *var,
=20
 static int ps3fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
-	unsigned long size, offset;
+	int r;
=20
-	size =3D vma->vm_end - vma->vm_start;
-	offset =3D vma->vm_pgoff << PAGE_SHIFT;
-	if (offset + size > info->fix.smem_len)
-		return -EINVAL;
-
-	offset +=3D info->fix.smem_start;
-	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
-			    size, vma->vm_page_prot))
-		return -EAGAIN;
+	r =3D vm_iomap_memory(vma, info->fix.smem_start, info->fix.smem_len);
=20
 	dev_dbg(info->device, "ps3fb: mmap framebuffer P(%lx)->V(%lx)\n",
-		offset, vma->vm_start);
-	return 0;
+		info->fix.smem_start + vma->vm_pgoff << PAGE_SHIFT,
+		vma->vm_start);
+
+	return r;
 }
=20
     /*
--=20
1.7.10.4




--------------enig3E463DA5528557B4BFCD88B4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRehEbAAoJEPo9qoy8lh71kJsQAJWW1Wn+UPvASyDoah0c16jC
qV9591i7Io/1GmjUz0wO0J/y2ikknXHWkd84lH60ymD4gZ8HtxOmUl+UrKDu75ew
g4jEYNbCBnD18oy5IZiCbuuvOlCo41Xp+vfYfvvGBmRrKxMp1vD3Kw+5EYASXeh4
aWnJVB0U+Qq3yXgH2Lj7j8kwCcnYjn05yJrKyVKb6HuIfaMVpBPu7kTDdUFvqN5W
w6PHoNRqJX1cz8uLCUd6MReGGGINSjwC4Qx2zRg9s7rV3if3vUeReqDSYpLxlLZi
soyvTczMQME905Ce32OfXk6PnJ0Cvi1V4XWPvH2Y0SQby7M6mhzgaHnuzVgveEvM
dNES0tqdhKakPFSzEFSdEakVzna1uRkeBMbb4m9EKldVMRgbydXRLIbtF9XVW4nA
oXmKL4jetLrvpg3/A1PVuy/hLt+EfeiHR5KRCHSQHlMmW8qTgtSPAByW9edAykec
nPdCr9jSl0Kd9o2Gf9qG6+7xH6Mvra/rkcwyv1pEwNgIcb4tGmR9/zhu2m1D9ge/
GdG5s2xXCw3NSdz6zDo/E/fefqF0+F4niuurLs5Fe7w8Slck6WtbIW4Sa21FJL3L
XbVgrHYRBkU7jNfkirjhsSrEgutIrdCzslHvSXG8dA+cfXLdgbN1HTYQ8YSsZFjc
O4YCWcmsYeekouEH4Rp6
=AETJ
-----END PGP SIGNATURE-----

--------------enig3E463DA5528557B4BFCD88B4--
