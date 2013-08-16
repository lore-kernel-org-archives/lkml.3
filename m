Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3HPGLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 02:11:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52997 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3HPGLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 02:11:31 -0400
Date: Fri, 16 Aug 2013 16:11:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20130816161119.2192be96e63d98aaf6714954@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Aug_2013_16_11_19_+1000_GgHV5G/2O0IH4bP6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Aug_2013_16_11_19_+1000_GgHV5G/2O0IH4bP6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/built-in.o: In function `.__offline_pages.constprop.10':
memory_hotplug.c:(.ref.text+0x10ec): undefined reference to `.is_hugepage_a=
ctive'

Caused by commit 9a9137504d7c ("mm: memory-hotplug: enable memory hotplug
to handle hugepage").

This build has CONFIG_HUGETLB_PAGE (which exposes the declaration of
is_hugepage_active() in include/linux/hugetlb.h, but
CONFIG_MEMORY_FAILURE unset (which hides the definition of
is_hugepage_active() in mm/hugetlb.c.

The single caller (in mm/memory_hotplug.c) is protected by
CONFIG_MEMORY_HOTREMOVE.

I have applied this patch for today (which may also not work in every
case):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 16 Aug 2013 16:06:19 +1000
Subject: [PATCH] mm: move is_hugepage_active() outside protecting ifdef

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/hugetlb.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0dc8ef9..38bc25b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3434,22 +3434,6 @@ follow_huge_pud(struct mm_struct *mm, unsigned long =
address,
=20
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
=20
-#ifdef CONFIG_MEMORY_FAILURE
-
-/* Should be called in hugetlb_lock */
-static int is_hugepage_on_freelist(struct page *hpage)
-{
-	struct page *page;
-	struct page *tmp;
-	struct hstate *h =3D page_hstate(hpage);
-	int nid =3D page_to_nid(hpage);
-
-	list_for_each_entry_safe(page, tmp, &h->hugepage_freelists[nid], lru)
-		if (page =3D=3D hpage)
-			return 1;
-	return 0;
-}
-
 bool is_hugepage_active(struct page *page)
 {
 	VM_BUG_ON(!PageHuge(page));
@@ -3472,6 +3456,22 @@ bool is_hugepage_active(struct page *page)
 	return page_count(page) > 0;
 }
=20
+#ifdef CONFIG_MEMORY_FAILURE
+
+/* Should be called in hugetlb_lock */
+static int is_hugepage_on_freelist(struct page *hpage)
+{
+	struct page *page;
+	struct page *tmp;
+	struct hstate *h =3D page_hstate(hpage);
+	int nid =3D page_to_nid(hpage);
+
+	list_for_each_entry_safe(page, tmp, &h->hugepage_freelists[nid], lru)
+		if (page =3D=3D hpage)
+			return 1;
+	return 0;
+}
+
 /*
  * This function is called from memory failure code.
  * Assume the caller holds page lock of the head page.
--=20
1.8.4.rc0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Aug_2013_16_11_19_+1000_GgHV5G/2O0IH4bP6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSDcKMAAoJEECxmPOUX5FEgvQQAIUr3awqhDe99g7DYqs/Y2vj
5fxazZIFarLXaD4xuhBCONF4GkgzeqPMNjnfvkfALBKH6hwKmv6s6IZyTC0ZpWsw
6BOQV3dte6l5BEQOvUjwI5wtBmOnk/wtby0G+QlRusqaxqMdnkObcRGperz9U5hK
5VbyTB/j1awKogCUf6+4VVbNDS8Xz1FYU+RTJxi1PAQjGeFb/0ocnxWOiaYBFS4T
bCAm0syIGjNaOSgX42ZwwlQrqo9XjtUGVd4kWJAmPwE3TAk5kI+TudI2xRBorkLn
Z/GFTCPSyuXHcCWw5k3KOzs1WxHkDYBiqhPS8cnNACtOvQwyShREwO1rCHScQnpA
TawTpvBvu4cp3wS1ajGmQf66/6/mc/7h+gkTo8gE09Cueu6GamaT20g3bLxKxfl5
zdiXJD92oWYxH9hj2CG4n6q/qDHk+BpIKJ+QFGakj7hvbiIcPmuqdfYg6KryOPa7
blaZwalDIS1rtH+H3ok/NDV+bdRDUWZ+ci9EkzU5NBoX0/FFu0GjRkOViAmoNGO/
px2/PTt0zULsSzI195jzFSHYNqTfnZ4kmQTl2Dfm1/LK2qu6HJwFoZb5a3pAa1kf
4/s5gooXrgfXG2dZH0HfsNl1w7n45eoY7gDjwkN2Hl4H9nqkXC3pi/tGcWQAzjF7
gH5f5cYfZNrod7ZVqsT3
=Kyrs
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Aug_2013_16_11_19_+1000_GgHV5G/2O0IH4bP6--
