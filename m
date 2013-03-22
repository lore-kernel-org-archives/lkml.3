Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423364Ab3CVWFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422662Ab3CVWFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:05:21 -0400
Date: Fri, 22 Mar 2013 15:05:10 -0700
From: Zach Brown <zab@redhat.com>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, koverstreet@google.com, bcrl@kvack.org,
        schwidefsky@de.ibm.com, kirill.shutemov@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] aio: convert the ioctx list to radix tree
Message-ID: <20130322220510.GV10038@lenny.home.zabbo.net>
References: <1363977199-1507-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363977199-1507-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 08:33:19PM +0200, Octavian Purdila wrote:
> When using a large number of threads performing AIO operations the
> IOCTX list may get a significant number of entries which will cause
> significant overhead. For example, when running this fio script:

Indeed.  But you also need to consider the impact this change has on the
typical case of only having one ctx in the mm.  Please include
measurements of that case in the commit message.

> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -831,7 +831,7 @@ int s390_enable_sie(void)
>  	task_lock(tsk);
>  	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
>  #ifdef CONFIG_AIO
> -	    !hlist_empty(&tsk->mm->ioctx_list) ||
> +	    tsk->mm->ioctx_rtree.rnode ||
>  #endif

Boy, what a curious thing.  I wonder if this is still needed if we're no
longer storing the mm in the ctx after retry support is removed.

> +	err = radix_tree_insert(&mm->ioctx_rtree, ctx->user_id, ctx);

Hmm.  Is there anything stopping an exceptionally jerky app from racing
io_setup() and munmap() and having two contexts be mapped to the same
address and get the same user_id?  I guess this would just return
-EEXIST, then, not do anything terrible.  I guess that's OK?

> +					       idx, sizeof(ctx)/sizeof(void *));

ARRAY_SIZE(ctx)

And why bother tracking the starting idx?  If you're completely draining
it simply always start from 0?

- z
