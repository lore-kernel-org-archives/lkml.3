Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaKMJkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:40:41 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63129 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaKMJkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:40:39 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1415809894-24084-1-git-send-email-martink@posteo.de>
References: <20141112112643.GA30821@ulmo.nvidia.com>
	<1415809894-24084-1-git-send-email-martink@posteo.de>
Date: Thu, 13 Nov 2014 10:40:38 +0100
Message-ID: <CAJfpegt2Xz0tGUygpN4eyb3g8EsFNWomsUUOmGBMj03ocOPVng@mail.gmail.com>
Subject: Re: [PATCH] fuse: don't check for file->private_data on open().
From: Miklos Szeredi <miklos@szeredi.hu>
To: Martin Kepplinger <martink@posteo.de>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, thierry.reding@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        giedriuswork@gmail.com,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 5:31 PM, Martin Kepplinger <martink@posteo.de> wrote:
> The miscdevice core now sets file->private_data to the struct miscdevice
> so don't fail when this is not NULL.

Does it?  Look:

static int misc_open(struct inode * inode, struct file * file)
{
    ...
    if (file->f_op->open) {
        file->private_data = c;
        err = file->f_op->open(inode,file);
    }

It only sets ->private_data if the device provides an open method.
Fuse doesn't, so it's not clear what this patch is trying to fix.

Thanks,
Miklos


>
> Reported-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This is a question: what does this check provide and does overwriting
> file->private_data make any difference?
>
> Is open() by the user not allowed here, if file->private_data is set?
>
> thanks!!
>
>  fs/fuse/inode.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 03246cd..562407e 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1092,9 +1092,6 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
>         }
>
>         mutex_lock(&fuse_mutex);
> -       err = -EINVAL;
> -       if (file->private_data)
> -               goto err_unlock;
>
>         err = fuse_ctl_add_conn(fc);
>         if (err)
> --
> 1.7.10.4
>
