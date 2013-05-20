Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3ETRxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:53:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab3ETRxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:53:16 -0400
Date: Mon, 20 May 2013 13:52:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/8] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130520175229.GI133453@redhat.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
 <1369065716-22801-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369065716-22801-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 06:01:51PM +0200, Frederic Weisbecker wrote:
> When the watchdog runs, it prevents the full dynticks
> CPUs from stopping their tick because the hard lockup
> detector uses perf events internally, which in turn
> rely on the periodic tick.
> 
> Since this is a rather confusing behaviour that is not
> easy to track down and identify for those who want to
> test CONFIG_NO_HZ_FULL, let's default disable the
> watchdog on boot time when full dynticks is enabled.
> 
> The user can still enable it later on runtime using
> proc or sysctl.

I thought Peter committed a patch to perf so that this isn't needed any
more?

Cheers,
Don

> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Don Zickus <dzickus@redhat.com>
> ---
>  kernel/watchdog.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 05039e3..7e1a021 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -543,6 +543,12 @@ static struct smp_hotplug_thread watchdog_threads = {
>  
>  void __init lockup_detector_init(void)
>  {
> +#ifdef CONFIG_NO_HZ_FULL
> +	watchdog_enabled = 0;
> +	watchdog_disabled = 1;
> +	pr_warning("Disabled lockup detectors by default because of full dynticks\n");
> +	pr_warning("You can overwrite that with 'sysctl -w kernel.watchdog=1'\n");
> +#endif
>  	set_sample_period();
>  	if (smpboot_register_percpu_thread(&watchdog_threads)) {
>  		pr_err("Failed to create watchdog threads, disabled\n");
> -- 
> 1.7.5.4
> 
