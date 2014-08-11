Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaHKHtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:49:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaHKHtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:49:15 -0400
Date: Mon, 11 Aug 2014 09:49:11 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Yu <chao2.yu@samsung.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: avoid unneeded up_write when fail to add entry in
 ->symlink
Message-ID: <20140811074911.GA29526@quack.suse.cz>
References: <00bd01cfb374$4b397a30$e1ac6e90$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00bd01cfb374$4b397a30$e1ac6e90$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 09-08-14 09:49:31, Chao Yu wrote:
> We have released the ->i_data_sem before invoking udf_add_entry(),
> so in following error path, we should not release this lock again.
  Good catch. I've merged the patch to my tree. Thanks.

							Honza

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/udf/namei.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 9737cba..83a0600 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -1014,7 +1014,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
>  
>  	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
>  	if (!fi)
> -		goto out_no_entry;
> +		goto out_fail;
>  	cfi.icb.extLength = cpu_to_le32(sb->s_blocksize);
>  	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
>  	if (UDF_SB(inode->i_sb)->s_lvid_bh) {
> @@ -1036,6 +1036,7 @@ out:
>  
>  out_no_entry:
>  	up_write(&iinfo->i_data_sem);
> +out_fail:
>  	inode_dec_link_count(inode);
>  	iput(inode);
>  	goto out;
> -- 
> 2.0.1.474.g72c7794
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
