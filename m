Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3DZMGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:06:47 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52406 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab3DZMGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:06:43 -0400
Date: Fri, 26 Apr 2013 06:06:40 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        codalist@TELEMANN.coda.cs.cmu.edu, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] fsfreeze: added new file_start_write_killable
Message-ID: <20130426120640.GA20612@parisc-linux.org>
References: <517A3FEC.7010709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517A3FEC.7010709@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:50:52AM +0200, Marco Stornelli wrote:
> Replace file_start_write with file_start_write_killable where
> possible.

I feel like I'm missing context here.  Possibly because you only cc'd me
on patch 2/4.  In particular, file_start_write doesn't exist upstream,
so I'm not sure what it's for.  But returning 1 for non-regular files
looks dodgy:

> +static inline int file_start_write_killable(struct file *file)
> +{
> +	if (!S_ISREG(file_inode(file)->i_mode))
> +		return 1;
> +	return sb_start_write_killable(file_inode(file)->i_sb);
> +}

> +++ b/fs/aio.c
> @@ -1103,8 +1103,11 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb, int rw, aio_rw_op *rw_op)
>  	if (iocb->ki_pos < 0)
>  		return -EINVAL;
>  
> -	if (rw == WRITE)
> -		file_start_write(file);
> +	if (rw == WRITE) {
> +		ret = file_start_write_killable(file);
> +		if (ret < 0)
> +			return ret;
> +	}
>  	do {

So ... it's OK to do this write to pipes/directories/devices/... ?  Or is
that check always taken care of elsewhere?  If so, why do we need this
check?  I'm confused.  None of the callers check for the 'ret == 1' case,
so I'm sure there's something wrong here, I just can't tell what it is.

> +++ b/fs/read_write.c
> @@ -438,17 +438,19 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
>  	ret = rw_verify_area(WRITE, file, pos, count);
>  	if (ret >= 0) {
>  		count = ret;
> -		file_start_write(file);
> -		if (file->f_op->write)
> -			ret = file->f_op->write(file, buf, count, pos);
> -		else
> -			ret = do_sync_write(file, buf, count, pos);
> +		ret = file_start_write_killable(file);
>  		if (ret > 0) {
> -			fsnotify_modify(file);
> -			add_wchar(current, ret);
> +			if (file->f_op->write)
> +				ret = file->f_op->write(file, buf, count, pos);
> +			else
> +				ret = do_sync_write(file, buf, count, pos);
> +			if (ret > 0) {
> +				fsnotify_modify(file);
> +				add_wchar(current, ret);
> +			}
> +			inc_syscw(current);
> +			file_end_write(file);
>  		}
> -		inc_syscw(current);
> -		file_end_write(file);
>  	}
>  
>  	return ret;

I don't like it that you've increased the indentation here.  Better to do
a preliminary patch which just converts to our normal style with gotos.  ie:

- 	if (ret >= 0) {
- 		count = ret;
-		file_start_write(file);
-		if (file->f_op->write)
-			ret = file->f_op->write(file, buf, count, pos);
-		else
-			ret = do_sync_write(file, buf, count, pos);
- 		if (ret > 0) {
-			fsnotify_modify(file);
-			add_wchar(current, ret);
- 		}
-		inc_syscw(current);
-		file_end_write(file);
+	if (ret < 0)
+		goto out;
+	count = ret;
+	file_start_write(file);
+	if (file->f_op->write)
+		ret = file->f_op->write(file, buf, count, pos);
+	else
+		ret = do_sync_write(file, buf, count, pos);
+	if (ret > 0) {
+		fsnotify_modify(file);
+		add_wchar(current, ret);
 	}
+	inc_syscw(current);
+	file_end_write(file);
+ out: 
 	return ret;

and then this patch would just add another if ... goto out case.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
