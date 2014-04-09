Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaDICp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:45:29 -0400
Received: from ozlabs.org ([203.10.76.45]:37934 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbaDICp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:45:27 -0400
Date: Wed, 9 Apr 2014 12:45:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the userns tree with Linus' tree
Message-Id: <20140409124520.aa778b59b4e6f38bc5f2bef5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Apr_2014_12_45_20_+1000_zQAUtxd8mIo0IBOa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Apr_2014_12_45_20_+1000_zQAUtxd8mIo0IBOa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
fs/namespace.c between commits  from Linus' tree and commits from the
userns tree.

I fixed it up (I used the conflict resolution that your sent to Linus -
see below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/namespace.c
index 2ffc5a2905d4,52f4174e294c..000000000000
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@@ -665,13 -632,47 +666,47 @@@ struct vfsmount *lookup_mnt(struct pat
  	return m;
  }
 =20
- static struct mountpoint *new_mountpoint(struct dentry *dentry)
+ /*
+  * __is_local_mountpoint - Test to see if dentry is a mountpoint in the
+  *                         current mount namespace.
+  *
+  * The common case is dentries are not mountpoints at all and that
+  * test is handled inline.  For the slow case when we are actually
+  * dealing with a mountpoint of some kind, walk through all of the
+  * mounts in the current mount namespace and test to see if the dentry
+  * is a mountpoint.
+  *
+  * The mount_hashtable is not usable in the context because we
+  * need to identify all mounts that may be in the current mount
+  * namespace not just a mount that happens to have some specified
+  * parent mount.
+  */
+ bool __is_local_mountpoint(struct dentry *dentry)
+ {
+ 	struct mnt_namespace *ns =3D current->nsproxy->mnt_ns;
+ 	struct mount *mnt;
+ 	bool is_covered =3D false;
+=20
+ 	if (!d_mountpoint(dentry))
+ 		goto out;
+=20
+ 	down_read(&namespace_sem);
+ 	list_for_each_entry(mnt, &ns->list, mnt_list) {
+ 		is_covered =3D (mnt->mnt_mountpoint =3D=3D dentry);
+ 		if (is_covered)
+ 			break;
+ 	}
+ 	up_read(&namespace_sem);
+ out:
+ 	return is_covered;
+ }
+=20
+ static struct mountpoint *lookup_mountpoint(struct dentry *dentry)
  {
 -	struct list_head *chain =3D mountpoint_hashtable + hash(NULL, dentry);
 +	struct hlist_head *chain =3D mp_hash(dentry);
  	struct mountpoint *mp;
- 	int ret;
 =20
 -	list_for_each_entry(mp, chain, m_hash) {
 +	hlist_for_each_entry(mp, chain, m_hash) {
  		if (mp->m_dentry =3D=3D dentry) {
  			/* might be worth a WARN_ON() */
  			if (d_unlinked(dentry))
@@@ -680,6 -681,14 +715,14 @@@
  			return mp;
  		}
  	}
+ 	return NULL;
+ }
+=20
+ static struct mountpoint *new_mountpoint(struct dentry *dentry)
+ {
 -	struct list_head *chain =3D mountpoint_hashtable + hash(NULL, dentry);
++	struct hlist_head *chain =3D mp_hash(dentry);
+ 	struct mountpoint *mp;
+ 	int ret;
 =20
  	mp =3D kmalloc(sizeof(struct mountpoint), GFP_KERNEL);
  	if (!mp)
@@@ -693,7 -702,8 +736,8 @@@
 =20
  	mp->m_dentry =3D dentry;
  	mp->m_count =3D 1;
 -	list_add(&mp->m_hash, chain);
 +	hlist_add_head(&mp->m_hash, chain);
+ 	INIT_LIST_HEAD(&mp->m_list);
  	return mp;
  }
 =20
@@@ -746,7 -757,8 +791,8 @@@ static void detach_mnt(struct mount *mn
  	mnt->mnt_parent =3D mnt;
  	mnt->mnt_mountpoint =3D mnt->mnt.mnt_root;
  	list_del_init(&mnt->mnt_child);
 -	list_del_init(&mnt->mnt_hash);
 +	hlist_del_init_rcu(&mnt->mnt_hash);
+ 	list_del_init(&mnt->mnt_mp_list);
  	put_mountpoint(mnt->mnt_mp);
  	mnt->mnt_mp =3D NULL;
  }


--Signature=_Wed__9_Apr_2014_12_45_20_+1000_zQAUtxd8mIo0IBOa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTRLRFAAoJEMDTa8Ir7ZwV2AIP/2Uie4FPF9pXsXYb6N9xeqsa
zGj45EL/dgJtNQtSEU2LVoJYujnE+A9/U//tX/7rLh5t5AUe0zBVXXnXXrgeYzxy
nNVCdOaQ2PSFPksgAedHH/nRxiKTJi78uRNDbWWUuRsAdhd9VhZW96DigKAuV+a8
Op+BY0u6ttdj/pqHNjhvROmukWzyB1+tUMsEWVyZkjeH+8QiqSllzz7tdXTAAWQi
AvmV7T8RqBiGIataq6XL9X9nTFkORKhj+5VWockddZk6wrAhqWizRCTECPtTw2WP
LVHp4eJ9riOBa520dM8wYM5GkiCa4wQB87yjAlD9Y1oQCnys4sb98PSkkLvj/CSM
9APeBB8R1kOrZUXQn/V1v2v8irCI+0h1/xOQgFEZ08QqO1tqsljctIQOmwOcY5BX
fwji3FHziqXrvtFv+QEepPiwRBIs7bUG+k2BhEEqU/4uszI45T1KfEyxewl7tFnx
w6BQDXl0vuCKVrSh0hB8H48ziIVbzvfrDgD1n/t05RofMJl3wN66Eg/+9n7SOw/v
RQOB5qC0ZfYSqEL3oMWIw8bdyRExmjfqBEJyQn9v/wyJG54NJVm4pIvAZX2YipWP
SLxmpye3gnmbySBsDsuT3wtHCNryuSeCOJv6DV7/Ktqv1+mGtCectuDvnBcxILk8
6LA3LoBKCBodfdFFIaeD
=UBi5
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Apr_2014_12_45_20_+1000_zQAUtxd8mIo0IBOa--
