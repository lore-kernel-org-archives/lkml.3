Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaDWERh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:17:37 -0400
Received: from ozlabs.org ([103.22.144.67]:32907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbaDWERf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:17:35 -0400
Date: Wed, 23 Apr 2014 14:17:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140423141727.0262510673258b07e9a9fa4a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Apr_2014_14_17_27_+1000_XTiil/4_xe918AZN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Apr_2014_14_17_27_+1000_XTiil/4_xe918AZN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from arch/arm/mm/flush.c:20:0:
include/linux/hugetlb.h: In function 'hugepages_supported':
include/linux/hugetlb.h:468:9: error: 'HPAGE_SHIFT' undeclared (first use i=
n this function)

And a few more similarly.

Caused by commit c669debfbf05 ("hugetlb: ensure hugepage access is denied
if hugepages are not supported").

I added the following fix patch:

=46rom 91e29eff2be1b6bc0c9ea33b1ee901dd4877e924 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 Apr 2014 14:12:56 +1000
Subject: [PATCH] hugetlb: ensure hugepage access is denied if hugepages are
 not supported -fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/hugetlb.h | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 4eace5e94117..cbee9847e425 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -214,6 +214,15 @@ static inline int is_file_hugepages(struct file *file)
 	return 0;
 }
=20
+static inline bool hugepages_supported(void)
+{
+	/*
+	 * Some platform decide whether they support huge pages at boot
+	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
+	 * there is no such support
+	 */
+	return HPAGE_SHIFT !=3D 0;
+}
=20
 #else /* !CONFIG_HUGETLBFS */
=20
@@ -458,14 +467,4 @@ static inline spinlock_t *huge_pte_lock(struct hstate =
*h,
 	return ptl;
 }
=20
-static inline bool hugepages_supported(void)
-{
-	/*
-	 * Some platform decide whether they support huge pages at boot
-	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
-	 * there is no such support
-	 */
-	return HPAGE_SHIFT !=3D 0;
-}
-
 #endif /* _LINUX_HUGETLB_H */
--=20
1.9.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Apr_2014_14_17_27_+1000_XTiil/4_xe918AZN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVz7dAAoJEMDTa8Ir7ZwVwJgP/iHj8VUXkOv8ZRHYjpuAwtAM
r6Av13BAvWwucr32BU7Ae6cHWmcCy5JQCDtiILaCmv08vvqq05nmNWzNo6eSnCqh
9o2jh78u2Mmt+uQchMLgQ1qGlfow/EwbXfLV3biV8B8edygntgdZMlpevzIhfXyN
mgM9gWEUpgd3H1z+Qj7xf28S4b9NdnAmcfaqoddOFHI7Qj/rJW3YnQvs1VG0gwSD
7jgdoJpryB7cTs/VXBRRuufVTTkcSD+R5BrBXpb1mwXAS+jYlkue0fCKxe8zfz6C
yh6CQF7sEo9Hf8fJgueF0l0AY+xG+u+ZiK7ri07oWjY4rrzbg6tTSACEMzwfmtha
DSLliE9G2T4d9jmdOR2vr6ic4N0q0I3nztUX4exaIY0ybQWchz68pTVxHTLTIg1c
K9QLjY9E0upL+BLFvkrb6uHjTs+snKqYXpGAbdmnh+Z4Oj/92F56D3c3jxr/HYdM
VeFfusHcKLelgcq3aV1c6xMLOztmjte5pM7uQ/RuujVIXoWRAQO2mhrrq4MJJr/v
I6XB9KngS4sXptR2nMPNBo22vtdxdfw7YzZimVdVctHogDxxCf5uyzZeqOGWpgmr
VMEay/VTPcGzxgsl8/kWS+/JGE0csnzNIQGZnYXEJ/gOcwdd67MdRTQD+QswFOk5
Rfz7B/2S9DXZxRghXGCn
=MM8o
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Apr_2014_14_17_27_+1000_XTiil/4_xe918AZN--
