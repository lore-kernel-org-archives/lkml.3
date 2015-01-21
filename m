Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbbAUFlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:41:05 -0500
Received: from ozlabs.org ([103.22.144.67]:57602 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbAUFlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:41:03 -0500
Date: Wed, 21 Jan 2015 16:40:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Rob Ward <robert.ward114@googlemail.com>
Subject: linux-next: manual merge of the char-misc tree with the block tree
Message-ID: <20150121164056.2a21289c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TBnxOymMj=NAABp4cxvWG_S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TBnxOymMj=NAABp4cxvWG_S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/char/mem.c between commit b4caecd48005 ("fs: introduce
f_op->mmap_capabilities for nommu mmap support") from the block tree
and commit 73f0718e74e2 ("drivers: char: mem: Make /dev/mem an optional
device") from the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/mem.c
index 9a6b63783a94,080273287c48..000000000000
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@@ -732,25 -717,17 +728,23 @@@ static const struct file_operations __m
  	.write		=3D write_mem,
  	.mmap		=3D mmap_mem,
  	.open		=3D open_mem,
 +#ifndef CONFIG_MMU
  	.get_unmapped_area =3D get_unmapped_area_mem,
 +	.mmap_capabilities =3D memory_mmap_capabilities,
 +#endif
  };
 =20
- #ifdef CONFIG_DEVKMEM
- static const struct file_operations kmem_fops =3D {
+ static const struct file_operations __maybe_unused kmem_fops =3D {
  	.llseek		=3D memory_lseek,
  	.read		=3D read_kmem,
  	.write		=3D write_kmem,
  	.mmap		=3D mmap_kmem,
  	.open		=3D open_kmem,
 +#ifndef CONFIG_MMU
  	.get_unmapped_area =3D get_unmapped_area_mem,
 +	.mmap_capabilities =3D memory_mmap_capabilities,
 +#endif
  };
- #endif
 =20
  static const struct file_operations null_fops =3D {
  	.llseek		=3D null_lseek,
@@@ -793,22 -775,24 +785,24 @@@ static const struct memdev=20
  	const char *name;
  	umode_t mode;
  	const struct file_operations *fops;
 -	struct backing_dev_info *dev_info;
 +	fmode_t fmode;
  } devlist[] =3D {
+ #ifdef CONFIG_DEVMEM
 -	 [1] =3D { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
 +	 [1] =3D { "mem", 0, &mem_fops, FMODE_UNSIGNED_OFFSET },
+ #endif
  #ifdef CONFIG_DEVKMEM
 -	 [2] =3D { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 +	 [2] =3D { "kmem", 0, &kmem_fops, FMODE_UNSIGNED_OFFSET },
  #endif
 -	 [3] =3D { "null", 0666, &null_fops, NULL },
 +	 [3] =3D { "null", 0666, &null_fops, 0 },
  #ifdef CONFIG_DEVPORT
 -	 [4] =3D { "port", 0, &port_fops, NULL },
 +	 [4] =3D { "port", 0, &port_fops, 0 },
  #endif
 -	 [5] =3D { "zero", 0666, &zero_fops, &zero_bdi },
 -	 [7] =3D { "full", 0666, &full_fops, NULL },
 -	 [8] =3D { "random", 0666, &random_fops, NULL },
 -	 [9] =3D { "urandom", 0666, &urandom_fops, NULL },
 +	 [5] =3D { "zero", 0666, &zero_fops, 0 },
 +	 [7] =3D { "full", 0666, &full_fops, 0 },
 +	 [8] =3D { "random", 0666, &random_fops, 0 },
 +	 [9] =3D { "urandom", 0666, &urandom_fops, 0 },
  #ifdef CONFIG_PRINTK
 -	[11] =3D { "kmsg", 0644, &kmsg_fops, NULL },
 +	[11] =3D { "kmsg", 0644, &kmsg_fops, 0 },
  #endif
  };
 =20

--Sig_/TBnxOymMj=NAABp4cxvWG_S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvzvtAAoJEMDTa8Ir7ZwVl7QQAIJ1g9DVV9Vu/WRLlcVdrRh2
akv3mZf/bJrceVjJyZdW5FBUKLWwwkQmDvh8Ue+DNAY1XVG3UbD7IzNnmP9BJgni
4Gevhkjj9wNUZXKYoN5UPlWMb6rIkhUrwysNCdTvrlbUrJRpFXh6EoZo7XD6hd8w
es4E62eGN3qu572VRJJSMdga/aE04+0prhSSu7lw4sPdGm7/I/TmHPTLnYXOIHrn
6DHbZrCJEdTFmUBVPD5Bp3t11lu7cDpilOwrqakoCkNvI76RM61BXkBvV9ehxzuE
tFmhqJ36JtKKN+sBMCGZybnys+Pnu+rFZs7P2QGiBDIMJlGJ8lkaU9XVLtNNcf7s
i0SDBciHP7Jx+6IM+oh208o7LgmEayN/n/wWl818waPAKfjcgkkl0thMUPxsC+D1
OAxDoBTOv9SEdcX9PM8k0z4N85lGq8Yr2I0ZroDUQyT18rcu59jHXEuuDYIPOhRw
DdYLbAy4gZ+LyzAgPrzAviZWZSj3YqcOoM2n+A56xjWUfvSsCFSLxca3cpz1ZtG2
w6+qnBeGVvDTP24ffuJF1vH9oPejsobjcH3aeYGS89nwMhpQUIb0NpA/92f+rt4S
TX8dl8m0exa3ikVEFZaRnFWl5mwJEXM/Atuo4+DJa0tpWFIdRrVoFK/w0TuUmKXd
onqeoKSifAWnJOx9N1f3
=aQ8Y
-----END PGP SIGNATURE-----

--Sig_/TBnxOymMj=NAABp4cxvWG_S--
