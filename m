Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaHMHVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:21:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33686 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaHMHVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:21:47 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a6-53eb11ffc57b
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 01/13] f2fs: should convert inline_data during
	the mkwrite
Date: Wed, 13 Aug 2014 15:20:46 +0800
Message-id: <009901cfb6c7$36b82a60$a4287f20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZW5v7x+xA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQd3/gq+DDab91ba4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	lqxewl7wVbNi0/vVzA2MPxS7GDk4JARMJA70m3cxcgKZYhIX7q1n62Lk4hASmM4osbX3DjuE
	84NR4uGtWawgVWwCKhLLO/4zgdgiAj4SD+4tAbOZBTIlJvS/YAexhQScJE4ubWMBsTkFnCUO
	vXkFFhcWiJa49OMdWD2LgKrEm/0T2UGO4BWwlGhZxA8S5hUQlPgx+R4LxEgtifU7j0ONl5fY
	vOYtM8ShChI7zr5mhDjBSOLsjLdQNeISG4/cYpnAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCY+GZ1A7GlQ0WhxgFOBiVeHgreF8FC7EmlhVX5h5ilOBg
	VhLhddgCFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cDo
	ICzPfKvx3I1+g90rbzWt/vj7iu6pVXfCz/L9dQ74YVOSsf++wjy/lw9zk68qRKXF+An9L89a
	ziF826+g8Ibd2oVHXX9PXSxQICKk2ib05dCfT8Zr103a5DVBe97CQ1seJUx//edASkXssdSZ
	CdqbA8pyz1VX3it7KDDjw/EqzkNTNGN/7+6SUmIpzkg01GIuKk4EACjWSpeBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 01/13] f2fs: should convert inline_data during the mkwrite
> 
> If mkwrite is called to an inode having inline_data, it can overwrite the data
> index space as NEW_ADDR. (e.g., the first 4 bytes are coincidently zero)

Good catch!

As I did some simple tests, I found that thread will receive SIGBUS when
operating mmaped page exceed file size, so here, we will meet a inline data
inode only when we mkwrite the first page.
Please correct me if I'm wrong.

In this case, why not just do f2fs_read_inline_data & skip f2fs_reserve_block,
instead of converting inline_data and following f2fs_write_inline_data in
->writepage().

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/data.c   |  2 +-
>  fs/f2fs/f2fs.h   |  2 +-
>  fs/f2fs/file.c   | 11 ++++++++---
>  fs/f2fs/inline.c | 20 ++++++++++++--------
>  4 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 7aef28d..ac3ccc2 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -946,7 +946,7 @@ static int f2fs_write_begin(struct file *file, struct address_space
> *mapping,
> 
>  	f2fs_balance_fs(sbi);
>  repeat:
> -	err = f2fs_convert_inline_data(inode, pos + len);
> +	err = f2fs_convert_inline_data(inode, pos + len, NULL);
>  	if (err)
>  		goto fail;
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 790a073..c8288c9 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1439,7 +1439,7 @@ extern const struct inode_operations f2fs_special_inode_operations;
>   */
>  bool f2fs_may_inline(struct inode *);
>  int f2fs_read_inline_data(struct inode *, struct page *);
> -int f2fs_convert_inline_data(struct inode *, pgoff_t);
> +int f2fs_convert_inline_data(struct inode *, pgoff_t, struct page *);
>  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
>  void truncate_inline_data(struct inode *, u64);
>  int recover_inline_data(struct inode *, struct page *);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 87cdac4..ecbdf6a 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -41,6 +41,11 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
> 
>  	sb_start_pagefault(inode->i_sb);
> 
> +	/* force to convert with normal data indices */
> +	err = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, page);
> +	if (err)
> +		goto out;
> +
>  	/* block allocation */
>  	f2fs_lock_op(sbi);
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
> @@ -533,7 +538,7 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
> 
>  	if ((attr->ia_valid & ATTR_SIZE) &&
>  			attr->ia_size != i_size_read(inode)) {
> -		err = f2fs_convert_inline_data(inode, attr->ia_size);
> +		err = f2fs_convert_inline_data(inode, attr->ia_size, NULL);
>  		if (err)
>  			return err;
> 
> @@ -622,7 +627,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  	loff_t off_start, off_end;
>  	int ret = 0;
> 
> -	ret = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1);
> +	ret = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, NULL);
>  	if (ret)
>  		return ret;
> 
> @@ -678,7 +683,7 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
>  	if (ret)
>  		return ret;
> 
> -	ret = f2fs_convert_inline_data(inode, offset + len);
> +	ret = f2fs_convert_inline_data(inode, offset + len, NULL);
>  	if (ret)
>  		return ret;
> 
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index 5beecce..1ec512d 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -124,9 +124,10 @@ out:
>  	return err;
>  }
> 
> -int f2fs_convert_inline_data(struct inode *inode, pgoff_t to_size)
> +int f2fs_convert_inline_data(struct inode *inode, pgoff_t to_size,
> +						struct page *page)
>  {
> -	struct page *page;
> +	struct page *new_page = page;
>  	int err;
> 
>  	if (!f2fs_has_inline_data(inode))
> @@ -134,17 +135,20 @@ int f2fs_convert_inline_data(struct inode *inode, pgoff_t to_size)
>  	else if (to_size <= MAX_INLINE_DATA)
>  		return 0;
> 
> -	page = grab_cache_page(inode->i_mapping, 0);
> -	if (!page)
> -		return -ENOMEM;
> +	if (!page || page->index != 0) {
> +		new_page = grab_cache_page(inode->i_mapping, 0);
> +		if (!new_page)
> +			return -ENOMEM;
> +	}
> 
> -	err = __f2fs_convert_inline_data(inode, page);
> -	f2fs_put_page(page, 1);
> +	err = __f2fs_convert_inline_data(inode, new_page);
> +	if (!page || page->index != 0)
> +		f2fs_put_page(new_page, 1);
>  	return err;
>  }
> 
>  int f2fs_write_inline_data(struct inode *inode,
> -			   struct page *page, unsigned size)
> +				struct page *page, unsigned size)
>  {
>  	void *src_addr, *dst_addr;
>  	struct page *ipage;
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

