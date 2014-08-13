Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaHMKcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:32:21 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:50907 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaHMKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:32:19 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140603114827.3188.35705.stgit@localhost.localdomain>
References: <20140603114827.3188.35705.stgit@localhost.localdomain>
Date: Wed, 13 Aug 2014 12:32:18 +0200
Message-ID: <CAJfpegsee+n14g6JoLOxq5DKy_9cptWR200W1aH3vr65wjZjqQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: do not evict dirty inodes
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 1:49 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
> Commit 1e18bda8 added .write_inode method to the fuse super_operations. This
> allowed fuse to use the kernel infrastructure for writing out dirty metadata
> (mtime and ctime for now). However, given that .drop_inode was not redefined
> from the legacy generic_delete_inode(), on umount(2) generic_shutdown_super()
> led to the eviction of all inodes disregarding their state.
>
> The patch removes .drop_inode definition from the fuse super_operations. This
> works because now iput_final() calls generic_drop_inode() and returns w/o
> evicting inode. This, in turn, allows generic_shutdown_super() to write dirty
> inodes by calling sync_filesystem().
>
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> ---
>  fs/fuse/inode.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 754dcf2..ee017be 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -791,7 +791,6 @@ static const struct super_operations fuse_super_operations = {
>         .destroy_inode  = fuse_destroy_inode,
>         .evict_inode    = fuse_evict_inode,
>         .write_inode    = fuse_write_inode,
> -       .drop_inode     = generic_delete_inode,
>         .remount_fs     = fuse_remount_fs,
>         .put_super      = fuse_put_super,
>         .umount_begin   = fuse_umount_begin,
>

(Sorry about the late answer)

Big problem with this is that I don't want to make umount(2) and
sync(2) wait on userspace filesystem.  Generally this would make
umount() hang if a fuse daemon was stuck for any reason.

But is this really necessary?

We are talking about just regular files: mtime is only updated by
write(2) and friends. ctime is updated by write(2) as well as some
other ops.  For write, we can sync the times on FLUSH (close), for
other ops we could flush the ctime synchronously.  E.g. unlink would
trigger UNLINK and SETATTR.

Long term, much better solution would be to add a timestamp to
fuse_in_header which would remove the duplicate requests and then we
could also extend the kernel caching of timestamps from just regular
files to everything, which would make the protocol conceptually
simpler.

Thanks,
Miklos
