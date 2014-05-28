Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaE1Rkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:40:49 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48741 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaE1Rks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140528172540.GM29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
	<1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
	<20140528081053.GP11096@twins.programming.kicks-ass.net>
	<20140528145831.GH29957@tassilo.jf.intel.com>
	<20140528153548.GY11096@twins.programming.kicks-ass.net>
	<20140528160847.GJ29957@tassilo.jf.intel.com>
	<20140528170531.GT30445@twins.programming.kicks-ass.net>
	<20140528172540.GM29957@tassilo.jf.intel.com>
Date: Wed, 28 May 2014 19:40:47 +0200
Message-ID: <CABPqkBSJGu67NMw5YRA6f0W5JqP8OC4Y6W4mgbasAM+N458yqA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 7:25 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Wed, May 28, 2014 at 07:05:31PM +0200, Peter Zijlstra wrote:
>> On Wed, May 28, 2014 at 09:08:47AM -0700, Andi Kleen wrote:
>> > On Wed, May 28, 2014 at 05:35:48PM +0200, Peter Zijlstra wrote:
>> > > On Wed, May 28, 2014 at 07:58:31AM -0700, Andi Kleen wrote:
>>
>> > > > When a PEBS counter overflows it clears its respective GLOBAL_STATUS bit
>> > > > automatically.
>> > >
>> > > That's an ambiguous statement; did you mean to say a PEBS enabled
>> > > counter will not raise its bit in GLOBAL_STATUS on counter overflow?
>> >
>> > Let's revisit how PEBS works:
>> >
>> > - The counter overflows and sets the GLOBAL_STATUS bit
>> > - The PEBS assist is armed
>> > - The counter triggers again
>> > - The PEBS assist fires and delivers a PEBS record
>> > - Finally it clears the GLOBAL_STATUS
>> > - When the threshold is reached it raises an PMI
>> >
>> > So the GLOBAL_STATUS bit is visible between the first overflow and the end
>> > of the PEBS record delivery.
>>
>> OK, so that's something entirely different from what you initially said,
>> but it is what I thought it did -- you said that it clears on overflow
>> but it clears after recording.
>
> Fair enough. I should have said PEBS assist.
>
>> If we get the PMI (where denoted) we can actually reconstruct which
>> event triggered, by looking at which bit(s) flipped between the recorded
>> state and the current state (due to E coming before F)
>
> Normally when the PMI PEBS handler runs the GLOBAL_STATUS is already cleared
> (as the PEBS assist will execute concurrently during the NMI entry)
> Looking at the status won't help you much, it only has the PEBS bit
> set.
>
> I don't think we need to do anything. It's a very unlikely situation
> in normal operation, as the counter period is very long compared
> to the race window.  When it happens very rarely we can ignore it.
>
> It can happen mainly when you program two counters to count exactly
> the same thing with the same threshold, but why would you do that?
>
That's a plausible scenario if you consider two distinct sessions of a tool,
i.e., two users running perf top or perf record some precise events.

> I guess what would make sense is to add some debug counter somewhere
> for this situation (more than one bit set)
>
> -Andi
