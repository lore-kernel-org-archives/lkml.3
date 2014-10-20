Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaJTAIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:08:31 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61774 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaJTAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <20141019213534.GG23531@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com> <20141019213534.GG23531@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Oct 2014 17:08:08 -0700
Message-ID: <CALCETrX3XYGd+2x_W89wq5tkuMBNF5NxDa02ha=UzQhU2r6Khg@mail.gmail.com>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 2:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Oct 16, 2014 at 05:00:56PM -0700, Andy Lutomirski wrote:
>> The current cap_user_rdpmc code seems rather confused to me.  On x86,
>> *all* events set cap_user_rdpmc if the global rdpmc control is set.
>> But only x86_pmu events define .event_idx, so amd uncore events won't
>> actually expose their rdpmc index to userspace.
>>
>> Would it make more sense to add a flag PERF_X86_EVENT_RDPMC_PERMITTED
>> that gets set on all events created while rdpmc == 1, to change
>> x86_pmu_event_idx to do something like:
>>
>> if (event->hw.flags & PERF_X86_EVENT_RDPMC_PERMITTED)
>>   return event->hw.event_base_rdpmc + 1;
>> else
>>   return 0;
>>
>> and to change arch_perf_update_userpage cap_user_rdpmc to match
>> PERF_X86_EVENT_RDPMC_PERMITTED?
>>
>> Then we could ditch the static key and greatly simplify writes to the
>> rdpmc flag by just counting PERF_X86_EVENT_RDPMC_PERMITTED events.
>>
>> This would be a user-visible change on AMD, and I can't test it.
>
> I have AMD hardware to test this. But yes something like that seems
> fine.

Before I totally screw this up: is .event_idx used for anything except
userspace rdpmc?  There are a whole bunch of implementations of that
callback:

 - perf_event_idx_default seems fishy
 - power_pmu_event_idx seems even fishier
 - cpumsf_pmu_event_idx is the same as power_pmu_event_idx.
 - perf_swevent_event_idx returns 0.

etc.

x86 is the only implementation of arch_perf_update_userpage, which
makes me think that the .event_idx callback should just be removed and
that arch_perf_update_userpage should be responsible for filling it in
if needed.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
