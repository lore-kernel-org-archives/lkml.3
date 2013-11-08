Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3KHGu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:50:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41979 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3KHGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:50:57 -0500
Date: Fri, 8 Nov 2013 17:50:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-Id: <20131108175055.4c050e6770e0047aec42dae3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_17_50_55_+1100_vwOTmEs261=2CWWS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_17_50_55_+1100_vwOTmEs261=2CWWS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in fs/dcache.c
between commit 84550b9356af ("RCU'd vfsmounts") from the vfs tree and
commit 40216baa0101 ("vfs: Lazily remove mounts on unlinked files and
directories. v2") from the userns tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

Al, I do have to wonder why a commit whose whole commit message is:

"RCU'd vfsmounts
   =20
_very_ preliminary, barely tested."

is in linux-next as is not being kept over for v3.14 at this point.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index 6f418c540f76,1e9bf96b0132..000000000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -1362,110 -1478,17 +1362,101 @@@ void shrink_dcache_parent(struct dentr
  }
  EXPORT_SYMBOL(shrink_dcache_parent);
 =20
 +static enum d_walk_ret umount_collect(void *_data, struct dentry *dentry)
 +{
 +	struct select_data *data =3D _data;
 +	enum d_walk_ret ret =3D D_WALK_CONTINUE;
 +
 +	if (dentry->d_lockref.count) {
 +		dentry_lru_del(dentry);
 +		if (likely(!list_empty(&dentry->d_subdirs)))
 +			goto out;
 +		if (dentry =3D=3D data->start && dentry->d_lockref.count =3D=3D 1)
 +			goto out;
 +		printk(KERN_ERR
 +		       "BUG: Dentry %p{i=3D%lx,n=3D%s}"
 +		       " still in use (%d)"
 +		       " [unmount of %s %s]\n",
 +		       dentry,
 +		       dentry->d_inode ?
 +		       dentry->d_inode->i_ino : 0UL,
 +		       dentry->d_name.name,
 +		       dentry->d_lockref.count,
 +		       dentry->d_sb->s_type->name,
 +		       dentry->d_sb->s_id);
 +		BUG();
 +	} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
 +		/*
 +		 * We can't use d_lru_shrink_move() because we
 +		 * need to get the global LRU lock and do the
 +		 * LRU accounting.
 +		 */
 +		d_lru_del(dentry);
 +		d_shrink_add(dentry, &data->dispose);
 +		data->found++;
 +		ret =3D D_WALK_NORETRY;
 +	}
 +out:
 +	if (data->found && need_resched())
 +		ret =3D D_WALK_QUIT;
 +	return ret;
 +}
 +
 +/*
 + * destroy the dentries attached to a superblock on unmounting
 + */
 +void shrink_dcache_for_umount(struct super_block *sb)
 +{
 +	struct dentry *dentry;
 +
 +	if (down_read_trylock(&sb->s_umount))
 +		BUG();
 +
 +	dentry =3D sb->s_root;
 +	sb->s_root =3D NULL;
 +	for (;;) {
 +		struct select_data data;
 +
 +		INIT_LIST_HEAD(&data.dispose);
 +		data.start =3D dentry;
 +		data.found =3D 0;
 +
 +		d_walk(dentry, &data, umount_collect, NULL);
 +		if (!data.found)
 +			break;
 +
 +		shrink_dentry_list(&data.dispose);
 +		cond_resched();
 +	}
 +	d_drop(dentry);
 +	dput(dentry);
 +
 +	while (!hlist_bl_empty(&sb->s_anon)) {
 +		struct select_data data;
 +		dentry =3D hlist_bl_entry(hlist_bl_first(&sb->s_anon), struct dentry, d=
_hash);
 +
 +		INIT_LIST_HEAD(&data.dispose);
 +		data.start =3D NULL;
 +		data.found =3D 0;
 +
 +		d_walk(dentry, &data, umount_collect, NULL);
 +		if (data.found)
 +			shrink_dentry_list(&data.dispose);
 +		cond_resched();
 +	}
 +}
 +
- static enum d_walk_ret check_and_collect(void *_data, struct dentry *dent=
ry)
+ struct detach_data {
+ 	struct dentry *found;
+ };
+ static enum d_walk_ret do_detach_submounts(void *ptr, struct dentry *dent=
ry)
  {
- 	struct select_data *data =3D _data;
+ 	struct detach_data *data =3D ptr;
 =20
- 	if (d_mountpoint(dentry)) {
- 		data->found =3D -EBUSY;
- 		return D_WALK_QUIT;
- 	}
+ 	if (d_mountpoint(dentry))
+ 		data->found =3D dentry;
 =20
- 	return select_collect(_data, dentry);
- }
-=20
- static void check_and_drop(void *_data)
- {
- 	struct select_data *data =3D _data;
-=20
- 	if (d_mountpoint(data->start))
- 		data->found =3D -EBUSY;
- 	if (!data->found)
- 		__d_drop(data->start);
+ 	return data->found ? D_WALK_QUIT : D_WALK_CONTINUE;
  }
 =20
  /**

--Signature=_Fri__8_Nov_2013_17_50_55_+1100_vwOTmEs261=2CWWS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfInPAAoJEMDTa8Ir7ZwVKBsP/jubQB36dM2aJA0SYgC/r7Qf
1n8/DoweNpVmUhwGlNH98TUhzwMFoCDOiJ4cFw8k303UCXoCTrKmoFYJSW+qcEF7
XyQbk0+30UIopmainKeO+PqQP0N58fNnPEBA7ZD+gpre8FIh4lqymMnRYX7Uic7f
4awXsJLFL2n4HAxTWnwCBpK2hEaSLVKuj1ZBJ+Zae/eDUoTIOYdbPLP4TEzz9R40
ooMqeqVzb3LKuswhgNH45A4COGbwF1aTNZ0P4qWSNVpqK7srTRMcoEq5sxP+vXhm
31unTEZXFgE31gpxQ3i5kF2/AqY+DueKlyhB73lNoXsdlBJJiRy8DTyE9Cs4Uqar
1ozu/GdtOnWV7Mem2zZTqJUmKGLujdXSgGAm30Bnk0ToMfV+Zvtg+tUjaGQRSv+V
7LJusV7eGx89TcNnje0Ihi2qbYDoymrdYXxxa6AVvVcHjH0j/q2ZwDOPL3cXWu3I
p3CQiGc6FSWDi710qAFhfgnA7SE45+/x8h980bkXSQwhwDHhVOkVtVniBfOX0i4h
2CMQKkfUwBlTAv+OYrAbbGR9wyxmrEWGbwUlfwthqopKGM0xhJK1f5LzpXKAzWP/
U1ta1h/pt0HveDf9Gvc5PVRElWaHe39XTQwuMpDeWNmUlZTQxBbfru9g5P3Gc8uz
Ko44WSs5RBO3VgpwayH6
=x6rl
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_17_50_55_+1100_vwOTmEs261=2CWWS--
