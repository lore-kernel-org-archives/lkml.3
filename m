Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaANStP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:49:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaANSsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:48:53 -0500
Date: Tue, 14 Jan 2014 19:48:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 1/3] timers: Reduce __run_timers()
	latency for empty list
Message-ID: <20140114184828.GA29331@redhat.com>
References: <20140114041449.GA13934@linux.vnet.ibm.com> <1389672919-14621-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389672919-14621-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Paul E. McKenney wrote:
>
> The __run_timers() function currently steps through the list one jiffy at
> a time in order to update the timer wheel.  However, if the timer wheel
> is empty, no adjustment is needed other than updating ->timer_jiffies.

Yes, but ->active_timers == 0 doesn't necessarily mean "empty", it only
counts the non-deferrable timers?

> In this case, which is likely to be common for NO_HZ_FULL kernels, the
> kernel currently incurs a large latency for no good reason.  This commit
> therefore short-circuits this case.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/timer.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 6582b82fa966..21849275828f 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -337,6 +337,17 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
>  }
>  EXPORT_SYMBOL_GPL(set_timer_slack);
>
> +static bool catchup_timer_jiffies(struct tvec_base *base)
> +{
> +#ifdef CONFIG_NO_HZ_FULL
> +	if (!base->active_timers) {
> +		base->timer_jiffies = jiffies;
> +		return 1;
> +	}
> +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> +	return 0;
> +}
> +
>  static void
>  __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
>  {
> @@ -1146,6 +1157,10 @@ static inline void __run_timers(struct tvec_base *base)
>  	struct timer_list *timer;
>
>  	spin_lock_irq(&base->lock);

Do we really need to take base->lock before catchup_timer_jiffies() ?
->timer_jiffies can only be changed by us, and it seems that we do
not care if we race with base->active_timers++.

> +	if (catchup_timer_jiffies(base)) {
> +		spin_unlock_irq(&base->lock);
> +		return;

This is what I can't understand... Doesn't this mean that, unless this
base have a non-deferrable timer, we can never run the pending deferrable
timers even if the system/cpu is "busy" ?

Oleg.

