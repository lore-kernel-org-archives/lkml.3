Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3HWMKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:10:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48690 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3HWMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:10:14 -0400
Date: Fri, 23 Aug 2013 14:10:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [sched_delayed] sched: RT throttling activated
Message-ID: <20130823121004.GW31370@twins.programming.kicks-ass.net>
References: <521722EE.70209@fold.natur.cuni.cz>
 <20130823100913.GQ31370@twins.programming.kicks-ass.net>
 <52173BBD.3050803@fold.natur.cuni.cz>
 <20130823110254.GU31370@twins.programming.kicks-ass.net>
 <521748FC.10809@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521748FC.10809@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 01:35:24PM +0200, Martin Mokrejs wrote:

> # ps -deo pid,cls,cmd | grep -e 'RR \[' -e 'FF \['

This explicitly only lists kernel threads; from your other comment:

> The shell/python tasks have 'TS' in place of the FF value in the second column
> so I guess they are not requiring realtime responsiveness.

I'll assume you actually inspected the other tasks and found none.

>     7  FF [migration/0]
>    10  FF [watchdog/0]
>    11  FF [watchdog/1]
>    12  FF [migration/1]
>    17  FF [migration/2]
>    22  FF [migration/3]

The 'migration' threads only look like FIFO threads but they're secretly
not and don't count to the limit. The watchdog threads shouldn't run
much either.

>  2161  FF [irq/50-iwlwifi]

Oh a threaded interrupt, I presume you're not using "threadiqrs" since
this is the only interrupt thread around and I see a
'request_threaded_irq()' call in
drivers/net/wireless/iwlwifi/pcie/trans.c

And wow, why would that thing consume that much cpu. 

Johill, ever seen the iwlwifi interrupt go 'funny' and consume gobs of
cpu-time?


> > Nope, you get that message once to tell you that we throttle RT tasks.
> 
> I think the message could improved to explain this is a warn ONCE message and
> that there is no "[sched_delayed] sched: RT throttling deactivated" counterpart
> message to be anticipated.

Would something like: 

  sched: [ONCE] RT throttle hit -- inspect system configuration.

Be a better message?

Also, could you clarify what exact kernel version you're running? I
couldn't find it in your previous messages.
