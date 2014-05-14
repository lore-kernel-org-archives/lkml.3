Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaENLKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:10:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbaENLKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:10:51 -0400
Date: Wed, 14 May 2014 13:10:48 +0200
From: Jan Kara <jack@suse.cz>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH V2 1/2] fs: include device name in error messages about
 freezing
Message-ID: <20140514111048.GA5824@quack.suse.cz>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-05-14 00:04:42, Mateusz Guzik wrote:
> While here use pr_err instead of printk(KERN_ERR...)
  The patch looks good. Just one nit below:

> Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Eric Sandeen <esandeen@redhat.com>
> ---
>  fs/super.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 48377f7..017e10a 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1323,8 +1323,7 @@ int freeze_super(struct super_block *sb)
>  	if (sb->s_op->freeze_fs) {
>  		ret = sb->s_op->freeze_fs(sb);
>  		if (ret) {
> -			printk(KERN_ERR
> -				"VFS:Filesystem freeze failed\n");
> +			pr_err("VFS:Filesystem %s freeze failed\n", sb->s_id);
  I'd somewhat prefer to have the format like:
VFS (device %s): Filesystem freeze failed\n

  That should easy to programatically parse if necessary and also more
consistent with how filesystems report errors. Now VFS itself doesn't have
any unified style but still...

								Honza

>  			sb->s_writers.frozen = SB_UNFROZEN;
>  			smp_wmb();
>  			wake_up(&sb->s_writers.wait_unfrozen);
> @@ -1364,8 +1363,7 @@ int thaw_super(struct super_block *sb)
>  	if (sb->s_op->unfreeze_fs) {
>  		error = sb->s_op->unfreeze_fs(sb);
>  		if (error) {
> -			printk(KERN_ERR
> -				"VFS:Filesystem thaw failed\n");
> +			pr_err("VFS:Filesystem %s thaw failed\n", sb->s_id);
>  			up_write(&sb->s_umount);
>  			return error;
>  		}
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
