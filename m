Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaHRJD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:03:26 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:33118 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:03:24 -0400
Date: Mon, 18 Aug 2014 11:03:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/5] softlockup: make detector be aware of task switch of
 processes hogging cpu
Message-ID: <20140818090319.GA25495@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407768567-171794-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Don Zickus <dzickus@redhat.com> wrote:

> From: chai wen <chaiw.fnst@cn.fujitsu.com>
> 
> For now, soft lockup detector warns once for each case of process softlockup.
> But the thread 'watchdog/n' may not always get the cpu at the time slot between
> the task switch of two processes hogging that cpu to reset soft_watchdog_warn.
> 
> An example would be two processes hogging the cpu.  Process A causes the
> softlockup warning and is killed manually by a user.  Process B immediately
> becomes the new process hogging the cpu preventing the softlockup code from
> resetting the soft_watchdog_warn variable.
> 
> This case is a false negative of "warn only once for a process", as there may
> be a different process that is going to hog the cpu.  Resolve this by
> saving/checking the pid of the hogging process and use that to reset
> soft_watchdog_warn too.
> 
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
> [modified the comment and changelog to be more specific]
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  kernel/watchdog.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4c2e11c..6d0a891 100644
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
> @@ -326,8 +329,20 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  			return HRTIMER_RESTART;
>  
>  		/* only warn once */
> -		if (__this_cpu_read(soft_watchdog_warn) == true)
> +		if (__this_cpu_read(soft_watchdog_warn) == true) {
> +
> +			/*
> +			 * Handle the case where multiple processes are
> +			 * causing softlockups but the duration is small
> +			 * enough, the softlockup detector can not reset
> +			 * itself in time.  Use pids to detect this.
> +			 */
> +			if (__this_cpu_read(softlockup_warn_pid_saved) != pid) {

So I agree with the motivation of this improvement, but is this 
implementation namespace-safe?

Thanks,

	Ingo
