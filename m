Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3DSFWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 01:22:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3DSFVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 01:21:53 -0400
Date: Fri, 19 Apr 2013 07:15:02 +0200
From: Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 15/18] ext4: remove unused code from
 ext4_remove_blocks()
Message-ID: <20130419051502.GF19244@quack.suse.cz>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
 <1365498867-27782-16-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365498867-27782-16-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 11:14:24, Lukas Czerner wrote:
> The "head removal" branch in the condition is never used in any code
> path in ext4 since the function only caller ext4_ext_rm_leaf() will make
> sure that the extent is properly split before removing blocks. Note that
> there is a bug in this branch anyway.
> 
> This commit removes the unused code completely and makes use of
> ext4_error() instead of printk if dubious range is provided.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/extents.c |   21 ++++-----------------
>  1 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6c5a70a..4adaa8a 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2435,23 +2435,10 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
>  			*partial_cluster = EXT4_B2C(sbi, pblk);
>  		else
>  			*partial_cluster = 0;
> -	} else if (from == le32_to_cpu(ex->ee_block)
> -		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
> -		/* head removal */
> -		ext4_lblk_t num;
> -		ext4_fsblk_t start;
> -
> -		num = to - from;
> -		start = ext4_ext_pblock(ex);
> -
> -		ext_debug("free first %u blocks starting %llu\n", num, start);
> -		ext4_free_blocks(handle, inode, NULL, start, num, flags);
> -
> -	} else {
> -		printk(KERN_INFO "strange request: removal(2) "
> -				"%u-%u from %u:%u\n",
> -				from, to, le32_to_cpu(ex->ee_block), ee_len);
> -	}
> +	} else
> +		ext4_error(sbi->s_sb, "strange request: removal(2) "
> +			   "%u-%u from %u:%u\n",
> +			   from, to, le32_to_cpu(ex->ee_block), ee_len);
>  	return 0;
>  }
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
