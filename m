Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaEMGhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:37:36 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:52597 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaEMGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:37:34 -0400
Date: Tue, 13 May 2014 08:37:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
Message-ID: <20140513063729.GA7905@gmail.com>
References: <20140512190438.314125476@linutronix.de>
 <20140512173705.0bbdb675@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512173705.0bbdb675@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> >    This is beyond sloppy and outright stupid.
> 
> Thomas, listen to yourself. You are calling something that got in
> without updating the documentation and test case "beyond sloppy and
> outright stupid". Sure, I'll agree it was a little sloppy, and today I'm
> more on the ball to get things like this right (as we push much harder
> today on documentation coming in along with code changes). But the
> change log had:
> 
>     need updated after this patch is accepted
>     1) Document/*
>     2) the testcase scripts/rt-tester/t4-l2-pi-deboost.tst
> 
> I agree this should be fixed, but you temper tantrum over this seems 
> a bit over the top.

Well, the thing is, it's not just about the breakage, but the 
changelog and the patch in itself already violates a very basic and 
fundamental kernel workflow pattern we try to follow all the time for 
core kernel changes: when speedups are introduced then fixes are never 
'promised' to be done in an uncertain future, but are done preferably 
before (or together) with the speedup.

Especially when there's an ABI involved.

The "break and fix later" kind of pattern might not be as problematic 
for debug features which are not critical to users, but for ABI facing 
changes it's deadly and inacceptable.

Also, the problems with the broken commit already begin with the 
readability of the changelog:

1)

The very first sentence:

  > In current rtmutex,

Should be:

  > In the current rtmutex code,

2)

Also, the 'Example' that comes next is just a flow of sentences 
without any vertical alignment (tabs, spaces, etc.), making it harder 
to review.

3)

Plus, here:

  "time3
   A or other high prio task sleeps, but we have passed some time
   The B and C's prio are changed in the period (time2 ~ time3)"

where does the first sentence end?

4)

  "when requiring lock,"

I suspect that wanted to say 'reacquiring' the lock.

5)

  "Other advantage of this patch:"

s/advantage/advantages/

6)

  "The states of a rtmutex are reduced a half, easier to read the code."

s/reduced a half/reduced by half

7)

 it is unrelated/unneed boosting 

s/unneed/unneeded

?

8)

The diffstat is 'frickin hug:

 kernel/futex.c          |  22 +++++-----
 kernel/rtmutex-debug.c  |   1 -
 kernel/rtmutex.c        | 318 +++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------
 kernel/rtmutex_common.h |  16 +------
 4 files changed, 127 insertions(+), 230 deletions(-)

When a changelog is harder to read due to basic grammar and 
typographical errors, and when the patch is large, it's harder to 
notice more fundamental problems as well.

(I've attached the full changelog below for reference.)

I should have noticed these warning signs when pulling your tree, I 
generally read over changelogs and patches I pull, but missed this - 
not sure what fell into me.

My bad, will be more careful next time around.

Thanks,

	Ingo

=====================================>
>From 8161239a8bcce9ad6b537c04a1fa3b5c68bae693 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 17:09:41 +0800
Subject: [PATCH] rtmutex: Simplify PI algorithm and make highest prio task get
 lock

In current rtmutex, the pending owner may be boosted by the tasks
in the rtmutex's waitlist when the pending owner is deboosted
or a task in the waitlist is boosted. This boosting is unrelated,
because the pending owner does not really take the rtmutex.
It is not reasonable.

Example.

time1:
A(high prio) onwers the rtmutex.
B(mid prio) and C (low prio) in the waitlist.

time2
A release the lock, B becomes the pending owner
A(or other high prio task) continues to run. B's prio is lower
than A, so B is just queued at the runqueue.

time3
A or other high prio task sleeps, but we have passed some time
The B and C's prio are changed in the period (time2 ~ time3)
due to boosting or deboosting. Now C has the priority higher
than B. ***Is it reasonable that C has to boost B and help B to
get the rtmutex?

NO!! I think, it is unrelated/unneed boosting before B really
owns the rtmutex. We should give C a chance to beat B and
win the rtmutex.

This is the motivation of this patch. This patch *ensures*
only the top waiter or higher priority task can take the lock.

How?
1) we don't dequeue the top waiter when unlock, if the top waiter
   is changed, the old top waiter will fail and go to sleep again.
2) when requiring lock, it will get the lock when the lock is not taken and:
   there is no waiter OR higher priority than waiters OR it is top waiter.
3) In any time, the top waiter is changed, the top waiter will be woken up.

The algorithm is much simpler than before, no pending owner, no
boosting for pending owner.

Other advantage of this patch:
1) The states of a rtmutex are reduced a half, easier to read the code.
2) the codes become shorter.
3) top waiter is not dequeued until it really take the lock:
   they will retain FIFO when it is stolen.

Not advantage nor disadvantage
1) Even we may wakeup multiple waiters(any time when top waiter changed),
   we hardly cause "thundering herd",
   the number of wokenup task is likely 1 or very little.
2) two APIs are changed.
   rt_mutex_owner() will not return pending owner, it will return NULL when
                    the top waiter is going to take the lock.
   rt_mutex_next_owner() always return the top waiter.
	                 will not return NULL if we have waiters
                         because the top waiter is not dequeued.

   I have fixed the code that use these APIs.

need updated after this patch is accepted
1) Document/*
2) the testcase scripts/rt-tester/t4-l2-pi-deboost.tst

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D3012D5.4060709@cn.fujitsu.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c          |  22 ++--
 kernel/rtmutex-debug.c  |   1 -
 kernel/rtmutex.c        | 318 +++++++++++++++++-------------------------------
 kernel/rtmutex_common.h |  16 +--
 4 files changed, 127 insertions(+), 230 deletions(-)

