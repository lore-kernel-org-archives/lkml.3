Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaG1HYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:24:54 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36952 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1HYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:24:52 -0400
Message-ID: <1406532289.5133.223.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sergey Oboguev <oboguev.public@gmail.com>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Mon, 28 Jul 2014 09:24:49 +0200
In-Reply-To: <8738dm9t4z.fsf@tassilo.jf.intel.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <8738dm9t4z.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 18:19 -0700, Andi Kleen wrote: 
> Sergey Oboguev <oboguev.public@gmail.com> writes:
> 
> > [This is a repost of the message from few day ago, with patch file
> > inline instead of being pointed by the URL.]
> 
> Have you checked out the preemption control that was posted some time
> ago? It did essentially the same thing, but somewhat simpler than your 
> patch.
> 
> http://lkml.iu.edu/hypermail/linux/kernel/1403.0/00780.html
> 
> Yes I agree with you that lock preemption is a serious issue that needs solving.

Yeah, it's a problem, and well known.

One mitigation mechanism that exists in the stock kernel today is the
LAST_BUDDY scheduler feature.  That took pgsql benchmarks from "shite"
to "shiny", and specifically targeted this issue.

Another is SCHED_BATCH, which can solve a lot of the lock problem by
eliminating wakeup preemption within an application.  One could also
create an extended batch class which is not only immune from other
SCHED_BATCH and/or SCHED_IDLE tasks, but all SCHED_NORMAL wakeup
preemption.  Trouble is that killing wakeup preemption precludes very
fast very light tasks competing with hogs for CPU time.  If your load
depends upon these performing well, you have a problem.

Mechanism #3 is use of realtime scheduler classes.  This one isn't
really a mitigation mechanism, it's more like donning a super suit.

So three mechanisms exist, the third being supremely effective, but high
frequency usage is expensive, ergo huge patch.

The lock holder preemption problem being identical to the problem RT
faces with kernel locks...

A lazy preempt implementation ala RT wouldn't have the SCHED_BATCH
problem, but would have a problem in that should critical sections not
be as tiny as it should be, every time you dodge preemption you're
fighting the fair engine, may pay heavily in terms of scheduling
latency.  Not a big hairy deal, if it hurts, don't do that.  Bigger
issue is that you have to pop into the kernel on lock acquisition and
release to avoid jabbering with the kernel via some public phone.
Popping into the kernel, if say some futex were victimized, also erases
the "f" in futex, and restricting cost to consumer won't be any easier.

The difference wrt cost acceptability is that the RT issue is not a
corner case, it's core issue resulting from the nature of the RT beast
itself, so the feature not being free is less annoying.  A corner case
fix OTOH should not impact the general case at all.

Whatever outcome, I hope it'll be tiny. 1886 ain't tiny.

-Mike

