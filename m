Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3K0OLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:11:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3K0OLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:11:07 -0500
Date: Wed, 27 Nov 2013 06:10:30 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-192301e70af3f6803c6354a464ebfa742da738ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        David.Laight@ACULAB.COM, geert@linux-m68k.org,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        David.Laight@ACULAB.COM, geert@linux-m68k.org,
        akpm@linux-foundation.org, tj@kernel.org, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20131113154538.GB15810@redhat.com>
References: <20131113154538.GB15810@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Check TASK_DEAD rather than EXIT_DEAD in schedule_debug()
Git-Commit-ID: 192301e70af3f6803c6354a464ebfa742da738ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:10:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  192301e70af3f6803c6354a464ebfa742da738ae
Gitweb:     http://git.kernel.org/tip/192301e70af3f6803c6354a464ebfa742da738ae
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Nov 2013 16:45:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 13:50:53 +0100

sched: Check TASK_DEAD rather than EXIT_DEAD in schedule_debug()

schedule_debug() ignores in_atomic() if prev->exit_state != 0.
This is not what we want, ->exit_state is set by exit_notify()
but we should complain until the task does the last schedule()
in TASK_DEAD.

See also 7407251a0e2e "PF_DEAD cleanup", I think this ancient
commit explains why schedule() had to rely on ->exit_state,
until that commit exit_notify() disabled preemption and set
PF_DEAD which was used to detect the exiting task.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131113154538.GB15810@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 687985b..19db8f3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2414,10 +2414,10 @@ static inline void schedule_debug(struct task_struct *prev)
 {
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
-	 * schedule() atomically, we ignore that path for now.
-	 * Otherwise, whine if we are scheduling when we should not be.
+	 * schedule() atomically, we ignore that path. Otherwise whine
+	 * if we are scheduling when we should not.
 	 */
-	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
+	if (unlikely(in_atomic_preempt_off() && prev->state != TASK_DEAD))
 		__schedule_bug(prev);
 	rcu_sleep_check();
 
