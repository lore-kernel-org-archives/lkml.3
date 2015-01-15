Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbbAOPUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:20:42 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60653 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAOPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:20:39 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Namjae Jeon <namjae.jeon@samsung.com>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>
Cc: Brian Foster <bfoster@redhat.com>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: file freeze support
In-Reply-To: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 15 Jan 2015 18:19:36 +0300
Message-ID: <87sifc137b.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Namjae Jeon <namjae.jeon@samsung.com> writes:

> We introduce per-file freeze feature for unifying defrag ext4 and xfs
> as first ingredient. We get the idea courtesy of Dave Chinner
> (https://lkml.org/lkml/2014/7/14/759)
> per-file freeze will be used to avoid that file is not modified while
> userspace is doing the defrag.
>
> This patch tries to implement file write freeze functionality.
> Introduce new inode state, I_WRITE_FREEZED.
> When this state is set, any process which tries to modify the file's addr=
ess
> space, either by pagefault mmap writes or using write(2), will block until
> the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFRE=
EZE
> ioctl and clear by FS_IOC_FWTHAW ioctl.
>
> File write freeze functionality, when used in conjunction with
> inode's immutable flag can be used for creating truly stable file snapsho=
ts
> wherein write freeze will prevent any modification to the file from alrea=
dy
> open file descriptors and immutable flag will prevent any new modification
> to the file. One of the intended uses for stable file snapshots would be =
in
> the defragmentation applications which defrags single file.
>
> For implementation purpose, initially we tried to keep percpu usage count=
ers
> inside struct inode just like there is struct sb_writers in super_block.
> But considering that it will significantly bloat up struct inode when act=
ually
> the usage of file write freeze will be infrequent, we dropped this idea.
> Instead we have tried to use already present filesystem freezing infrastr=
ucture.
> Current approach makes it possible for implementing file write freeze wit=
hout
> bloating any of struct super_block/inode.
> In FS_IOC_FWFREEZE, we wait for complete fs to be frozen, set I_WRITE_FRE=
EZED to
> inode's state and unfreeze the fs.=20
Looks interesting. I have added some comments below.
>
> TODO : prevent inode eviction when I_WRITE_FREEZED state is set.
> TODO : xfstests testcase for file freeze.
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/btrfs/inode.c        |  1 +
>  fs/buffer.c             |  1 +
>  fs/ext4/inode.c         |  1 +
>  fs/f2fs/file.c          |  1 +
>  fs/gfs2/file.c          |  1 +
>  fs/inode.c              | 19 ++++++++++++++++++
>  fs/ioctl.c              | 30 +++++++++++++++++++++++++++++
>  fs/nilfs2/file.c        |  1 +
>  fs/ocfs2/mmap.c         |  1 +
>  fs/super.c              | 51 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/fs.h      | 13 +++++++++++++
>  include/uapi/linux/fs.h |  2 ++
>  mm/filemap.c            |  1 +
>  13 files changed, 123 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e687bb0..357c749 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8262,6 +8262,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, =
struct vm_fault *vmf)
>  	u64 page_start;
>  	u64 page_end;
>=20=20
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);
>  	ret  =3D btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
>  	if (!ret) {
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 20805db..966d50b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2444,6 +2444,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, =
struct vm_fault *vmf,
>  	int ret;
>  	struct super_block *sb =3D file_inode(vma->vm_file)->i_sb;
>=20=20
> +	inode_start_write(file_inode(vma->vm_file));
>  	sb_start_pagefault(sb);
>=20=20
>  	/*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5653fa4..7e1e41e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4981,6 +4981,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, s=
truct vm_fault *vmf)
>  	get_block_t *get_block;
>  	int retries =3D 0;
>=20=20
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vma->vm_file);
>  	/* Delalloc case is easy... */
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index f172ddc4..9e23f8d 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -40,6 +40,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *=
vma,
>=20=20
>  	f2fs_balance_fs(sbi);
>
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);
IMHO it is reasonable to fold sb_start_{write,pagefault}, to inode_start_{w=
rite,pagefault}
>=20=20
>  	f2fs_bug_on(sbi, f2fs_has_inline_data(inode));
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 6e600ab..bddf66b 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -393,6 +393,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *v=
ma, struct vm_fault *vmf)
>  	loff_t size;
>  	int ret;
>=20=20
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);
>=20=20
>  	/* Update file times before taking page lock */
> diff --git a/fs/inode.c b/fs/inode.c
> index aa149e7..82a96d0 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1929,3 +1929,22 @@ void inode_set_flags(struct inode *inode, unsigned=
 int flags,
>  				  new_flags) !=3D old_flags));
>  }
>  EXPORT_SYMBOL(inode_set_flags);
> +
> +void inode_start_write(struct inode *inode)
> +{
> +	struct super_block *sb =3D inode->i_sb;
> +
> +retry:
> +	spin_lock(&inode->i_lock);
This means that i_lock will be acquired on each mkpage_write for all
users who do not care about fsfreeze which result smp performance drawback
It is reasonable to add lockless test first because flag is set while
whole fs is frozen so we can not enter this routine.

> +	if (inode->i_state & I_WRITE_FREEZED) {
> +		DEFINE_WAIT(wait);
> +
> +		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> +				TASK_UNINTERRUPTIBLE);
> +		spin_unlock(&inode->i_lock);
> +		schedule();
> +		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> +		goto retry;
> +	}
> +	spin_unlock(&inode->i_lock);
> +}
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 214c3c1..c8e9ae3 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -540,6 +540,28 @@ static int ioctl_fsthaw(struct file *filp)
>  	return thaw_super(sb);
>  }
>=20=20
> +static int ioctl_filefreeze(struct file *filp)
> +{
> +	struct inode *inode =3D file_inode(filp);
> +
> +	if (!inode_owner_or_capable(inode))
> +		return -EPERM;
> +
> +	/* Freeze */
> +	return file_write_freeze(inode);
> +}

> +
> +static int ioctl_filethaw(struct file *filp)
> +{
> +	struct inode *inode =3D file_inode(filp);
> +
> +	if (!inode_owner_or_capable(inode))
> +		return -EPERM;
> +
> +	/* Thaw */
> +	return file_write_unfreeze(inode);
> +}
> +
>  /*
>   * When you add any new common ioctls to the switches above and below
>   * please update compat_sys_ioctl() too.
> @@ -589,6 +611,14 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd,=
 unsigned int cmd,
>  		error =3D ioctl_fsthaw(filp);
>  		break;
>=20=20
> +	case FS_IOC_FWFREEZE:
> +		error =3D ioctl_filefreeze(filp);
> +		break;
> +
> +	case FS_IOC_FWTHAW:
> +		error =3D ioctl_filethaw(filp);
> +		break;
> +
>  	case FS_IOC_FIEMAP:
>  		return ioctl_fiemap(filp, arg);
>=20=20
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 3a03e0a..5110d9d 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -66,6 +66,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vm=
a, struct vm_fault *vmf)
>  	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
>  		return VM_FAULT_SIGBUS; /* -ENOSPC */
>=20=20
> +	inode_start_write(file_inode(vma->vm_file));
>  	sb_start_pagefault(inode->i_sb);
>  	lock_page(page);
>  	if (page->mapping !=3D inode->i_mapping ||
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 10d66c7..d073fc2 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -136,6 +136,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *=
vma, struct vm_fault *vmf)
>  	sigset_t oldset;
>  	int ret;
>=20=20
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);
>  	ocfs2_block_signals(&oldset);
>=20=20
> diff --git a/fs/super.c b/fs/super.c
> index eae088f..5e44e42 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1393,3 +1393,54 @@ out:
>  	return 0;
>  }
>  EXPORT_SYMBOL(thaw_super);
> +
IMHO it is reasonable to open code this procedure so user is responsible
for calling  freeze_super(), thaw_super() . This allow to call for
several inodes in a row like follows:

ioctl(sb,FIFREEZE)
while (f =3D pop(files_list))
  ioctl(f,FS_IOC_FWFREEZE)
ioctl(sb,FITHAW)

This required for directory defragmentation(small files compacting)

> +int file_write_freeze(struct inode *inode)
> +{
> +	struct super_block *sb =3D inode->i_sb;
> +	int ret =3D 0;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
> +
> +	spin_lock(&inode->i_lock);
> +
> +	if (inode->i_state & I_WRITE_FREEZED)
> +		ret =3D -EBUSY;
> +	spin_unlock(&inode->i_lock);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D freeze_super(sb);
> +	if (ret)
> +		return ret;
> +
> +	spin_lock(&inode->i_lock);
> +	inode->i_state |=3D I_WRITE_FREEZED;
> +	smp_wmb();
> +	spin_unlock(&inode->i_lock);
> +
> +	return thaw_super(sb);
> +}
> +EXPORT_SYMBOL(file_write_freeze);
> +
> +int file_write_unfreeze(struct inode *inode)
> +{
> +	struct super_block *sb =3D inode->i_sb;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
> +
> +	spin_lock(&inode->i_lock);
> +
> +	if (!(inode->i_state & I_WRITE_FREEZED)) {
> +		spin_unlock(&inode->i_lock);
> +		return -EINVAL;
> +	}
> +
> +	inode->i_state &=3D ~I_WRITE_FREEZED;
> +	smp_wmb();
> +	wake_up(&sb->s_writers.wait_unfrozen);
> +	spin_unlock(&inode->i_lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(file_write_unfreeze);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8639770..13eba85 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1313,8 +1313,12 @@ extern struct timespec current_fs_time(struct supe=
r_block *sb);
>   * Snapshotting support.
>   */
>=20=20
> +int file_write_freeze(struct inode *inode);
> +int file_write_unfreeze(struct inode *inode);
> +
>  void __sb_end_write(struct super_block *sb, int level);
>  int __sb_start_write(struct super_block *sb, int level, bool wait);
> +void inode_start_write(struct inode *inode);
>=20=20
>  /**
>   * sb_end_write - drop write access to a superblock
> @@ -1730,6 +1734,12 @@ struct super_operations {
>   *
>   * I_DIO_WAKEUP		Never set.  Only used as a key for wait_on_bit().
>   *
> + * I_WRITE_FREEZED	This bit is set by calling file_write_freeze ioctl and
> + *			unset by file_write_thaw ioctl. If this is set, the
> + *			processes which have already open the file and try to
> + *			modify the file address space will block until the bit
> + *			is cleared.
> + *
>   * Q: What is the difference between I_WILL_FREE and I_FREEING?
>   */
>  #define I_DIRTY_SYNC		(1 << 0)
> @@ -1746,6 +1756,7 @@ struct super_operations {
>  #define __I_DIO_WAKEUP		9
>  #define I_DIO_WAKEUP		(1 << I_DIO_WAKEUP)
>  #define I_LINKABLE		(1 << 10)
> +#define I_WRITE_FREEZED	(1 << 11)
>=20=20
>  #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
>=20=20
> @@ -2321,6 +2332,7 @@ static inline void file_start_write(struct file *fi=
le)
>  {
>  	if (!S_ISREG(file_inode(file)->i_mode))
>  		return;
> +	inode_start_write(file_inode(file));
>  	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
>  }
>=20=20
> @@ -2328,6 +2340,7 @@ static inline bool file_start_write_trylock(struct =
file *file)
>  {
>  	if (!S_ISREG(file_inode(file)->i_mode))
>  		return true;
> +	inode_start_write(file_inode(file));
>  	return __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
>  }
>=20=20
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 3735fa0..3f529a7 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -167,6 +167,8 @@ struct inodes_stat_t {
>  #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
>  #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
>  #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
> +#define FS_IOC_FWFREEZE		_IOWR('X', 122, int) /* File Freeze */
> +#define FS_IOC_FWTHAW			_IOWR('X', 123, int) /* File Thaw */
>=20=20
>  /*
>   * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index bd8543c..b07a873 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2066,6 +2066,7 @@ int filemap_page_mkwrite(struct vm_area_struct *vma=
, struct vm_fault *vmf)
>  	struct inode *inode =3D file_inode(vma->vm_file);
>  	int ret =3D VM_FAULT_LOCKED;
>=20=20
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vma->vm_file);
>  	lock_page(page);
> --=20
> 1.8.5.5

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUt9qIAAoJELhyPTmIL6kB6m0IAMBBHqfMIlJNmMW/2nUdwdyD
APAw1uhWllPGqhi/uckTMHEMGG1UUJMib6OQkImme1FkL8T8VkB4fzpn2DHaWqim
4DpIk5UXBXDqQ4VNYVFEMDpouW0R2GOMgacjc1JO57yfQg/lqt5ES1eaG/onCcJH
FmCvR2t2cJN3BPpH/BY48Q52ND0VVsIWxXyJicCXIhDCKpZh7PzRAW91Q5t6Xihu
4poWZ2z+FZ3ZmHavOp26jUebfLVVgUvYpcQXxSmt75LXSdGW70kyWSNfYCgJdiSX
li9p3bwy1nOboUWwzzIXE9VECHHyYm49ymLjKvT9AbjJW2c0Ni46i6HORCbj1wA=
=Pkg8
-----END PGP SIGNATURE-----
--=-=-=--
