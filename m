Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3IRA4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:56:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33509 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3IRA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:56:47 -0400
Date: Wed, 18 Sep 2013 10:56:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: linux-next: manual merge of the vfs tree with the aio-direct tree
Message-Id: <20130918105638.6fa7c29605c14b408b7f5a7e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_10_56_38_+1000_5IZ2ZzozJRguP6_K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_10_56_38_+1000_5IZ2ZzozJRguP6_K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got conflicts in fs/nfs/direct.c
and fs/nfs/file.c between commits b9517433d65d ("dio: Convert direct_IO
to use iov_iter"), a8431c667ae8 ("nfs: add support for read_iter,
write_iter") and a1b8ec384b73 ("nfs: simplify swap") from the aio-direct
tree and commit c18d1ec44f7a ("nfs: use %p[dD] instead of open-coded (and
often racy) equivalents") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfs/direct.c
index 239c2fe,d71d66c..0000000
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@@ -118,18 -117,26 +118,17 @@@ static inline int put_dreq(struct nfs_d
   * @nr_segs: size of iovec array
   *
   * The presence of this routine in the address space ops vector means
 - * the NFS client supports direct I/O. However, for most direct IO, we
 - * shunt off direct read and write requests before the VFS gets them,
 - * so this method is only ever called for swap.
 + * the NFS client supports direct I/O. However, we shunt off direct
 + * read and write requests before the VFS gets them, so this method
 + * should never be called.
   */
 -ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov=
, loff_t pos, unsigned long nr_segs)
 +ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 +		      loff_t pos)
  {
- 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
- 			iocb->ki_filp->f_path.dentry->d_name.name,
- 			(long long) pos, iter->nr_segs);
 -#ifndef CONFIG_NFS_SWAP
+ 	dprintk("NFS: nfs_direct_IO (%pD) off/no(%Ld/%lu) EINVAL\n",
 -			iocb->ki_filp, (long long) pos, nr_segs);
++			iocb->ki_filp, (long long) pos, iter->nr_segs);
 =20
  	return -EINVAL;
 -#else
 -	VM_BUG_ON(iocb->ki_nbytes !=3D PAGE_SIZE);
 -
 -	if (rw =3D=3D READ || rw =3D=3D KERNEL_READ)
 -		return nfs_file_direct_read(iocb, iov, nr_segs, pos,
 -				rw =3D=3D READ ? true : false);
 -	return nfs_file_direct_write(iocb, iov, nr_segs, pos,
 -				rw =3D=3D WRITE ? true : false);
 -#endif /* CONFIG_NFS_SWAP */
  }
 =20
  static void nfs_direct_release_pages(struct page **pages, unsigned int np=
ages)
@@@ -1010,13 -905,11 +1009,11 @@@ ssize_t nfs_file_direct_read(struct kio
  	struct address_space *mapping =3D file->f_mapping;
  	size_t count;
 =20
 -	count =3D iov_length(iov, nr_segs);
 +	count =3D iov_iter_count(iter);
  	nfs_add_stats(mapping->host, NFSIOS_DIRECTREADBYTES, count);
 =20
- 	dfprintk(FILE, "NFS: direct read(%s/%s, %zd@%Ld)\n",
- 		file->f_path.dentry->d_parent->d_name.name,
- 		file->f_path.dentry->d_name.name,
- 		count, (long long) pos);
+ 	dfprintk(FILE, "NFS: direct read(%pD2, %zd@%Ld)\n",
+ 		file, count, (long long) pos);
 =20
  	retval =3D 0;
  	if (!count)
@@@ -1065,13 -959,11 +1062,11 @@@ ssize_t nfs_file_direct_write(struct ki
  	struct address_space *mapping =3D file->f_mapping;
  	size_t count;
 =20
 -	count =3D iov_length(iov, nr_segs);
 +	count =3D iov_iter_count(iter);
  	nfs_add_stats(mapping->host, NFSIOS_DIRECTWRITTENBYTES, count);
 =20
- 	dfprintk(FILE, "NFS: direct write(%s/%s, %zd@%Ld)\n",
- 		file->f_path.dentry->d_parent->d_name.name,
- 		file->f_path.dentry->d_name.name,
- 		count, (long long) pos);
+ 	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
+ 		file, count, (long long) pos);
 =20
  	retval =3D generic_write_checks(file, &pos, &count, 0);
  	if (retval)
diff --cc fs/nfs/file.c
index 19ac4fd,e2fcacf..0000000
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@@ -174,18 -165,18 +165,17 @@@ nfs_file_flush(struct file *file, fl_ow
  EXPORT_SYMBOL_GPL(nfs_file_flush);
 =20
  ssize_t
 -nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 -		unsigned long nr_segs, loff_t pos)
 +nfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
  {
- 	struct dentry * dentry =3D iocb->ki_filp->f_path.dentry;
- 	struct inode * inode =3D dentry->d_inode;
+ 	struct inode *inode =3D file_inode(iocb->ki_filp);
  	ssize_t result;
 =20
  	if (iocb->ki_filp->f_flags & O_DIRECT)
 -		return nfs_file_direct_read(iocb, iov, nr_segs, pos, true);
 +		return nfs_file_direct_read(iocb, iter, pos);
 =20
- 	dprintk("NFS: read_iter(%s/%s, %lu@%lu)\n",
- 		dentry->d_parent->d_name.name, dentry->d_name.name,
 -	dprintk("NFS: read(%pD2, %lu@%lu)\n",
++	dprintk("NFS: read_iter(%pD2, %lu@%lu)\n",
+ 		iocb->ki_filp,
 -		(unsigned long) iov_length(iov, nr_segs), (unsigned long) pos);
 +		(unsigned long) iov_iter_count(iter), (unsigned long) pos);
 =20
  	result =3D nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping);
  	if (!result) {
@@@ -655,25 -634,24 +633,24 @@@ static int nfs_need_sync_write(struct f
  	return 0;
  }
 =20
 -ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
 -		       unsigned long nr_segs, loff_t pos)
 +ssize_t nfs_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
 +			    loff_t pos)
  {
- 	struct dentry * dentry =3D iocb->ki_filp->f_path.dentry;
- 	struct inode * inode =3D dentry->d_inode;
+ 	struct file *file =3D iocb->ki_filp;
+ 	struct inode *inode =3D file_inode(file);
  	unsigned long written =3D 0;
  	ssize_t result;
 -	size_t count =3D iov_length(iov, nr_segs);
 +	size_t count =3D iov_iter_count(iter);
 =20
- 	result =3D nfs_key_timeout_notify(iocb->ki_filp, inode);
+ 	result =3D nfs_key_timeout_notify(file, inode);
  	if (result)
  		return result;
 =20
- 	if (iocb->ki_filp->f_flags & O_DIRECT)
+ 	if (file->f_flags & O_DIRECT)
 -		return nfs_file_direct_write(iocb, iov, nr_segs, pos, true);
 +		return nfs_file_direct_write(iocb, iter, pos);
 =20
- 	dprintk("NFS: write_iter(%s/%s, %lu@%lld)\n",
- 		dentry->d_parent->d_name.name, dentry->d_name.name,
- 		(unsigned long) count, (long long) pos);
 -	dprintk("NFS: write(%pD2, %lu@%Ld)\n",
++	dprintk("NFS: write_iter(%pD2, %lu@%Ld)\n",
+ 		file, (unsigned long) count, (long long) pos);
 =20
  	result =3D -EBUSY;
  	if (IS_SWAPFILE(inode))

--Signature=_Wed__18_Sep_2013_10_56_38_+1000_5IZ2ZzozJRguP6_K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSOPpLAAoJEECxmPOUX5FEQQcQAJPC34Ph2FthDeUeNz8Ti8Xh
Lf4z0/guGEPNLFllPQKj5gf5+NpC14d9M6DS7+QvEZO97UlqstsxCRLEBEuJc2Z2
zX3WVVNfM/YyijQ4BIORgIZI+t7PDF+dTpugeQNJ1Lh7xQ8ML+Q2Lug/Bf1ezAp/
G806jgeEkdgeJgb6cFMJcHknxEG5LdV0QJRx4YpEVWz1N0uvvAgQRDYLvg11atEA
p5xpeHNv3rBl4XVQax9bR47EMqoboVzeXDZATIFHrBik1Kjkiwdji3CbjggOf86C
E6CEOQNHEm+wIR3aQqqo0T72/ByiyY9Psga5L0UWwygN4wznG/kqPeqxeGNcTMi2
D9gng2/bcAfWnqx/+HYttDQJ1XxntzucnQqBF+RTPSyogYCgy5ZDZ7V6fO8CPsBz
gze1SF2uBcskt4eCXxGcuETrUra+OXoYT6zaotXca5hxhXEkULEuKJcg/ujvsft3
yIC0JdX6w77dJrR2kYIz+Nc8ioQIZrJuWdVC7L/3IZmpOryWDsBe0VlOpF6nAYiY
4x7NF4i/gmH9UmFICV1FtkJiTFsT8Vzd60O/TzeboF/G+yuExxyBLoyzY1rKaf7g
ni5+sBXK+Na4k2QtvIKLhZ58gd5YL+w3B4K4DvgebYaeGm43VWG2i3F/IwwMazGD
+e00LsXi13KBPXDQV9Kk
=srLD
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_10_56_38_+1000_5IZ2ZzozJRguP6_K--
