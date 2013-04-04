Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506Ab3DDFln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:41:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39901 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3DDFll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:41:41 -0400
Date: Thu, 4 Apr 2013 16:41:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20130404164139.bf1b475b3e5476e1f5327d53@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_16_41_39_+1100_EdypLtvwq78m+=/y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_16_41_39_+1100_EdypLtvwq78m+=/y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in fs/compat.c
between commit 1fd193fd030a ("switch compat readv/writev variants to
COMPAT_SYSCALL_DEFINE") from the vfs tree and commit 76b021d053ed
("convert vmsplice to COMPAT_SYSCALL_DEFINE") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/compat.c
index 5058345,b7a89b9..0000000
--- a/fs/compat.c
+++ b/fs/compat.c
@@@ -1069,26 -1064,195 +1068,6 @@@ asmlinkage long compat_sys_getdents64(u
  }
  #endif /* ! __ARCH_OMIT_COMPAT_SYS_GETDENTS64 */
 =20
- asmlinkage long
- compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
- 		    unsigned int nr_segs, unsigned int flags)
- {
- 	unsigned i;
- 	struct iovec __user *iov;
- 	if (nr_segs > UIO_MAXIOV)
- 		return -EINVAL;
- 	iov =3D compat_alloc_user_space(nr_segs * sizeof(struct iovec));
- 	for (i =3D 0; i < nr_segs; i++) {
- 		struct compat_iovec v;
- 		if (get_user(v.iov_base, &iov32[i].iov_base) ||
- 		    get_user(v.iov_len, &iov32[i].iov_len) ||
- 		    put_user(compat_ptr(v.iov_base), &iov[i].iov_base) ||
- 		    put_user(v.iov_len, &iov[i].iov_len))
- 			return -EFAULT;
- 	}
- 	return sys_vmsplice(fd, iov, nr_segs, flags);
- }
-=20
 -static ssize_t compat_do_readv_writev(int type, struct file *file,
 -			       const struct compat_iovec __user *uvector,
 -			       unsigned long nr_segs, loff_t *pos)
 -{
 -	compat_ssize_t tot_len;
 -	struct iovec iovstack[UIO_FASTIOV];
 -	struct iovec *iov =3D iovstack;
 -	ssize_t ret;
 -	io_fn_t fn;
 -	iov_fn_t fnv;
 -
 -	ret =3D -EINVAL;
 -	if (!file->f_op)
 -		goto out;
 -
 -	ret =3D -EFAULT;
 -	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
 -		goto out;
 -
 -	tot_len =3D compat_rw_copy_check_uvector(type, uvector, nr_segs,
 -					       UIO_FASTIOV, iovstack, &iov);
 -	if (tot_len =3D=3D 0) {
 -		ret =3D 0;
 -		goto out;
 -	}
 -
 -	ret =3D rw_verify_area(type, file, pos, tot_len);
 -	if (ret < 0)
 -		goto out;
 -
 -	fnv =3D NULL;
 -	if (type =3D=3D READ) {
 -		fn =3D file->f_op->read;
 -		fnv =3D file->f_op->aio_read;
 -	} else {
 -		fn =3D (io_fn_t)file->f_op->write;
 -		fnv =3D file->f_op->aio_write;
 -	}
 -
 -	if (fnv)
 -		ret =3D do_sync_readv_writev(file, iov, nr_segs, tot_len,
 -						pos, fnv);
 -	else
 -		ret =3D do_loop_readv_writev(file, iov, nr_segs, pos, fn);
 -
 -out:
 -	if (iov !=3D iovstack)
 -		kfree(iov);
 -	if ((ret + (type =3D=3D READ)) > 0) {
 -		if (type =3D=3D READ)
 -			fsnotify_access(file);
 -		else
 -			fsnotify_modify(file);
 -	}
 -	return ret;
 -}
 -
 -static size_t compat_readv(struct file *file,
 -			   const struct compat_iovec __user *vec,
 -			   unsigned long vlen, loff_t *pos)
 -{
 -	ssize_t ret =3D -EBADF;
 -
 -	if (!(file->f_mode & FMODE_READ))
 -		goto out;
 -
 -	ret =3D -EINVAL;
 -	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
 -		goto out;
 -
 -	ret =3D compat_do_readv_writev(READ, file, vec, vlen, pos);
 -
 -out:
 -	if (ret > 0)
 -		add_rchar(current, ret);
 -	inc_syscr(current);
 -	return ret;
 -}
 -
 -asmlinkage ssize_t
 -compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 -		 unsigned long vlen)
 -{
 -	struct fd f =3D fdget(fd);
 -	ssize_t ret;
 -	loff_t pos;
 -
 -	if (!f.file)
 -		return -EBADF;
 -	pos =3D f.file->f_pos;
 -	ret =3D compat_readv(f.file, vec, vlen, &pos);
 -	f.file->f_pos =3D pos;
 -	fdput(f);
 -	return ret;
 -}
 -
 -asmlinkage ssize_t
 -compat_sys_preadv64(unsigned long fd, const struct compat_iovec __user *v=
ec,
 -		    unsigned long vlen, loff_t pos)
 -{
 -	struct fd f;
 -	ssize_t ret;
 -
 -	if (pos < 0)
 -		return -EINVAL;
 -	f =3D fdget(fd);
 -	if (!f.file)
 -		return -EBADF;
 -	ret =3D -ESPIPE;
 -	if (f.file->f_mode & FMODE_PREAD)
 -		ret =3D compat_readv(f.file, vec, vlen, &pos);
 -	fdput(f);
 -	return ret;
 -}
 -
 -asmlinkage ssize_t
 -compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
 -		  unsigned long vlen, u32 pos_low, u32 pos_high)
 -{
 -	loff_t pos =3D ((loff_t)pos_high << 32) | pos_low;
 -	return compat_sys_preadv64(fd, vec, vlen, pos);
 -}
 -
 -static size_t compat_writev(struct file *file,
 -			    const struct compat_iovec __user *vec,
 -			    unsigned long vlen, loff_t *pos)
 -{
 -	ssize_t ret =3D -EBADF;
 -
 -	if (!(file->f_mode & FMODE_WRITE))
 -		goto out;
 -
 -	ret =3D -EINVAL;
 -	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
 -		goto out;
 -
 -	ret =3D compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 -
 -out:
 -	if (ret > 0)
 -		add_wchar(current, ret);
 -	inc_syscw(current);
 -	return ret;
 -}
 -
 -asmlinkage ssize_t
 -compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 -		  unsigned long vlen)
 -{
 -	struct fd f =3D fdget(fd);
 -	ssize_t ret;
 -	loff_t pos;
 -
 -	if (!f.file)
 -		return -EBADF;
 -	pos =3D f.file->f_pos;
 -	ret =3D compat_writev(f.file, vec, vlen, &pos);
 -	f.file->f_pos =3D pos;
 -	fdput(f);
 -	return ret;
 -}
 -
 -asmlinkage ssize_t
 -compat_sys_pwritev64(unsigned long fd, const struct compat_iovec __user *=
vec,
 -		     unsigned long vlen, loff_t pos)
 -{
 -	struct fd f;
 -	ssize_t ret;
 -
 -	if (pos < 0)
 -		return -EINVAL;
 -	f =3D fdget(fd);
 -	if (!f.file)
 -		return -EBADF;
 -	ret =3D -ESPIPE;
 -	if (f.file->f_mode & FMODE_PWRITE)
 -		ret =3D compat_writev(f.file, vec, vlen, &pos);
 -	fdput(f);
 -	return ret;
 -}
 -
 -asmlinkage ssize_t
 -compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *ve=
c,
 -		   unsigned long vlen, u32 pos_low, u32 pos_high)
 -{
 -	loff_t pos =3D ((loff_t)pos_high << 32) | pos_low;
 -	return compat_sys_pwritev64(fd, vec, vlen, pos);
 -}
 -
  /*
   * Exactly like fs/open.c:sys_open(), except that it doesn't set the
   * O_LARGEFILE flag.

--Signature=_Thu__4_Apr_2013_16_41_39_+1100_EdypLtvwq78m+=/y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXRKTAAoJEECxmPOUX5FE+bIP/2uCE845seGtB+fbHLWX4Er/
nV68a37KLe00Wet1fddh6LjH3GYxQ9LZtT90ZWQBd1C5geeQGbaPdmxowfMDQhTZ
rh9c4DI0ukCgsVfW9c4A6dXsFJ9gG0HPu0LwTw+0sEXXy90kms4TobpQ6bT7yMjJ
lr7kJOEnJBYlscDywxBHQylEX7wfpjIetbXdhkt2yBSlX1Y7QHKYO1fp6RqCYb52
FHGPFRsjw4jLi8hIZ1q4MQ+j03uE1rorOGJEMRlXYjU4BzSatTvTHEK3yxiPoyS4
37ZUbOBvJS9gVUvyBAIXgbR3vO1HTTCAt5CDlILz1qVjziv4/OxF1UAcObUU99BY
Z61QB5D56CeuJEqutu0KfEgiTQND9y6pIlWgwlkmILaXF5MrFcXmvlxaw5s3C3Mz
hSlL+BsLwtOVcfMgQa2OqOQ+kWtmG5u4q3hpbfdnV9xrBzAD0uNMRslrfnP+Nh6v
iQ8RZkmM1FDAwSoqCcT9H7AtzjufwAs/OMuXuxqVq7JDMBBTqu8RHFI6BesHN4RJ
+NY7+KXrFa1PKtDdkstjM4WJNLyL4TQSrhI1XDMAQpVMi6R1gBI8oQY0O3AvwksN
xvX6DCmTAAGYKCaFjnfqJR4G1Hl+Qrammutl9RPmDLM0I9YvrsHdpT/Rhh7Ozk5X
vKdhYaJULowaWFpOckBp
=UOk6
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_16_41_39_+1100_EdypLtvwq78m+=/y--
