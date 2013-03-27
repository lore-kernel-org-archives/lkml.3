Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3C0GCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:02:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50414 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3C0GCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:02:13 -0400
X-AuditID: 9c93016f-b7cecae000004cf8-bd-51528b63a394
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: asm/8267
References: <20130324115556.GA4866@pd.tnic> <20130324155924.GB4866@pd.tnic>
	<20130326183452.GC27518@pd.tnic>
Date: Wed, 27 Mar 2013 15:02:10 +0900
In-Reply-To: <20130326183452.GC27518@pd.tnic> (Borislav Petkov's message of
	"Tue, 26 Mar 2013 19:34:52 +0100")
Message-ID: <87ip4dgz31.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Tue, 26 Mar 2013 19:34:52 +0100, Borislav Petkov wrote:
> On Sun, Mar 24, 2013 at 04:59:24PM +0100, Borislav Petkov wrote:
>> On Sun, Mar 24, 2013 at 12:55:56PM +0100, Borislav Petkov wrote:
>> > Hi,
>> > 
>> > so I was tracing a small .c program like so:
>> > 
>> > $ ./perf record ~/test/asm
>> > 
>> > and here's what got spewed in dmesg. Kernel is plain -rc4. Any pending
>> > fixes in tip I should try?
>> > 
>> > [ 3700.194208] BUG: using smp_processor_id() in preemptible [00000000] code: asm/8333
>> > [ 3700.194226] caller is perf_event_task_ctx+0x55/0x140
>> 
>> Ok, here's the call stack I was able to reconstruct:
>> 
>> perf_event_exit_task()
>> |->perf_event_exit_task_context()
>>    |-> perf_event_task()
>>        |-> perf_event_task_event()
>> 	   |-> perf_event_task_ctx()
>> 	       |-> perf_event_task_match()
>> 		   |-> event_filter_match()
>> 		       |-> smp_processor_id() -> debug_smp_processor_id()
>
> Ok, jolsa just rootcaused it: It is caused by
> d610d98b5de6860feb21539726e9af7c9094151c calling perf_event_task_ctx()
> outside of the preempt-safe protection.

Oops, my bad.  Forgot to enable CONFIG_DEBUG_PREEMPT when testing. :(

>
> There's a straightforward fix below, what to people think?

Looks okay to me.  Thanks for fixing this!
Namhyung

>
> --
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 7b4a55d41efc..f3bb3384a106 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4455,8 +4455,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
>  next:
>  		put_cpu_ptr(pmu->pmu_cpu_context);
>  	}
> +
> +	preempt_disable();
>  	if (task_event->task_ctx)
>  		perf_event_task_ctx(task_event->task_ctx, task_event);
> +	preempt_enable();
>  
>  	rcu_read_unlock();
>  }
