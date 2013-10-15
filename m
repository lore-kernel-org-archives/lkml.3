Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3JONqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:46:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3JONqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:46:06 -0400
Date: Tue, 15 Oct 2013 15:46:04 +0200
From: Jan Kara <jack@suse.cz>
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@zeniv.linux.org.uk>, jbacik <jbacik@fusionio.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] inode: For readonly filesystem, func file_update_time
 should return -EROFS rather than zero.
Message-ID: <20131015134604.GF12428@quack.suse.cz>
References: <201310151125581359520@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310151125581359520@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-10-13 11:26:00, majianpeng wrote:
> For ext2 mounted with errors=remount-ro, if write a file and because the
> harddisk error, the fs became ro.But the following test can't return.
> 
> int main()
> {
> 	int ret;
> 	int i = 0;
> 	char buff[SIZE];
> 	int fd = open("/opt/test", O_WRONLY|O_TRUNC|O_CREAT);
> 
> 	if (fd < 0) {
> 		printf("open error %s\n", strerror(errno));
> 		return errno;
> 	}
> 
> 	ret = write(fd, buff, SIZE);
> 	lseek(fd, 0, 0);
> 
> 	while (1) {
> 		ret = write(fd, buff, SIZE);
> 		if (ret < 0) {
> 			printf("write error %s\n", strerror(errno));
> 			break;
> 		}
> 		lseek(fd, 0, 0);
> 		i++;
> 	}
> 	printf("write count=%d\n", i);
> 	close(fd);
> 
> 	return 0;
> }
> 
> For ext3/ext4, because jbd the test can return. But for ext2, because no
> jbd and not reading bitmap from harddisk, the test continue.
> 
> So we should add check readonly-fs on write-path. Func file_update_time
> already check the readonly flag,but it can't return -EROFS.
> For readonly-fs, it can't update a/c/m time of file,it should return
> -EROFS rather than zero.
  The patch looks good to me so feel free to add
Reviewed-by: Jan Kara <jack@suse.cz>
  Just the reasoning in the changelog doesn't look completely correct - we
are free to succeed doing write to a FMODE_WRITE file descriptor even if
the filesystem below it decided to declare game over and switched itself to
read-only mode. It is actually ext2/3/4 which is problematic - its
switching to read-only mode is rather hacky as we cannot really do it
properly from the arbitrary context in which we handle errors. It's not
VFS' fault it doesn't notice the switching...

								Honza

> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index b33ba8e..65302c1 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1644,8 +1644,9 @@ int file_update_time(struct file *file)
>  		return 0;
>  
>  	/* Finally allowed to write? Takes lock. */
> -	if (__mnt_want_write_file(file))
> -		return 0;
> +	ret = __mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
>  
>  	ret = update_time(inode, &now, sync_it);
>  	__mnt_drop_write_file(file);
> -- 
> 1.8.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
