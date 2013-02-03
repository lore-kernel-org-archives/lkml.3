Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3BCLKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:10:31 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48543 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3BCLK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:10:29 -0500
Date: Sun, 3 Feb 2013 12:10:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] sched/rt:  add a tuning knob to allow changing
 SCHED_RR timeslice
Message-ID: <20130203111025.GC11739@gmail.com>
References: <20130131135242.1b77b841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131135242.1b77b841@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> 
> Add a /proc/sys/kernel scheduler knob named sched_rr_timeslice_ms
> that allows global changing of the SCHED_RR timeslice value. User
> visable value is in milliseconds but is stored as jiffies.  Setting
> to 0 (zero) resets to the default (currently 100ms).
> 
> Signed-off-by: Clark Williams <williams@redhat.com>
> ---
>  include/linux/sched/sysctl.h |  5 +++++
>  kernel/sched/core.c          | 19 +++++++++++++++++++
>  kernel/sched/rt.c            |  6 ++++--
>  kernel/sysctl.c              |  8 ++++++++
>  4 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
> index 912adab..fda131f 100644
> --- a/include/linux/sched/sysctl.h
> +++ b/include/linux/sched/sysctl.h
> @@ -10,6 +10,11 @@
>   */
>  #define RR_TIMESLICE		(100 * HZ / 1000)
>  
> +extern int sched_rr_timeslice;
> +extern int sched_rr_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos);
> +
>  /*
>   *  control realtime throttling:
>   *
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..1c39c33 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7508,6 +7508,25 @@ static int sched_rt_global_constraints(void)
>  }
>  #endif /* CONFIG_RT_GROUP_SCHED */
>  
> +int sched_rr_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos)
> +{
> +	int ret;
> +	static DEFINE_MUTEX(mutex);
> +
> +	mutex_lock(&mutex);
> +	ret = proc_dointvec(table, write, buffer, lenp, ppos);
> +	/* make sure that internally we keep jiffies */
> +	/* also, writing zero resets timeslice to default */
> +	if (!ret && write) {
> +		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
> +			RR_TIMESLICE :
> msecs_to_jiffies(sched_rr_timeslice);

hm, this patch is whitespace damaged. (line wrapped)

The first patch looks good, I've applied it.

Thanks,

	Ingo
