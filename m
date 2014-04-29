Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaD2LDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:03:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40150 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaD2LDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:03:09 -0400
Date: Tue, 29 Apr 2014 14:02:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: Re: [PATCH 41/47] staging/lustre/llite: remove dead code
Message-ID: <20140429110251.GC26890@mwanda>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-42-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-42-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:07:05PM -0400, Oleg Drokin wrote:
> From: "John L. Hammond" <john.hammond@intel.com>
> 
> In llite remove unused declarations, parameters, types, and unused,
> get-only, or set-only structure members. Add static and const
> qualifiers to declarations where possible.
> 
> Signed-off-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-on: http://review.whamcloud.com/9767
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2675
> Reviewed-by: Lai Siyao <lai.siyao@intel.com>
> Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>

This is a random grab bag of changes to lots of files.  One thing per
patch, etc, next time.

> diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
> index 8b55080..7d520d8 100644
> --- a/drivers/staging/lustre/lustre/llite/dcache.c
> +++ b/drivers/staging/lustre/lustre/llite/dcache.c
> @@ -69,8 +69,7 @@ static void ll_release(struct dentry *de)
>  		ll_intent_release(lld->lld_it);
>  		OBD_FREE(lld->lld_it, sizeof(*lld->lld_it));
>  	}
> -	LASSERT(lld->lld_cwd_count == 0);
> -	LASSERT(lld->lld_mnt_count == 0);
> +

I'm totally in favour of removing LASSERT() calls...  But is this a
"set only" struct member?  It's totally unclear from the patch
description.

> diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
> index 51c5327..1b47774 100644
> --- a/drivers/staging/lustre/lustre/llite/statahead.c
> +++ b/drivers/staging/lustre/lustre/llite/statahead.c
> @@ -1230,9 +1230,7 @@ do_it:
>  			 */
>  			ll_release_page(page, le32_to_cpu(dp->ldp_flags) &
>  					      LDF_COLLIDE);
> -			sai->sai_in_readpage = 1;
>  			page = ll_get_dir_page(dir, pos, &chain);
> -			sai->sai_in_readpage = 0;
>  		} else {
>  			LASSERT(le32_to_cpu(dp->ldp_flags) & LDF_COLLIDE);
>  			ll_release_page(page, 1);
> @@ -1563,12 +1561,6 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
>  			return entry ? 1 : -EAGAIN;
>  		}
>  
> -		/* if statahead is busy in readdir, help it do post-work */
> -		while (!ll_sa_entry_stated(entry) &&
> -		       sai->sai_in_readpage &&
> -		       !sa_received_empty(sai))
> -			ll_post_statahead(sai);
> -
>  		if (!ll_sa_entry_stated(entry)) {
>  			sai->sai_index_wait = entry->se_index;
>  			lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(30), NULL,

What is this change about really?  I've already waded through 1271 lines
of random changes at this point and now I have to figure out what
ll_post_statahead() does and why we don't need to call it now?

Anyways, please explain this change.

Btw, it's very easy to break up a patch into separate patches.  Use
git citool.  Highlight the lines of code which make things static.
Right click and select "Add highlighted lines to commit."  This patch
has three Reviewed-by tags so you guys need to be pushing back on this
kind of stuff, it's obviously outside of the "one thing per patch" rule.

regards,
dan carpenter
