Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAOUeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:34:07 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55312 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaAOUeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:34:04 -0500
X-Originating-IP: 173.246.103.110
Date: Wed, 15 Jan 2014 12:33:55 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
 latency for empty list
Message-ID: <20140115203354.GC11147@jtriplet-mobl1>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 09:20:46PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The __run_timers() function currently steps through the list one jiffy at
> a time in order to update the timer wheel.  However, if the timer wheel
> is empty, no adjustment is needed other than updating ->timer_jiffies.
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
> index 2245b7374c3d..295837e5e011 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -338,6 +338,17 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
>  }
>  EXPORT_SYMBOL_GPL(set_timer_slack);
>  
> +static bool catchup_timer_jiffies(struct tvec_base *base)
> +{
> +#ifdef CONFIG_NO_HZ_FULL
> +	if (!base->all_timers) {
> +		base->timer_jiffies = jiffies;
> +		return 1;
> +	}
> +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> +	return 0;
> +}

In a function with return type "bool", please use true/false, not 1/0.

Please also document the semantic of the return value.

- Josh Triplett
