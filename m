Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaJEUCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:02:22 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36955 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaJEUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:02:21 -0400
Date: Sun, 5 Oct 2014 16:02:18 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/2] sysfs/kernfs: make read requests on pre-alloc files
 use the buffer.
Message-ID: <20141005200218.GJ8549@htj.dyndns.org>
References: <20140930022205.13407.99210.stgit@notabene.brown>
 <20140930023334.13407.61093.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930023334.13407.61093.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:33:34PM +1000, NeilBrown wrote:
> To match the previous patch which used the pre-alloc buffer for
> writes, this patch causes reads to use the same buffer.
> This is not strictly necessary as the current seq_read() will allocate
> on first read, so user-space can trigger the required pre-alloc.  But
> consistency is valuable.
> 
> The read function is somewhat simpler than seq_read() and, for example,
> does not support reading from an offset into the file: reads must be
> at the start of the file.
> 
> As the buffer is shared with writes and other reads, the mutex is
> extended to cover the copy_to_user.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  fs/kernfs/file.c |   17 ++++++++++-------
>  fs/sysfs/file.c  |   28 ++++++++++++++++++++++++----
>  2 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 73bd5ed143cd..7072240604f5 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -189,7 +189,9 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
>  	const struct kernfs_ops *ops;
>  	char *buf;
>  
> -	buf = kmalloc(len, GFP_KERNEL);
> +	buf = of->buf;
> +	if (!buf)
> +		buf = kmalloc(len, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> @@ -210,21 +212,22 @@ static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
>  	else
>  		len = -EINVAL;
>  
> -	kernfs_put_active(of->kn);
> -	mutex_unlock(&of->mutex);
> -
>  	if (len < 0)
> -		goto out_free;
> +		goto out_unlock;
>  
>  	if (copy_to_user(user_buf, buf, len)) {
>  		len = -EFAULT;
> -		goto out_free;
> +		goto out_unlock;
>  	}
>  
>  	*ppos += len;
>  
> + out_unlock:
> +	kernfs_put_active(of->kn);
> +	mutex_unlock(&of->mutex);
>   out_free:
> -	kfree(buf);
> +	if (buf != of->buf)
> +		kfree(buf);
>  	return len;
>  }

Can you please also make kernfs reject ->seq_show() if .prealloc is
being used?

> +/* kernfs read callback for regular sysfs files with pre-alloc */
> +static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
> +                            size_t count, loff_t pos)
> +{
> +       const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
> +       struct kobject *kobj = of->kn->parent->priv;
> +
> +       if (pos)
> +               return 0;
> +       return ops->show(kobj, of->kn->priv, buf);

Shouldn't it also memset?

Thanks.

-- 
tejun
