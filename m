Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbaDXRzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:55:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbaDXRzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:55:04 -0400
Message-ID: <53594FF2.2010002@infradead.org>
Date: Thu, 24 Apr 2014 10:54:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>, tglx@linutronix.de,
        john.stultz@linaro.org
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        viresh.kumar@linaro.org
Subject: Re: [PATCH] timer_stats: add core information to event counters
References: <1398325667-27060-1-git-send-email-daniel.sangorrin@toshiba.co.jp> <1398325667-27060-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
In-Reply-To: <1398325667-27060-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/14 00:47, Daniel Sangorrin wrote:
> Add information specifying the CPU core where timer callbacks (events)
> were executed to the output of /proc/timer_stats.
> 
> Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
> Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
> ---
>  Documentation/timers/timer_stats.txt | 41 ++++++++++++++++++++----------------
>  kernel/time/timer_stats.c            | 20 ++++++++++--------
>  2 files changed, 34 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
> index 8abd40b..e54077a 100644
> --- a/Documentation/timers/timer_stats.txt
> +++ b/Documentation/timers/timer_stats.txt
> @@ -21,7 +21,7 @@ Linux system over a sample period:
>  - the name of the process which initialized the timer
>  - the function where the timer was initialized
>  - the callback function which is associated to the timer
> -- the number of events (callbacks)
> +- the number of events (callbacks) executed per core
>  
>  timer_stats adds an entry to /proc: /proc/timer_stats
>  
> @@ -45,23 +45,28 @@ readouts.
>  
>  Sample output of /proc/timer_stats:
>  
> -Timerstats sample period: 3.888770 s
> -  12,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
> -  15,     1 swapper          hcd_submit_urb (rh_timer_func)
> -   4,   959 kedac            schedule_timeout (process_timeout)
> -   1,     0 swapper          page_writeback_init (wb_timer_fn)
> -  28,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
> -  22,  2948 IRQ 4            tty_flip_buffer_push (delayed_work_timer_fn)
> -   3,  3100 bash             schedule_timeout (process_timeout)
> -   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
> -   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
> -   1,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
> -   1,  2292 ip               __netdev_watchdog_up (dev_watchdog)
> -   1,    23 events/1         do_cache_clean (delayed_work_timer_fn)
> -90 total events, 30.0 events/sec
> -
> -The first column is the number of events, the second column the pid, the third
> -column is the name of the process. The forth column shows the function which
> +Timer Stats Version: v0.3
> +Sample period: 4.365 s
> +Collection: inactive
> +     0,   4366,     0 swapper/1        tick_setup_sched_timer (tick_sched_timer)
> +  4366,      0,     1 swapper/0        tick_setup_sched_timer (tick_sched_timer)
> +     0,      5,  1132 sshd             sk_reset_timer (tcp_write_timer)
> +     0,      4,   515 apache2          schedule_hrtimeout_range_clock (hrtimer_wakeup)
> +    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
> +    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
> +    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
> +    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
> +    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
> +     0,      7,     0 swapper/1        sk_reset_timer (tcp_delack_timer)
> +     3,      4,     0 swapper/0        clocksource_watchdog (clocksource_watchdog)
> +    0D,     3D,    13 kworker/1:0      queue_delayed_work_on (delayed_work_timer_fn)
> +    3D,     0D,    22 kworker/0:1      queue_delayed_work_on (delayed_work_timer_fn)
> +     1,      0,    22 kworker/0:1      e1000_watchdog_task (e1000_watchdog)
> +8842 total events, 2025.658 events/sec
> +

Is the number of events in decimal or hex?  If in decimal, what do
0D and 3D mean?

> +The first comma-separated columns represent the number of events (one
> +column per present core), the next column the pid, and the next one is the
> +name of the process. The last column shows the function which
>  initialized the timer and in parenthesis the callback function which was

                                parentheses

>  executed on expiry.
>  


-- 
~Randy
