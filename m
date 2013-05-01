Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3EASNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:13:38 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49348 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3EASNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130501111219.GF28253@dyad.programming.kicks-ass.net>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
	<20130501090718.GA28253@dyad.programming.kicks-ass.net>
	<m261z3uipb.fsf@firstfloor.org>
	<20130501111219.GF28253@dyad.programming.kicks-ass.net>
Date: Wed, 1 May 2013 20:13:31 +0200
Message-ID: <CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a serious problem because it silently corrupts events on the
sibling thread.
The problem can be observed easily using a basic perf stat command. The idea
is to use an event for which we easily know the final count in advance. I use
ROB_MISC_EVENT:LBR_INSERTS, i.e., the number of entries inserted into
the LBR. If I am not using the LBR, then the count should be zero.
Given that LBR
is not used by default, the count should be zero.  Then, you combine this
event with the MEM_* events to cause multiplexing in system-wide mode
and you use a workload which does a lot of memory accesses (I use a triad
loop):

On IVB (desktop), you can do:
# perf stat -a -e r20cc,r81d0,r02d2,r02d4,r401d1 triad

You will get a non-zero count for r20cc (lbr_inserts). That's wrong.

If you restrict to one thread/core, you get the correct answer:

# perf stat -C0-3 -a -e r20cc,r81d0,r02d2,r02d4,r401d1 triad

Then, you get 0 for lbr_insert. This is the correct answer.

Unfortunately, Andi's patch fails to correct the problem though
it is the right approach. As he said, the problem is unfortunately
deeper than this.


On Wed, May 1, 2013 at 1:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 01, 2013 at 02:56:32AM -0700, Andi Kleen wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> >
>> > So you're saying that if two SMT siblings count the same MEM_*_RETIRED event
>> > (on the same counter?) events can get accounted to the wrong sibling?
>>
>> It can happen regardless of what event is enabled on the other counter.
>
> What I was trying to ask is.. where does it leak to. Does it leak to whatever
> event the other counter is counting? Or does it explicitly leak to any sibilng
> counter also counting MEM_*_RETIRED?
>
>     SMT0   SMT1
>
> C0   MR     MR
> C1
> C2
> C3
>
> So here SMT[01]-C0 will cross count their events.
>
>
>     SMT0   SMT1
>
> C0   MR
> C1          MR
> C2
> C3
>
> Will they too here?
>
>
>     SMT0   SMT1
>
> C0   MR     Cycles
> C1
> C2
> C3
>
> What about here?
>
>
> So again; do they specifically leak between the same counters of siblings or
> between the same events of siblings. Your initial explanation wasn't clear on
> when and where exactly the leak happens.
>
>
>> > This begs the question what happens when the sibling does have the (same?)
>> > counter enabled but counting an all together different event; do we then still
>> > 'loose' events from the one sibling and add then to the other counter?
>>
>> Yes, that is what the patch fixes.
>
> Well, it very much depends on the above answer; if case-3 leaks samples from
> SMT0-C0 to SMT1-C0 then the patch doesn't fix anything as the SMT1-C0 event
> (cycles) doesn't bother with the shared register.
>
>
