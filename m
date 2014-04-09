Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaDICkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:40:04 -0400
Received: from ozlabs.org ([203.10.76.45]:39818 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbaDICkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:40:01 -0400
Date: Wed, 9 Apr 2014 12:39:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with Linus' tree
Message-Id: <20140409123952.d15c10c4684ac27ed19f6430@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Apr_2014_12_39_52_+1000_DAsSmei.Ps_DULym"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Apr_2014_12_39_52_+1000_DAsSmei.Ps_DULym
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in fs/namei.c
between commits from Linus' tree and commits 3dd905eaa258 ("vfs: Don't
allow overwriting mounts in the current mount namespace") and
f43d102a391d ("vfs: Lazily remove mounts on unlinked files and
directories") from the userns tree.

I fixed it up (I used the conflict resolution that you sent to Linus -
see below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/namei.c
index 88339f59efb5,384fcc6a5606..000000000000
--- a/fs/namei.c
+++ b/fs/namei.c
@@@ -4082,33 -4045,17 +4085,33 @@@ int vfs_rename(struct inode *old_dir, s
  	if (error)
  		return error;
 =20
 +	old_name =3D fsnotify_oldname_init(old_dentry->d_name.name);
  	dget(new_dentry);
 -	lock_two_nondirectories(source, target);
 +	if (!is_dir || (flags & RENAME_EXCHANGE))
 +		lock_two_nondirectories(source, target);
 +	else if (target)
 +		mutex_lock(&target->i_mutex);
 =20
  	error =3D -EBUSY;
- 	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
+ 	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
  		goto out;
 =20
 -	error =3D try_break_deleg(source, delegated_inode);
 -	if (error)
 -		goto out;
 -	if (target) {
 +	if (max_links && new_dir !=3D old_dir) {
 +		error =3D -EMLINK;
 +		if (is_dir && !new_is_dir && new_dir->i_nlink >=3D max_links)
 +			goto out;
 +		if ((flags & RENAME_EXCHANGE) && !is_dir && new_is_dir &&
 +		    old_dir->i_nlink >=3D max_links)
 +			goto out;
 +	}
 +	if (is_dir && !(flags & RENAME_EXCHANGE) && target)
 +		shrink_dcache_parent(new_dentry);
 +	if (!is_dir) {
 +		error =3D try_break_deleg(source, delegated_inode);
 +		if (error)
 +			goto out;
 +	}
 +	if (target && !new_is_dir) {
  		error =3D try_break_deleg(target, delegated_inode);
  		if (error)
  			goto out;
@@@ -4123,31 -4064,73 +4126,32 @@@
  	if (error)
  		goto out;
 =20
 -	if (target) {
 +	if (!(flags & RENAME_EXCHANGE) && target) {
 +		if (is_dir)
 +			target->i_flags |=3D S_DEAD;
  		dont_mount(new_dentry);
+ 		detach_mounts(new_dentry);
  	}
 -	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
 -		d_move(old_dentry, new_dentry);
 +	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE)) {
 +		if (!(flags & RENAME_EXCHANGE))
 +			d_move(old_dentry, new_dentry);
 +		else
 +			d_exchange(old_dentry, new_dentry);
 +	}
  out:
 -	unlock_two_nondirectories(source, target);
 +	if (!is_dir || (flags & RENAME_EXCHANGE))
 +		unlock_two_nondirectories(source, target);
 +	else if (target)
 +		mutex_unlock(&target->i_mutex);
  	dput(new_dentry);
 -	return error;
 -}
 -
 -/**
 - * vfs_rename - rename a filesystem object
 - * @old_dir:	parent of source
 - * @old_dentry:	source
 - * @new_dir:	parent of destination
 - * @new_dentry:	destination
 - * @delegated_inode: returns an inode needing a delegation break
 - *
 - * The caller must hold multiple mutexes--see lock_rename()).
 - *
 - * If vfs_rename discovers a delegation in need of breaking at either
 - * the source or destination, it will return -EWOULDBLOCK and return a
 - * reference to the inode in delegated_inode.  The caller should then
 - * break the delegation and retry.  Because breaking a delegation may
 - * take a long time, the caller should drop all locks before doing
 - * so.
 - *
 - * Alternatively, a caller may pass NULL for delegated_inode.  This may
 - * be appropriate for callers that expect the underlying filesystem not
 - * to be NFS exported.
 - */
 -int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 -	       struct inode *new_dir, struct dentry *new_dentry,
 -	       struct inode **delegated_inode)
 -{
 -	int error;
 -	int is_dir =3D d_is_directory(old_dentry) || d_is_autodir(old_dentry);
 -	const unsigned char *old_name;
 -
 -	if (old_dentry->d_inode =3D=3D new_dentry->d_inode)
 - 		return 0;
 -=20
 -	error =3D may_delete(old_dir, old_dentry, is_dir);
 -	if (error)
 -		return error;
 -
 -	if (!new_dentry->d_inode)
 -		error =3D may_create(new_dir, new_dentry);
 -	else
 -		error =3D may_delete(new_dir, new_dentry, is_dir);
 -	if (error)
 -		return error;
 -
 -	if (!old_dir->i_op->rename)
 -		return -EPERM;
 -
 -	old_name =3D fsnotify_oldname_init(old_dentry->d_name.name);
 -
 -	if (is_dir)
 -		error =3D vfs_rename_dir(old_dir,old_dentry,new_dir,new_dentry);
 -	else
 -		error =3D vfs_rename_other(old_dir,old_dentry,new_dir,new_dentry,delega=
ted_inode);
 -	if (!error)
 +	if (!error) {
  		fsnotify_move(old_dir, new_dir, old_name, is_dir,
 -			      new_dentry->d_inode, old_dentry);
 +			      !(flags & RENAME_EXCHANGE) ? target : NULL, old_dentry);
 +		if (flags & RENAME_EXCHANGE) {
 +			fsnotify_move(new_dir, old_dir, old_dentry->d_name.name,
 +				      new_is_dir, NULL, new_dentry);
 +		}
 +	}
  	fsnotify_oldname_free(old_name);
 =20
  	return error;

--Signature=_Wed__9_Apr_2014_12_39_52_+1000_DAsSmei.Ps_DULym
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTRLL+AAoJEMDTa8Ir7ZwVLAQQAIB0UwWke/2nNT8+CtvH4ayo
FgEiF6RDd2TnmORuBMZk+OLco76KlMxiiLHyfptAaTylijsM6ZyN7e1mzfVsToPL
Qfb3j+MUUmxFkwC1e0qFwSTmY5Wv2NWoeRhO6ZBhC+XMj27ZGwxUjd4/nOVnwHHz
WAj1x1GOn9ujustxOlqJh6CopReMvrQ+W47pFNBWCslTHGMclxXAR+IT68eJZ4ml
hIlyEkar3hTo+1ysjsPbPYcoFPXsGh5JwvPGJLulgFOP+LW+dAex9D+f/EwKHpBa
K33l54PttJqDOGsAzo76GmBMOQHD1AD/KXcdOkz1758UadGP5c+hBJTLamNgEm6M
swk8SO9wgbDJ/IjVWGEOPup9QWazce9HOVq7bkfljtMgle0Ayo/6SB2KryfMYQch
/OxAT7XPoQkViILlJSR4eeWtexKExTlhY/aGoo8ohAP3qDU3xOIDI/SOnUtqBoL5
Do3CARG6j6VANkGPA4VouwQUAjz+sGAT26sRCwNkU9eCTTX+MY8DecyG7Y9AhjGn
pBpdtxXdD/1XiWKzVaXx2ulrqRYSBfBmlHEtcMWMpsM+2LD8pnrmtu5C99BtKQPz
RK+mL+IrITWMPFusujBoDiu54iFTcLOqS0bi6iIPopJ8u3lZ+aqJZZJCpjH+hpP3
7Ou3EG7cD0vSTYCmLi0z
=cgLX
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Apr_2014_12_39_52_+1000_DAsSmei.Ps_DULym--
