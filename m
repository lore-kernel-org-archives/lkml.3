Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3LKWgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:36:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3LKWgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:36:42 -0500
Date: Wed, 11 Dec 2013 23:36:35 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: clear close-on-exec flag as part of put_unused_fd()
Message-ID: <20131211223634.GA13828@mguzik.redhat.com>
References: <1386796107-4197-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386796107-4197-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:08:27PM +0100, Yann Droneaud wrote:
> close-on-exec flag is set by get_unused_fd_flags(), it makes
> sense to clear it in the opposite function, eg. put_unused_fd().
> 
> Additionally, since the close_on_exec bit array is always initialized
> to 0, it can be safely assumed that any newly allocated file descriptor
> has close-on-exec flag not set, so there's no need to clear it
> explicitly.
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>  fs/file.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 4a78f981557a..e98f5a5b1050 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -500,8 +500,6 @@ repeat:
>  	__set_open_fd(fd, fdt);
>  	if (flags & O_CLOEXEC)
>  		__set_close_on_exec(fd, fdt);
> -	else
> -		__clear_close_on_exec(fd, fdt);
>  	error = fd;
>  #if 1
>  	/* Sanity check */
> @@ -530,6 +528,7 @@ EXPORT_SYMBOL(get_unused_fd_flags);
>  static void __put_unused_fd(struct files_struct *files, unsigned int fd)
>  {
>  	struct fdtable *fdt = files_fdtable(files);
> +	__clear_close_on_exec(fd, fdt);
>  	__clear_open_fd(fd, fdt);
>  	if (fd < files->next_fd)
>  		files->next_fd = fd;
> @@ -599,7 +598,6 @@ int __close_fd(struct files_struct *files, unsigned fd)
>  	if (!file)
>  		goto out_unlock;
>  	rcu_assign_pointer(fdt->fd[fd], NULL);
> -	__clear_close_on_exec(fd, fdt);
>  	__put_unused_fd(files, fd);
>  	spin_unlock(&files->file_lock);
>  	return filp_close(file, files);
> @@ -625,7 +623,6 @@ void do_close_on_exec(struct files_struct *files)
>  		set = fdt->close_on_exec[i];
>  		if (!set)
>  			continue;
> -		fdt->close_on_exec[i] = 0;
>  		for ( ; set ; fd++, set >>= 1) {
>  			struct file *file;
>  			if (!(set & 1))
> @@ -806,8 +803,6 @@ static int do_dup2(struct files_struct *files,
>  	__set_open_fd(fd, fdt);
>  	if (flags & O_CLOEXEC)
>  		__set_close_on_exec(fd, fdt);
> -	else
> -		__clear_close_on_exec(fd, fdt);
>  	spin_unlock(&files->file_lock);
>  
>  	if (tofree)

>From my reading this will break at least the following:
fd = open(..., .. | O_CLOEXEC);
dup2(whatever, fd);

now fd has O_CLOEXEC even though it should not

-- 
Mateusz Guzik
