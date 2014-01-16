Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaAPECN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:02:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57623 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaAPECK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:02:10 -0500
Date: Wed, 15 Jan 2014 20:02:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH v3 tip/core/timers 0/5] Crude timer-wheel latency hacks
Message-ID: <20140116040203.GA5206@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011604-0928-0000-0000-00000574DDCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following five patches provide some crude timer-wheel latency patches.
I understand that a more comprehensive solution is in progress, but in the
meantime, these patches work well in cases where a given CPU has either
zero or one timers pending, which is a common case for NO_HZ_FULL kernels.
Note that these patches do not help in the case where a given timer wheel
has a pair of widely separated timers, while the more comprehensive
solution is likely to handle more gracefully.  So, on the off-chance
that this is helpful to someone, the individual patches are as follows:

1.	Add ->all_timers field to tbase_vec to count all timers, not
	just the non-deferrable ones.

2.	Avoid jiffy-at-a-time stepping when the timer wheel is empty.

3.	Avoid jiffy-at-a-time stepping when the timer wheel transitions
	to empty.

4.	Avoid jiffy-at-a-time stepping after a timer is added to an
	initially empty timer wheel.

5.	Make internal_add_timer() update ->next_timer if ->active_timers == 0,
	courtesy of Oleg Nesterov.

Differences from v2:

o	Add patch #5 from Oleg.

o	Move the check for adding to an empty timer wheel from mod_timer()
	to internal_add_timer(), as suggested by Oleg Nesterov.

o	Addressed review comments from Oleg, Steven Rostedt, Josh Triplett,
	and Fengguang Wu.

Differences from v1:

o	Fix an embarrassing bug located by Oleg Nesterov where the
	timer wheel could be judged to be empty even if it contained
	deferrable timers.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/timer.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

