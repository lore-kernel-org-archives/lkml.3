Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaHBOlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 10:41:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:42729 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbaHBOly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 10:41:54 -0400
Date: Sat, 2 Aug 2014 07:42:23 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: invalidate xattr node page when
 evict inode
Message-ID: <20140802144223.GA1094@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <017301cfacc1$4b476730$e1d63590$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017301cfacc1$4b476730$e1d63590$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Thu, Jul 31, 2014 at 09:13:11PM +0800, Chao Yu wrote:
> When inode is evicted, all the page cache belong to this inode should be
> released including the xattr node page. But previously we didn't do this, this
> patch fixed this issue.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index 0e69aa9..8a5403b 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -267,10 +267,16 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
>  void f2fs_evict_inode(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +	struct f2fs_inode_info *fi = F2FS_I(inode);
>  
>  	trace_f2fs_evict_inode(inode);
> +
>  	truncate_inode_pages_final(&inode->i_data);
>  
> +	if (fi->i_xattr_nid)
> +		invalidate_mapping_pages(NODE_MAPPING(sbi),
> +					fi->i_xattr_nid, fi->i_xattr_nid);

It would be good to place this below with invalidate_mapping_paages(ino).
Since, in the case of deletion, we need to get the xattr node page again
on the remove_inode_page call path.

Thanks,

> +
>  	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
>  			inode->i_ino == F2FS_META_INO(sbi))
>  		goto out_clear;
> -- 
> 2.0.1.474.g72c7794
