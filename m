Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaKXJWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:22:37 -0500
Received: from ozlabs.org ([103.22.144.67]:52194 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaKXJWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:22:35 -0500
Date: Mon, 24 Nov 2014 20:22:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the akpm-current tree with the ftrace
 tree
Message-ID: <20141124202228.11999e2b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Uz5NaR/qSAhCS.+a7qIxDUe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Uz5NaR/qSAhCS.+a7qIxDUe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/printk/printk.c between commit afdc34a3d3b8 ("printk: Add
per_cpu printk func to allow printk to be diverted") from the ftrace
tree and commit b59ed413b21b ("printk: add and use LOGLEVEL_<level>
defines for KERN_<LEVEL> equivalents") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/printk/printk.c
index 35c4b2232d6d,218ea26d75b8..000000000000
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@@ -1807,30 -1805,6 +1805,30 @@@ asmlinkage int printk_emit(int facility
  }
  EXPORT_SYMBOL(printk_emit);
 =20
 +int vprintk_default(const char *fmt, va_list args)
 +{
 +	int r;
 +
 +#ifdef CONFIG_KGDB_KDB
 +	if (unlikely(kdb_trap_printk)) {
 +		r =3D vkdb_printf(fmt, args);
 +		return r;
 +	}
 +#endif
- 	r =3D vprintk_emit(0, -1, NULL, 0, fmt, args);
++	r =3D vprintk_emit(0, LOGLEVEL_DEFAULT, NULL, 0, fmt, args);
 +
 +	return r;
 +}
 +EXPORT_SYMBOL_GPL(vprintk_default);
 +
 +/*
 + * This allows printk to be diverted to another function per cpu.
 + * This is useful for calling printk functions from within NMI
 + * without worrying about race conditions that can lock up the
 + * box.
 + */
 +DEFINE_PER_CPU(printk_func_t, printk_func) =3D vprintk_default;
 +
  /**
   * printk - print a kernel message
   * @fmt: format string

--Sig_/Uz5NaR/qSAhCS.+a7qIxDUe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcvjZAAoJEMDTa8Ir7ZwVDbYQAJEHeHWi1Jl49wG6HO66StBb
LJ4tQnyVb53m0kIi5m9spfcwIPt/eE7rmq6vHosJhdnWBKbmvQ3dtpygdxyarJs/
rcIf3IPGQN3aqSXMp0iLTb9ilSjbb3ypk6/4MFyT4qp+H2jz8RcfVi5Nvax4nKDN
n6PevyaEAvN6JSLQ7iMD8DNGw+spPX9+tGoBCmC06Udsl1MCDqzplF7SkaNPdU1s
iv3v6j1ETg9+K/B4EnPr+fyQgLIdvB1PzsgORa7Tga0qF0GFWxvmQJXhPwfgltuH
0LvlH1mGtAavlqA/0vUj/j6MG4niQ0Uni7v+olDumBVDot/7bADnFKsg1lY9Dx8x
LPpZDQXoX9RIlxS3b7Y5/ADNgJNIbmemXCM93OjY4Cqcpxv2zw0Uw3fVvKmXfknq
v9NJHwoLh6gV5Cfg0DIIlNX5wllngmkNAViwL7+Z1aGRXAgQy9dlh0Sy4PIKw4tO
L2taXCwxXwbdEvX+FucQm8oLwtDRyqGioqmz5OXpS6l3XD702wbm/KS9bACm1ve2
EElFzY5zpXASFFyil+NqIDANa39S7EnVHdqYUCVATr3ZqELEBdhfQu8dnEJ7ZUrM
osVO+ceQ/drLzEmRWAB0Y5xspg2roexuJHcynbIweKoyJPXvoMLX6DUdNLMdU1+u
i74v2ibRTE0rO2yoWMww
=jGfb
-----END PGP SIGNATURE-----

--Sig_/Uz5NaR/qSAhCS.+a7qIxDUe--
