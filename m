Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaKZCmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:42:14 -0500
Received: from ozlabs.org ([103.22.144.67]:35458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaKZCmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:42:12 -0500
Date: Wed, 26 Nov 2014 13:41:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>
Subject: linux-next: manual merge of the block tree with the ext4 tree
Message-ID: <20141126134152.49cd4296@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VteD/TK2atdBXWzc6ZQvB4x"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VteD/TK2atdBXWzc6ZQvB4x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/fs-writeback.c between commit 74ba19abbeae ("vfs: add support for a
lazytime mount option") from the ext4 tree and commit 9c6ac78eb352
("writeback: fix a subtle race condition in I_DIRTY clearing") from the
block tree.

I fixed it up (maybe, please check - see below) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/fs-writeback.c
index cab2d6d74828,2d609a5fbfea..000000000000
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@@ -480,12 -479,28 +480,28 @@@ __writeback_single_inode(struct inode *
  	 * write_inode()
  	 */
  	spin_lock(&inode->i_lock);
- 	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
- 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
- 		inode->i_state &=3D ~I_DIRTY_PAGES;
+=20
  	dirty =3D inode->i_state & I_DIRTY;
- 	inode->i_state &=3D ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_TIME);
 -	inode->i_state &=3D ~I_DIRTY;
++	inode->i_state &=3D ~(I_DIRTY | I_DIRTY_TIME);
+=20
+ 	/*
+ 	 * Paired with smp_mb() in __mark_inode_dirty().  This allows
+ 	 * __mark_inode_dirty() to test i_state without grabbing i_lock -
+ 	 * either they see the I_DIRTY bits cleared or we see the dirtied
+ 	 * inode.
+ 	 *
+ 	 * I_DIRTY_PAGES is always cleared together above even if @mapping
+ 	 * still has dirty pages.  The flag is reinstated after smp_mb() if
+ 	 * necessary.  This guarantees that either __mark_inode_dirty()
+ 	 * sees clear I_DIRTY_PAGES or we see PAGECACHE_TAG_DIRTY.
+ 	 */
+ 	smp_mb();
+=20
+ 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+ 		inode->i_state |=3D I_DIRTY_PAGES;
+=20
  	spin_unlock(&inode->i_lock);
+=20
  	/* Don't write the inode if only I_DIRTY_PAGES was set */
  	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
  		int err =3D write_inode(inode, wbc);

--Sig_/VteD/TK2atdBXWzc6ZQvB4x
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdT4BAAoJEMDTa8Ir7ZwVWDsQAJVwTxFXnyS3m1F7jrDCWnDL
HuZ6UUfvKIXOiRd2qULJkW9/novbaKaGs6TUQh8L3xWTW7Wi9qb/8zehi7cbVUgi
I3zk3ugnbLSoWNMPhwUsSSh5ar17HJHNo7/qgf0B4cGYLbsZ8ALjGz4FmhbWgcly
L49oUTSrCC1MpqIOZX/kPsf/8JuqsLs289YIqg/xdxy5e0fQSY+oWmO7cViR2sTQ
FZRVlkwhBalaRIQqjrRrwvQT/AyWksT5wFpvd8IVnEruX6v09rK9610KlFwUpSyl
ndN8PGgTKn2uoDBdRbeNWaVlJeT5JxkJjg8Kq8FukvTsSMx7ObUsjjer2nptz4Da
LYc/l+eAGI1CP4eIvlTnzmPvMa7s4VS2u2UH0b/KONXphA4LrNguS3lzZFiBcDaK
hHTCKJlsDeF4tcqX9Hs9RO33mkfOnRu8K2nfajLzMu0LasnMxkqqNF0g008JxOIv
1Od5JQxcoD1PsUB7lHJJ8LFvCVS/0bo/4+UhLTOJiZemuEDSPRVoBAqm4F09vv3z
/UnJMIfJU4F2AJPKQqfMgcq0UeoTIqmXDjiER6l7re65ssRl7lvihc9r0Gr4/wz9
QiPf4Fdii0bGoB8bhIAJY/6Ha9fX0qLpNqPqjlQVH13YKjruB1BsP7JS3838/2iH
xkGPYs8o8zCLeB0R2G6z
=bI3d
-----END PGP SIGNATURE-----

--Sig_/VteD/TK2atdBXWzc6ZQvB4x--
