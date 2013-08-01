Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3HAJsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:48:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25137 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab3HAJsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:48:50 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367942400"; 
   d="scan'208";a="8087229"
Message-ID: <51FA2E1A.1080604@cn.fujitsu.com>
Date: Thu, 01 Aug 2013 17:44:58 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: unlisted-recipients:;;linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;linux-fsdevel@vger.kernel.org
					     ^-missing end of address
Subject: Re: [PATCH] f2fs: fix handling orphan inodes
References: <1375343917-24093-1-git-send-email-jaegeuk.kim@samsung.com>
In-Reply-To: <1375343917-24093-1-git-send-email-jaegeuk.kim@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/01 17:47:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/01 17:47:34,
	Serialize complete at 2013/08/01 17:47:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 03:58 PM, Jaegeuk Kim wrote:

> This patch fixes mishandling of the sbi->n_orphans variable.
> 
> If users request lots of f2fs_unlink(), check_orphan_space() could be contended.
> In such the case, sbi->n_orphans can be read incorrectly so that f2fs_unlink()
> would fall into the wrong state which results in the failure of
> add_orphan_inode().
> 
> So, let's increment sbi->n_orphans virtually prior to the actual orphan inode
> stuffs. After that, let's release sbi->n_orphans by calling release_orphan_inode
> or remove_orphan_inode.

Hi Kim,
The key point is that we did not reduce sbi->n_orphans when we release/remove orphan inode,
so just adding the reduction step can fix this issue.
But why moving the increment of sbi->n_orphans before we add orphan inode? It seems that we
can not get benefit from it, and it makes the procedure a bit complex, because we should
reduce the sbi->n_orphans in some fail pathes before we really add orphan inode.

Thanks,
Gu

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/checkpoint.c | 13 ++++++++++---
>  fs/f2fs/dir.c        |  2 ++
>  fs/f2fs/f2fs.h       |  3 ++-
>  fs/f2fs/namei.c      | 19 ++++++++++++++-----
>  4 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index fe91773..c5a5c39 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -182,7 +182,7 @@ const struct address_space_operations f2fs_meta_aops = {
>  	.set_page_dirty	= f2fs_set_meta_page_dirty,
>  };
>  
> -int check_orphan_space(struct f2fs_sb_info *sbi)
> +int acquire_orphan_inode(struct f2fs_sb_info *sbi)
>  {
>  	unsigned int max_orphans;
>  	int err = 0;
> @@ -197,10 +197,19 @@ int check_orphan_space(struct f2fs_sb_info *sbi)
>  	mutex_lock(&sbi->orphan_inode_mutex);
>  	if (sbi->n_orphans >= max_orphans)
>  		err = -ENOSPC;
> +	else
> +		sbi->n_orphans++;
>  	mutex_unlock(&sbi->orphan_inode_mutex);
>  	return err;
>  }
>  
> +void release_orphan_inode(struct f2fs_sb_info *sbi)
> +{
> +	mutex_lock(&sbi->orphan_inode_mutex);
> +	sbi->n_orphans--;
> +	mutex_unlock(&sbi->orphan_inode_mutex);
> +}
> +
>  void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
>  	struct list_head *head, *this;
> @@ -229,8 +238,6 @@ retry:
>  		list_add(&new->list, this->prev);
>  	else
>  		list_add_tail(&new->list, head);
> -
> -	sbi->n_orphans++;
>  out:
>  	mutex_unlock(&sbi->orphan_inode_mutex);
>  }
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index d1bb260..384c6da 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -572,6 +572,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
>  
>  		if (inode->i_nlink == 0)
>  			add_orphan_inode(sbi, inode->i_ino);
> +		else
> +			release_orphan_inode(sbi);
>  	}
>  
>  	if (bit_pos == NR_DENTRY_IN_BLOCK) {
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index a6858c7..78777cd 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1044,7 +1044,8 @@ void destroy_segment_manager(struct f2fs_sb_info *);
>  struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
>  struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
>  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
> -int check_orphan_space(struct f2fs_sb_info *);
> +int acquire_orphan_inode(struct f2fs_sb_info *);
> +void release_orphan_inode(struct f2fs_sb_info *);
>  void add_orphan_inode(struct f2fs_sb_info *, nid_t);
>  void remove_orphan_inode(struct f2fs_sb_info *, nid_t);
>  int recover_orphan_inodes(struct f2fs_sb_info *);
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 3297278..4e47518 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -239,7 +239,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
>  	if (!de)
>  		goto fail;
>  
> -	err = check_orphan_space(sbi);
> +	err = acquire_orphan_inode(sbi);
>  	if (err) {
>  		kunmap(page);
>  		f2fs_put_page(page, 0);
> @@ -393,7 +393,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	struct inode *old_inode = old_dentry->d_inode;
>  	struct inode *new_inode = new_dentry->d_inode;
>  	struct page *old_dir_page;
> -	struct page *old_page;
> +	struct page *old_page, *new_page;
>  	struct f2fs_dir_entry *old_dir_entry = NULL;
>  	struct f2fs_dir_entry *old_entry;
>  	struct f2fs_dir_entry *new_entry;
> @@ -415,7 +415,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	ilock = mutex_lock_op(sbi);
>  
>  	if (new_inode) {
> -		struct page *new_page;
>  
>  		err = -ENOTEMPTY;
>  		if (old_dir_entry && !f2fs_empty_dir(new_inode))
> @@ -427,9 +426,13 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		if (!new_entry)
>  			goto out_dir;
>  
> +		err = acquire_orphan_inode(sbi);
> +		if (err)
> +			goto put_out_dir;
> +
>  		if (update_dent_inode(old_inode, &new_dentry->d_name)) {
> -			f2fs_put_page(new_page, 1);
> -			goto out_dir;
> +			release_orphan_inode(sbi);
> +			goto put_out_dir;
>  		}
>  
>  		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
> @@ -438,8 +441,12 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		if (old_dir_entry)
>  			drop_nlink(new_inode);
>  		drop_nlink(new_inode);
> +
>  		if (!new_inode->i_nlink)
>  			add_orphan_inode(sbi, new_inode->i_ino);
> +		else
> +			release_orphan_inode(sbi);
> +
>  		update_inode_page(new_inode);
>  	} else {
>  		err = f2fs_add_link(new_dentry, old_inode);
> @@ -472,6 +479,8 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	mutex_unlock_op(sbi, ilock);
>  	return 0;
>  
> +put_out_dir:
> +	f2fs_put_page(new_page, 1);
>  out_dir:
>  	if (old_dir_entry) {
>  		kunmap(old_dir_page);


