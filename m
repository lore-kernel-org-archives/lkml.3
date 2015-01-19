Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbbASIiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:38:22 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:58243 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbASIiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:38:21 -0500
Date: Mon, 19 Jan 2015 11:38:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20150119083817.GA3203@moon>
References: <20150119191718.365d4c98@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119191718.365d4c98@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 07:17:18PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (sparc defconfig)
> failed like this:
> 
> In file included from arch/sparc/include/asm/bug.h:20:0,
>                  from include/linux/bug.h:4,
>                  from include/linux/thread_info.h:11,
>                  from include/asm-generic/preempt.h:4,
>                  from arch/sparc/include/generated/asm/preempt.h:1,
>                  from include/linux/preempt.h:18,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:5,
>                  from include/linux/slab.h:14,
>                  from mm/mmap.c:12:
> mm/mmap.c: In function 'exit_mmap':
> mm/mmap.c:2858:46: error: 'PUD_SHIFT' undeclared (first use in this function)
>     round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
>                                               ^
> include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
>   int __ret_warn_on = !!(condition);    \
>                          ^
> mm/mmap.c:2858:46: note: each undeclared identifier is reported only once for each function it appears in
>     round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
>                                               ^
> include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
>   int __ret_warn_on = !!(condition);    \
>                          ^
> 
> Caused by commit b316feb3c37f ("mm: account pmd page tables to the
> process").  32 bit sparc does not seem to define PUD_SHIFT ...
> 
> I am not sure what the correct fix is here, so I just did the following
> patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 19 Jan 2015 19:10:53 +1100
> Subject: [PATCH] mm: account pmd page tables to the process fix
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/mmap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 6a7d36d133fb..25271805ab39 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2854,8 +2854,10 @@ void exit_mmap(struct mm_struct *mm)
>  
>  	WARN_ON(atomic_long_read(&mm->nr_ptes) >
>  			round_up(FIRST_USER_ADDRESS, PMD_SIZE) >> PMD_SHIFT);
> +#ifdef PUD_SHIFT
>  	WARN_ON(mm_nr_pmds(mm) >
>  			round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);
> +#endif
>  }
>  
>  /* Insert vm structure into process list sorted by address

Looks like it should be #ifdef CONFIG_MMU, Kirill?
