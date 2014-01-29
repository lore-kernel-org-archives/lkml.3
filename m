Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaA2Bmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:42:46 -0500
Received: from ozlabs.org ([203.10.76.45]:40236 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbaA2Bmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:42:44 -0500
Date: Wed, 29 Jan 2014 12:42:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the nfsd tree with Linus' tree
Message-Id: <20140129124238.6e1667abab08be8be2dafe01@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_12_42_38_+1100_cWlZEdzBHAW4iRgC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_12_42_38_+1100_cWlZEdzBHAW4iRgC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the nfsd tree got a conflict in
fs/nfsd/nfs4acl.c between commit 4ac7249ea5a0 ("nfsd: use get_acl and
->set_acl") from Linus' tree and commit 3554116d3aae ("nfsd4: simplify
xdr encoding of nfsv4 names") from the nfsd tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfsd/nfs4acl.c
index 649ad7cf2204,eea24c9a561d..000000000000
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@@ -37,13 -37,9 +37,14 @@@
  #include <linux/slab.h>
  #include <linux/nfs_fs.h>
  #include <linux/export.h>
 +#include "nfsfh.h"
+ #include "nfsd.h"
  #include "acl.h"
 +#include "vfs.h"
 =20
 +#define NFS4_ACL_TYPE_DEFAULT	0x01
 +#define NFS4_ACL_DIR		0x02
 +#define NFS4_ACL_OWNER		0x04
 =20
  /* mode bit translations: */
  #define NFS4_READ_MODE (NFS4_ACE_READ_DATA)
@@@ -916,17 -849,26 +917,22 @@@ nfs4_acl_get_whotype(char *p, u32 len
  	return NFS4_ACL_WHO_NAMED;
  }
 =20
- int
- nfs4_acl_write_who(int who, char *p)
+ __be32 nfs4_acl_write_who(int who, __be32 **p, int *len)
  {
  	int i;
+ 	int bytes;
 =20
  	for (i =3D 0; i < ARRAY_SIZE(s2t_map); i++) {
- 		if (s2t_map[i].type =3D=3D who) {
- 			memcpy(p, s2t_map[i].string, s2t_map[i].stringlen);
- 			return s2t_map[i].stringlen;
- 		}
+ 		if (s2t_map[i].type !=3D who)
+ 			continue;
+ 		bytes =3D 4 + (XDR_QUADLEN(s2t_map[i].stringlen) << 2);
+ 		if (bytes > *len)
+ 			return nfserr_resource;
+ 		*p =3D xdr_encode_opaque(*p, s2t_map[i].string,
+ 					s2t_map[i].stringlen);
+ 		*len -=3D bytes;
+ 		return 0;
  	}
- 	BUG();
+ 	WARN_ON_ONCE(1);
  	return -1;
  }
 -
 -EXPORT_SYMBOL(nfs4_acl_new);
 -EXPORT_SYMBOL(nfs4_acl_get_whotype);
 -EXPORT_SYMBOL(nfs4_acl_write_who);

--Signature=_Wed__29_Jan_2014_12_42_38_+1100_cWlZEdzBHAW4iRgC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6FySAAoJEMDTa8Ir7ZwVZh4P/2jD9fLkbKb1xlPHW824xx2i
mfWiI4nwKoQmB99UU992DRN3h944LIlro9VXezVsviZiyrozlFSM9Znok1wdT+PU
3BPVrDyqCTGEU9WML5A8yWZxHh8ysx2GEHZiTN2Mt2XH308ASrAI/LwoIxcEaWaS
aR1zP9L0k2PV5D/zmAQNG59kxan6U5Xf11pICUob9ytzPP77ypq0f5gahl1cswiW
tiFxQv0g4DvskBrLIDouUETFq9GIaMX+w4udvQstBclFHAR1PRYqvyYYkBoCJydn
vWWSXz6z5bT7XE1nzYZGVmp3QWww+lFA56K5isu/iE7Jke2frfD5WSSnfM4SOZj2
M5KA5A7OV/t3xIg0EbYssrfdI3pAbfU75QrITFxbEKYBVy4NHx6xI0BDgUHVaFLQ
xXRgYYQZmGfcJDWj2lcQrAI+sWkEHSbiruq58kmX010huZPY+d16sxXRoST262PY
vfP5IOfHahEhWkhcR+KseaJMhN8P7w4F0NKHj74xHf/LLU7/q4/Pqf6U2Nt86hAv
xjpWZ3I8sUAyOepX/As86vPLJZR2STtH5cC3PRB1H7xEzVarT7sIc231X0USBiIV
1xfMTGIvIi4AnTWgy2auNs/7YoWhX5rAUYgmhtIEVNvwUbTUQ5wg4ZOVZcri3te8
HFzBOn/EOmVakPL2P5ll
=egy+
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_12_42_38_+1100_cWlZEdzBHAW4iRgC--
