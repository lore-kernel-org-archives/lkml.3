Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaGJLL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:11:59 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:58062 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaGJLL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:11:57 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140710093101.21765.96636.stgit@localhost.localdomain>
References: <20140710093101.21765.96636.stgit@localhost.localdomain>
Date: Thu, 10 Jul 2014 13:11:56 +0200
Message-ID: <CAJfpegutNSn-z2P754L-C_K1Ly_19ERw6ccpPpepAYRtANX9_w@mail.gmail.com>
Subject: Re: [PATCH] fuse: remove WARN_ON writeback on dead inode
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:32 AM, Maxim Patlasov
<MPatlasov@parallels.com> wrote:
> FUSE has an architectural peculiarity: it cannot write to an inode, unless it
> has an associated file open for write. Since the beginning (Apr 30 2008, commit
> 3be5a52b), FUSE BUG_ON (later WARN_ON) the case when it has to process
> writeback, but all associated files are closed. The latest relevant commit is
> 72523425:
>
>>   Don't bug if there's no writable files found for page writeback.  If ever
>>   this is triggered, a WARN_ON helps debugging it much better then a BUG_ON.
>>
>>   Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>
> But that situation can happen in quite a legal way: for example, let's mmap a
> file, then issue O_DIRECT read to mmapped region and immediately close file
> and munmap. O_DIRECT will pin some pages, execute IO to them and then mark
> pages dirty. Here we are.

Something's not right. Fuse assumes that the file can only be modified
if there's at least one open file for read-write, otherwise  the page
can't be written back, resulting in fs corruption.

The VFS also assumes in the read-only remount code that if no files
are open for write then the filesystem can safely be remounted
read-only and no modifications can occur after that.

The situation you describe above contradict those assumptions.

Removing the warning only makes the problem worse, since now the
corruption will happen silently.

CC-ing linux-fsdevel and linux-mm.  Anyone has a better insight into this?

Thanks,
Miklos




>
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---
>  fs/fuse/file.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 6e16dad..3a47aa2 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1624,8 +1624,8 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
>         fuse_writepage_free(fc, req);
>  }
>
> -static struct fuse_file *__fuse_write_file_get(struct fuse_conn *fc,
> -                                              struct fuse_inode *fi)
> +static struct fuse_file *fuse_write_file_get(struct fuse_conn *fc,
> +                                            struct fuse_inode *fi)
>  {
>         struct fuse_file *ff = NULL;
>
> @@ -1640,14 +1640,6 @@ static struct fuse_file *__fuse_write_file_get(struct fuse_conn *fc,
>         return ff;
>  }
>
> -static struct fuse_file *fuse_write_file_get(struct fuse_conn *fc,
> -                                            struct fuse_inode *fi)
> -{
> -       struct fuse_file *ff = __fuse_write_file_get(fc, fi);
> -       WARN_ON(!ff);
> -       return ff;
> -}
> -
>  int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
>  {
>         struct fuse_conn *fc = get_fuse_conn(inode);
> @@ -1655,7 +1647,7 @@ int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
>         struct fuse_file *ff;
>         int err;
>
> -       ff = __fuse_write_file_get(fc, fi);
> +       ff = fuse_write_file_get(fc, fi);
>         err = fuse_flush_times(inode, ff);
>         if (ff)
>                 fuse_file_put(ff, 0);
>
