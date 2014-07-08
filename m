Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaGHH6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:58:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:53692 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaGHH6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:58:46 -0400
Date: Tue, 8 Jul 2014 00:58:43 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: f2fs: Add f2fs_balance_fs for direct IO
Message-ID: <20140708075843.GA59558@jmac>
References: <1404711988-18264-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404711988-18264-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

It occurs a merge conflict.
Please check the patch.

Anyway, IMO, it needs to place f2fs_balance_fs somewhere in get_data_block.

Thanks,

On Mon, Jul 07, 2014 at 01:46:28PM +0800, Huang Ying wrote:
> Otherwise, if a large amount of direct IO writes were done, the
> segment allocation may be failed because no enough segments are gced.
> 
> Signed-off-by: Huang, Ying <ying.huang@intel.com>
> ---
>  fs/f2fs/data.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -1038,6 +1038,7 @@ static ssize_t f2fs_direct_IO(int rw, st
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file->f_mapping->host;
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  
>  	/* Let buffer I/O handle the inline data case. */
>  	if (f2fs_has_inline_data(inode))
> @@ -1046,8 +1047,11 @@ static ssize_t f2fs_direct_IO(int rw, st
>  	if (check_direct_IO(inode, rw, iter, offset))
>  		return 0;
>  
> +	if (rw == WRITE)
> +		f2fs_balance_fs(sbi);
> +
>  	/* clear fsync mark to recover these blocks */
> -	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
> +	fsync_mark_clear(sbi, inode->i_ino);
>  
>  	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
>  				  get_data_block);

-- 
Jaegeuk Kim
