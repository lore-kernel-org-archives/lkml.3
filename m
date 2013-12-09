Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674Ab3LISYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:24:31 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46096 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3LISY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:24:29 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL v2] posix cpu timers cleanups for 3.14
Date: Mon,  9 Dec 2013 19:24:07 +0100
Message-Id: <1386613447-5042-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull the timers/posix-timers-for-tip-v2 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/posix-timers-for-tip-v2

HEAD: 531f64fd6f46a3f2a3edb1b97ecc827c775932c5

This is the second version of the pull request that I sent you a few weeks ago:
http://lkml.kernel.org/r/1385221040-24731-1-git-send-email-fweisbec@gmail.com

Changes in this v2:

* rebase against latest tip:timers/core (there was a conflict with some dynticks
  patches)

* add a cleanup suggested by Kosaki in patch 02/10: remove a useless group
  timer sample snapshot and rearm on timer rescheduling.

Also the previous pull request lacked a high level overall description, so I'm
adding one here.

---

Posix cpu timers changes for 3.14:

* Remove dying thread/process timers caching that were complicating the code
  for no significant win.

* Remove early task reference release on dying timer sample read. Again it was
  not worth the code complication. The other timer's resources aren't released until
  timer_delete() is called anyway (or when the whole process dies).

* Remove leftover arguments in reaped target cleanup

* Consolidate some timer sampling code

* Remove use of tasklist lock

* Robustify sighand locking against exec and exit by using the safer
  lock_task_sighand() API instead of sighand raw locking.

* Convert some unnecessary BUG_ON() to WARN_ON()


Thanks,
	Frederic
---

Frederic Weisbecker (10):
      posix-timers: Remove dead thread posix cpu timers caching
      posix-timers: Remove dead process posix cpu timers caching
      posix-timers: Cleanup reaped target handling
      posix-timers: Remove dead task special case
      posix-timers: Remove useless clock sample on timers cleanup
      posix-timers: Consolidate posix_cpu_clock_get()
      posix-timers: Use sighand lock instead of tasklist_lock for task clock sample
      posix-timers: Use sighand lock instead of tasklist_lock on timer deletion
      posix-timers: Remove remaining uses of tasklist_lock
      posix-timers: Convert abuses of BUG_ON to WARN_ON


 kernel/posix-cpu-timers.c | 312 +++++++++++++++++++---------------------------
 1 file changed, 129 insertions(+), 183 deletions(-)
