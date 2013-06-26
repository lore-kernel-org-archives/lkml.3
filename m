Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3FZHfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:35:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45644 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3FZHfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130624084414.GJ28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<1371824448-7306-2-git-send-email-eranian@google.com>
	<20130624084414.GJ28407@twins.programming.kicks-ass.net>
Date: Wed, 26 Jun 2013 09:35:44 +0200
Message-ID: <CABPqkBR_WTwC=oFO=eHuNgr0auZoKJPNuzC7q0v4XJyvbnbi9A@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf,x86: disable PEBS-LL in intel_pmu_pebs_disable()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:44 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jun 21, 2013 at 04:20:41PM +0200, Stephane Eranian wrote:
>> Make sure intel_pmu_pebs_disable() and intel_pmu_pebs_enable()
>> are symmetrical w.r.t. PEBS-LL and precise store.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> This seems unrelated to the actual patch series and should still go in.
>
Yes, it is unrelated. I just ran into it while testing the patch.
It was missing since the beginning, it seems.

>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> index ed3e553..3065c57 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -653,6 +653,12 @@ void intel_pmu_pebs_disable(struct perf_event *event)
>>       struct hw_perf_event *hwc = &event->hw;
>>
>>       cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
>> +
>> +     if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
>> +             cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
>> +     else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
>> +             cpuc->pebs_enabled &= ~(1ULL << 63);
>> +
>>       if (cpuc->enabled)
>>               wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
>>
>> --
>> 1.8.1.2
>>
