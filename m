Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaHLS0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbaHLS0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:26:14 -0400
Date: Tue, 12 Aug 2014 14:25:39 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140812142539.01851e52@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in 2009, Spencer Candland pointed out there is a race with
do_sys_times, where multiple threads calling do_sys_times can
sometimes get decreasing results.

https://lkml.org/lkml/2009/11/3/522

As a result of that discussion, some of the code in do_sys_times
was moved under a spinlock.

However, that does not seem to actually make the race go away on
larger systems. One obvious remaining race is that after one thread
is about to return from do_sys_times, it is preempted by another
thread, which also runs do_sys_times, and stores a larger value in
the shared variable than what the first thread got.

This race is on the kernel/userspace boundary, and not fixable
with spinlocks.

Removing the spinlock from do_sys_times does not seem to result
in an increase in the number of times a decreasing utime is
observed when running the test case. In fact, on the 80 CPU test
system that I tried, I saw a small decrease, from an average
14.8 to 6.5 instances of backwards utime running the test case.

Back in 2009, in changeset 2b5fe6de5 Oleg Nesterov already found
that it should be safe to remove the spinlock.  I believe this is
true, because it appears that nobody changes another task's ->sighand
pointer, except at fork time and exit time, during which the task
cannot be in do_sys_times.

This is subtle enough to warrant documenting.

The increased scalability of removing the spinlock should help
things like databases and middleware that measure the resource
use of every query processed.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Frank Mayhar <fmayhar@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sanjay Rao <srao@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sys.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 66a751e..cb81ce4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -862,11 +862,15 @@ void do_sys_times(struct tms *tms)
 {
 	cputime_t tgutime, tgstime, cutime, cstime;
 
-	spin_lock_irq(&current->sighand->siglock);
+	/*
+	 * sys_times gets away with not locking &current->sighand->siglock
+	 * because most of the time only the current process gets to change
+	 * its own sighand pointer. The exception is exit, which changes
+	 * the sighand pointer of an exiting process.
+	 */
 	thread_group_cputime_adjusted(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
-	spin_unlock_irq(&current->sighand->siglock);
 	tms->tms_utime = cputime_to_clock_t(tgutime);
 	tms->tms_stime = cputime_to_clock_t(tgstime);
 	tms->tms_cutime = cputime_to_clock_t(cutime);
