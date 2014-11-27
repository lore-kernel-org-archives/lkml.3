Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaK0JMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:12:14 -0500
Received: from ozlabs.org ([103.22.144.67]:49398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaK0JMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:12:06 -0500
Date: Thu, 27 Nov 2014 20:11:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141127201156.62487051@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0mhRPpP_rfNMqw=0z5ikgJD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0mhRPpP_rfNMqw=0z5ikgJD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/lustre/lustre/llite/dcache.c,
drivers/staging/lustre/lustre/llite/llite_internal.h,
drivers/staging/lustre/lustre/llite/llite_lib.c,
drivers/staging/lustre/lustre/llite/namei.c and
drivers/staging/lustre/lustre/llite/statahead.c between various commits
from the vfs tree and commit 2d00bd17a270 ("staging: lustre: Coalesce
string fragments") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/lustre/lustre/llite/dcache.c
index f692261e9b5c,5f03c5fbb098..000000000000
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@@ -258,9 -258,10 +258,9 @@@ void ll_invalidate_aliases(struct inod
  	       inode->i_ino, inode->i_generation, inode);
 =20
  	ll_lock_dcache(inode);
 -	ll_d_hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
 -		CDEBUG(D_DENTRY, "dentry in drop %.*s (%p) parent %p inode %p flags %d\=
n",
 -		       dentry->d_name.len, dentry->d_name.name,
 -		       dentry, dentry->d_parent,
 +	ll_d_hlist_for_each_entry(dentry, p, &inode->i_dentry, d_u.d_alias) {
- 		CDEBUG(D_DENTRY, "dentry in drop %pd (%p) parent %p "
- 		       "inode %p flags %d\n", dentry, dentry, dentry->d_parent,
++		CDEBUG(D_DENTRY, "dentry in drop %pd (%p) parent %p inode %p flags %d\n=
",
++		       dentry, dentry, dentry->d_parent,
  		       dentry->d_inode, dentry->d_flags);
 =20
  		if (unlikely(dentry =3D=3D dentry->d_sb->s_root)) {
diff --cc drivers/staging/lustre/lustre/llite/llite_internal.h
index 77d1c12704b4,79fc29b3710c..000000000000
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@@ -1489,8 -1489,8 +1489,8 @@@ static inline void __d_lustre_invalidat
   */
  static inline void d_lustre_invalidate(struct dentry *dentry, int nested)
  {
- 	CDEBUG(D_DENTRY, "invalidate dentry %pd (%p) parent %p inode %p "
- 	       "refc %d\n", dentry, dentry,
 -	CDEBUG(D_DENTRY, "invalidate dentry %.*s (%p) parent %p inode %p refc %d=
\n",
 -	       dentry->d_name.len, dentry->d_name.name, dentry,
++	CDEBUG(D_DENTRY, "invalidate dentry %pd (%p) parent %p inode %p refc %d\=
n",
++	       dentry, dentry,
  	       dentry->d_parent, dentry->d_inode, d_count(dentry));
 =20
  	spin_lock_nested(&dentry->d_lock,
diff --cc drivers/staging/lustre/lustre/llite/llite_lib.c
index 7b6b9e2e0102,3b0336029da3..000000000000
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@@ -698,8 -690,10 +690,8 @@@ void lustre_dump_dentry(struct dentry *
  	list_for_each(tmp, &dentry->d_subdirs)
  		subdirs++;
 =20
- 	CERROR("dentry %p dump: name=3D%pd parent=3D%p, inode=3D%p, count=3D%u,"
- 	       " flags=3D0x%x, fsdata=3D%p, %d subdirs\n", dentry, dentry,
 -	CERROR("dentry %p dump: name=3D%.*s parent=3D%.*s (%p), inode=3D%p, coun=
t=3D%u, flags=3D0x%x, fsdata=3D%p, %d subdirs\n",
 -	       dentry,
 -	       dentry->d_name.len, dentry->d_name.name,
 -	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
++	CERROR("dentry %p dump: name=3D%pd parent=3D%p, inode=3D%p, count=3D%u, =
flags=3D0x%x, fsdata=3D%p, %d subdirs\n",
++	       dentry, dentry,
  	       dentry->d_parent, dentry->d_inode, d_count(dentry),
  	       dentry->d_flags, dentry->d_fsdata, subdirs);
  	if (dentry->d_inode !=3D NULL)
diff --cc drivers/staging/lustre/lustre/llite/namei.c
index 8e926b385a60,671d0cd2a6a2..000000000000
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@@ -598,9 -619,8 +598,8 @@@ static int ll_atomic_open(struct inode=20
  	long long lookup_flags =3D LOOKUP_OPEN;
  	int rc =3D 0;
 =20
- 	CDEBUG(D_VFSTRACE, "VFS Op:name=3D%pd,dir=3D%lu/%u(%p),file %p,"
- 			   "open_flags %x,mode %x opened %d\n",
 -	CDEBUG(D_VFSTRACE, "VFS Op:name=3D%.*s,dir=3D%lu/%u(%p),file %p,open_fla=
gs %x,mode %x opened %d\n",
 -	       dentry->d_name.len, dentry->d_name.name, dir->i_ino,
++	CDEBUG(D_VFSTRACE, "VFS Op:name=3D%pd,dir=3D%lu/%u(%p),file %p, open_fla=
gs %x,mode %x opened %d\n",
 +	       dentry, dir->i_ino,
  	       dir->i_generation, dir, file, open_flags, mode, *opened);
 =20
  	it =3D kzalloc(sizeof(*it), GFP_NOFS);
@@@ -843,12 -862,11 +842,11 @@@ static int ll_create_nd(struct inode *d
  {
  	int rc;
 =20
- 	CDEBUG(D_VFSTRACE, "VFS Op:name=3D%pd,dir=3D%lu/%u(%p),"
- 			   "flags=3D%u, excl=3D%d\n",
 -	CDEBUG(D_VFSTRACE, "VFS Op:name=3D%.*s,dir=3D%lu/%u(%p),flags=3D%u, excl=
=3D%d\n",
 -	       dentry->d_name.len, dentry->d_name.name, dir->i_ino,
++	CDEBUG(D_VFSTRACE, "VFS Op:name=3D%pd,dir=3D%lu/%u(%p), flags=3D%u, excl=
=3D%d\n",
 +	       dentry, dir->i_ino,
  	       dir->i_generation, dir, mode, want_excl);
 =20
 -	rc =3D ll_mknod_generic(dir, &dentry->d_name, mode, 0, dentry);
 +	rc =3D ll_mknod(dir, dentry, mode, 0);
 =20
  	ll_stats_ops_tally(ll_i2sbi(dir), LPROC_LL_CREATE, 1);
 =20
@@@ -974,7 -1101,8 +972,7 @@@ out
   * Instead, ll_ddelete() and ll_d_iput() will update it based upon if the=
re
   * is any lock existing. They will recycle dentries and inodes based upon=
 locks
   * too. b=3D20433 */
- static int ll_unlink(struct inode * dir, struct dentry *dentry)
 -static int ll_unlink_generic(struct inode *dir, struct dentry *dparent,
 -			     struct dentry *dchild, struct qstr *name)
++static int ll_unlink(struct inode *dir, struct dentry *dentry)
  {
  	struct ptlrpc_request *request =3D NULL;
  	struct md_op_data *op_data;
diff --cc drivers/staging/lustre/lustre/llite/statahead.c
index 09d965e76842,c4bd09edb0ce..000000000000
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@@ -1612,9 -1609,9 +1609,8 @@@ int do_statahead_enter(struct inode *di
  				} else if ((*dentryp)->d_inode !=3D inode) {
  					/* revalidate, but inode is recreated */
  					CDEBUG(D_READA,
- 					      "stale dentry %pd inode %lu/%u, "
- 					      "statahead inode %lu/%u\n",
 -					      "stale dentry %.*s inode %lu/%u, statahead inode %lu/%u\n",
 -					      (*dentryp)->d_name.len,
 -					      (*dentryp)->d_name.name,
++					      "stale dentry %pd inode %lu/%u, statahead inode %lu/%u\n",
 +					      *dentryp,
  					      (*dentryp)->d_inode->i_ino,
  					      (*dentryp)->d_inode->i_generation,
  					      inode->i_ino,
@@@ -1665,9 -1662,8 +1661,8 @@@
  	if (unlikely(sai->sai_inode !=3D parent->d_inode)) {
  		struct ll_inode_info *nlli =3D ll_i2info(parent->d_inode);
 =20
- 		CWARN("Race condition, someone changed %pd just now: "
- 		      "old parent "DFID", new parent "DFID"\n",
 -		CWARN("Race condition, someone changed %.*s just now: old parent " DFID=
 ", new parent " DFID "\n",
 -		      (*dentryp)->d_name.len, (*dentryp)->d_name.name,
++		CWARN("Race condition, someone changed %pd just now: old parent "DFID",=
 new parent "DFID"\n",
 +		      *dentryp,
  		      PFID(&lli->lli_fid), PFID(&nlli->lli_fid));
  		dput(parent);
  		iput(sai->sai_inode);

--Sig_/0mhRPpP_rfNMqw=0z5ikgJD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdurhAAoJEMDTa8Ir7ZwVqH0P/07PN0jkri6bXITjBmWYS8IW
IfrQ2XUnXmwTIWjT6aIQgwLgH2VcDsYkY8KHVq1a4XrpooKYlGMcHt+vXnV8oyCA
dsowOHGRmDiPlV2FMYK8vUfG82xkkYIAI0EsICiH0X19BCtt73ywXMFDFBQSNNhQ
2AXvriVy2lHAcZiP9sOG4z1RNBdSecbNRAIiW9mD5ONzN28tAbn7CGc/iZnP+0Sk
GjIiTqMS44OZ46geCRqA8FiypVLjmkGM0Fq2ri2P8GD8JejAwDbu9o7eKYImDuI4
fRjszqcA+abZEGBVa4UdcQJf78xAndNW4bc/SkxCNnF94gVF7QfeXhUjBliRaxe2
vYkQ+D5pTHtowYZygGSOB8z6uosa7AyvB3foQ5h3NXEvQo2QOcEg0MoKXa5DvJhE
zV7QF9F+9Pg1ZHHgyWd+/ud8NYtnksL7kHZnNdsJgLk/1SRdJXIcyPTPTip66M9e
WT0//nK5Ple+cafjsqE2kocSNQXNlgEwc22aefHlKOHhXuJ4RaStcmj8B38LMdUP
YOBk5duS/TQn29fp5RcGz7QFVcRVrXqNdwuXEaBmg+I/vpSpLtcOQkY1FDT++lEg
y2jGRCsIo3kyCa6lpX4CStNZqxVDndqm34QPuh2lKq0vadVWs2Hp0IQ+awrWtH+U
FicKw3JdB6EdiUvFQizs
=2wKk
-----END PGP SIGNATURE-----

--Sig_/0mhRPpP_rfNMqw=0z5ikgJD--
