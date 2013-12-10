Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3LJOC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:02:26 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54128 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3LJOCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:02:23 -0500
Date: Tue, 10 Dec 2013 15:02:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, fengguang.wu@intel.com, james.hogan@imgtec.com,
        jason.low2@hp.com, viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] nohz_full: update cpu load fix in nohz_full
Message-ID: <20131210140217.GA10633@localhost.localdomain>
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org>
 <1386074112-30754-4-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386074112-30754-4-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 08:35:12PM +0800, Alex Shi wrote:
> We are not always 0 when update nohz cpu load, after nohz_full enabled.
> But current code still treat the cpu as idle. that is incorrect.
> Fix it to use correct cpu_load.
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/proc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> index 16f5a30..f1441f0 100644
> --- a/kernel/sched/proc.c
> +++ b/kernel/sched/proc.c
> @@ -568,8 +568,14 @@ void update_cpu_load_nohz(void)
>  		/*
>  		 * We were idle, this means load 0, the current load might be
>  		 * !0 due to remote wakeups and the sort.
> +		 * or we may has only one task and in NO_HZ_FULL, then still use
> +		 * normal cpu load.
>  		 */
> -		__update_cpu_load(this_rq, 0, pending_updates);
> +		if (this_rq->cfs.h_nr_running) {
> +			unsigned load = get_rq_runnable_load(this_rq);
> +			__update_cpu_load(this_rq, load, pending_updates);
> +		} else
> +			__update_cpu_load(this_rq, 0, pending_updates);

But decay_load_missed() doesnt handle non 0 loads, right? It probably make more sense
to first fix __update_cpu_load() to make it handle this kind of thing before fixing the caller.

Now you had patches that remove the cpu_load secondary idx I think? You should move this patch to
that series.

>  	}
>  	raw_spin_unlock(&this_rq->lock);
>  }
> -- 
> 1.8.1.2
> 
