Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3IJEWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:22:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55557 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3IJEV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:21:59 -0400
Date: Tue, 10 Sep 2013 14:21:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910142150.23c1dc3b9f44a6f55e4ad1fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Sep_2013_14_21_50_+1000_0bz.8nI8gYfB=Y3d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Sep_2013_14_21_50_+1000_0bz.8nI8gYfB=Y3d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
between commits 8aab6a27332b ("vfs: reorganize dput() memory accesses")
and 0d98439ea3c6 ("vfs: use lockred "dead" flag to mark unrecoverably
dead dentries") from Linus' tree and commit "dcache: remove dentries from
LRU before putting on dispose list" from the akpm tree.

I fixed it up (hopefully - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index a4cc2eb,43a1c0e..0000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -374,7 -344,6 +374,7 @@@ static void dentry_lru_add(struct dentr
  static void __dentry_lru_del(struct dentry *dentry)
  {
  	list_del_init(&dentry->d_lru);
- 	dentry->d_flags &=3D ~(DCACHE_SHRINK_LIST | DCACHE_LRU_LIST);
++	dentry->d_flags &=3D ~DCACHE_LRU_LIST;
  	dentry->d_sb->s_nr_dentry_unused--;
  	this_cpu_dec(nr_dentry_unused);
  }
@@@ -393,14 -372,15 +403,16 @@@ static void dentry_lru_del(struct dentr
 =20
  static void dentry_lru_move_list(struct dentry *dentry, struct list_head =
*list)
  {
+ 	BUG_ON(dentry->d_flags & DCACHE_SHRINK_LIST);
+=20
  	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
  	if (list_empty(&dentry->d_lru)) {
 +		dentry->d_flags |=3D DCACHE_LRU_LIST;
  		list_add_tail(&dentry->d_lru, list);
- 		dentry->d_sb->s_nr_dentry_unused++;
- 		this_cpu_inc(nr_dentry_unused);
  	} else {
  		list_move_tail(&dentry->d_lru, list);
+ 		dentry->d_sb->s_nr_dentry_unused--;
+ 		this_cpu_dec(nr_dentry_unused);
  	}
  	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
  }
@@@ -498,7 -478,8 +510,8 @@@ EXPORT_SYMBOL(d_drop)
   * If ref is non-zero, then decrement the refcount too.
   * Returns dentry requiring refcount drop, or NULL if we're done.
   */
- static inline struct dentry *dentry_kill(struct dentry *dentry)
+ static inline struct dentry *
 -dentry_kill(struct dentry *dentry, int ref, int unlock_on_failure)
++dentry_kill(struct dentry *dentry, int unlock_on_failure)
  	__releases(dentry->d_lock)
  {
  	struct inode *inode;
@@@ -591,7 -573,7 +606,7 @@@ repeat
  	return;
 =20
  kill_it:
- 	dentry =3D dentry_kill(dentry);
 -	dentry =3D dentry_kill(dentry, 1, 1);
++	dentry =3D dentry_kill(dentry, 1);
  	if (dentry)
  		goto repeat;
  }
@@@ -816,7 -798,7 +831,7 @@@ static struct dentry * try_prune_one_de
  {
  	struct dentry *parent;
 =20
- 	parent =3D dentry_kill(dentry);
 -	parent =3D dentry_kill(dentry, 0, 0);
++	parent =3D dentry_kill(dentry, 0);
  	/*
  	 * If dentry_kill returns NULL, we have nothing more to do.
  	 * if it returns the same dentry, trylocks failed. In either
@@@ -836,9 -818,10 +851,10 @@@
  	dentry =3D parent;
  	while (dentry) {
  		if (lockref_put_or_lock(&dentry->d_lockref))
- 			return;
- 		dentry =3D dentry_kill(dentry);
+ 			return NULL;
 -		dentry =3D dentry_kill(dentry, 1, 1);
++		dentry =3D dentry_kill(dentry, 1);
  	}
+ 	return NULL;
  }
 =20
  static void shrink_dentry_list(struct list_head *list)

--Signature=_Tue__10_Sep_2013_14_21_50_+1000_0bz.8nI8gYfB=Y3d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLp5iAAoJEECxmPOUX5FEpKEP+wU12m6rUj+nlMz8XwKEqCsN
fIpOF62oYyPq04Gz6as91hqJ3IK5y+1XiUIa77ol87lx3UTMk0U6On37eDuiqbIP
25WMzCqCFUn3oFjTUw8xFQM15akqyculBsYDisd6klKBWWpPFdrLDpWYy+oX3v+i
k9tv6g9xVEbTF6+KO8YUKJRpLm0y9PYWu+uadDj4xrDVLArE7O+4bHwDhsbKokDo
EOSDb/K0GJrXChJyrTyf8Ba8X9/Swx5lxP27PtvMXO25/LzAxgZwVH+O3YgzQuxb
gzz2gBIK6SDYdatGJBHc0Q46HR+d0bdYqnWNNKITQaIqHtGvPeYe+ivE7ojKLf9d
FJF76+Vutj6l0BmQ678xiYw/zcuvaeq0YZK3/q020R4a/vcUsQTZA5O6E5IhC+/s
zwnqiAlvtgja36xB8ufgXa1by96NRxMYiYxaBNyCY3K1f+4z02aCb2fD8nIPYPep
ciSSfxzw6j7/UuSf1OcmfAZYaZrdI4tqEGNS2oSttkKPjvgEzc1J6Ct1OZX0tZZB
oXCn2xPfG1v+gdRiW3JOInLH9bmoTnZBPHeXs1/ahKz6ttHoQB3DiPctsWzL17y3
9UEt5lbsw6iP1xh8qiYrhHIVGlZZXkrGoIEJZ7AajLzsMPfbJrGeeeI/8cERZvOr
q4G/BuamcF9vpqZhfFtf
=xrzZ
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Sep_2013_14_21_50_+1000_0bz.8nI8gYfB=Y3d--
