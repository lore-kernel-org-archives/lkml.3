Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3KZKPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:15:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab3KZKP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:15:28 -0500
Date: Tue, 26 Nov 2013 09:04:36 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 08/11] ext4: rename: create ext4_renament structure for
 local vars
Message-ID: <20131126080436.GA1384@quack.suse.cz>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu>
 <1384952512-21600-9-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384952512-21600-9-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-11-13 14:01:49, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Need to split up ext4_rename() into helpers but there are two many local
                                                            ^^ too

> variables involved, so create a new structure.  This also, apparently,
> makes the generated code size slightly smaller.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/ext4/namei.c | 211 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 114 insertions(+), 97 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index e0129b6e74cf..c9e38bd30e8b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3001,6 +3001,22 @@ static struct buffer_head *ext4_get_first_dir_block(handle_t *handle,
>  	return ext4_get_first_inline_block(inode, parent_de, retval);
>  }
>  
> +struct ext4_renament {
> +	struct inode *dir;
> +	struct dentry *dentry;
> +	struct inode *inode;
> +
> +	/* entry for "dentry" */
> +	struct buffer_head *bh;
> +	struct ext4_dir_entry_2 *de;
> +	int inlined;
> +
> +	/* entry for parent block of inode if it's a directory */
  Maybe "entry for '..' in inode if it is a directory"? It looks more
comprehensible to me.

> +	struct buffer_head *dir_bh;
> +	struct ext4_dir_entry_2 *parent_de;
> +	int dir_inlined;
> +};
> +
>  /*
>   * Anybody can rename anything with this: the permission checks are left to the
>   * higher-level routines.
> @@ -3014,196 +3030,197 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		       unsigned int flags)
>  {
>  	handle_t *handle = NULL;
> -	struct inode *old_inode, *new_inode;
> -	struct buffer_head *old_bh, *new_bh, *dir_bh;
> -	struct ext4_dir_entry_2 *old_de, *new_de;
> +	struct ext4_renament old = {
> +		.dir = old_dir,
> +		.dentry = old_dentry,
> +	};
> +	struct ext4_renament new = {
> +		.dir = new_dir,
> +		.dentry = new_dentry,
> +	};
  The code would look slightly more logical if we initialized .inode as
well. Not sure if it is worth an extra patch or if you just fold it here...

  Otherwise the patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
