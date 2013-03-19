Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3CSMuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:50:11 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:36140 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3CSMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <1363696984.22553.41.camel@laptop>
References: <20130318134645.GA3278@quad>
	<1363696984.22553.41.camel@laptop>
Date: Tue, 19 Mar 2013 13:50:08 +0100
Message-ID: <CABPqkBSmVzk=0nvHiuk-+XSfNX8ODXWKeJ+jUu2482=NvMoghg@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Salman Qazi <sqazi@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 1:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-03-18 at 14:46 +0100, Stephane Eranian wrote:
>>
>> This patch fixes an uninitialized pt_regs struct in drain BTS
>> function. The pt_regs struct is propagated all the way to the
>> code_get_segment() function from perf_instruction_pointer()
>> and may get garbage.
>>
>> We cannot simply inherit the actual pt_regs from the interrupt
>> because BTS must be flushed on context-switch or when the associated
>> event is disabled. And there we do not have a pt_regs handy.
>>
>> Setting pt_regs to all zeroes may not be the best option but it is
>> not clear what else to do given where the drain_bts_buffer() is called
>> from.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> index b05a575..208f0c8 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -302,6 +302,8 @@ int intel_pmu_drain_bts_buffer(void)
>>       struct perf_sample_data data;
>>       struct pt_regs regs;
>>
>> +     memset(&regs, 0, sizeof(regs));
>> +
>>       if (!event)
>>               return 0;
>>
>
> Should we not replace:
>
>         regs.ip     = 0;
>
> with that memset? It avoids the memset work in a few cases and removes
> the then superfluous clearing of the IP field.
>
We could drop it because it's covered by the memset().

The issue here was that you eventually end up in code_segment_base() which
looks at other uninitialized fields in pt_regs and may cause breakage.
