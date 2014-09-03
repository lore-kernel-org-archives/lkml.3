Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaICEGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 00:06:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaICEG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 00:06:28 -0400
Date: Wed, 3 Sep 2014 14:06:17 +1000
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kbuild-all@01.org, lkml <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>, autofs@vger.kernel.org
Subject: [PATCH] autofs4: use ACCESS_ONCE rather than rcu_dereference for
 dentry->d_inode
Message-ID: <20140903140617.7502ad32@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8Xnn/5WxTxmXnB0/OkC4vFD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8Xnn/5WxTxmXnB0/OkC4vFD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



As the kbuild test robot reports, rcu_dereference() isn't really
appropriate here - we don't need a memory barrier, just a guard
against accidentally dereferencing NULL.

This can be merged into
 autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mod=
e.
in 'mm'.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 71e4413d65c8..d76d083f2f06 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -463,7 +463,7 @@ static int autofs4_d_manage(struct dentry *dentry, bool=
 rcu_walk)
 			return 0;
 		if (d_mountpoint(dentry))
 			return 0;
-		inode =3D rcu_dereference(dentry->d_inode);
+		inode =3D ACCESS_ONCE(dentry->d_inode);
 		if (inode && S_ISLNK(inode->i_mode))
 			return -EISDIR;
 		if (list_empty(&dentry->d_subdirs))

--Sig_/8Xnn/5WxTxmXnB0/OkC4vFD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAaTujnsnt1WYoG5AQKuXhAAtOkxbxEp6cXChqxzp9nNwhsxbxqeBYdl
rFDJPLgZVbe1bOcqmkuQfZdzh+pOQzowhb09m6doLg/d2JwkB0cLgmAeZKS6ufOa
U6BPw0lIfxjf6i257t+rGcKBkJAFF/IoPz3XIazZIm3hELoLc/y9nPtoIA9/cgnH
p1DTJWfm7RPAskSwJJooNUD8ccb2/MvQ1i94K9rEgrJsyJYH7tniyt/ySJyx0F7g
DWYUhBNYxZ17I16lcuD4GvR5nYCKfkpsyZVTmJtTwU1Yo6CQa/K8IAPwfZyNhxbP
ZZ72HPNoOFPl783uTwWLLc4/VVR9DjAMKggnncDQKogtnJt+MARqpvtRYPMwOg5e
uxIo15XOwOzmNaXC5cQ8knBDJkFfHamFTxmdHVPLPWVG5neqmwlcRRcBRmUfTmr8
TYNtPGrcpyuWA4CP/PKCtynpE+L2Qxwg4/ICO0f2a2I1/DeJ1mOZ+dTau5mgIgo5
rgzdv9vzfx35pC1RuV0RmTPcjOuqhzNvhPAYGirH37Zxl28RGybY9bNp34iqEo11
aDqmREGs899LB3Ei/qv+LOxt1RM1C6LDcwDpuTBLt/XENbPzIzKItcRUqvMvvR7N
Z3fJFsQ6LOtI8URb/MRztZVQNqh9DEmYh+DRGKfWW53uO7otFRzBqYBJGVdE3w5P
uv5LJ9BoInY=
=r/9g
-----END PGP SIGNATURE-----

--Sig_/8Xnn/5WxTxmXnB0/OkC4vFD--
