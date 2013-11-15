Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3KOJYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:24:09 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34927 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3KOJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:24:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131115063457.GB12442@gmail.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
	<20131115063457.GB12442@gmail.com>
Date: Fri, 15 Nov 2013 10:24:02 +0100
Message-ID: <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
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

On Fri, Nov 15, 2013 at 7:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> Jiri,
>>
>> I was trying the grouping support in perf stat and I was surprised
>> to see that if I create a group that is too big to be scheduled, and
>> where only N out of P events can fit, perf stat still yields counts
>> for the N events. I was expecting 0 counts or <not supported>.
>>
>> The kernel semantic is to schedule all the events in a group or
>> none. Perf does something different and this is confusing. If you
>> use explicit grouping then I think you want to group to fail if not
>> all the events can be scheduled:
>>
>> On an IvyBridge:
>> $ perf stat --g -e
>> '{cycles,instructions,branches,branches,branches,branches,branches}'
>> noploop 1
>>      3 229 417 079 cycles
>>      3 223 919 023 instructions              #    1,00  insns per cycle
>>      3 220 868 098 branches
>>      3 220 868 098 branches
>>      3 220 868 098 branches
>>      3 220 868 098 branches
>>    <not supported> branches
>>
>> I think it should be: <not supported> for all events.
>
> Btw., does the kernel side currently support discovery of such
> impossible group scheduling constraints at group setup time? If not
> then it probably should and it should reject them straight away.
>
The kernel does validate events as they are added to a group.
That's why we have validate_event(), validate_group() and
the fake_cpuc mode.
