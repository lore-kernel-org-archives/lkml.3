Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbaJINww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:52:52 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:62140 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJINwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:52:41 -0400
Date: Thu, 9 Oct 2014 09:52:37 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/2] sysfs/kernfs: make read requests on pre-alloc files
 use the buffer.
Message-ID: <20141009135237.GD14387@htj.dyndns.org>
References: <20141008234119.19126.4182.stgit@notabene.brown>
 <20141008235706.19126.82634.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008235706.19126.82634.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 10:57:06AM +1100, NeilBrown wrote:
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
> As seq_read() does not use the prealloc buffer, ->seq_show is
> incompatible with ->prealloc and caused an EINVAL return from open().
> sysfs code which calls into kernfs always chooses the correct function.
> 
> As the buffer is shared with writes and other reads, the mutex is
> extended to cover the copy_to_user.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Tejun Heo <tj@kernel.org>

Some nitpicks.

> @@ -690,6 +694,12 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
>  	 */
>  	of->atomic_write_len = ops->atomic_write_len;
>  
> +	error = -EINVAL;
> +	if (ops->prealloc && ops->seq_show)
> +		/* ->seq_show is incompatible with ->prealloc,
> +		 * ->read must be used instead.
> +		 */
> +		goto err_free;

Let's please use fully-winged comments.  If it looks weird inside the
if block, it can just be located right on top, I think.  Also,
wouldn't it be better if the comment explained the reason for the
incompatibility?  Along the same line, I think it'd be better if this
is also explicitly explained where ->prealloc is defined.

> +/* kernfs read callback for regular sysfs files with pre-alloc */
> +static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
> +                            size_t count, loff_t pos)
> +{
> +       const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
> +       struct kobject *kobj = of->kn->parent->priv;
> +
> +       if (pos || buf != of->prealloc_buf)
> +	       /* If buf != of->prealloc_buf, we don't know how
> +		* large it is, so cannot safely pass it to ->show
> +		*/
> +               return 0;
> +       return ops->show(kobj, of->kn->priv, buf);
> +}

Ditto on the comment formatting also shouldn't the latter condition be
a WARN_ON_ONCE()?

Thanks.

-- 
tejun
