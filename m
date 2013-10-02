Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3JBMGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:06:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab3JBMF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:05:57 -0400
Date: Wed, 2 Oct 2013 14:05:55 +0200
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, tytso@mit.edu, mszeredi@suse.cz
Subject: Re: [PATCH 5/7] ext4: rename: move EMLINK check up
Message-ID: <20131002120555.GB25126@quack.suse.cz>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
 <1380643239-16060-6-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380643239-16060-6-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-10-13 18:00:37, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Move checking i_nlink from after ext4_get_first_dir_block() to before.  The
> check doesn't rely on the result of that function and the function only
> fails on fs corruption, so the order shouldn't matter.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
  This looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/namei.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 01bd80e..1348251 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3082,6 +3082,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			retval = -ENOTEMPTY;
>  			if (!empty_dir(new.inode))
>  				goto end_rename;
> +		} else {
> +			retval = -EMLINK;
> +			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
> +				goto end_rename;
>  		}
>  		retval = -EIO;
>  		old.dir_bh = ext4_get_first_dir_block(handle, old.inode,
> @@ -3091,10 +3095,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			goto end_rename;
>  		if (le32_to_cpu(old.parent_de->inode) != old.dir->i_ino)
>  			goto end_rename;
> -		retval = -EMLINK;
> -		if (!new.inode && new.dir != old.dir &&
> -		    EXT4_DIR_LINK_MAX(new.dir))
> -			goto end_rename;
>  		BUFFER_TRACE(old.dir_bh, "get_write_access");
>  		retval = ext4_journal_get_write_access(handle, old.dir_bh);
>  		if (retval)
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
