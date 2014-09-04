Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaIDJXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:23:34 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:37744 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaIDJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:23:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYrAMguCFR5LKYhPGdsb2JhbABZgw2DVoUHqAcGmkGFaQEDAQEBgQgXBQEBAQE4NoQEAQUnExwjEAgDGAklDwUlAwcaE4hBvlwBFxiFZIlRB4RMBZxrjCGMdSsvgk8BAQE
Date: Thu, 4 Sep 2014 19:23:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: akpm@linux-foundation.org, xuejiufei@huawei.com, ming.lei@canonical.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
Message-ID: <20140904092329.GN20473@dastard>
References: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:54:54PM +0800, Junxiao Bi wrote:
> commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O during memory allocation")
> introduces PF_MEMALLOC_NOIO flag to avoid doing I/O inside memory allocation, __GFP_IO is cleared
> when this flag is set, but __GFP_FS implies __GFP_IO, it should also be cleared. Or it may still
> run into I/O, like in superblock shrinker.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: joyce.xue <xuejiufei@huawei.com>
> Cc: Ming Lei <ming.lei@canonical.com>
> ---
>  include/linux/sched.h |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5c2c885..2fb2c47 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1936,11 +1936,13 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
>  #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
>  #define used_math() tsk_used_math(current)
>  
> -/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags */
> +/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags
> + * __GFP_FS is also cleared as it implies __GFP_IO.
> + */
>  static inline gfp_t memalloc_noio_flags(gfp_t flags)
>  {
>  	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
> -		flags &= ~__GFP_IO;
> +		flags &= ~(__GFP_IO | __GFP_FS);
>  	return flags;
>  }

You also need to mask all the shrink_control->gfp_mask
initialisations in mm/vmscan.c. The current code only masks the page
reclaim gfp_mask, not those that are passed to the shrinkers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
