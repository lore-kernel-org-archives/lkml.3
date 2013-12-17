Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3LQXcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:32:33 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48485 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3LQXcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:32:32 -0500
Date: Tue, 17 Dec 2013 15:32:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 12/13] nohz: Allow all CPUs outside nohz_full range to do
 timekeeping
Message-ID: <20131217233228.GF19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-13-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-13-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121723-7164-0000-0000-00000458967B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:31PM +0100, Frederic Weisbecker wrote:
> Now that we have all the infrastructure in place and ready to support
> timekeeping duty balanced across every non full dynticks CPUs, we can
> hereby extend the timekeeping duty affinity.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Alex Shi <alex.shi@linaro.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> ---
>  include/linux/tick.h | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index bd3c32e..07c02e8 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -203,15 +203,7 @@ static inline int tick_timekeeping_default_cpu(void)
>   */
>  static inline bool tick_timekeeping_cpu(int cpu)
>  {
> -	/*
> -	 * If there are full dynticks CPUs around,
> -	 * CPU 0 must stay periodic to update timekeeping.
> -	 */
> -	if (tick_nohz_full_enabled())
> -		return cpu == 0;
> -
> -	/* Otherwise any CPU is elligible for timekeeping duty */
> -	return true;
> +	return !tick_nohz_full_cpu(cpu);

OK, I guess the future is already here.  ;-)

Is it still OK for RCU to kick tick_do_timer_cpu?  Or are there race
conditions that could result in the wrong CPU being kicked?  Or is
there some guarantee that I missed that says that the timekeeping
CPU cannot change while in RCU_SYSIDLE_FULL_NOTED state?

							Thanx, Paul

>  }
> 
>  extern void tick_nohz_init(void);
> -- 
> 1.8.3.1
> 

