Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaFWDOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:14:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15814 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaFWDOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:14:05 -0400
X-AuditID: cbfee61b-f79f86d00000144c-9a-53a79b753484
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1403485976-29398-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1403485976-29398-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [PATCH 1/2] f2fs: introduce f2fs_do_tmpfile for code consistency
Date: Mon, 23 Jun 2014 11:13:09 +0800
Message-id: <000401cf8e91$2b93c3a0$82bb4ae0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLoXS3tPMtfZBG51Gn4rub72A1C25lMVc9w
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd3S2cuDDTo2qlo8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfG4w6ugR6PiZcdO
	xgbGdoUuRk4OCQETiYM7d7NB2GISF+6tB7K5OIQEFjFKPPqxkB3C+cEoseDASbAqNgEVieUd
	/5lAbBEBNYnefVPAbGaBTIkJ/S/YQWwhASeJAwvngtmcAs4SNx7/ZQWxhQV8JTadbmAGsVkE
	VCX+r3wO1ssrYCkxZdceKFtQ4sfkeywQM7Uk1u88DjVfXmLzmrfMEJcqSOw4+5oR4gYjiT//
	F7JC1IhLbDxyi2UCo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIDvxn0jsYVzVYHGIU4GBU4uHVcFseLMSaWFZcmXuIUYKDWUmEt7EBKMSbklhZlVqUH19U
	mpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFRQSg01sN7yYyv7Cwb09dyv3L+
	ryMYsWTCzoefZadvyJ732E7uRuyq7qvM7ituL9n7W5+f5cXODK5VjiF7HUrTvv013t74/7GE
	X6vCzl2fNPmFjx+eFbLesyinM136wdsIqS5W1dr9H09Wba7um5fnX3jsl6Fw0Uzre/VbJ2Ru
	eRkUeal2gYWIEktxRqKhFnNRcSIAQB6Cj3gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Monday, June 23, 2014 9:13 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim; Chao Yu
> Subject: [PATCH 1/2] f2fs: introduce f2fs_do_tmpfile for code consistency
> 
> This patch adds f2fs_do_tmpfile to eliminate the redundant init_inode_metadata
> flow.
> Throught this, we can provide the consistent lock usage, e.g., fi->i_sem,  and
> this will enable better debugging stuffs.
> 
> Cc: Chao Yu <chao2.yu@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/dir.c   | 27 ++++++++++++++++++++++++---
>  fs/f2fs/f2fs.h  |  1 +
>  fs/f2fs/namei.c | 30 ++++++++----------------------
>  3 files changed, 33 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 09760d5..fe6aaca 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -337,8 +337,7 @@ static struct page *init_inode_metadata(struct inode *inode,
>  	struct page *page;
>  	int err;
> 
> -	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE) &&
> -			inode->i_nlink) {
> +	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
>  		page = new_inode_page(inode, name);
>  		if (IS_ERR(page))
>  			return page;
> @@ -364,7 +363,8 @@ static struct page *init_inode_metadata(struct inode *inode,
>  		set_cold_node(inode, page);
>  	}
> 
> -	init_dent_inode(name, page);
> +	if (name)
> +		init_dent_inode(name, page);
> 
>  	/*
>  	 * This file should be checkpointed during fsync.
> @@ -537,6 +537,27 @@ fail:
>  	return err;
>  }
> 
> +int f2fs_do_tmpfile(struct inode *inode, struct inode *dir)
> +{
> +	struct page *page;
> +	int err = 0;
> +
> +	down_write(&F2FS_I(inode)->i_sem);

Here I did not find nlink/pino/xattr_ver which we should protect by ->i_sem,
Am I missing something?

> +	page = init_inode_metadata(inode, dir, NULL);
> +	if (IS_ERR(page)) {
> +		err = PTR_ERR(page);
> +		goto fail;
> +	}
> +	/* we don't need to mark_inode_dirty now */
> +	update_inode(inode, page);
> +	f2fs_put_page(page, 1);
> +
> +	update_parent_metadata(dir, inode, F2FS_I(dir)->i_current_depth);

Things we did in update_parent_metadata() is: 1.clear FI_NEW_INODE of inode flag,
2. update mtime&ctime of dir and mark it dirty.
IMO, we do not need the update op because we do not access/modify current dir
as we did normally through f2fs_add_link path.
So how about using clear_inode_flag instead of update_parent_metadata and leave
current dir as clean?

Thanks,
Yu

> +fail:
> +	up_write(&F2FS_I(inode)->i_sem);
> +	return err;
> +}
> +
>  /*
>   * It only removes the dentry from the dentry page,corresponding name
>   * entry in name page does not need to be touched during deletion.
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 58df97e..ca421a8 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1136,6 +1136,7 @@ void f2fs_set_link(struct inode *, struct f2fs_dir_entry *,
>  int update_dent_inode(struct inode *, const struct qstr *);
>  int __f2fs_add_link(struct inode *, const struct qstr *, struct inode *);
>  void f2fs_delete_entry(struct f2fs_dir_entry *, struct page *, struct inode *);
> +int f2fs_do_tmpfile(struct inode *, struct inode *);
>  int f2fs_make_empty(struct inode *, struct inode *);
>  bool f2fs_empty_dir(struct inode *);
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 0d55517..9de4ab3 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -494,7 +494,6 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t
> mode)
>  	struct super_block *sb = dir->i_sb;
>  	struct f2fs_sb_info *sbi = F2FS_SB(sb);
>  	struct inode *inode;
> -	struct page *page;
>  	int err;
> 
>  	inode = f2fs_new_inode(dir, mode);
> @@ -509,38 +508,25 @@ static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t
> mode)
>  	err = acquire_orphan_inode(sbi);
>  	if (err)
>  		goto out;
> +
> +	err = f2fs_do_tmpfile(inode, dir);
> +	if (err)
> +		goto release_out;
> +
>  	/*
>  	 * add this non-linked tmpfile to orphan list, in this way we could
>  	 * remove all unused data of tmpfile after abnormal power-off.
>  	 */
>  	add_orphan_inode(sbi, inode->i_ino);
> -
> -	page = new_inode_page(inode, NULL);
> -	if (IS_ERR(page)) {
> -		err = PTR_ERR(page);
> -		goto remove_out;
> -	}
> -
> -	err = f2fs_init_acl(inode, dir, page);
> -	if (err)
> -		goto unlock_out;
> -
> -	err = f2fs_init_security(inode, dir, NULL, page);
> -	if (err)
> -		goto unlock_out;
> -
> -	f2fs_put_page(page, 1);
>  	f2fs_unlock_op(sbi);
> 
>  	alloc_nid_done(sbi, inode->i_ino);
> -	mark_inode_dirty(inode);
>  	d_tmpfile(dentry, inode);
>  	unlock_new_inode(inode);
>  	return 0;
> -unlock_out:
> -	f2fs_put_page(page, 1);
> -remove_out:
> -	remove_orphan_inode(sbi, inode->i_ino);
> +
> +release_out:
> +	release_orphan_inode(sbi);
>  out:
>  	f2fs_unlock_op(sbi);
>  	clear_nlink(inode);
> --
> 1.8.5.2 (Apple Git-48)

