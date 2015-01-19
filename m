Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbbASIRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:17:31 -0500
Received: from ozlabs.org ([103.22.144.67]:41931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbbASIR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:17:29 -0500
Date: Mon, 19 Jan 2015 19:17:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20150119191718.365d4c98@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2fDZJS/8XhNqI8U9ndF/VFl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2fDZJS/8XhNqI8U9ndF/VFl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (sparc defconfig)
failed like this:

In file included from arch/sparc/include/asm/bug.h:20:0,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/asm-generic/preempt.h:4,
                 from arch/sparc/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/slab.h:14,
                 from mm/mmap.c:12:
mm/mmap.c: In function 'exit_mmap':
mm/mmap.c:2858:46: error: 'PUD_SHIFT' undeclared (first use in this functio=
n)
    round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
                                              ^
include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
  int __ret_warn_on =3D !!(condition);    \
                         ^
mm/mmap.c:2858:46: note: each undeclared identifier is reported only once f=
or each function it appears in
    round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
                                              ^
include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
  int __ret_warn_on =3D !!(condition);    \
                         ^

Caused by commit b316feb3c37f ("mm: account pmd page tables to the
process").  32 bit sparc does not seem to define PUD_SHIFT ...

I am not sure what the correct fix is here, so I just did the following
patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 19 Jan 2015 19:10:53 +1100
Subject: [PATCH] mm: account pmd page tables to the process fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/mmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 6a7d36d133fb..25271805ab39 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2854,8 +2854,10 @@ void exit_mmap(struct mm_struct *mm)
=20
 	WARN_ON(atomic_long_read(&mm->nr_ptes) >
 			round_up(FIRST_USER_ADDRESS, PMD_SIZE) >> PMD_SHIFT);
+#ifdef PUD_SHIFT
 	WARN_ON(mm_nr_pmds(mm) >
 			round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
+#endif
 }
=20
 /* Insert vm structure into process list sorted by address
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/2fDZJS/8XhNqI8U9ndF/VFl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvL2TAAoJEMDTa8Ir7ZwVEkcP+gPflWplhmrmMz1geZgoaylO
YI9A6LgexQKLCPwpt0emknXMOX8EEAx5SYgBpGdN8S5xcsYpsY/zbfYIrD/6Pm8t
jajiQHnRVhqZmZgliZ+fTYsGWPlWXo0USV4Fcq/OB3bpZnyRfsPI0olJuosQWONh
L1JuIiz/SAmSiParg5gzxPetfD3gwQM5UcznnoFukQ0liyVWW9SH//XimZ5meJ3N
1Cof9FDMGmNrLazqmvUTMdC2fzbf0Qr9euQf2UoygIV73xxiTa5IY/1LHyYStNYo
jzzi9koL2eIPKPEguGQ8ZaOGsyRdK0Je4S7CcsCF62tBxVmpWgAtL+iJW2hghNfQ
szITKfYZPsfjZ3v2eQzQa431rr9XMOJVz+IpjxnKpeY0N+/fC+qF5lrFZWZGf625
YXud37vx+hC1ahJlJafsM6nolPPKbQazYKZOI7YeprxwhEs/rDBqGABgcIL8kMIK
GyWP2w+BLFaycvSuKCTerH2t++tqkXlZ6GYy77wniCCKSNu+ogpgrKTZ+dLSiETl
2Q+fieEbkgqhaIDMCuwaFFecdU4rlEQWl3tJhkXsBmSm4e3ubxM3nf3E4UYPPCJa
W0PLDryUHHZCkXQL/toYmOm7ABRzt/fBmCI2lHc+cosTOSBk2syVzv+v48qHKup2
LpVrGfK6wChiX0Ch7NmM
=Rbtb
-----END PGP SIGNATURE-----

--Sig_/2fDZJS/8XhNqI8U9ndF/VFl--
