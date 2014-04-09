Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaDIJw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:52:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbaDIJw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:52:58 -0400
Date: Wed, 9 Apr 2014 11:52:54 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 12/22] ext2: Remove ext2_xip_verify_sb()
Message-ID: <20140409095254.GE32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <5f91cb658e1ee1b593be9fd719e8f204b0069031.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f91cb658e1ee1b593be9fd719e8f204b0069031.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:38, Matthew Wilcox wrote:
> Jan Kara pointed out that calling ext2_xip_verify_sb() in ext2_remount()
> doesn't make sense, since changing the XIP option on remount isn't
> allowed.  It also doesn't make sense to re-check whether blocksize is
> supported since it can't change between mounts.
> 
> Replace the call to ext2_xip_verify_sb() in ext2_fill_super() with the
> equivalent check and delete the definition.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  One nit below:
...
> @@ -1273,22 +1275,11 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
>  	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
>  		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
>  
> -	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
> -				    EXT2_MOUNT_XIP if not */
> -
> -	if ((ext2_use_xip(sb)) && (sb->s_blocksize != PAGE_SIZE)) {
> -		ext2_msg(sb, KERN_WARNING,
> -			"warning: unsupported blocksize for xip");
> -		err = -EINVAL;
> -		goto restore_opts;
> -	}
> -
>  	es = sbi->s_es;
> -	if ((sbi->s_mount_opt ^ old_mount_opt) & EXT2_MOUNT_XIP) {
> +	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_XIP) {
>  		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
>  			 "xip flag with busy inodes while remounting");
> -		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
> -		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
> +		sbi->s_mount_opt ^= EXT2_MOUNT_XIP;
  Although this is correct, it was easier to see that the previous code is
correct so I'd prefer if you kept it that way.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
