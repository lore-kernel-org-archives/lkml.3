Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaIHJqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:46:06 -0400
Received: from ozlabs.org ([103.22.144.67]:33309 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbaIHJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:46:04 -0400
Date: Mon, 8 Sep 2014 19:45:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140908194557.21b3fc2e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0B6ThQ0Bqv/j.cvOndC2d2z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0B6ThQ0Bqv/j.cvOndC2d2z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
allyesconfig) failed like this:

mm/page_alloc.c: In function 'dump_vma':
mm/page_alloc.c:6742:46: error: request for member 'pgprot' in something no=
t a structure or union
   vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
                                              ^

Caused by commit d1305f0fa17f ("mm: introduce dump_vma").  pgprot_t on
PPC is normally (i.e. unless STRICT_MM_TYPECHECKS is explicitly
defined) just an "unsigned long" (see
arch/powerpc/include/asm/page.h).  This is true for several other
architectures as well.

I added this fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Sep 2014 19:41:54 +1000
Subject: [PATCH] mm: introduce dump_vma fix 2

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb510c08073b..0de60769bcf6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6739,7 +6739,7 @@ void dump_vma(const struct vm_area_struct *vma)
 		"prot %lx anon_vma %p vm_ops %p\n"
 		"pgoff %lx file %p private_data %p\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-		vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
+		vma->vm_prev, vma->vm_mm, pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data);
 	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
--=20
2.1.0


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/0B6ThQ0Bqv/j.cvOndC2d2z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDXrZAAoJEMDTa8Ir7ZwVNEYP/idSeCGW7mOA9OGqdSXs9Wmj
Ya/wJHHIZxX550lus9XYxe/9t5XsmC4nJ+eBwTrGitof4x/eDqBCW4tUBCZOiUo8
Br1RfVahIFJvKcuanwwW4iALYdJxSOcr0hGisKT4ti1IKUZto+pic+FT2ji1WXlw
VIbee+LYulC8XYmDibIVSKCvg1VgW5Ebsopw5HRh1FTnU8uZaQ+HtuLi13UMnW1R
S69vJUqxLffTtn3dK7wA4zEZ93AnYSLP0QDrGYHagO/lNeFkT0NAednwkX7h50WA
LWfZ5MAo7a+oGdTyu1p4H+/GrqTgO43KD39iI1yQaih9BdWw7vTy+J8RDMt01it5
4zVq4qWGKC1qS55gZ8tAvHXKIOcYIp7cBhSBGzfGuCVsfto8OwvoRMYznSrLh7+L
qsYVLVUl10/R3DUBu8KBw5blmhUEJp8S8UDx20uGgOWs5RgHe6uqspRyHRJfy/GS
sr45fKP7RHHgAxj6eQ9mFlDPa2ju+qd+lo/K/MSAGE/YvMO6ahDLuCz8gpIXumTm
J7n1FPP0tuPCytcNlRW9pxXUJA3f1dqJz51VHUM3C6REGLdQXi/8A6dHmnEc925n
2Pf8x21q1tUK2yC3HaJ7OLQtYpBqJixZYmhqpk2Jvct8koO1w9uyKi1G5W0374WP
nDsaMawuYdl1R+2RKuR9
=oTes
-----END PGP SIGNATURE-----

--Sig_/0B6ThQ0Bqv/j.cvOndC2d2z--
