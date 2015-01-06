Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbbAFTcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:32:31 -0500
Received: from mail.kernel.org ([198.145.29.136]:44679 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbbAFTc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:32:28 -0500
Date: Tue, 6 Jan 2015 11:32:22 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 1/2] f2fs: get rid of kzalloc in
 __recover_inline_status
Message-ID: <20150106193222.GA54001@jaegeuk-mac02>
References: <009301d0297a$1fc55780$5f500680$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009301d0297a$1fc55780$5f500680$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Tue, Jan 06, 2015 at 02:28:43PM +0800, Chao Yu wrote:
> We use kzalloc to allocate memory in __recover_inline_status, and use this
> all-zero memory to check the inline date content of inode page by comparing
> them. This is low effective and not needed, let's check inline date content
> directly.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/inode.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index 3a8958d..8be0fd5 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -67,29 +67,25 @@ static void __set_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
>  	}
>  }
>  
> -static int __recover_inline_status(struct inode *inode, struct page *ipage)
> +static void __recover_inline_status(struct inode *inode, struct page *ipage)
>  {
>  	void *inline_data = inline_data_addr(ipage);
> +	__le32 *start = inline_data;
> +	__le32 *end = start + MAX_INLINE_DATA / sizeof(__le32);
>  	struct f2fs_inode *ri;
> -	void *zbuf;
> -
> -	zbuf = kzalloc(MAX_INLINE_DATA, GFP_NOFS);
> -	if (!zbuf)
> -		return -ENOMEM;
> -
> -	if (!memcmp(zbuf, inline_data, MAX_INLINE_DATA)) {
> -		kfree(zbuf);
> -		return 0;
> -	}
> -	kfree(zbuf);
>  
> +	while (start < end)
> +		if (*start++)
> +			goto recover;
> +	return;
> +recover:
>  	f2fs_wait_on_page_writeback(ipage, NODE);
>  	set_inode_flag(F2FS_I(inode), FI_DATA_EXIST);
>  
>  	ri = F2FS_INODE(ipage);
>  	set_raw_inline(F2FS_I(inode), ri);
>  	set_page_dirty(ipage);
> -	return 0;
> +	return;
>  }

I think *goto recovery* is not a good way.

How's like this?
If you don't mind, I'll merge the patch with this.

static void __recover_inline_status(struct inode *inode, struct page *ipage)
{
	void *inline_data = inline_data_addr(ipage);
	__le32 *start = inline_data;
	__le32 *end = start + MAX_INLINE_DATA / sizeof(__le32);

	while (start < end) {
		if (*start++) {
			f2fs_wait_on_page_writeback(ipage, NODE);

			set_inode_flag(F2FS_I(inode), FI_DATA_EXIST);
			set_raw_inline(F2FS_I(inode), F2FS_INODE(ipage));
			set_page_dirty(ipage);
			return;
		}
	}
	return;
}

Thanks,

>  
>  static int do_read_inode(struct inode *inode)
> @@ -98,7 +94,6 @@ static int do_read_inode(struct inode *inode)
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
>  	struct page *node_page;
>  	struct f2fs_inode *ri;
> -	int err = 0;
>  
>  	/* Check if ino is within scope */
>  	if (check_nid_range(sbi, inode->i_ino)) {
> @@ -142,7 +137,7 @@ static int do_read_inode(struct inode *inode)
>  
>  	/* check data exist */
>  	if (f2fs_has_inline_data(inode) && !f2fs_exist_data(inode))
> -		err = __recover_inline_status(inode, node_page);
> +		__recover_inline_status(inode, node_page);
>  
>  	/* get rdev by using inline_info */
>  	__get_inode_rdev(inode, ri);
> @@ -152,7 +147,7 @@ static int do_read_inode(struct inode *inode)
>  	stat_inc_inline_inode(inode);
>  	stat_inc_inline_dir(inode);
>  
> -	return err;
> +	return 0;
>  }
>  
>  struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> -- 
> 2.2.1
