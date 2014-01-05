Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaAENGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 08:06:21 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48840 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaAENGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 08:06:19 -0500
Date: Sun, 5 Jan 2014 14:06:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] sched/nohz: fix overflow error in
 scheduler_tick_max_deferment()
Message-ID: <20140105130612.GB17617@localhost.localdomain>
References: <1387315388-31676-1-git-send-email-khilman@linaro.org>
 <1387315388-31676-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387315388-31676-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 01:23:08PM -0800, Kevin Hilman wrote:
> The conversion of the max deferment from usecs to nsecs can easily
> overflow on platforms where a long is 32-bits.  To fix, cast the usecs
> value to u64 before multiplying by NSECS_PER_USEC.
> 
> This was discovered on 32-bit ARM platform when extending the max
> deferment value.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4b1fe3e69fe4..3d7c80e1c4d9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2203,7 +2203,7 @@ u64 scheduler_tick_max_deferment(void)
>  	if (time_before_eq(next, now))
>  		return 0;
>  
> -	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
> +	return (u64)jiffies_to_usecs(next - now) * NSEC_PER_USEC;

Just to be sure I understand the issue. The problem is that jiffies_to_usecs()
return an unsigned int which is then multiplied by NSEC_PER_USEC. If the result
of the mul is too big to be stored in an unsigned int, we overflow and may loose
some high part of the result. Right?

>  }
>  
>  static __init int sched_nohz_full_init_debug(void)
> -- 
> 1.8.3
> 
