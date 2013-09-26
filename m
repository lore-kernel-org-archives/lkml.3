Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3IZLkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:40:04 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41915 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:40:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130926111618.GU3081@twins.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
 <1380099377.8523.9.camel@marge.simpson.net> <20130926095812.GR3081@twins.programming.kicks-ass.net>
 <CAPM31RL9RGX=ohUVag=tD41MbXs47dDgpndGfjBt68QeL-De7g@mail.gmail.com> <20130926111618.GU3081@twins.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Thu, 26 Sep 2013 04:39:30 -0700
Message-ID: <CAPM31RKvhdDu_NmRd-hv7xBzM6qsS=Y0ey96GpLt36-oBrqdBg@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 4:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Sep 26, 2013 at 03:55:55AM -0700, Paul Turner wrote:
>> > +               /*
>> > +                * Don't bother with select_idle_sibling() in the case of a sync wakeup
>> > +                * where we know the only running task will soon go-away. Going
>> > +                * through select_idle_sibling will only lead to pointless ping-pong.
>> > +                */
>> > +               if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1 &&
>>
>> I've long thought of trying something like this.
>>
>> I like the intent but I'd go a step further in that I think we want to
>> also implicitly extract WF_SYNC itself.
>
> I have vague memories of actually trying something like that a good
> number of years ago.. sadly that's all I remember about it.
>
>> What we really then care about is predicting the overlap associated
>> with userspace synchronization objects, typically built on top of
>> futexes.  Unfortunately the existence/use of per-thread futexes
>> reduces how much state you could usefully associate with the futex.
>> One approach might be to hash (with some small saturating counter)
>> against rip.  But this gets more complicated quite quickly.
>
> Why would you need per object storage? To further granulate the
> predicted overlap? instead of having one per task, you have one per
> object?

It is my intuition that there are a few common objects with fairly
polarized behavior:  I.e. For condition variables and producer
consumer queues, a wakeup strongly predicts blocking.  Whereas for
locks protecting objects, e.g. a Mutex, would be expected to have the
opposite behavior.

For this hint to be beneficial you have to get it right frequently,
getting it wrong in the first case hurts cache and in the second hurts
parallelism.  Today we always err on the side of hurting locality
since the cost of getting it wrong is better bounded.  These are
sufficiently common, and likely to be interspersed, that I suspect
allowing them to interact on a thread-wide counter will basically give
a mush result (or even be an anti predictor since it will strongly
favor the last observation) an an input.
