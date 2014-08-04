Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaHDOb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaHDOb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:31:26 -0400
Date: Mon, 4 Aug 2014 10:31:22 -0400
From: Don Zickus <dzickus@redhat.com>
To: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 2/2] softlockup: make detector be aware of task switch of
 processes hogging cpu
Message-ID: <20140804143122.GF87407@redhat.com>
References: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
 <1407137779-19129-2-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407137779-19129-2-git-send-email-chaiw.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:36:19PM +0800, chai wen wrote:
> 
> For now, soft lockup detector warns once for each case of process softlockup.
> But the thread 'watchdog/n' may can not always get cpu at the time slot between
> the task switch of two processes hogging that cpu.
> This case is a false negative of "warn only once for a process", as there may be
> a different process that is going to hog the cpu. Is is better for detector to
> be aware of it. 

I am not sure I fully understand the problem resolved.

>From the changelog I understood that two processes bouncing back and forth
could hog the cpu and could create a 'false negative' (a situation not
reported but should).

But looking at the patch below I was a little confused on the
__touch_watchdog addition.  See below:

> 
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
> ---
>  kernel/watchdog.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4c2e11c..908050c 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -42,6 +42,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
>  static DEFINE_PER_CPU(bool, soft_watchdog_warn);
>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
>  static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
> +static DEFINE_PER_CPU(pid_t, softlockup_warn_pid_saved);
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  static DEFINE_PER_CPU(bool, hard_watchdog_warn);
>  static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
> @@ -317,6 +318,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  	 */
>  	duration = is_softlockup(touch_ts);
>  	if (unlikely(duration)) {
> +		pid_t pid = task_pid_nr(current);
> +
>  		/*
>  		 * If a virtual machine is stopped by the host it can look to
>  		 * the watchdog like a soft lockup, check to see if the host
> @@ -326,8 +329,18 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  			return HRTIMER_RESTART;
>  
>  		/* only warn once */
> -		if (__this_cpu_read(soft_watchdog_warn) == true)
> +		if (__this_cpu_read(soft_watchdog_warn) == true) {
> +			/*
> +			 * soft lockup detector should be aware of that there
> +			 * may be a task-swicth of two different processes
> +			 * hogging the cpu continously
> +			 */
> +			if (__this_cpu_read(softlockup_warn_pid_saved) != pid) {
> +				__this_cpu_write(soft_watchdog_warn, false);
> +				__touch_watchdog();
> +			}

The above piece is what I am trying to understand.  Are you saying that
when two different processes are hogging the cpu, undo the
soft_watchdog_warn and allow the second pid to be reported?

Just trying to understand the problem and see if this is the right
approach (because 3 or more processes could cause the same problem???).

Cheers,
Don

>  			return HRTIMER_RESTART;
> +		}
>  
>  		if (softlockup_all_cpu_backtrace) {
>  			/* Prevent multiple soft-lockup reports if one cpu is already
> @@ -342,7 +355,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  
>  		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
>  			smp_processor_id(), duration,
> -			current->comm, task_pid_nr(current));
> +			current->comm, pid);
> +		__this_cpu_write(softlockup_warn_pid_saved, pid);
>  		print_modules();
>  		print_irqtrace_events(current);
>  		if (regs)
> -- 
> 1.7.1
> 
