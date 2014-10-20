Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaJTAfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:35:46 -0400
Received: from ozlabs.org ([103.22.144.67]:40694 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaJTAen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:34:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Martin Kepplinger <martink@posteo.de>
Cc: lguest@lists.ozlabs.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lguest: lguest_user.c is open() called by the user?
In-Reply-To: <54430160.6020503@posteo.de>
References: <54430160.6020503@posteo.de>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Oct 2014 11:02:08 +1030
Message-ID: <87vbnf8ttj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Kepplinger <martink@posteo.de> writes:
> hi
>
> Just a question for understanding: open() is not implemented in
> lguest_user.c's miscdevice. The miscdevice core, in this case, does
> _not_ set file->private_data on a user's open() call. Is open() called
> by the user here? and do you here _depend_ on file->private_data being
> NULL after open()? (could you even?)
>
> Would the following force to NULL be necessary if the miscdevice core
> _would_ set private_data?

Hi Martin!

        Yes, the private_data is NULL on a new file.  See
get_empty_filp in fs/file_table.c, which does kmem_cache_zalloc
(zeroing all the contents).

So this isn't necessary here.

Thanks!
Rusty.

> diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
> index 4263f4c..3d472ea 100644
> --- a/drivers/lguest/lguest_user.c
> +++ b/drivers/lguest/lguest_user.c
> @@ -497,6 +497,12 @@ static int close(struct inode *inode, struct file
> *file)
>         return 0;
>  }
>
> +static int open(struct inode *inode, struct file *file)
> +{
> +       /* assuming the miscdevice core sets private_data on open() */
> +       file->private_data = NULL;
> +}
> +
>  /*L:000
>   * Welcome to our journey through the Launcher!
>   *
> @@ -514,6 +520,7 @@ static int close(struct inode *inode, struct file *file)
>   */
>  static const struct file_operations lguest_fops = {
>         .owner   = THIS_MODULE,
> +       .open    = open,
>         .release = close,
>         .write   = write,
>         .read    = read,
> -- 
>
> thanks
>                                martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
