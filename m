Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3CDUbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:31:18 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:49013 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab3CDUbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:31:17 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] drbd: add module_put() on error path in drbd_proc_open()
Date: Mon, 04 Mar 2013 21:31:09 +0100
Message-ID: <9738633.yZ4agRkgQF@quad>
User-Agent: KMail/4.8.5 (Linux/3.2.0-35-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1362173982-26454-1-git-send-email-khoroshilov@ispras.ru>
References: <1362173982-26454-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

Thanks a lot! I have put it into our tree.
http://git.drbd.org/gitweb.cgi?p=drbd-8.4.git

I intend to get it into the 3.10 merge window.

Best,
 Phil

> If single_open() fails in drbd_proc_open(), module refcount is left
> incremented. The patch adds module_put() on the error path.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/block/drbd/drbd_proc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
> index 56672a6..30fe0a5 100644
> --- a/drivers/block/drbd/drbd_proc.c
> +++ b/drivers/block/drbd/drbd_proc.c
> @@ -313,8 +313,14 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
> 
>  static int drbd_proc_open(struct inode *inode, struct file *file)
>  {
> -	if (try_module_get(THIS_MODULE))
> -		return single_open(file, drbd_seq_show, PDE(inode)->data);
> +	int err;
> +
> +	if (try_module_get(THIS_MODULE)) {
> +		err = single_open(file, drbd_seq_show, PDE(inode)->data);
> +		if (err)
> +			module_put(THIS_MODULE);
> +		return err;
> +	}
>  	return -ENODEV;
>  }
