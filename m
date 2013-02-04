Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3BDHRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:17:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38227 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3BDHRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:17:33 -0500
Date: Mon, 4 Feb 2013 18:17:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Wen Congyang <wency@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130204181724.4f55ae04b00b458ebb5abba4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_18_17_24_+1100_FGorheZfVQeoij.w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_18_17_24_+1100_FGorheZfVQeoij.w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/mm/init_64.c: In function 'remove_pmd_table':
arch/x86/mm/init_64.c:921:3: error: implicit declaration of function 'map_l=
ow_page' [-Werror=3Dimplicit-function-declaration]
arch/x86/mm/init_64.c:921:14: warning: cast to pointer from integer of diff=
erent size [-Wint-to-pointer-cast]
arch/x86/mm/init_64.c:924:3: error: implicit declaration of function 'unmap=
_low_page' [-Werror=3Dimplicit-function-declaration]
arch/x86/mm/init_64.c: In function 'remove_pud_table':
arch/x86/mm/init_64.c:978:14: warning: cast to pointer from integer of diff=
erent size [-Wint-to-pointer-cast]
arch/x86/mm/init_64.c: In function 'remove_pagetable':
arch/x86/mm/init_64.c:1004:9: warning: cast to pointer from integer of diff=
erent size [-Wint-to-pointer-cast]

Caused by commit "memory-hotplug: common APIs to support page tables
hot-remove" from the akpm tree interacting with commit 973dc4f3fad5
("x86, mm: Remove early_memremap workaround for page table accessing on
64bit") from the tip tree.

I applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 4 Feb 2013 18:12:17 +1100
Subject: [PATCH] memory-hotplug: common APIs to support page tables hot-rem=
ove fix fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/mm/init_64.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 951cc1e..67bad4b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -918,10 +918,9 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr,=
 unsigned long end,
 			continue;
 		}
=20
-		pte_base =3D (pte_t *)map_low_page((pte_t *)pmd_page_vaddr(*pmd));
+		pte_base =3D (pte_t *)pmd_page_vaddr(*pmd);
 		remove_pte_table(pte_base, addr, next, direct);
 		free_pte_table(pte_base, pmd);
-		unmap_low_page(pte_base);
 	}
=20
 	/* Call free_pmd_table() in remove_pud_table(). */
@@ -975,10 +974,9 @@ remove_pud_table(pud_t *pud_start, unsigned long addr,=
 unsigned long end,
 			continue;
 		}
=20
-		pmd_base =3D (pmd_t *)map_low_page((pmd_t *)pud_page_vaddr(*pud));
+		pmd_base =3D (pmd_t *)pud_page_vaddr(*pud);
 		remove_pmd_table(pmd_base, addr, next, direct);
 		free_pmd_table(pmd_base, pud);
-		unmap_low_page(pmd_base);
 	}
=20
 	if (direct)
@@ -1001,11 +999,10 @@ remove_pagetable(unsigned long start, unsigned long =
end, bool direct)
=20
 		next =3D pgd_addr_end(start, end);
=20
-		pud =3D (pud_t *)map_low_page((pud_t *)pgd_page_vaddr(*pgd));
+		pud =3D (pud_t *)pgd_page_vaddr(*pgd);
 		remove_pud_table(pud, start, next, direct);
 		if (free_pud_table(pud, pgd))
 			pgd_changed =3D true;
-		unmap_low_page(pud);
 	}
=20
 	if (pgd_changed)
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Feb_2013_18_17_24_+1100_FGorheZfVQeoij.w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRD2CEAAoJEECxmPOUX5FE06oP/3gyYb/Lx/ZdqnNU4cmfCyUK
hlNucU7sk4QKNqH1SlhSrLhD28TWh1i1ZcRnYEqtvg3ucFX5IIS7rfXaS0wnC6Rm
rRq9nh2gBHk9z2ts2Ai7WGW6+YCnVT7WABCHxZN/zMnQHiky6q54+LxaixL+X8PD
1aEu5PPfh/dqm34qTRQtnPmWuzIQGJbZ6cb+K+t3Sos5kSwMEUQ00nuK+4fE4DZC
B73318XvwZbF9vf3JXMu1KRfjrPqiYm7dj/EjJwabLSAjiV1mH42J6IOvv9uwmNU
JSQyb88d1eGdh2pvw35+wtAK3BW9siwnkZiP9Mx0GLpji3cI0g3E+VsOEwUb7xcm
Gk9tsghWqCzTIrwVC1hqILzFDFe5BLyc7y3J15kiMkceROEbyahXTFJFnKryINsC
JGOFdiZrFuwRJtVW4DgKARoRGgB4LSma/7MLokkKNXY+pmVit9y9nFRLy1rRYOgr
eAFEsJmDEiSApmiz2TTWveyTZjb/7ch+q4YxuC/UpLdgorlIZKILwFQeGszdkNnD
3RHGmw28r+BXqxMlim9C32SuXAVcyabZCry42+NL/XQkfO7p5exEs5p0kjDJP5qv
d0MwcKEQFfKlqQHdVXfjC0tPskw0FTeAil+rT+aps4wFg65/Cnr9xuK8iwYFa89x
zsX4GPlqIW9058Ga3IPP
=QIBg
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_18_17_24_+1100_FGorheZfVQeoij.w--
