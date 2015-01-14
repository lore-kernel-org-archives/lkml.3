Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbbANRWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbbANRWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:22:10 -0500
Date: Wed, 14 Jan 2015 15:21:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <clark.williams@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] timer: upper bound on loops of __run_timers
 processing
Message-ID: <20150114172147.GA16570@amt.cnet>
References: <20141230195228.GA3057@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230195228.GA3057@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ping?

On Tue, Dec 30, 2014 at 05:52:28PM -0200, Marcelo Tosatti wrote:
> 
> Commit "timers: do not raise softirq unconditionally", allows for timer
> wheel processing (__run_timers) to be delayed for long periods of time.
> 
> The effect is that 
> 
> loops = jiffies - base->timer_jiffies
> 
> Can grow to very large values resulting in __run_timers taking hundreds
> of milliseconds to execute.
> 
> Fix by creating an upper bound on the number of loops to be processed.
> This allows a nohz=off kernel to achieve desired latencies.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index f59e18c..c128416 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1488,6 +1488,12 @@ void run_local_timers(void)
>  	}
>  #endif
>  
> +	if (time_after_eq(jiffies, base->timer_jiffies)) {
> +		unsigned long jiffies_delta = jiffies - base->timer_jiffies;
> +		if (jiffies_delta > TVR_SIZE)
> +			raise_softirq(TIMER_SOFTIRQ);
> +	}
> +
>  	if (!base->active_timers)
>  		goto out;
>  
