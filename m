Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3G2MNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:13:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40423 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3G2MNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:13:20 -0400
Date: Mon, 29 Jul 2013 14:13:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smp: kill unnecessary variable - csd_flags
Message-ID: <20130729121305.GE3008@twins.programming.kicks-ass.net>
References: <51F5D399.3050609@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F5D399.3050609@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:29:45AM +0800, Xie XiuQi wrote:
> We used csd_flags formerly because we allocated csd_data by
> kmalloc when "wait == 0". When fail to allocation, we will
> fall back to on-stack allocation. "csd_data" might be invalid
> after generic_exec_single return.
> 
> But now we use per cpu data for single cpu ipi calls, and
> csd_data can't fall back to on-stack allocation when "wait == 0".
> 
> So csd_flags is unnecessary now. Remove it.

The much simpler argument is that both callsites of
generic_exec_single() do an unconditional csd_lock().

> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  kernel/smp.c |   11 +----------
>  1 files changed, 1 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 4dba0f7..cac2b6e 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -186,25 +186,16 @@ void generic_smp_call_function_single_interrupt(void)
> 
>  	while (!list_empty(&list)) {
>  		struct call_single_data *csd;
> -		unsigned int csd_flags;
> 
>  		csd = list_entry(list.next, struct call_single_data, list);
>  		list_del(&csd->list);
> 
> -		/*
> -		 * 'csd' can be invalid after this call if flags == 0
> -		 * (when called through generic_exec_single()),
> -		 * so save them away before making the call:
> -		 */
> -		csd_flags = csd->flags;
> -
>  		csd->func(csd->info);
> 
>  		/*
>  		 * Unlocked CSDs are valid through generic_exec_single():
>  		 */
> -		if (csd_flags & CSD_FLAG_LOCK)
> -			csd_unlock(csd);
> +		csd_unlock(csd);

The comment is completely useless and confusing after this; why do you
leave it in? 
