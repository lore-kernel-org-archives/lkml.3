Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaFDNAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:00:12 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43062 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaFDNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:00:09 -0400
Message-ID: <538F186A.2060801@linaro.org>
Date: Wed, 04 Jun 2014 15:00:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
CC: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] sched,trace: Add a tracepoint for remote wakeups
 via polling
References: <cover.1401841482.git.luto@amacapital.net> <c932da32f908d0c0c9ea5b7f7d5fff540eb8fec6.1401841482.git.luto@amacapital.net>
In-Reply-To: <c932da32f908d0c0c9ea5b7f7d5fff540eb8fec6.1401841482.git.luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 02:29 AM, Andy Lutomirski wrote:
> Remote wakeups of polling CPUs are a valuable performance
> improvement; add a tracepoint to make it much easier to verify that
> they're working.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

I don't think this trace makes sense. The polling state is x86 only and 
this trace is in the generic code.

Furthermore, you may be not in polling state but in the idle mainloop 
before or after the idle state, so the trace will be wrong for the 
purpose you are aiming.

IMO, the right place would be in 'poll_idle' but why add such trace ?

If, on x86, we exit poll_idle, we have the idle state exit trace. The 
missing information would be the origin of the 'wakeup' (irq or ipi or 
nothing). The missing informations are the IPI traces [1].

And as a sidenote, the polling state could be rare on a system with a 
cpuidle driver, it should be much more easy to restrict the idle states 
to 'poll' only and check there are no IPI_WAKEUP, no ?

   -- Daniel

[1] 
http://lists.linaro.org/pipermail/linaro-kernel/2013-November/008581.html

> ---
>   include/trace/events/sched.h | 20 ++++++++++++++++++++
>   kernel/sched/core.c          |  4 ++++
>   2 files changed, 24 insertions(+)
>
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 67e1bbf..08f8632 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -530,6 +530,26 @@ TRACE_EVENT(sched_swap_numa,
>   			__entry->dst_pid, __entry->dst_tgid, __entry->dst_ngid,
>   			__entry->dst_cpu, __entry->dst_nid)
>   );
> +
> +/*
> + * Tracepoint for waking a polling cpu without an IPI.
> + */
> +TRACE_EVENT(sched_wake_polling_cpu,
> +
> +	TP_PROTO(int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	cpu	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu	= cpu;
> +	),
> +
> +	TP_printk("cpu=%d", __entry->cpu)
> +);
>   #endif /* _TRACE_SCHED_H */
>
>   /* This part must be outside protection */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 321d800..18bebfc 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -564,6 +564,8 @@ void resched_task(struct task_struct *p)
>
>   	if (set_nr_and_not_polling(p))
>   		smp_send_reschedule(cpu);
> +	else
> +		trace_sched_wake_polling_cpu(cpu);
>   }
>
>   void resched_cpu(int cpu)
> @@ -647,6 +649,8 @@ static void wake_up_idle_cpu(int cpu)
>   	smp_mb();
>   	if (!tsk_is_polling(rq->idle))
>   		smp_send_reschedule(cpu);
> +	else
> +		trace_sched_wake_polling_cpu(cpu);
>   }
>
>   static bool wake_up_full_nohz_cpu(int cpu)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

