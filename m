Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3KOKld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:41:33 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64578 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3KOKl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:41:28 -0500
MIME-Version: 1.0
In-Reply-To: <20131115103405.GA18264@gmail.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
	<20131115063457.GB12442@gmail.com>
	<CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
	<20131115103405.GA18264@gmail.com>
Date: Fri, 15 Nov 2013 11:41:27 +0100
Message-ID: <CABPqkBTAWSSY8meG7MBm6+3LUEQ31nP83CPvDG_nsi13s7ALJA@mail.gmail.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Fri, Nov 15, 2013 at 7:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Stephane Eranian <eranian@google.com> wrote:
>> >
>> >> Jiri,
>> >>
>> >> I was trying the grouping support in perf stat and I was surprised
>> >> to see that if I create a group that is too big to be scheduled, and
>> >> where only N out of P events can fit, perf stat still yields counts
>> >> for the N events. I was expecting 0 counts or <not supported>.
>> >>
>> >> The kernel semantic is to schedule all the events in a group or
>> >> none. Perf does something different and this is confusing. If you
>> >> use explicit grouping then I think you want to group to fail if not
>> >> all the events can be scheduled:
>> >>
>> >> On an IvyBridge:
>> >> $ perf stat --g -e
>> >> '{cycles,instructions,branches,branches,branches,branches,branches}'
>> >> noploop 1
>> >>      3 229 417 079 cycles
>> >>      3 223 919 023 instructions              #    1,00  insns per cycle
>> >>      3 220 868 098 branches
>> >>      3 220 868 098 branches
>> >>      3 220 868 098 branches
>> >>      3 220 868 098 branches
>> >>    <not supported> branches
>> >>
>> >> I think it should be: <not supported> for all events.
>> >
>> > Btw., does the kernel side currently support discovery of such
>> > impossible group scheduling constraints at group setup time? If not
>> > then it probably should and it should reject them straight away.
>>
>> The kernel does validate events as they are added to a group. That's
>> why we have validate_event(), validate_group() and the fake_cpuc
>> mode.
>
> So the problem here isn't really that the kernel doesn't tell
> userspace about it, but that perf stat does not interpret the
> validation result properly.
>
Correct.

> That brings up an interesting question: what is better for users, if
> we schedule as many as we can and say 'not supported' to the rest
> (current behavior), or if we fail the whole group?
>
> I'd say that the default behavior should be what Jiri implemented: get
> the most out of the situation and inform. But you are right in that
> 'forcing' all elements of a group to be valid should be possible as
> well - if a special perf stat option or event format is used.
>
> Even in that second case it shouldn't say <unsupported> for everything
> in the result, but should deny the run immediately and return with an
> error, and should tell the user how many events in the group fit and
> which ones didn't.
>
Fine with me.
