Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3EON1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:27:14 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37402 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530Ab3EON1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130513194313.GA30998@gmail.com>
References: <20130510094053.GF1040@krava.brq.redhat.com>
	<20130510095345.GG3039@dyad.programming.kicks-ass.net>
	<20130510101823.GA18427@gmail.com>
	<20130510102245.GA31235@dyad.programming.kicks-ass.net>
	<20130510103112.GA18755@gmail.com>
	<20130510103436.GC31235@dyad.programming.kicks-ass.net>
	<20130510105536.GA18805@gmail.com>
	<20130510112756.GH31235@dyad.programming.kicks-ass.net>
	<20130511075008.GC24435@gmail.com>
	<20130513093624.GC3708@dyad.programming.kicks-ass.net>
	<20130513194313.GA30998@gmail.com>
Date: Wed, 15 May 2013 15:27:12 +0200
Message-ID: <CABPqkBRFMB_HUvwEXo5EK68Z6LJ9KWLNmqNBENZq-7vsP-NsrA@mail.gmail.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 9:43 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Sat, May 11, 2013 at 09:50:08AM +0200, Ingo Molnar wrote:
>> > That's really a red herring: there's absolutely no reason why the
>> > kernel could not pass back the level of precision it provided.
>>
>> All I've been saying is that doing random precision without feedback is
>> confusing.
>
> I agree with that.
>
>> We also don't really have a good feedback channel for this kind of
>> thing. The best I can come up with is tagging each and every sample with
>> the quality it represents. I think we can do with only one extra
>> PERF_RECORD_MISC bit, but it looks like we're quickly running out of
>> those things.
>
> Hm, how about passing precision back to user-space at creation time, in
> the perf_attr data structure? There's no need to pass it back in every
> sample, precision will not really change during the life-time of an event.
>
>> But I think the biggest problem is PEBS's inability do deal with REP
>> prefixes; see this email from Stephane:
>> https://lkml.org/lkml/2011/2/1/177
>>
>> It is really unfortunate for PEBS to have such a side-effect; but it
>> makes all memset/memcpy/memmove things appear like they have no cost.
>> I'm very sure that will surprise a number of people.
>
> I'd expect PEBS to get gradually better.
>
> Note that at least for user-space, REP MOVS is getting rarer. libc uses
> SSE based memcpy/memset variants - which is not miscounted by PEBS. The
> kernel still uses REP MOVS - but it's a special case because it cannot
> cheaply use vector registers.
>
> The vast majority of code gets measured by cycles:pp more accurately than
> cycles.
>
I don't understand how you come to that conclusion. I can show you simple
examples where this is not true at all (even without rep mov).

I will repeat once again what PEBS provides. The only guarantee of PEBS
is that it captures the next dynamic address after an instruction that caused
the event to occur.

The address is the 'next' one because PEBS captures at retirement of the sampled
instruction. The caveats are that the sampled instruction is not the
one at the end
of the sampling period for this event. It may be N cycles later.
Therefore there is a
shadow during which qualifying instructions may be executed but never sampled.
This is what INST_RETIRED:PREC_DIST is trying to compensate for.
Furthermore, as pointed out recently, the filters are ignored for the sampled
instruction. They are honored up to the sampling period. As such, the sampled
instruction does not qualify for the filters. Filters can vastly
change the meaning
of an event: for instance cmask=1 changes  LLC_MISS to cycles with
pending LLC misses.

I would add that using uops_retired:cmask=16:invert to gain precise cycle
does not behave the same way across processors. It turns out that Westmere and
SandyBridge handle this differently during halted cycles. So in the
end, I think it is
pretty hard to understand what's being measured uniformly. And
therefore I think it
is a VERY bad idea to default cycles to cycles:pp when PEBS is present.
