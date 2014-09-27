Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaI0GdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:33:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaI0GdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:33:14 -0400
Date: Fri, 26 Sep 2014 23:33:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] shmem: fix nlink for rename overwrite directory
Message-ID: <20140927063311.GA8006@infradead.org>
References: <20140924155617.GD7441@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924155617.GD7441@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 05:56:17PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If overwriting an empty directory with rename, then need to drop the extra
> nlink.
> 
> Test prog:

Can you send a patch to wire this up for xfstests?

> 
> #include <stdio.h>
> #include <fcntl.h>
> #include <err.h>
> #include <sys/stat.h>
> 
> int main(void)
> {
> 	const char *test_dir1 = "test-dir1";
> 	const char *test_dir2 = "test-dir2";
> 	int res;
> 	int fd;
> 	struct stat statbuf;
> 
> 	res = mkdir(test_dir1, 0777);
> 	if (res == -1)
> 		err(1, "mkdir(\"%s\")", test_dir1);
> 
> 	res = mkdir(test_dir2, 0777);
> 	if (res == -1)
> 		err(1, "mkdir(\"%s\")", test_dir2);
> 
> 	fd = open(test_dir2, O_RDONLY);
> 	if (fd == -1)
> 		err(1, "open(\"%s\")", test_dir2);
> 
> 	res = rename(test_dir1, test_dir2);
> 	if (res == -1)
> 		err(1, "rename(\"%s\", \"%s\")", test_dir1, test_dir2);
> 
> 	res = fstat(fd, &statbuf);
> 	if (res == -1)
> 		err(1, "fstat(%i)", fd);
> 
> 	if (statbuf.st_nlink != 0) {
> 		fprintf(stderr, "nlink is %lu, should be 0\n", statbuf.st_nlink);
> 		return 1;
> 	}
> 
> 	return 0;
> }
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: stable@vger.kernel.org
> ---
>  mm/shmem.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2367,8 +2367,10 @@ static int shmem_rename2(struct inode *o
>  
>  	if (new_dentry->d_inode) {
>  		(void) shmem_unlink(new_dir, new_dentry);
> -		if (they_are_dirs)
> +		if (they_are_dirs) {
> +			drop_nlink(new_dentry->d_inode);
>  			drop_nlink(old_dir);
> +		}
>  	} else if (they_are_dirs) {
>  		drop_nlink(old_dir);
>  		inc_nlink(new_dir);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
