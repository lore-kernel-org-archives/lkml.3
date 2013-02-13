Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366Ab3BMXx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:53:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3BMXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:53:27 -0500
Date: Wed, 13 Feb 2013 15:53:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH linux-next v2] ocfs2: remove kfree() redundant null
 checks
Message-Id: <20130213155325.9f352cbf.akpm@linux-foundation.org>
In-Reply-To: <1360787385-75824-1-git-send-email-tim.gardner@canonical.com>
References: <1360787385-75824-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 13:29:45 -0700
Tim Gardner <tim.gardner@canonical.com> wrote:

> smatch analysis indicates a number of redundant NULL checks before
> calling kfree(), e.g.,
> 
> fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
>  redundant null check on *tl_copy calling kfree()
> 
> fs/ocfs2/alloc.c:6755 ocfs2_zero_range_for_truncate() info:
>  redundant null check on pages calling kfree()
> 
> ...
>
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 31b9463..83a1a1d 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6134,7 +6134,7 @@ bail:
>  		iput(tl_inode);
>  	brelse(tl_bh);
>  
> -	if (status < 0 && (*tl_copy)) {
> +	if (status < 0) {
>  		kfree(*tl_copy);
>  		*tl_copy = NULL;
>  		mlog_errno(status);

This change does other things.  For example, if
ocfs2_begin_truncate_log_recovery()'s first "goto bail" is taken, we
will now call mlog_errno(status) twice.

That function is pretty confused about its error recovery and logging.
it needs some maintenance.  I'll omit this hunk of your patch.


> @@ -534,7 +533,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
>  		mlog_errno(status);
>  
>  bail:
> -	if ((status < 0) && (*alloc_copy)) {
> +	if (status < 0) {
>  		kfree(*alloc_copy);
>  		*alloc_copy = NULL;
>  	}

Similar, but this change lokos OK.


