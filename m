Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaKFFox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:44:53 -0500
Received: from ozlabs.org ([103.22.144.67]:58347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaKFFov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:44:51 -0500
Date: Thu, 6 Nov 2014 16:44:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141106164444.2123e6d5@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SQkIU+9a3=4JgIXNI2LX1AA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SQkIU+9a3=4JgIXNI2LX1AA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/fremap.c: In function 'SYSC_remap_file_pages':
mm/fremap.c:241:22: error: 'struct address_space' has no member named 'i_mm=
ap_mutex'
   mutex_lock(&mapping->i_mmap_mutex);
                      ^
mm/fremap.c:247:24: error: 'struct address_space' has no member named 'i_mm=
ap_mutex'
   mutex_unlock(&mapping->i_mmap_mutex);
                        ^

Caused by commit 1f8c97e79f66 ("mm: convert i_mmap_mutex to rwsem").

I applied this patch for today (not sure if there is a better way):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Nov 2014 16:26:41 +1100
Subject: [PATCH] mm: convert i_mmap_mutex to rwsem fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/fremap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 9129013732d7..2805d71cf476 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -238,13 +238,13 @@ get_write_lock:
 			}
 			goto out_freed;
 		}
-		mutex_lock(&mapping->i_mmap_mutex);
+		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |=3D VM_NONLINEAR;
 		vma_interval_tree_remove(vma, &mapping->i_mmap);
 		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		flush_dcache_mmap_unlock(mapping);
-		mutex_unlock(&mapping->i_mmap_mutex);
+		i_mmap_unlock_write(mapping);
 	}
=20
 	if (vma->vm_flags & VM_LOCKED) {
--=20
2.1.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/SQkIU+9a3=4JgIXNI2LX1AA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWwrQAAoJEMDTa8Ir7ZwVZdMP/1ounCfXn1ZPfxzdn0JFyuyL
L5SvDu4ZdJ1sC5ITaxh1idluh/PdQ+yS3Woz/GsM08WIE8DYBkzPJZurZ7KQyO07
9ReI2vzr/4iWuoIBcrzbq0ObgatbP4rt6unY/nzFv9ALx6S6ZJMfXKeMCLfb8P1N
TEw4yl4Lx4d5ohaYH+pB5UeMkVYb2uc5l6D3drMkV7bsGsrGGSpCPLqgKXN4/Jhh
+8F+EwfcqiJ/OpxCThyqHek6/3voTD3krSTCXIWGGUj3Khpqu/iUh7hebJKzKg48
XUXfhfn6CGHwvQ3mzXVPvUew7TCfXGs7+plDFUYaiUAmxA74f3jMv1ggG5vUinQn
8WaciZMlK+qoJa9iYZQW+8RCttoBaqfOHyGy532rbUzaN9uqcqx2lu8arHpKD162
PL2g0Xoc1QVrJP18Ly/aSHG8vMuxKIE+U1njztVN889T/mjSTsVr0Kgo5a9TfBgN
eUppGLa5JbbHEMb40XwIkWd4fJfa663o2XH5g4rO1QdR30BD0b8MFESUKHwdIPd0
7102ki0mBbnpx6mu8OYqkKvNrX1mzpKdd0ZX5aOg2SDmmALPT//FjdRNm6uMd9Ui
vvmHT68DG0LlVI1O87a9X5KbkghJMbQ8lT6tgLacZWnImz7xkymuz9Tt44IZlepP
/R6BLlhUP13rDTGFwFPr
=pyd6
-----END PGP SIGNATURE-----

--Sig_/SQkIU+9a3=4JgIXNI2LX1AA--
