Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935794Ab3DRAPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:15:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59591 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab3DRAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:15:49 -0400
Message-ID: <516F3B30.30307@gmail.com>
Date: Thu, 18 Apr 2013 08:15:44 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>,
        Behan Webster <behanw@converseincode.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: Remove unnecessary __builtin_constant_p()
References: <1366225776.8817.28.camel@pippen.local.home>
In-Reply-To: <1366225776.8817.28.camel@pippen.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
On 04/18/2013 03:09 AM, Steven Rostedt wrote:
> The slab.c code has a size check macro that checks the size of the
> following structs:
>
> struct arraycache_init
> struct kmem_list3
>
> The index_of() function that takes the sizeof() of the above two structs
> and does an unnecessary __builtin_constant_p() on that. As sizeof() will
> always end up being a constant making this always be true. The code is
> not incorrect, but it just adds added complexity, and confuses users and
> wastes the time of reviewers of the code, who spends time trying to
> figure out why the builtin_constant_p() was used.

In normal case, builtin_constant_p() is used for what?

>
> This patch is just a clean up that makes the index_of() code a little
> bit less complex.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 856e4a1..6047900 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -325,9 +325,7 @@ static void cache_reap(struct work_struct *unused);
>   static __always_inline int index_of(const size_t size)
>   {
>   	extern void __bad_size(void);
> -
> -	if (__builtin_constant_p(size)) {
> -		int i = 0;
> +	int i = 0;
>   
>   #define CACHE(x) \
>   	if (size <=x) \
> @@ -336,9 +334,7 @@ static __always_inline int index_of(const size_t size)
>   		i++;
>   #include <linux/kmalloc_sizes.h>
>   #undef CACHE
> -		__bad_size();
> -	} else
> -		__bad_size();
> +	__bad_size();
>   	return 0;
>   }
>   
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

