Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbaH1Bfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:35:34 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:58946 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaH1Bfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net>
References: <CALCETrWT_p1-5nkiAjWoeta19fkO3rDiJe9_mhRVqF8x1zXv2A@mail.gmail.com>
 <2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 27 Aug 2014 18:35:10 -0700
Message-ID: <CALCETrXx+fsXqx1eP7GyZvS975pBmskOMx-rW1ZfqMfLRXL1Gw@mail.gmail.com>
Subject: Re: [PATCH] fs: Remove implicit nodev for new mounts in non-root userns
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 5:03 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Currently, creating a new mount (as opposed to bindmount) in a
> non-root userns will implicitly set nodev unless the fs is devpts.
> Something like this will be necessary for file systems that allow
> the mounter to create device nodes without using mknod (e.g. FUSE
> if/when that is allowed), but none of the currently allowed
> filesystems do this.
>

Any thoughts, Eric?

> Implicitly adding nodev is problematic, though.  It will make it
> unsafe to ever remove the implicit addition, since userspace might
> start to rely on it.
>
> This fixes a minor regression in:
>
>     9566d6742852 mnt: Correct permission checks in do_remount
>
> Prior to that commit, MNT_NODEV wasn't enforced for remounts, so
> there is existing user code that creates a new mount in a userns
> without MS_NODEV and then expects a remount with matching options to
> work.  That commit broke code that does this.
>
> Fortunately, since the implicit nodev has no effect on any existing
> filesystems, we can still safely remove it.
>
> This replaces the implicit nodev with an explicit nodev requirement:
> anyone who mounts a filesystem without FS_USERNS_DEV_MOUNT will get
> -EPERM unless they set nodev.  If they set nodev, that setting will
> be locked.
>
> As an added benefit, if anything like device namespaces is ever
> added, then user code will be able to opt out of nodev by clearing
> nodev.
>
> To keep existing code working, this adds FS_USERNS_DEV_MOUNT to all
> FS_USERNS_MOUNT filesystems.  All of the current filesystems with
> FS_USERNS_MOUNT set are safe.
>
> I confirmed that this is compatible with Sandstorm's revision
> 1bf0c4847b.  That revision of Sandstorm does not work without this
> fix if 9566d6742852 is applied.
>
> Cc: Kenton Varda <kenton@sandstorm.io>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  fs/namespace.c   | 16 ++++++++++++----
>  fs/proc/root.c   |  2 +-
>  fs/ramfs/inode.c |  2 +-
>  fs/sysfs/mount.c |  2 +-
>  ipc/mqueue.c     |  2 +-
>  mm/shmem.c       |  4 ++--
>  6 files changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 0acabea58319..835fa9e8307e 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2154,12 +2154,20 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
>                         put_filesystem(type);
>                         return -EPERM;
>                 }
> -               /* Only in special cases allow devices from mounts
> -                * created outside the initial user namespace.
> +
> +               /*
> +                * If a filesystem might allow the mounter to put
> +                * device nodes on it without the checks in mknod,
> +                * then require MS_NODEV to mount it.
>                  */
>                 if (!(type->fs_flags & FS_USERNS_DEV_MOUNT)) {
> -                       flags |= MS_NODEV;
> -                       mnt_flags |= MNT_NODEV | MNT_LOCK_NODEV;
> +                       if (!(mnt_flags & MNT_NODEV)) {
> +                               put_filesystem(type);
> +                               return -EPERM;
> +                       }
> +
> +                       /* Do not allow nodev to be cleared. */
> +                       mnt_flags |= MNT_LOCK_NODEV;
>                 }
>         }
>
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 094e44d4a6be..2313b280729e 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -159,7 +159,7 @@ static struct file_system_type proc_fs_type = {
>         .name           = "proc",
>         .mount          = proc_mount,
>         .kill_sb        = proc_kill_sb,
> -       .fs_flags       = FS_USERNS_MOUNT,
> +       .fs_flags       = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
>  };
>
>  void __init proc_root_init(void)
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index d365b1c4eb3c..b95b7302d4cc 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -261,7 +261,7 @@ static struct file_system_type ramfs_fs_type = {
>         .name           = "ramfs",
>         .mount          = ramfs_mount,
>         .kill_sb        = ramfs_kill_sb,
> -       .fs_flags       = FS_USERNS_MOUNT,
> +       .fs_flags       = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
>  };
>
>  int __init init_ramfs_fs(void)
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 8a49486bf30c..56ba59317e24 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -58,7 +58,7 @@ static struct file_system_type sysfs_fs_type = {
>         .name           = "sysfs",
>         .mount          = sysfs_mount,
>         .kill_sb        = sysfs_kill_sb,
> -       .fs_flags       = FS_USERNS_MOUNT,
> +       .fs_flags       = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
>  };
>
>  int __init sysfs_init(void)
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 4fcf39af1776..56abbc848d4c 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -1394,7 +1394,7 @@ static struct file_system_type mqueue_fs_type = {
>         .name = "mqueue",
>         .mount = mqueue_mount,
>         .kill_sb = kill_litter_super,
> -       .fs_flags = FS_USERNS_MOUNT,
> +       .fs_flags = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
>  };
>
>  int mq_init_ns(struct ipc_namespace *ns)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a42add14331c..f4a708a8f9e3 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3149,7 +3149,7 @@ static struct file_system_type shmem_fs_type = {
>         .name           = "tmpfs",
>         .mount          = shmem_mount,
>         .kill_sb        = kill_litter_super,
> -       .fs_flags       = FS_USERNS_MOUNT,
> +       .fs_flags       = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
>  };
>
>  int __init shmem_init(void)
> @@ -3208,7 +3208,7 @@ static struct file_system_type shmem_fs_type = {
>         .name           = "tmpfs",
>         .mount          = ramfs_mount,
>         .kill_sb        = kill_litter_super,
> -       .fs_flags       = FS_USERNS_MOUNT,
> +       .fs_flags       = FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
>  };
>
>  int __init shmem_init(void)
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
