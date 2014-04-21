Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaDUXU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:20:56 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34452 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaDUXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:20:54 -0400
Date: Tue, 22 Apr 2014 01:20:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linaro-networking@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 14/19] tick-sched: add comment about 'idle_active' in
 tick_nohz_idle_exit()
Message-ID: <20140421232047.GA5579@localhost.localdomain>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
 <387f4713d52595f055620f39dc7a0edad7d4d8bf.1398072824.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <387f4713d52595f055620f39dc7a0edad7d4d8bf.1398072824.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 03:25:10PM +0530, Viresh Kumar wrote:
> The sequence of calls for dynticks CPUs is a bit confusing. Add a comment in
> tick_nohz_idle_exit() to mention it clearly. All information required is in
> commit and this conversation with Frederic.
> 
> https://lkml.org/lkml/2014/4/10/355
> 
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/time/tick-sched.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 71f64ee..c3aed50 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -922,6 +922,22 @@ void tick_nohz_idle_exit(void)
>  
>  	ts->inidle = 0;
>  
> +	/*
> +	 * Can idle_active be false here?
> +	 * Ideally this would be the sequence of calls:
> +	 * - tick_nohz_idle_enter(), i.e. idle_active = true;
> +	 * - local_irq_disable()
> +	 * - IDLE
> +	 * - wake up due to IPI or other interrupt
> +	 * - local_irq_enable()
> +	 * - tick_nohz_irq_enter(), i.e. idle_active = false;
> +	 * - tick_nohz_irq_exit(), i.e. idle_active = true; This is not called
> +	 *   in case of IPI's as need_resched() will prevent that in
> +	 *   tick_irq_exit(), as we don't need to account any more for idle time
> +	 *   or try to enter dyntics mode (We are going to exit idle state).
> +	 *
> +	 * - tick_nohz_idle_exit()
> +	 */
>  	if (ts->idle_active || ts->tick_stopped)
>  		now = ktime_get();

It's still over-detailed. Much of the above is easily deduced after common review. OTOH
I proposed to summarize there: https://lkml.org/lkml/2014/4/11/334
The below disambiguates it a bit further.

Now it's eventually getting as big as your comment ;-)


          /*
           * ts->idle_active drives the idle time which typically elapses in the idle loop
           * but breaks on IRQs interrupting idle loop.
           *
           * Hence ts->idle_active can be 1 here if we exit the idle loop without the help of
           * an IRQ. OTOH it can be 0 on idle exit if a wake up IPI pulled the CPU out of
           * the idle loop. Since we know that we'll be exiting the idle task after the wake
           * up IPI, all the pending idle sleep time is flushed on irq entry and no more is
           * accounted further thanks to the need_resched() check on irq_exit().
           */

Thanks.
