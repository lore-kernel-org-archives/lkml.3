Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759Ab3HHPCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:02:22 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46029 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3HHPCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:02:19 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable reprogramming in remove_hrtimer
From: "ethan.zhao" <ethan.kernel@gmail.com>
In-Reply-To: <1375774140.5412.9.camel@marge.simpson.net>
Date: Thu, 8 Aug 2013 23:02:06 +0800
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BBA29515-CD89-47C5-B155-B71A6F6632DC@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com> <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de> <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com> <20130730093519.GP3008@twins.programming.kicks-ass.net> <1375774140.5412.9.camel@marge.simpson.net>
To: Mike Galbraith <bitbucket@online.de>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ÔÚ 2013-8-6£¬ÏÂÎç3:29£¬Mike Galbraith <bitbucket@online.de> Ð´µÀ£º

> +int sched_needs_cpu(int cpu)
> +{
> +	return  cpu_rq(cpu)->avg_idle < sysctl_sched_migration_cost;
> +}
> +
> #else /* CONFIG_NO_HZ_COMMON */
> 
> static inline bool got_nohz_idle_kick(void)
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -548,7 +548,7 @@ static ktime_t tick_nohz_stop_sched_tick
> 		time_delta = timekeeping_max_deferment();
> 	} while (read_seqretry(&jiffies_lock, seq));
> 
> -	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
> +	if (sched_needs_cpu(cpu) || rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
> 	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
> 		next_jiffies = last_jiffies + 1;
> 		delta_jiffies = 1;

If the performace regression was caused by too much expensive clock device reprogramming and too frequent entering /exiting of C-states¡­   this patch should work.
except the following result is almost always false under 3.11-rc3 code.

> return  cpu_rq(cpu)->avg_idle < sysctl_sched_migration_cost;



Ethan

