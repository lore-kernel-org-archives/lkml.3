Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3LDGRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:17:20 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63496 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3LDGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:17:19 -0500
Message-ID: <529EC8E0.6060103@linaro.org>
Date: Wed, 04 Dec 2013 14:17:04 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
CC: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] nohz_full: update cpu load fix in nohz_full
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org> <1386074112-30754-4-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1386074112-30754-4-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 08:35 PM, Alex Shi wrote:
> We are not always 0 when update nohz cpu load, after nohz_full enabled.
> But current code still treat the cpu as idle. that is incorrect.
> Fix it to use correct cpu_load.

Frederic, Could you like to give some comments?

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
>  	}
>  	raw_spin_unlock(&this_rq->lock);
>  }
> 


-- 
Thanks
    Alex
