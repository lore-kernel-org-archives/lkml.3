Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3D2Bfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:35:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60548 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3D2Bfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:35:46 -0400
Date: Mon, 29 Apr 2013 11:35:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the vfs tree with the powerpc tree
Message-Id: <20130429113540.55b2593d303bc2a9142919fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_11_35_40_+1000_7twd2=FMfYKT3uPf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_11_35_40_+1000_7twd2=FMfYKT3uPf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
arch/powerpc/kernel/rtas_flash.c between commit ad18a364f186
("powerpc/rtas_flash: Free kmem upon module exit"),  from the powerpc
tree and commit 5c0333c00ff6 ("ppc: Clean up rtas_flash driver somewhat")
from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kernel/rtas_flash.c
index a3e4034,8196bfb..0000000
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@@ -806,20 -740,17 +758,22 @@@ enomem_buf
 =20
  static void __exit rtas_flash_cleanup(void)
  {
+ 	int i;
+=20
  	rtas_flash_term_hook =3D NULL;
 =20
 +	if (rtas_firmware_flash_list) {
 +		free_flash_list(rtas_firmware_flash_list);
 +		rtas_firmware_flash_list =3D NULL;
 +	}
 +
- 	if (flash_block_cache)
- 		kmem_cache_destroy(flash_block_cache);
+ 	for (i =3D 0; i < ARRAY_SIZE(rtas_flash_files); i++) {
+ 		const struct rtas_flash_file *f =3D &rtas_flash_files[i];
+ 		remove_proc_entry(f->filename, NULL);
+ 	}
 =20
- 	remove_flash_pde(firmware_flash_pde);
- 	remove_flash_pde(firmware_update_pde);
- 	remove_flash_pde(validate_pde);
- 	remove_flash_pde(manage_pde);
+ 	kmem_cache_destroy(flash_block_cache);
+ 	kfree(rtas_validate_flash_data.buf);
  }
 =20
  module_init(rtas_flash_init);

--Signature=_Mon__29_Apr_2013_11_35_40_+1000_7twd2=FMfYKT3uPf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfc5sAAoJEECxmPOUX5FEwY8P/3/NCSy0xC1uFbWmhOhyh4uo
bTeoLBIw67kh6HUQYimQm/vcAofREmoLVNTu8rkQ6XlGE/ZtRWqLsQQ2tujwgDHq
LniVT38GqlfQyI+Ze2KlQJpxk3mJGyKgUHVMhzoDYLdSkDMCJp0a+lA2Ze9QY/Pc
OyeaH38Qqu99U7vLJAIFUEhaA7BPs7byXIRa2AZ8j9Qgx941No+uzcQRNOjfU6yn
yR2G9gfIghZpWOligNmlIKgyGqvQS9iPR1JHtSl572GgCZroycyDGle6VnqDR3k1
ZEmoD5GJT4bRME8hhL70zEvRfazKTWcaREprx+g2yaxCR7uiDG579AXi4xWsWSRC
zV/qF5eHuy1dUw+X6VQCi5a4lcAD1O4iChYP5x+Jf7LN3GiPvr6TBuYiCT0v7HD+
27odo0HX49S5kOSW837tYCbXTHIffAYU7Te9uu39nCJTXnkBOXvnPj2EKSYSugM5
7m47PDiZsKOn9NBnvkmlYKiDYuHso9F0c6aTwAtpvUAW65Sko65yUvExzCF+dkrj
AgoEPDv6kTcCv1Xw5pi+ycrQuJrW+QZEai9apu+r6j7dfZziqGcKS29lYOwf8uWp
MuF0XS5Hu2ixKCnw0ZIBzD0YtJDfYRNTHgyvij8TAkrc/d7m0pStcm0+SbbyC14b
Gsle7wQ3FypJKPdzf1TK
=1gIE
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_11_35_40_+1000_7twd2=FMfYKT3uPf--
