Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3KOE6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:58:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45214 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab3KOE5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:57:47 -0500
Date: Fri, 15 Nov 2013 15:57:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the akpm tree with the sparc-next tree
Message-Id: <20131115155733.b05306db95bc04bcb76c83f9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Nov_2013_15_57_33_+1100_PubQaX/XC9j_AMYj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Nov_2013_15_57_33_+1100_PubQaX/XC9j_AMYj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/sparc/mm/init_64.c between commit 37b3a8ff3e08 ("sparc64: Move from
4MB to 8MB huge pages") from the sparc-next tree and commit "sparc:
handle pgtable_page_ctor() fail" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/mm/init_64.c
index bd6430ded69f,d6de9353ee11..000000000000
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@@ -2563,16 -2511,21 +2563,16 @@@ pte_t *pte_alloc_one_kernel(struct mm_s
  pgtable_t pte_alloc_one(struct mm_struct *mm,
  			unsigned long address)
  {
 -	struct page *page;
 -	pte_t *pte;
 -
 -	pte =3D get_from_cache(mm);
 -	if (pte)
 -		return pte;
 +	struct page *page =3D alloc_page(GFP_KERNEL | __GFP_NOTRACK |
 +				       __GFP_REPEAT | __GFP_ZERO);
- 	pte_t *pte =3D NULL;
 =20
- 	if (page) {
- 		pgtable_page_ctor(page);
- 		pte =3D (pte_t *) page_address(page);
 -	page =3D __alloc_for_cache(mm);
+ 	if (!page)
+ 		return NULL;
+ 	if (!pgtable_page_ctor(page)) {
+ 		free_hot_cold_page(page, 0);
+ 		return NULL;
  	}
-=20
- 	return pte;
+ 	return (pte_t *) page_address(page);
  }
 =20
  void pte_free_kernel(struct mm_struct *mm, pte_t *pte)

--Signature=_Fri__15_Nov_2013_15_57_33_+1100_PubQaX/XC9j_AMYj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJShanBAAoJEMDTa8Ir7ZwVackP/iZ/8ue6eBn0VdjXBryFbMA3
2Y/wSOpUhBN6eWEw7B67/v3Hv3iWq/6cav/cXBa/2i6f88SGzfQYlDcrJjP4BKy8
1FQW+cOLIF86CAHmdwJoQw2N911DmLI4M9dKd58cocCO1WJb1KAP37ubn8YiYWX0
jogSouCfxNk0/LtBbmpiaEYJpgeeO83w7m01F0Dx06iE5tvIKv+j191M44Lsry2h
pxJJi/8lf0o3l0OAtwchhvXNzjLRcLlEp7CkmyEiUkO7ZfZdTTgXQEeQ0MmJiXy6
fmg4VKk/XVVqxhLn1p884y6eN5DmV6FGoRGJl1YYL8CeU4/cGyE3aCy5yysSrt6k
0vZ8zCqSXcdFNi6ukJ/8QVYwebH4cMEwyUslp90COrqRh3Kgcq0HJesXkj2kmCZk
PdswugylHECKuOX2DU98tX7NSjQ5nk7e3xLdUKsZlESiPpunusM9YfFpWAR2zehL
+a53ndmhQo3TNy/yFUqp94OzCxLRGEsoFR7phP0hrpx4WD5SEU2lHQj2DhY2wi7V
0utmgWrupaS0WBk1J0Ccyc6zQ+cGulrazyD5z4SyBSxSkqyvcpL1UO1n1aL58OnQ
3Yif4I7sd3WDWyjb7EXXKlq9MtJ/Yyh039XPJAcJXrqC4V0IeBSVdZIYdB3DVW0G
Qyvae32XtSxyGUczRJll
=TM/d
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Nov_2013_15_57_33_+1100_PubQaX/XC9j_AMYj--
