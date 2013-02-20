Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163Ab3BTU1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:27:09 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58861 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934837Ab3BTU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:27:07 -0500
Date: Wed, 20 Feb 2013 12:26:26 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Greg Thelen <gthelen@google.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tmpfs: fix mempolicy object leaks
In-Reply-To: <1361344302-26565-2-git-send-email-gthelen@google.com>
Message-ID: <alpine.LNX.2.00.1302201221270.1152@eggly.anvils>
References: <1361344302-26565-1-git-send-email-gthelen@google.com> <1361344302-26565-2-git-send-email-gthelen@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Greg Thelen wrote:

> This patch fixes several mempolicy leaks in the tmpfs mount logic.
> These leaks are slow - on the order of one object leaked per mount
> attempt.
> 
> Leak 1 (umount doesn't free mpol allocated in mount):
>     while true; do
>         mount -t tmpfs -o mpol=interleave,size=100M nodev /mnt
>         umount /mnt
>     done
> 
> Leak 2 (errors parsing remount options will leak mpol):
>     mount -t tmpfs -o size=100M nodev /mnt
>     while true; do
>         mount -o remount,mpol=interleave,size=x /mnt 2> /dev/null
>     done
>     umount /mnt
> 
> Leak 3 (multiple mpol per mount leak mpol):
>     while true; do
>         mount -t tmpfs -o mpol=interleave,mpol=interleave,size=100M nodev /mnt
>         umount /mnt
>     done
> 
> This patch fixes all of the above.  I could have broken the patch into
> three pieces but is seemed easier to review as one.

Yes, I agree, and nicely fixed - but one doubt below.  If you resolve
that, please add my Acked-by: Hugh Dickins <hughd@google.com>

> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  mm/shmem.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index efd0b3a..ed2cb26 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2386,6 +2386,7 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
>  			       bool remount)
>  {
>  	char *this_char, *value, *rest;
> +	struct mempolicy *mpol = NULL;
>  	uid_t uid;
>  	gid_t gid;
>  
> @@ -2414,7 +2415,7 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
>  			printk(KERN_ERR
>  			    "tmpfs: No value for mount option '%s'\n",
>  			    this_char);
> -			return 1;
> +			goto error;
>  		}
>  
>  		if (!strcmp(this_char,"size")) {
> @@ -2463,19 +2464,23 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
>  			if (!gid_valid(sbinfo->gid))
>  				goto bad_val;
>  		} else if (!strcmp(this_char,"mpol")) {
> -			if (mpol_parse_str(value, &sbinfo->mpol))
> +			mpol_put(mpol);

I haven't tested to check, but don't we need
			mpol = NULL;
here, in case the new option turns out to be bad?

> +			if (mpol_parse_str(value, &mpol))
>  				goto bad_val;
>  		} else {
>  			printk(KERN_ERR "tmpfs: Bad mount option %s\n",
>  			       this_char);
> -			return 1;
> +			goto error;
>  		}
>  	}
> +	sbinfo->mpol = mpol;
>  	return 0;
>  
>  bad_val:
>  	printk(KERN_ERR "tmpfs: Bad value '%s' for mount option '%s'\n",
>  	       value, this_char);
> +error:
> +	mpol_put(mpol);
>  	return 1;
>  
>  }
> @@ -2551,6 +2556,7 @@ static void shmem_put_super(struct super_block *sb)
>  	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>  
>  	percpu_counter_destroy(&sbinfo->used_blocks);
> +	mpol_put(sbinfo->mpol);
>  	kfree(sbinfo);
>  	sb->s_fs_info = NULL;
>  }
> -- 
> 1.8.1.3
