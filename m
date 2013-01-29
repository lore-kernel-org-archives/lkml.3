Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3A2W64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:58:56 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:40365 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3A2W6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:58:51 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130125182407.10037.26333.stgit@maximpc.sw.ru>
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru>
	<20130125182407.10037.26333.stgit@maximpc.sw.ru>
Date: Tue, 29 Jan 2013 23:58:51 +0100
Message-ID: <CAJfpegs85D9GM285gaO-49t7gJQBh9ZgMviXS-AOkp4z9k-6uA@mail.gmail.com>
Subject: Re: [PATCH 08/14] fuse: Flush files on wb close
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 7:24 PM, Maxim V. Patlasov
<MPatlasov@parallels.com> wrote:
> Any write request requires a file handle to report to the userspace. Thus
> when we close a file (and free the fuse_file with this info) we have to
> flush all the outstanding writeback cache. Note, that simply calling the
> filemap_write_and_wait() is not enough since fuse finishes page writeback
> immediately and thus the -wait part of the mentioned call will be no-op.
> Do real wait on per-inode writepages list.
>
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> ---
>  fs/fuse/file.c |   26 +++++++++++++++++++++++++-
>  1 files changed, 25 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 4f8fa45..496e74c 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -138,6 +138,12 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
>         }
>  }
>
> +static void __fuse_file_put(struct fuse_file *ff)
> +{
> +       if (atomic_dec_and_test(&ff->count))
> +               BUG();
> +}
> +
>  int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
>                  bool isdir)
>  {
> @@ -286,8 +292,23 @@ static int fuse_open(struct inode *inode, struct file *file)
>         return fuse_open_common(inode, file, false);
>  }
>
> +static void fuse_flush_writeback(struct inode *inode, struct file *file)
> +{
> +       struct fuse_conn *fc = get_fuse_conn(inode);
> +       struct fuse_inode *fi = get_fuse_inode(inode);
> +
> +       filemap_write_and_wait(file->f_mapping);
> +       wait_event(fi->page_waitq, list_empty_careful(&fi->writepages));
> +       spin_unlock_wait(&fc->lock);
> +}
> +
>  static int fuse_release(struct inode *inode, struct file *file)
>  {
> +       struct fuse_conn *fc = get_fuse_conn(inode);
> +
> +       if (fc->writeback_cache)
> +               fuse_flush_writeback(inode, file);
> +
>         fuse_release_common(file, FUSE_RELEASE);
>
>         /* return value is ignored by VFS */
> @@ -1343,7 +1364,8 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
>
>         for (i = 0; i < req->num_pages; i++)
>                 __free_page(req->pages[i]);
> -       fuse_file_put(req->ff, false);
> +       if (!fc->writeback_cache)
> +               fuse_file_put(req->ff, false);
>  }
>
>  static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
> @@ -1360,6 +1382,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
>         }
>         bdi_writeout_inc(bdi);
>         wake_up(&fi->page_waitq);
> +       if (fc->writeback_cache)
> +               __fuse_file_put(req->ff);
>  }

I don't see how this belongs in this patch.  And I suspect this can be
done unconditionally (for the non-writeback-cache case as well), but
please move it into a separate patch.

Thanks,
Miklos
