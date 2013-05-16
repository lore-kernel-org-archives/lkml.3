Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3EPPmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:42:24 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48407 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3EPPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:42:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130515165152.GB13916@laptop.home>
References: <20130503121122.931661809@chello.nl>
	<20130503121256.083340271@chello.nl>
	<20130503143507.GP19487@tassilo.jf.intel.com>
	<20130503170007.GA30733@dyad.programming.kicks-ass.net>
	<CABPqkBSTMJebZLjvLhdQ1hiemoqvO2t=vi+CG=yLjkFabOr8XQ@mail.gmail.com>
	<20130515165152.GB13916@laptop.home>
Date: Thu, 16 May 2013 17:42:19 +0200
Message-ID: <CABPqkBSrLdXrg+p_A537O1mkv8Ewm-qt+0ugWOwJvLa6yn9ERg@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 6:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 15, 2013 at 04:20:46PM +0200, Stephane Eranian wrote:
>> Hi,
>>
>> Based on our testing, it appears the corruption occurs only
>> when the MEM_* events are used and only on the sibling
>> counter. In other words, if HT0 has MEM_* in cntr0, then
>> HT1 cntr0 cannot be used, otherwise whatever is there may
>> get corrupted.
>
> Ah, great. That is the least horrid case :-)
>
Yeah.

>> So I think we could enhance Andi's initial patch
>> to handle this case instead of blacklist those events. They are
>> very important events.
>
> Will you take a stab at it? I suppose you'll have to make each counter
> have a shared resource and have the mem_*_retired events mark the
> resource taken.
>
Yes, I will try to come up with a patch to force multiplexing when those
events are used.

The difficulty is that we cannot use the shared_regs infrastructure because
the constraint is quite different. Here we need to say that if a mem event
uses cnt0 on one thread, then nothing can be using cnt0 on the other thread.
The current shared_regs infrastructure does not work on the counter level.
So we need to invent something else. It cannot even be extended. We need
to schedule the mem event, then look at the assignment and exclude all
the counters used by the mem event from the other thread. Alternatively,
we can only schedule mem event on counters which are not currently used
by the sibling thread. We need to peek at the used counters cross HT threads.
Not so easy to do.


> Also, did you test what happens when you turn SMT off in the BIOS so you
> get double the amount of counters; do we then leak into CNTn+4 or is all
> well again?
>
I have not tried that yet. Hopefully, it won't exhibit the problem.
