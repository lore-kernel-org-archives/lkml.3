Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaDQFHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:07:08 -0400
Received: from ozlabs.org ([103.22.144.67]:49460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaDQFHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:07:06 -0400
Date: Thu, 17 Apr 2014 15:06:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the userns tree with Linus' tree
Message-Id: <20140417150657.6d67e750081860b30f99715c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_15_06_57_+1000_B0pe1thtBaM9_IQq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_15_06_57_+1000_B0pe1thtBaM9_IQq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
fs/namespace.c between various commits from Linus' tree and various
commits from the userns tree.

I fixed it up (hopefully - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/namespace.c
index 182bc41cd887,128c051041be..000000000000
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@@ -667,13 -632,47 +668,47 @@@ struct vfsmount *lookup_mnt(struct pat
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
@@@ -695,7 -702,8 +738,8 @@@ static struct mountpoint *new_mountpoin
 =20
  	mp->m_dentry =3D dentry;
  	mp->m_count =3D 1;
 -	list_add(&mp->m_hash, chain);
 +	hlist_add_head(&mp->m_hash, chain);
+ 	INIT_LIST_HEAD(&mp->m_list);
  	return mp;
  }
 =20
@@@ -748,7 -757,8 +793,8 @@@ static void detach_mnt(struct mount *mn
  	mnt->mnt_parent =3D mnt;
  	mnt->mnt_mountpoint =3D mnt->mnt.mnt_root;
  	list_del_init(&mnt->mnt_child);
 -	list_del_init(&mnt->mnt_hash);
 +	hlist_del_init_rcu(&mnt->mnt_hash);
+ 	list_del_init(&mnt->mnt_mp_list);
  	put_mountpoint(mnt->mnt_mp);
  	mnt->mnt_mp =3D NULL;
  }
@@@ -936,9 -943,35 +983,25 @@@ static struct mount *clone_mnt(struct m
  	return ERR_PTR(err);
  }
 =20
 -static void delayed_free(struct rcu_head *head)
 -{
 -	struct mount *mnt =3D container_of(head, struct mount, mnt_rcu);
 -	kfree(mnt->mnt_devname);
 -#ifdef CONFIG_SMP
 -	free_percpu(mnt->mnt_pcp);
 -#endif
 -	kmem_cache_free(mnt_cache, mnt);
 -}
 -
+ static void cleanup_mnt(struct mount *mnt)
+ {
+ 	fsnotify_vfsmount_delete(&mnt->mnt);
+ 	dput(mnt->mnt.mnt_root);
+ 	deactivate_super(mnt->mnt.mnt_sb);
+ 	mnt_free_id(mnt);
+ 	complete(mnt->mnt_undone);
 -	call_rcu(&mnt->mnt_rcu, delayed_free);
++	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
+ }
+=20
+ static void cleanup_mnt_work(struct work_struct *work)
+ {
+ 	cleanup_mnt(container_of(work, struct mount, mnt_cleanup_work));
+ }
+=20
  static void mntput_no_expire(struct mount *mnt)
  {
- put_again:
+ 	struct completion undone;
+=20
  	rcu_read_lock();
  	mnt_add_count(mnt, -1);
  	if (likely(mnt->mnt_ns)) { /* shouldn't be the last one */

--Signature=_Thu__17_Apr_2014_15_06_57_+1000_B0pe1thtBaM9_IQq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTT2F2AAoJEMDTa8Ir7ZwVSDkP/1q982P951+bpzLei0WcyT/c
S2S0/dnRE2v3EqGzXYFyZsJCN0S+/GNyUAeJB24dWulnfPyi/Baka6DykKFGtdyn
TQhZ5JQGdEj5C/2ZsbRXWwbdeEiEYa9/K4IG/LpsTIgokga51BL/tK/UYHBS8UE+
omX6eH/PnCuZ8Dr/DogWXiBcfIuO45bbJvBk3yA7rNA8/dNjr8rUbS6YNLPqhQ3e
tN7f3CtdLgneBiirJRORep1oAGaGBIaehAdMB9IN372yZagLCd4ordbbD/hXoLpO
H+1TdMKTYr71+1EG8xnJuCWQ0864hjSgM1rKqfXv+geoPe8fD/V07VfSpj3r+CCQ
KZJEP7Y4iw9w368KTMJJK8rAvWhJf6PEecnMA1ABitGFgf9yuQcNjYyF5HV8es0G
rtGO2VJ0WIRzgv9iH/Innm/RLgX/sznUYq1EnVhmjHhyJ3Gz8JzgIK+xq5ePikUq
ArAVKmyC/S8Z8aJOPuQ3pt1I/7bzgYY7yx95GF/fXvTzIwFDyPUGqAB+esSJin6F
KH5kGLK3vvY0CtTqz7Pvme7EcCarN9dHVt7UdS994RwnF5QASKknd8bjLRZFgdjK
Kkpl0DyFmnQFB++xwdNbG+ZQFfMx5KS94iEMlqn2GH6wbEH0eQkZahau7v3Y+keh
QoNIi7KN97xsQcpy4kKt
=ajJG
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_15_06_57_+1000_B0pe1thtBaM9_IQq--
