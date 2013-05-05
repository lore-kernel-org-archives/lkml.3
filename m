Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3EETyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 15:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab3EETyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 15:54:35 -0400
Message-ID: <5186B8F1.9090105@redhat.com>
Date: Sun, 05 May 2013 15:54:25 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, prarit@redhat.com
CC: tip-bot for Thomas Gleixner <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu down
References: <alpine.LFD.2.02.1305031451561.2886@ionos> <tip-ae7868e241c015aadc8632d9fe633a102a5918f6@git.kernel.org>
In-Reply-To: <tip-ae7868e241c015aadc8632d9fe633a102a5918f6@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/05/2013 02:20 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  ae7868e241c015aadc8632d9fe633a102a5918f6
> Gitweb:     http://git.kernel.org/tip/ae7868e241c015aadc8632d9fe633a102a5918f6
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Fri, 3 May 2013 15:02:50 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sun, 5 May 2013 08:15:11 +0200
> 
> tick: Cleanup NOHZ per cpu data on cpu down
> 
> Prarit reported a crash on CPU offline/online. The reason is that on
> CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
> up. If at cpu online an interrupt happens before the per cpu tick
> device is registered the irq_enter() check potentially sees stale data
> and dereferences a NULL pointer.
> 
> Cleanup the data after the cpu is dead.
> 
> Reported-by: Prarit Bhargava <prarit@redhat.com>
> Cc: stable@vger.kernel.org
> Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305031451561.2886@ionos
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/tick-common.c   | 1 +
>  kernel/time/tick-internal.h | 6 ++++++
>  kernel/time/tick-sched.c    | 7 +++++++
>  3 files changed, 14 insertions(+)

Whoa -- I thought I said I'll test this first.  It doesn't work :( so that means
something else is wrong ... I'm in the middle of debug ATM.

P.

> 
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 6176a3e..29b765d 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -387,6 +387,7 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
>  		tick_shutdown_broadcast_oneshot(dev);
>  		tick_shutdown_broadcast(dev);
>  		tick_shutdown(dev);
> +		tick_shutdown_nohz(dev);
>  		break;
>  
>  	case CLOCK_EVT_NOTIFY_SUSPEND:
> diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
> index f0299ea..9644b29 100644
> --- a/kernel/time/tick-internal.h
> +++ b/kernel/time/tick-internal.h
> @@ -144,3 +144,9 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
>  #endif
>  
>  extern void do_timer(unsigned long ticks);
> +
> +#ifdef CONFIG_NO_HZ
> +extern void tick_shutdown_nohz(unsigned int *cpup);
> +#else
> +static inline void tick_shutdown_nohz(unsigned int *cpup) { }
> +#endif
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 225f8bf..e985ccd 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -797,6 +797,13 @@ static inline void tick_check_nohz(int cpu)
>  	}
>  }
>  
> +void tick_shutdown_nohz(unsigned int *cpup)
> +{
> +	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +
> +	memset(ts, 0, sizeof(*ts));
> +}
> +
>  #else
>  
>  static inline void tick_nohz_switch_to_nohz(void) { }
