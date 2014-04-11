Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450AbaDKPAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:00:46 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:35799 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759264AbaDKPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140411134243.160989490@infradead.org>
References: <20140411134243.160989490@infradead.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 11 Apr 2014 08:00:23 -0700
Message-ID: <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 6:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> A while ago both Mike and Andy complained that we still get pointless wakeup
> IPIs, we had a few patches back and forth but eventually more or less agreed
> and then nothing... :-)
>
> So here's a number of patches that implement something near what we left off
> with.
>
> Its only been compile/boot tested on x86_64, I've no actually looked at the IPI
> numbers yet.
>

Looks generally good and it should be a nice cleanup.

That being said, I think that this addresses once one of the two major
issues.  While the race you're fixing is more interesting, I think its
impact is dwarfed by the fact that ttwu_queue_remote completely
ignores polling.  (NB: I haven't actually tested this patch set, but I
did try to instrument this stuff awhile ago.)

To fix this, presumably the wake-from-idle path needs a
sched_ttwu_pending call, and ttwu_queue_remote could use resched_task.
 sched_ttwu_pending could benefit from a straightforward optimization:
it doesn't need rq->lock if llist is empty.

If you're not planning on trying to fix that, I can try to write up a
patch in the next day or two.

Even with all of this fixed, what happens when ttwu_queue_remote is
called with a task that has lower priority than whatever is currently
running on the targeted cpu?  I think the result is an IPI that serves
very little purpose other than avoiding taking a spinlock in the
waking thread.  This may be a bad tradeoff.  I doubt that this matters
for my particular workload, though.

--Andy
