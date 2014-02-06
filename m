Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaBFCI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 21:08:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:35460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaBFCIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 21:08:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,790,1384329600"; 
   d="scan'208";a="478820782"
Message-ID: <52F2EE9E.4070905@intel.com>
Date: Thu, 06 Feb 2014 10:08:30 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 06/14] perf, core: always switch pmu specific data during
 context switch
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>	<1388728091-18564-7-git-send-email-zheng.z.yan@intel.com>	<CABPqkBQS=kSyRb0hb7DSTAOmUpB03_Cq70Wi1NvHj+DAQc4FVQ@mail.gmail.com>	<20140205175528.GF5002@laptop.programming.kicks-ass.net> <CABPqkBTB3B817LBnY2pu0uLMhjHzJa8fL6a--iKe-2bKUxFZpQ@mail.gmail.com>
In-Reply-To: <CABPqkBTB3B817LBnY2pu0uLMhjHzJa8fL6a--iKe-2bKUxFZpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:35 AM, Stephane Eranian wrote:
> On Wed, Feb 5, 2014 at 6:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, Feb 05, 2014 at 06:19:27PM +0100, Stephane Eranian wrote:
>>> On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>>> If two tasks were both forked from the same parent task, Events in their perf
>>>> task contexts can be the same. Perf core optimizes context switch oout in this
>>>> case.
>>>>
>>>> Previous patch inroduces pmu specific data. The data is task specific, so we
>>>> should switch the data even when context switch is optimized out.
>>>>
>>> Reviwed-by: Stephane Eranian <eranian@google.com>
>>
>> You should look again.. that xchg() is an atomic op and a total waste of
>> time since the assignment back onto ctx->task_ctx_data is non-atomic.
>>
>> Complete fail there.
>>
> I admit, it was not clear to me why the xchg().

Sorry. I forget why I used xhcg(), maybe save a few lines of code.

Regards
Yan, Zheng

> 
>>>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>>>> ---
>>>>  kernel/events/core.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>>>> index b6650ab..d6d8dea 100644
>>>> --- a/kernel/events/core.c
>>>> +++ b/kernel/events/core.c
>>>> @@ -2319,6 +2319,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
>>>>                         next->perf_event_ctxp[ctxn] = ctx;
>>>>                         ctx->task = next;
>>>>                         next_ctx->task = task;
>>>> +                       ctx->task_ctx_data = xchg(&next_ctx->task_ctx_data,
>>>> +                                                 ctx->task_ctx_data);
>>>>                         do_switch = 0;
>>>>
>>>>                         perf_event_sync_stat(ctx, next_ctx);
>>>> --
>>>> 1.8.4.2
>>>>

