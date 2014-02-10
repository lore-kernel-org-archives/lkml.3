Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaBJOqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaBJOqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:46:45 -0500
Date: Mon, 10 Feb 2014 09:46:09 -0500
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/11] watchdog: Simplify a little the IPI call
Message-ID: <20140210144609.GX25953@redhat.com>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
 <1391876320-25068-10-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391876320-25068-10-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 05:18:38PM +0100, Frederic Weisbecker wrote:
> In order to remotely restart the watchdog hrtimer, update_timers()
> allocates a csd on the stack and pass it to __smp_call_function_single().
> 
> There is no partcular need, however, for a specific csd here. Lets
> simplify that a little by calling smp_call_function_single()
> which can already take care of the csd allocation by itself.

Sounds simple enough.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/watchdog.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4431610..01c6f97 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -505,7 +505,6 @@ static void restart_watchdog_hrtimer(void *info)
>  
>  static void update_timers(int cpu)
>  {
> -	struct call_single_data data = {.func = restart_watchdog_hrtimer};
>  	/*
>  	 * Make sure that perf event counter will adopt to a new
>  	 * sampling period. Updating the sampling period directly would
> @@ -515,7 +514,7 @@ static void update_timers(int cpu)
>  	 * might be late already so we have to restart the timer as well.
>  	 */
>  	watchdog_nmi_disable(cpu);
> -	__smp_call_function_single(cpu, &data, 1);
> +	smp_call_function_single(cpu, restart_watchdog_hrtimer, NULL, 1);
>  	watchdog_nmi_enable(cpu);
>  }
>  
> -- 
> 1.8.3.1
> 
