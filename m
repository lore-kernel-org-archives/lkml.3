Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3EMKEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:04:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab3EMKE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:04:26 -0400
Date: Mon, 13 May 2013 12:04:23 +0200
From: Jan Kara <jack@suse.cz>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, xfs@oss.sgi.com
Subject: Re: [Patch] quota: do not leak info to user-space
Message-ID: <20130513100423.GD400@quack.suse.cz>
References: <1368177873-4819-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368177873-4819-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10-05-13 17:24:33, Cong Wang wrote:
> From: Cong Wang <amwang@redhat.com>
> 
> There is a hole in struct fs_quota_stat, so we have to
> zero the struct on stack before copying it to user-space.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Cong Wang <amwang@redhat.com>
  Good point. I've merged the patch.

BTW for XFS folks: The structure definition looks somewhat odd (unaligned
definition of qs_flags, qs_uquota starts only at 32-bit boundary although
it has 64-bit fields in it) and I wouldn't be surprised if it needed compat
wrapper for 32-bit apps on some architectures...

								Honza
> 
> ---
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index c7314f1..2b0c182 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -211,6 +211,7 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
>  
>  	if (!sb->s_qcop->get_xstate)
>  		return -ENOSYS;
> +	memset(&fqs, 0, sizeof(fqs));
>  	ret = sb->s_qcop->get_xstate(sb, &fqs);
>  	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
>  		return -EFAULT;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
