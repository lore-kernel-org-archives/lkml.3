Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaLJGVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:21:54 -0500
Received: from ozlabs.org ([103.22.144.67]:57480 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaLJGVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:21:53 -0500
Date: Wed, 10 Dec 2014 17:21:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-ID: <20141210172143.2c218e27@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8kweepAGKSKJpjzidmg2P6b"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8kweepAGKSKJpjzidmg2P6b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got conflicts in
include/linux/user_namespace.h and kernel/user.c between commit
435d5f4bb2cc ("common object embedded into various struct ....ns") from
the vfs tree and commit 2b714ea67ed4 ("userns: Add a knob to disable
setgroups on a per user namespace basis") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/user_namespace.h
index 4cf06c140e21,6451c401dcf6..000000000000
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@@ -27,7 -32,8 +33,8 @@@ struct user_namespace=20
  	int			level;
  	kuid_t			owner;
  	kgid_t			group;
 -	unsigned int		proc_inum;
 +	struct ns_common	ns;
+ 	unsigned long		flags;
 =20
  	/* Register of per-UID persistent keyrings for this namespace */
  #ifdef CONFIG_PERSISTENT_KEYRINGS
diff --cc kernel/user.c
index 69b800aebf13,2d09940c9632..000000000000
--- a/kernel/user.c
+++ b/kernel/user.c
@@@ -50,10 -50,8 +50,11 @@@ struct user_namespace init_user_ns =3D=20
  	.count =3D ATOMIC_INIT(3),
  	.owner =3D GLOBAL_ROOT_UID,
  	.group =3D GLOBAL_ROOT_GID,
 -	.proc_inum =3D PROC_USER_INIT_INO,
 +	.ns.inum =3D PROC_USER_INIT_INO,
 +#ifdef CONFIG_USER_NS
 +	.ns.ops =3D &userns_operations,
 +#endif
+ 	.flags =3D USERNS_INIT_FLAGS,
  #ifdef CONFIG_PERSISTENT_KEYRINGS
  	.persistent_keyring_register_sem =3D
  	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),

--Sig_/8kweepAGKSKJpjzidmg2P6b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh+Z8AAoJEMDTa8Ir7ZwViuoP/0UGNrM3MnRpZX7crRoRvdz3
djihCukc9/Z3izwiJmZT8rtz3ISMbLDzTgMVUmW0fxRlJX+JJscWyRBzd1Xa8QWJ
IY8Qzscw9/ZTQhJnXEgv8qdJDbaEdBzLvPO2PQSAqtglAscNCGonODcHIAElPZXe
2CEluVirM055FgykkmuoB/wyw+A+vdStNh02apTnVRKd30sV+7TSW3d09uXPd9At
Rn9uFl8kDW1ahmRjzq6V2DCsSWIUmMxoEO6x80HFx9STRfsBGQl/jJzh25p9EZvK
SEvxgR0lXC2MO/76thI2ZJgGhOu+zY6lOzfuII+S2jZdvf9YjSNOYI0JDEcQD+2h
7rDqpaRY2iI6s5lNh+7tOAxt/K9Qp5ZL0OnvznD0HSdlu1O4MTXHe4p6TzNIR5rO
N2XPCClnv/5catug/4cZwQDXv8PO56u5jvdpmTQqAV7OAf76gIDqBoGvEgALtVqC
+WMtNXYV2gFRHiALISl1wfqe4kE/Hzp/TLYNuzsiBX5N2V21dLH6uT6idGFB6RT2
Lb1+8zfsL15gWloSAeG8KBmV/1USrUZr9nNKA+bJSVA82hFGhhT+1X2fUOT4TWhx
IheCuUNC2QPWmsyH9/TN7EOXYW6udEAFuqF4cbJu2RpSntS4RyffJxuZ2Eioi+CR
EU+HGMwdGUvbKqxHRnI5
=S20r
-----END PGP SIGNATURE-----

--Sig_/8kweepAGKSKJpjzidmg2P6b--
