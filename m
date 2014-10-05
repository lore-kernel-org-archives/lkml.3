Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaJET47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:56:59 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:57670 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaJET46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:56:58 -0400
Date: Sun, 5 Oct 2014 15:56:55 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] sysfs - allow attributes to request write buffer be
 pre-allocated.
Message-ID: <20141005195655.GI8549@htj.dyndns.org>
References: <20140930022205.13407.99210.stgit@notabene.brown>
 <20140930023334.13407.83407.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930023334.13407.83407.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Generally looks good to me.  Some nitpicks follow.

On Tue, Sep 30, 2014 at 12:33:34PM +1000, NeilBrown wrote:
...
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 4429d6d9217f..73bd5ed143cd 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -278,16 +278,12 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
>  		len = min_t(size_t, count, PAGE_SIZE);
>  	}
>  
> -	buf = kmalloc(len + 1, GFP_KERNEL);
> +	buf = of->buf;
> +	if (!buf)
> +		buf = kmalloc(len + 1, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	if (copy_from_user(buf, user_buf, len)) {
> -		len = -EFAULT;
> -		goto out_free;
> -	}
> -	buf[len] = '\0';	/* guarantee string termination */
> -
>  	/*
>  	 * @of->mutex nests outside active ref and is just to ensure that
>  	 * the ops aren't called concurrently for the same open file.

We probably should update the above comment.

> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 30faf797c2c3..07c326761671 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -179,6 +179,7 @@ struct kernfs_open_file {
>  	struct mutex		mutex;
>  	int			event;
>  	struct list_head	list;
> +	char			*buf;

Maybe something like ->prealloc_buf is better?

Thanks.

-- 
tejun
