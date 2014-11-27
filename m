Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaK0DyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:54:00 -0500
Received: from ozlabs.org ([103.22.144.67]:37615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbaK0Dx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:53:57 -0500
Date: Thu, 27 Nov 2014 14:53:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with the ext4 tree
Message-ID: <20141127145347.0083c0bc@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/u2L0JaVlfZ53Je6gcN/nqhY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/u2L0JaVlfZ53Je6gcN/nqhY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/fs-writeback.c between commit ef7fdf5e8c87 ("vfs: add support for a
lazytime mount option") from the ext4 tree and commit 9c6ac78eb352
("writeback: fix a subtle race condition in I_DIRTY clearing") from the
block tree.

I fixed it up (I took a guess, plese check - see below) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/fs-writeback.c
index 3d87174408ae,2d609a5fbfea..000000000000
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@@ -482,14 -479,30 +482,30 @@@ __writeback_single_inode(struct inode *
  	 * write_inode()
  	 */
  	spin_lock(&inode->i_lock);
- 	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
- 	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
- 		inode->i_state &=3D ~I_DIRTY_PAGES;
+=20
 -	dirty =3D inode->i_state & I_DIRTY;
 -	inode->i_state &=3D ~I_DIRTY;
 +	dirty =3D inode->i_state & I_DIRTY_INODE;
 +	inode->i_state &=3D ~I_DIRTY_INODE;
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
 -	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 +	if (dirty) {
  		int err =3D write_inode(inode, wbc);
  		if (ret =3D=3D 0)
  			ret =3D err;

--Sig_/u2L0JaVlfZ53Je6gcN/nqhY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJUdqBQAAoJEMDTa8Ir7ZwVZ0QP+Jfn89cUc1oxUl18Av6dgPMc
IxXwPxtpVc2wCvegl3VJDNuMyF+4V8Q2XVyRA4f7OvHfGSrGrB6skLEim+giIkT3
uohqvy/rrl6sD3j5KJfB4jGSwRL0BUMl+Z+KXdGjNJb8+oYxu3k32A+r5g+7XnX/
3F+SbNmhtjBhNFXrfcnbRR+m3lllzwirUNg8iY8WMAoXKsNtyF2KVYnARaNeSsty
GrE8imcso7Ty8OWieM0IuF/1q+HKCO074UR19DV3f6wEhHndlxq4FWZkX2wPeB8R
xYmEvoXU+wanSA6IrhKW2R3M76O7xf2qPQUMksKcNyOzX6TjJoforHpz1UgjKeyd
dahSKLKZ1zwRgxUX4PS1luAaZukjW+QKnlHV8n29e8ZRWxwUxlF4MvoosxiG/imF
btRTfP1K8b9tp9MmSvt+PjzaycgS/zD3FCmuxoANT6XLPBn+hgeAqTeA0QGFEl8Z
wm8XxhV423j/MXvYgsJ5OPozgb3FgUAjRBdVcUExYdD4fGBFAQ0IsVRMNSTnBOX3
2oYbjMBc9g3rPkNj0ZlrjNTuLugVgfjYATOUHzbIFCsK91N7x/ry8ZmjvkcCB8pk
k52JOkJ8GQ+M3P147qltW0oDA0KNgtaP9xcoiJ0q8mfx6VN82oz5soxbwSUKvbGy
u5dYqD4xNn4Q3TKHs0Y=
=GHZw
-----END PGP SIGNATURE-----

--Sig_/u2L0JaVlfZ53Je6gcN/nqhY--
