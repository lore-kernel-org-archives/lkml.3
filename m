Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3FXIB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:01:28 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43147 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3FXIB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130624074656.GG28407@twins.programming.kicks-ass.net>
References: <20130620164254.GA3556@quad>
	<20130624074656.GG28407@twins.programming.kicks-ass.net>
Date: Mon, 24 Jun 2013 10:01:26 +0200
Message-ID: <CABPqkBRpCmDH-TJgAYCDUF4bONuY1mtSiRmRTnbxduWj=+EsEA@mail.gmail.com>
Subject: Re: [PATCH v2] perf,x86: Fix shared register mutual exclusion enforcement
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        vincent.weaver@maine.edu, Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 9:46 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 20, 2013 at 06:42:54PM +0200, Stephane Eranian wrote:
>>
>> This patch fixes a problem with the shared registers mutual
>> exclusion code and incremental event scheduling by the
>> generic perf_event code.
>>
>> There was a bug whereby the mutual exclusion on the shared
>> registers was not enforced because of incremental scheduling
>> abort due to event constraints. As an example on Intel
>> Nehalem, consider the following events:
>>
>> group1= L1D_CACHE_LD:E_STATE,OFFCORE_RESPONSE_0:PF_RFO,L1D_CACHE_LD:I_STATE
>> group2= L1D_CACHE_LD:I_STATE
>>
>> The L1D_CACHE_LD event can only be measured by 2 counters. Yet, there
>> are 3 instances here. The first group can be scheduled and is committed.
>> Then, the generic code tries to schedule group2 and this fails (because
>> there is no more counter to support the 3rd instance of L1D_CACHE_LD).
>> But in x86_schedule_events() error path, put_event_contraints() is invoked
>> on ALL the events and not just the ones that just failed. That causes the
>> "lock" on the shared offcore_response MSR to be released. Yet the first group
>> is actually scheduled and is exposed to reprogramming of that shared msr by
>> the sibling HT thread. In other words, there is no guarantee on what is
>> measured.
>>
>> This patch fixes the problem by tagging committed events with the
>> PERF_X86_EVENT_COMMITTED tag. In the error path of x86_schedule_events(),
>> only the events NOT tagged have their constraint released. The tag
>> is eventually removed when the event in descheduled.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> OK, so I 'accidentally' read the patch again; and noticed something.
>
> In your case above; the get/put constraints are still fully matched.
> That is; the first group, which was successful, will not have done a put
> yet. So a subsequent get+put should still leave us with a positive 'ref'
> count and not undo things.
>
You are missing the error path in schedule_events():

 if (!assign || num) {

                for (i = 0; i < n; i++) {
                        if (x86_pmu.put_event_constraints)
                                x86_pmu.put_event_constraints(cpuc,
cpuc->event_list[i]);
                }

        }

That one wipes out on get() even on events that were correctly
schedule in the previous
invocation. So here group2 fails, but it should not release the
constraints from group1.

> Only once these events pass through x86_pmu_del() will they get a final
> put and the 'ref' count will drop to 0.
>
> Now the problem seems to be the get/put things don't actually count
> properly.
>
> However, if we look at __intel_shared_reg_{get,put}_constraints() there
> is a refcount in there; namely era->ref; however we don't appear to
> clear reg->alloc based on it.
>
The era->ref is not used to ref count the number of successful attempts
at scheduling. It is used to count the number of CPU sharing the resource.
So it goes from 0, 1, to 2. You can invoke schedule_events() many more
times. The reg->alloc is a bypass, to avoid checking the shared reg
again and again if it succeeded once.

For a while I thought I could leverage the era->ref to account the get/put.
But it does not work. Because the of the put().


> Should we?
