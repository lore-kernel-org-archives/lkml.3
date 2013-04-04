Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763489Ab3DDFlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:41:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52872 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3DDFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:41:35 -0400
Date: Thu, 4 Apr 2013 16:41:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20130404164126.4cc52e5a3101ad824e8baee8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_16_41_26_+1100_2CzSrvL79O_w4WHL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_16_41_26_+1100_2CzSrvL79O_w4WHL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got conflicts in
fs/read_write.c and fs/read_write.h between commit 1fd193fd030a ("switch
compat readv/writev variants to COMPAT_SYSCALL_DEFINE") from the vfs tree
and commit 19f4fc3aee18 ("convert sendfile{,64} to
COMPAT_SYSCALL_DEFINE") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/read_write.c
index e7d7bde,f738e4d..0000000
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@@ -903,203 -853,8 +887,203 @@@ SYSCALL_DEFINE5(pwritev, unsigned long
  	return ret;
  }
 =20
 +#ifdef CONFIG_COMPAT
 +
 +static ssize_t compat_do_readv_writev(int type, struct file *file,
 +			       const struct compat_iovec __user *uvector,
 +			       unsigned long nr_segs, loff_t *pos)
 +{
 +	compat_ssize_t tot_len;
 +	struct iovec iovstack[UIO_FASTIOV];
 +	struct iovec *iov =3D iovstack;
 +	ssize_t ret;
 +	io_fn_t fn;
 +	iov_fn_t fnv;
 +
 +	ret =3D -EINVAL;
 +	if (!file->f_op)
 +		goto out;
 +
 +	ret =3D -EFAULT;
 +	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
 +		goto out;
 +
 +	ret =3D compat_rw_copy_check_uvector(type, uvector, nr_segs,
 +					       UIO_FASTIOV, iovstack, &iov);
 +	if (ret <=3D 0)
 +		goto out;
 +
 +	tot_len =3D ret;
 +	ret =3D rw_verify_area(type, file, pos, tot_len);
 +	if (ret < 0)
 +		goto out;
 +
 +	fnv =3D NULL;
 +	if (type =3D=3D READ) {
 +		fn =3D file->f_op->read;
 +		fnv =3D file->f_op->aio_read;
 +	} else {
 +		fn =3D (io_fn_t)file->f_op->write;
 +		fnv =3D file->f_op->aio_write;
 +		file_start_write(file);
 +	}
 +
 +	if (fnv)
 +		ret =3D do_sync_readv_writev(file, iov, nr_segs, tot_len,
 +						pos, fnv);
 +	else
 +		ret =3D do_loop_readv_writev(file, iov, nr_segs, pos, fn);
 +
 +	if (type !=3D READ)
 +		file_end_write(file);
 +
 +out:
 +	if (iov !=3D iovstack)
 +		kfree(iov);
 +	if ((ret + (type =3D=3D READ)) > 0) {
 +		if (type =3D=3D READ)
 +			fsnotify_access(file);
 +		else
 +			fsnotify_modify(file);
 +	}
 +	return ret;
 +}
 +
 +static size_t compat_readv(struct file *file,
 +			   const struct compat_iovec __user *vec,
 +			   unsigned long vlen, loff_t *pos)
 +{
 +	ssize_t ret =3D -EBADF;
 +
 +	if (!(file->f_mode & FMODE_READ))
 +		goto out;
 +
 +	ret =3D -EINVAL;
 +	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
 +		goto out;
 +
 +	ret =3D compat_do_readv_writev(READ, file, vec, vlen, pos);
 +
 +out:
 +	if (ret > 0)
 +		add_rchar(current, ret);
 +	inc_syscr(current);
 +	return ret;
 +}
 +
 +COMPAT_SYSCALL_DEFINE3(readv, unsigned long, fd,
 +		const struct compat_iovec __user *,vec,
 +		unsigned long, vlen)
 +{
 +	struct fd f =3D fdget(fd);
 +	ssize_t ret;
 +	loff_t pos;
 +
 +	if (!f.file)
 +		return -EBADF;
 +	pos =3D f.file->f_pos;
 +	ret =3D compat_readv(f.file, vec, vlen, &pos);
 +	f.file->f_pos =3D pos;
 +	fdput(f);
 +	return ret;
 +}
 +
 +COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 +		const struct compat_iovec __user *,vec,
 +		unsigned long, vlen, loff_t, pos)
 +{
 +	struct fd f;
 +	ssize_t ret;
 +
 +	if (pos < 0)
 +		return -EINVAL;
 +	f =3D fdget(fd);
 +	if (!f.file)
 +		return -EBADF;
 +	ret =3D -ESPIPE;
 +	if (f.file->f_mode & FMODE_PREAD)
 +		ret =3D compat_readv(f.file, vec, vlen, &pos);
 +	fdput(f);
 +	return ret;
 +}
 +
 +COMPAT_SYSCALL_DEFINE5(preadv, unsigned long, fd,
 +		const struct compat_iovec __user *,vec,
 +		unsigned long, vlen, u32, pos_low, u32, pos_high)
 +{
 +	loff_t pos =3D ((loff_t)pos_high << 32) | pos_low;
 +	return compat_sys_preadv64(fd, vec, vlen, pos);
 +}
 +
 +static size_t compat_writev(struct file *file,
 +			    const struct compat_iovec __user *vec,
 +			    unsigned long vlen, loff_t *pos)
 +{
 +	ssize_t ret =3D -EBADF;
 +
 +	if (!(file->f_mode & FMODE_WRITE))
 +		goto out;
 +
 +	ret =3D -EINVAL;
 +	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
 +		goto out;
 +
 +	ret =3D compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 +
 +out:
 +	if (ret > 0)
 +		add_wchar(current, ret);
 +	inc_syscw(current);
 +	return ret;
 +}
 +
 +COMPAT_SYSCALL_DEFINE3(writev, unsigned long, fd,
 +		const struct compat_iovec __user *, vec,
 +		unsigned long, vlen)
 +{
 +	struct fd f =3D fdget(fd);
 +	ssize_t ret;
 +	loff_t pos;
 +
 +	if (!f.file)
 +		return -EBADF;
 +	pos =3D f.file->f_pos;
 +	ret =3D compat_writev(f.file, vec, vlen, &pos);
 +	f.file->f_pos =3D pos;
 +	fdput(f);
 +	return ret;
 +}
 +
 +COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 +		const struct compat_iovec __user *,vec,
 +		unsigned long, vlen, loff_t, pos)
 +{
 +	struct fd f;
 +	ssize_t ret;
 +
 +	if (pos < 0)
 +		return -EINVAL;
 +	f =3D fdget(fd);
 +	if (!f.file)
 +		return -EBADF;
 +	ret =3D -ESPIPE;
 +	if (f.file->f_mode & FMODE_PWRITE)
 +		ret =3D compat_writev(f.file, vec, vlen, &pos);
 +	fdput(f);
 +	return ret;
 +}
 +
 +COMPAT_SYSCALL_DEFINE5(pwritev, unsigned long, fd,
 +		const struct compat_iovec __user *,vec,
 +		unsigned long, vlen, u32, pos_low, u32, pos_high)
 +{
 +	loff_t pos =3D ((loff_t)pos_high << 32) | pos_low;
 +	return compat_sys_pwritev64(fd, vec, vlen, pos);
 +}
 +#endif
 +
- ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
- 		    loff_t max)
+ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
+ 		  	   size_t count, loff_t max)
  {
  	struct fd in, out;
  	struct inode *in_inode, *out_inode;
diff --cc fs/read_write.h
index b987806,d07b954..0000000
--- a/fs/read_write.h
+++ b/fs/read_write.h
@@@ -8,5 -8,7 +8,3 @@@ typedef ssize_t (*io_fn_t)(struct file=20
  typedef ssize_t (*iov_fn_t)(struct kiocb *, const struct iovec *,
  		unsigned long, loff_t);
 =20
- ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
- 		    loff_t max);
 -ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 -		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn);
 -ssize_t do_loop_readv_writev(struct file *filp, struct iovec *iov,
 -		unsigned long nr_segs, loff_t *ppos, io_fn_t fn);

--Signature=_Thu__4_Apr_2013_16_41_26_+1100_2CzSrvL79O_w4WHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXRKGAAoJEECxmPOUX5FErz0P/RRZaHGj6ktFwSey613VS2wC
RhI8+IwDU/fLEqxOBXk4s5dnsP2lUJqqjrFNtKbYtIDu28rYPDveGFlxhMK1qSLc
h181UT99m1+Xv5Lf+e8/BY5xsUtMYLzRy4MmzYp3PiNLzv1oInqGRSl/O1KyMT83
Th1HZDUFOfM9syTTyVEgmcpGq5nd33C/RlTeP94B3oN9kCU21Z9DUCpfq6C1ar8S
zb1kOW5OnpGXiamjMT9tBEoEKmlYz4p6ODIyOYnuKImy5E/3aHQ+DHbc34Ey8EXa
1n1xe9U5bhjc2xxdP5XLk8ZWIjvK2IqupFAIUAWwiPQLdTbotA3Rw7XZCeCeQYtf
49eE7k5kvcGi9YfXt2PALevww+bFUOpFVE9aIEGz69QZbFCXFW5/OchwBpRNsSKR
GolC/89XGOIEEVtGxJtHnmTbt+1lXQzNlhdBesOeilQ3AnG5wgkXcSAh41zOJc/5
5m/Zd+fEHophsJVkjJmaKMK1QgOARS9pjnzrzEZgVSdUjTM4LmSgkQtk4BslYmPW
bx7HwW6GULroLQamlojW/fVxWu9nJ+NJgV6qRf2PcbfEzyvN6agolISUJPUmpd5N
dO50eHlyRdVGVXgofGv6/E7Hoe50ZeExHgO6U1EFkfdVXk+JromRQq1q1aABcAgX
1pP7orSL+toXfk5hu4xx
=5PGf
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_16_41_26_+1100_2CzSrvL79O_w4WHL--
