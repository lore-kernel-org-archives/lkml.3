Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBZXGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:06:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41389 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaBZXF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:05:59 -0500
Date: Wed, 26 Feb 2014 15:05:54 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 1/3] percpu_ida: Fix data race on cpus_have_tags
 cpumask
Message-ID: <20140226230554.GE11655@kmo>
References: <cover.1391688720.git.agordeev@redhat.com>
 <dd1eb6b2f0f88e90417ba6ad57393147816a4287.1391688720.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd1eb6b2f0f88e90417ba6ad57393147816a4287.1391688720.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:24:53PM +0100, Alexander Gordeev wrote:
> Function steal_tags() might miss a bit in cpus_have_tags due to
> unsynchronized access from percpu_ida_free(). As result, function
> percpu_ida_alloc() might enter unwakable sleep. This update adds
> memory barriers to prevent the described scenario.
> 
> In fact, accesses to cpus_have_tags are fenced by prepare_to_wait()
> and wake_up() calls at the moment and the aforementioned sequence
> does not appear could hit. Nevertheless, explicit memory barriers
> still seem justifiable.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> Acked-by: Kent Overstreet <kmo@daterainc.com>
> ---
>  lib/percpu_ida.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index 7be235f..fccfb28 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -68,6 +68,11 @@ static inline void steal_tags(struct percpu_ida *pool,
>  	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
>  	struct percpu_ida_cpu *remote;
>  
> +	/*
> +	 * Pairs with smp_wmb() in percpu_ida_free()
> +	 */
> +	smp_rmb();
> +
>  	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
>  	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
>  	     cpus_have_tags--) {
> @@ -237,8 +242,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
>  	spin_unlock(&tags->lock);
>  
>  	if (nr_free == 1) {
> -		cpumask_set_cpu(smp_processor_id(),
> -				&pool->cpus_have_tags);
> +		cpumask_set_cpu(smp_processor_id(), &pool->cpus_have_tags);
> +		/*
> +		 * Pairs with smp_rmb() in steal_tags()
> +		 */
> +		smp_wmb();
>  		wake_up(&pool->wait);

I think I'm nacking this - there's a lot of code in the kernel that relies on
the fact that prepare_to_wait)/wake_up() do the appropriate fences, we really
shouldn't be adding to the barriers those do.

If you can come up with some other reason we need the barriers I'll reconsider.
