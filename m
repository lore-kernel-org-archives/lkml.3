Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3ETRzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab3ETRzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:55:18 -0400
Date: Mon, 20 May 2013 13:54:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 8/8] watchdog: Fix internal state with boot user
 disabled watchdog
Message-ID: <20130520175454.GK133453@redhat.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
 <1369065716-22801-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369065716-22801-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 06:01:56PM +0200, Frederic Weisbecker wrote:
> When the watchdog is disabled through the 'nmi_watchdog=0'
> boot parameter, the watchdog_running internal state isn't
> cleared. Hence further enablements through sysctl/procfs
> are ignored because the subsystem spuriously thinks it's
> already running.
> 
> Initialize it properly on boot.

Looks fine to me.  Can't think of a case where this breaks something.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/watchdog.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 10776fe..3fa5df20 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -31,7 +31,7 @@
>  
>  int watchdog_user_enabled = 1;
>  int __read_mostly watchdog_thresh = 10;
> -static int __read_mostly watchdog_running = 1;
> +static int __read_mostly watchdog_running;
>  static u64 __read_mostly sample_period;
>  
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
> @@ -545,10 +545,10 @@ void __init lockup_detector_init(void)
>  {
>  #ifdef CONFIG_NO_HZ_FULL
>  	watchdog_user_enabled = 0;
> -	watchdog_running = 0;
>  	pr_warning("Disabled lockup detectors by default because of full dynticks\n");
>  	pr_warning("You can overwrite that with 'sysctl -w kernel.watchdog=1'\n");
>  #endif
> +	watchdog_running = watchdog_user_enabled;
>  	set_sample_period();
>  	if (smpboot_register_percpu_thread(&watchdog_threads)) {
>  		pr_err("Failed to create watchdog threads, disabled\n");
> -- 
> 1.7.5.4
> 
