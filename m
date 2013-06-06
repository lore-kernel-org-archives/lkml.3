Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3FFE35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:29:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50284 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FFE34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:29:56 -0400
Message-ID: <1370492994.24311.331.camel@edumazet-glaptop>
Subject: Re: [PATCH] Fix lockup related to stop_machine being stuck in
 __do_softirq.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: greearb@candelatech.com
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Date: Wed, 05 Jun 2013 21:29:54 -0700
In-Reply-To: <1370492751-6886-1-git-send-email-greearb@candelatech.com>
References: <1370492751-6886-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 21:25 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>

> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 14d7758..f150ad6 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -204,6 +204,7 @@ EXPORT_SYMBOL(local_bh_enable_ip);
>   * should not be able to lock up the box.

Could you update the comment ?

I had the following :

- * We restart softirq processing for at most 2 ms,
- * and if need_resched() is not set.
+ * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
+ * but break the loop if need_resched() is set or after 2 ms.


>   */
>  #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
> +#define MAX_SOFTIRQ_RESTART 10
>  
>  asmlinkage void __do_softirq(void)
>  {
> @@ -212,6 +213,7 @@ asmlinkage void __do_softirq(void)
>  	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
>  	int cpu;
>  	unsigned long old_flags = current->flags;
> +	int max_restart = MAX_SOFTIRQ_RESTART;
>  
>  	/*
>  	 * Mask out PF_MEMALLOC s current task context is borrowed for the
> @@ -265,7 +267,8 @@ restart:
>  
>  	pending = local_softirq_pending();
>  	if (pending) {
> -		if (time_before(jiffies, end) && !need_resched())
> +		if (time_before(jiffies, end) && !need_resched()
> +		    && --max_restart)
>  			goto restart;
>  
>  		wakeup_softirqd();


if (cond1 && cond2 &&
    cond3) ...

or

if (cond1 &&
    cond2 &&
    cond3) ...

Thanks !


