Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbbATEEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 23:04:13 -0500
Received: from ozlabs.org ([103.22.144.67]:53741 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbbATEEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 23:04:11 -0500
Date: Tue, 20 Jan 2015 15:03:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-ID: <20150120150353.4b11b2c4@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/J0Qhd5Zg=Jq=hz9wwMUliV9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J0Qhd5Zg=Jq=hz9wwMUliV9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the audit tree got a conflict in
kernel/auditsc.c between commit 4a92843601ad ("audit: correctly record
file names with different path name types") and fcf22d8267ad ("audit:
create private file name copies when auditing inodes") from Linus' tree
and commits 997f7ee82a98 ("audit: enable filename recording via
getname_kernel()"), 2b1b63a2b7d3 ("audit: fix filename matching in
__audit_inode() and __audit_inode_child()") and 49463ee9d929 ("audit:
replace getname()/putname() hacks with reference counters") from the
audit tree.

It would have been nice if these new audit tree commits had been based
on v3.19-rc3 instead of v3.16 ... (especially since their Author dates
match their Committer dates).

I fixed it up (basically I used the audit tree versions - based on the
commit comments - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/auditsc.c
index 55f82fce2526,459a54555151..000000000000
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@@ -1878,48 -1802,17 +1804,15 @@@ void __audit_inode(struct filename *nam
  	}
 =20
  out_alloc:
 -	/* unable to find the name from a previous getname(). Allocate a new
 -	 * anonymous entry.
 -	 */
 +	/* unable to find an entry with both a matching name and type */
- 	n =3D audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
+ 	n =3D audit_alloc_name(context, AUDIT_TYPE_NORMAL);
  	if (!n)
  		return;
- 	/* unfortunately, while we may have a path name to record with the
- 	 * inode, we can't always rely on the string lasting until the end of
- 	 * the syscall so we need to create our own copy, it may fail due to
- 	 * memory allocation issues, but we do our best */
  	if (name) {
- 		/* we can't use getname_kernel() due to size limits */
- 		size_t len =3D strlen(name->name) + 1;
- 		struct filename *new =3D __getname();
-=20
- 		if (unlikely(!new))
- 			goto out;
-=20
- 		if (len <=3D (PATH_MAX - sizeof(*new))) {
- 			new->name =3D (char *)(new) + sizeof(*new);
- 			new->separate =3D false;
- 		} else if (len <=3D PATH_MAX) {
- 			/* this looks odd, but is due to final_putname() */
- 			struct filename *new2;
-=20
- 			new2 =3D kmalloc(sizeof(*new2), GFP_KERNEL);
- 			if (unlikely(!new2)) {
- 				__putname(new);
- 				goto out;
- 			}
- 			new2->name =3D (char *)new;
- 			new2->separate =3D true;
- 			new =3D new2;
- 		} else {
- 			/* we should never get here, but let's be safe */
- 			__putname(new);
- 			goto out;
- 		}
- 		strlcpy((char *)new->name, name->name, len);
- 		new->uptr =3D NULL;
- 		new->aname =3D n;
- 		n->name =3D new;
- 		n->name_put =3D true;
+ 		n->name =3D name;
+ 		name->refcnt++;
  	}
+=20
  out:
  	if (parent) {
  		n->name_len =3D n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;

--Sig_/J0Qhd5Zg=Jq=hz9wwMUliV9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvdO2AAoJEMDTa8Ir7ZwV4VEP/RsQ0Qi0eB2e8mtIt9imoL68
1ceVRF3v4XTgpBTCVgSaK1HNnhu71bPuttfOOC8X+kDMeatAirguGYyqvcfBQGQ1
cQ/yMy2Y0O5G+3G+IB+Fx9ijDAGF0pj3cJE2xPG6Qsb1tpE8xanYiZO+e3UQDl/X
78e1dcBzYpOqGYIjdNa/kkztXojs5D4pHYlYKyVKJWgrF2h7S3/hSnzoVzX/Vj41
/mX8Ru04MJWR8UVG9Ai8/n4dO32Ldo+ZHg0CtIoxDL15oMrmjdzBGqMoJopNhdRQ
fqlu/KBQvfbs/Gx3uNNIajVw4H8fvegRg3OuG6EtksKFFXeivxPKyViTwvqG3EC8
OsshxFfzLpKv6Zpu5kfz+6jBJsy7ifmm3gNeq1CK/3+YCkdK5OWhiqnCKqAwLlKd
ZATxfbI/sOrA1w4lqKG3MEeenqFU8aYQm4bLuiiiFUR/VvLggQWMOkjKWPa70W88
wLKajVozMjhKlPutak4c0HVW2dkjLO2UyJD7hFEq4ipV1+abEXsAD6dnCvk7oJGL
ij6C08xa7zflC3Sxv5YWSRpLjiDQHAMQYlA5fnw3tKA4u1uNJviiB6lqe8qYMCpb
XzYIadMnnGpD4SCNQPX/uCPFS4vQ5kUKjmvqbiijtFv+y/oqzU7vLQg2pLCBB3S4
wnX/jh7ONOFBBo9A56h+
=VVh6
-----END PGP SIGNATURE-----

--Sig_/J0Qhd5Zg=Jq=hz9wwMUliV9--
