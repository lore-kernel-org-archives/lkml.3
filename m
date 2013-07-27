Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3G0BIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 21:08:47 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36359 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3G0BIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 21:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130726215011.GK27075@twins.programming.kicks-ass.net>
References: <9E84D12D-7389-4D9A-803A-91FD704A92FA@gustavus.edu>
 <20130725112123.GT27075@twins.programming.kicks-ass.net> <228E8D34-E1A9-4D82-B353-F095E473B8D7@gustavus.edu>
 <20130725164051.GZ27075@twins.programming.kicks-ass.net> <20130725211521.GE18254@gmail.com>
 <CAPM31RJNgDS+gCZobJCt138J6MfbYhwTuTH8MrhP7DEqHGqi5g@mail.gmail.com>
 <CAPM31RJ7Xh5A9cTT_-qd47RH3pRhCqiuh-uKx1gktDk0g-5NNg@mail.gmail.com>
 <20130726210317.GC20909@twins.programming.kicks-ass.net> <CAPM31RKTznL=VKrMG=NV6OGit6EUj46x63L7tWXd40CGTaZKOg@mail.gmail.com>
 <20130726215011.GK27075@twins.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Fri, 26 Jul 2013 18:08:15 -0700
Message-ID: <CAPM31RJ1aPGehNJTtCakSdpFoPh6T=UCk1o0NEoN7PNtVtzhOg@mail.gmail.com>
Subject: Re: PROBLEM: Persistent unfair sharing of a processor by auto groups
 in 3.11-rc2 (has twice regressed)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Max Hailperin <max@gustavus.edu>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 2:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jul 26, 2013 at 02:24:50PM -0700, Paul Turner wrote:
>> On Fri, Jul 26, 2013 at 2:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> >
>> > OK, so I have the below; however on a second look, Paul, shouldn't that
>> > update_cfs_shares() call be in entity_tick(), right after calling
>> > update_cfs_rq_blocked_load(). Because placing it in
>> > update_cfs_rq_blocked_load() means its now called twice on the
>> > enqueue/dequeue paths through:
>> >
>> >   {en,de}queue_entity()
>> >     {en,de}queue_entity_load_avg()
>> >       update_cfs_rq_blocked_load()
>> >         update_cfs_shares()
>>
>> Yes, I agree: placing it directly in entity_tick() would be better.
>
> OK, how about the below then?

Looks good.

>
>> [ In f269ae046 the calls to update_cfs_rq_blocked_load() were amortized
>> and the separate update in {en,de}queue_entity_load_avg() were
>> removed. ]
>
> Right, I remember/saw that. Did you ever figure out why that regressed;
> as in should we look to bring some of that back?

Yes, the savings are measurable (we actually still use it internally).

So the particular problem in Linus's workload was that the amortization meant
that there was more delay until the first update for a newly created task.  This
then had negative interactivity with a make -j <N> workload since it allowed the
tasks to be over-represented in terms of the group shares they received.

With:
  a75cdaa9: "sched: Set an initial value of runnable avg for new forked task"

This should now be improved so we should look at bringing it back.
