Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbaGOX4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:56:47 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60098 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaGOX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140715142939.GJ9918@twins.programming.kicks-ass.net>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
	<1405384304-26816-3-git-send-email-eranian@google.com>
	<20140715142939.GJ9918@twins.programming.kicks-ass.net>
Date: Wed, 16 Jul 2014 01:56:43 +0200
Message-ID: <CABPqkBRaxyeXBGNZ8J1=XhfCyuhOhuWtz1spG-eVBE1Jgy-14A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] perf/x86: add support for sampling PEBS machine
 state registers
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 4:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 15, 2014 at 02:31:41AM +0200, Stephane Eranian wrote:
>> PEBS can capture machine state regs at retiremnt of the sampled
>> instructions. When precise sampling is enabled on an event, PEBS
>> is used, so substitute the interrupted state with the PEBS state.
>> Note that not all registers are captured by PEBS. Those missing
>> are replaced by the interrupt state counter-parts.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> index 980970c..d612bcd 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -925,6 +925,25 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>>       regs.bp = pebs->bp;
>>       regs.sp = pebs->sp;
>>
>> +     if (sample_type & PERF_SAMPLE_REGS_INTR) {
>> +             regs.ax = pebs->ax;
>> +             regs.bx = pebs->bx;
>> +             regs.cx = pebs->cx;
>> +             regs.si = pebs->si;
>> +             regs.di = pebs->di;
>> +
>> +             regs.r8 = pebs->r8;
>> +             regs.r9 = pebs->r9;
>> +             regs.r10 = pebs->r10;
>> +             regs.r11 = pebs->r11;
>> +             regs.r12 = pebs->r12;
>> +             regs.r13 = pebs->r13;
>> +             regs.r14 = pebs->r14;
>> +             regs.r14 = pebs->r15;
>> +
>> +             data.regs_intr.regs = &regs;
>
> This last assignment is superfluous. Note how you previous patch's
> perf_sample_regs_intr() is unconditionally writing its .regs value, and
> in turn, perf_sample_regs_intr() is called unconditionally from
> perf_prepare_sample().
>
Ok, I will remove it.
