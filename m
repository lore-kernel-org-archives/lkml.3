Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaL2X1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:27:52 -0500
Received: from mail3.unitn.it ([193.205.206.24]:61004 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaL2X1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:27:51 -0500
Date: Tue, 30 Dec 2014 00:27:38 +0100
From: luca abeni <luca.abeni@unitn.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Another SCHED_DEADLINE bug (with bisection and possible fix)
Message-ID: <20141230002738.6c12db31@utopia>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

when running some experiments on current git master, I noticed a
regression respect to version 3.18 of the kernel: when invoking
sched_setattr() to change the SCHED_DEADLINE parameters of a task that
is already scheduled by SCHED_DEADLINE, it is possible to crash the
system.

The bug can be reproduced with this testcase:
http://disi.unitn.it/~abeni/reclaiming/bug-test.tgz
Uncompress it, enter the "Bug-Test" directory, and type "make test".
After few cycles, my test machine (a laptop with an intel i7 CPU)
becomes unusable, and freezes.

Since I know that 3.18 is not affected by this bug, I tried a bisect,
that pointed to commit 67dfa1b756f250972bde31d65e3f8fde6aeddc5b
(sched/deadline: Implement cancel_dl_timer() to use in
switched_from_dl()).
By looking at that commit, I suspect the problem is that it removes the
following lines from init_dl_task_timer():
-       if (hrtimer_active(timer)) {
-               hrtimer_try_to_cancel(timer);
-               return;
-       }

As a result, when changing the parameters of a SCHED_DEADLINE task
init_dl_task_timer() is invoked again, and it can initialize a pending
timer (not sure why, but this seems to be the cause of the freezes I am
seeing).

So, I modified core.c::__setparam_dl() to invoke init_dl_task_timer()
only if the task is not already scheduled by SCHED_DEADLINE...
Basically, I changed
	init_dl_task_timer(dl_se);
into
	if (p->sched_class != &dl_sched_class) {
		init_dl_task_timer(dl_se);
	}

I am not sure if this is the correct fix, but with this change the
kernel survives my test script (mentioned above), and arrives to 500
cycles (without my patch, it crashes after 2 or 3 cycles).

What do you think? Is my patch correct, or should I fix the issue in a
different way?



			Thanks,
				Luca
