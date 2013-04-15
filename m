Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936132Ab3DPQg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935909Ab3DPQgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:24 -0400
Date: Mon, 15 Apr 2013 14:00:02 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] fsfreeze: use sb_start_write_killable instead of
 sb_start_write
Message-ID: <20130415120002.GD2299@quack.suse.cz>
References: <5169359A.4090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5169359A.4090709@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 13-04-13 12:38:18, Marco Stornelli wrote:
> Replace sb_start_write with sb_start_write_killable where
> possible.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/open.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 8c74100..d621d76 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -182,7 +182,9 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
>  	if (IS_APPEND(inode))
>  		goto out_putf;
>  
> -	sb_start_write(inode->i_sb);
> +	error = sb_start_write_killable(inode->i_sb);
> +	if (error < 0)
> +		return error;
>  	error = locks_verify_truncate(inode, f.file, length);
>  	if (!error)
>  		error = security_path_truncate(&f.file->f_path);
> @@ -273,7 +275,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (!file->f_op->fallocate)
>  		return -EOPNOTSUPP;
>  
> -	sb_start_write(inode->i_sb);
> +	ret = sb_start_write_killable(inode->i_sb);
> +	if (ret < 0)
> +		return ret;
>  	ret = file->f_op->fallocate(file, mode, offset, len);
>  	sb_end_write(inode->i_sb);
>  	return ret;
> -- 
> 1.7.3.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
