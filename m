Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3HSHGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:06:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56128 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3HSHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:06:14 -0400
Date: Mon, 19 Aug 2013 17:06:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the akpm-current tree with the ext4
 tree
Message-Id: <20130819170602.121c9247810db4836472d849@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Aug_2013_17_06_02_+1000_9n+2TRZ55uGpfi9Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Aug_2013_17_06_02_+1000_9n+2TRZ55uGpfi9Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/ext4/inode.c between commit 4958dee0e70f ("ext4: simplify truncation
code in ext4_setattr()") from the ext4 tree and commit fb6854ec9753
("truncate: drop 'oldsize' truncate_pagecache() parameter") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/inode.c
index fc4051e,9257d79..0000000
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -4598,9 -4523,7 +4598,8 @@@ int ext4_setattr(struct dentry *dentry
  		ext4_journal_stop(handle);
  	}
 =20
 -	if (attr->ia_valid & ATTR_SIZE) {
 +	if (attr->ia_valid & ATTR_SIZE && attr->ia_size !=3D inode->i_size) {
 +		handle_t *handle;
- 		loff_t oldsize =3D inode->i_size;
 =20
  		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
  			struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
@@@ -4608,69 -4531,71 +4607,69 @@@
  			if (attr->ia_size > sbi->s_bitmap_maxbytes)
  				return -EFBIG;
  		}
 -	}
 -
 -	if (S_ISREG(inode->i_mode) &&
 -	    attr->ia_valid & ATTR_SIZE &&
 -	    (attr->ia_size < inode->i_size)) {
 -		handle_t *handle;
 -
 -		handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 3);
 -		if (IS_ERR(handle)) {
 -			error =3D PTR_ERR(handle);
 -			goto err_out;
 -		}
 -		if (ext4_handle_valid(handle)) {
 -			error =3D ext4_orphan_add(handle, inode);
 -			orphan =3D 1;
 -		}
 -		EXT4_I(inode)->i_disksize =3D attr->ia_size;
 -		rc =3D ext4_mark_inode_dirty(handle, inode);
 -		if (!error)
 -			error =3D rc;
 -		ext4_journal_stop(handle);
 -
 -		if (ext4_should_order_data(inode)) {
 -			error =3D ext4_begin_ordered_truncate(inode,
 +		if (S_ISREG(inode->i_mode) &&
 +		    (attr->ia_size < inode->i_size)) {
 +			if (ext4_should_order_data(inode)) {
 +				error =3D ext4_begin_ordered_truncate(inode,
  							    attr->ia_size);
 -			if (error) {
 -				/* Do as much error cleanup as possible */
 -				handle =3D ext4_journal_start(inode,
 -							    EXT4_HT_INODE, 3);
 -				if (IS_ERR(handle)) {
 -					ext4_orphan_del(NULL, inode);
 +				if (error)
  					goto err_out;
 -				}
 -				ext4_orphan_del(handle, inode);
 -				orphan =3D 0;
 -				ext4_journal_stop(handle);
 +			}
 +			handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 3);
 +			if (IS_ERR(handle)) {
 +				error =3D PTR_ERR(handle);
  				goto err_out;
  			}
 -		}
 -	}
 -
 -	if (attr->ia_valid & ATTR_SIZE) {
 -		if (attr->ia_size !=3D inode->i_size) {
 -			i_size_write(inode, attr->ia_size);
 -			/*
 -			 * Blocks are going to be removed from the inode. Wait
 -			 * for dio in flight.  Temporarily disable
 -			 * dioread_nolock to prevent livelock.
 -			 */
 -			if (orphan) {
 -				if (!ext4_should_journal_data(inode)) {
 -					ext4_inode_block_unlocked_dio(inode);
 -					inode_dio_wait(inode);
 -					ext4_inode_resume_unlocked_dio(inode);
 -				} else
 -					ext4_wait_for_tail_page_commit(inode);
 +			if (ext4_handle_valid(handle)) {
 +				error =3D ext4_orphan_add(handle, inode);
 +				orphan =3D 1;
  			}
 +			down_write(&EXT4_I(inode)->i_data_sem);
 +			EXT4_I(inode)->i_disksize =3D attr->ia_size;
 +			rc =3D ext4_mark_inode_dirty(handle, inode);
 +			if (!error)
 +				error =3D rc;
  			/*
 -			 * Truncate pagecache after we've waited for commit
 -			 * in data=3Djournal mode to make pages freeable.
 +			 * We have to update i_size under i_data_sem together
 +			 * with i_disksize to avoid races with writeback code
 +			 * running ext4_wb_update_i_disksize().
  			 */
 -			truncate_pagecache(inode, inode->i_size);
 +			if (!error)
 +				i_size_write(inode, attr->ia_size);
 +			up_write(&EXT4_I(inode)->i_data_sem);
 +			ext4_journal_stop(handle);
 +			if (error) {
 +				ext4_orphan_del(NULL, inode);
 +				goto err_out;
 +			}
 +		} else
 +			i_size_write(inode, attr->ia_size);
 +
 +		/*
 +		 * Blocks are going to be removed from the inode. Wait
 +		 * for dio in flight.  Temporarily disable
 +		 * dioread_nolock to prevent livelock.
 +		 */
 +		if (orphan) {
 +			if (!ext4_should_journal_data(inode)) {
 +				ext4_inode_block_unlocked_dio(inode);
 +				inode_dio_wait(inode);
 +				ext4_inode_resume_unlocked_dio(inode);
 +			} else
 +				ext4_wait_for_tail_page_commit(inode);
  		}
 -		ext4_truncate(inode);
 +		/*
 +		 * Truncate pagecache after we've waited for commit
 +		 * in data=3Djournal mode to make pages freeable.
 +		 */
- 		truncate_pagecache(inode, oldsize, inode->i_size);
++		truncate_pagecache(inode, inode->i_size);
  	}
 +	/*
 +	 * We want to call ext4_truncate() even if attr->ia_size =3D=3D
 +	 * inode->i_size for cases like truncation of fallocated space
 +	 */
 +	if (attr->ia_valid & ATTR_SIZE)
 +		ext4_truncate(inode);
 =20
  	if (!rc) {
  		setattr_copy(inode, attr);

--Signature=_Mon__19_Aug_2013_17_06_02_+1000_9n+2TRZ55uGpfi9Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSEcPeAAoJEECxmPOUX5FESAMP/RsKgGbzt/ljw37Uc91iI0/F
gc2ZGJb5g2n2Jf+Kk9T4QIpR/tvusPkEqv6zMDLRwPtk62hxVqM4nSHj70EoCuPZ
rwBu+XHdj0N+V3ER8lCKs2BkYFkrQEJH1wJRnkW2RlnKzc/W0D8SXdHDf+vro0fu
pNlmcqfozPrQlwjFbVkCLVpzj1zI/AHjA7qp/uQDwcUCOAiAXNZdf1LSB1/MC+Sa
wGKPzKCvlG+non5x1v49es92U7fqIgJS/5MvqvlL7g/9kul0aNqgAwetr+brmEvR
DY75bofcNpLU/p8EjXPySoe3LDcALBHCmR1mieCD+TAdyqVTu9UFFJ+zhG7SaRLi
mzkNes/JTPG0kMgFBXrzpF1RCqaXBdnh9AuBHyMib6Uy8BlrsPhRwiRxyJPzRb/s
yOj+R+XphptB/0L4c7LWmubs+B5yUuE4aObSghnp4xhUkRAn+KNRKIaUqiTMBDbI
7E+ImhXoCcja2UzEYcOjI1ARDaZQYYDZPn8GW2Tz3kcsnSbrEQURypwWMwFQkvxH
Wi7w6inzJsC2O5JRj+8U9XnClAoPNkSornE72yOYvIVRBJJxgXT+MGioZxXWknER
eEdyGj9vC2ENjJM/VavvZDFhET2aYFkWgrn6lRyWu0paEDvGgVM78cIrEYgfczlN
+5D2S0au0EPmcEW5q4vH
=Vbt4
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Aug_2013_17_06_02_+1000_9n+2TRZ55uGpfi9Z--
