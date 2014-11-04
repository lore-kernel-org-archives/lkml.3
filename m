Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaKDQJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:09:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaKDQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:53 -0500
Date: Tue, 4 Nov 2014 08:07:37 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f7b8a47da17c9ee4998f2ca2018fcc424e953c0e@git.kernel.org>
Cc: fengguang.wu@intel.com, peterz@infradead.org, mingo@kernel.org,
        ktkhai@parallels.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: torvalds@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        oleg@redhat.com, ktkhai@parallels.com, fengguang.wu@intel.com,
        mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1414473874.8574.2.camel@tkhai>
References: <1414473874.8574.2.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove lockdep check in sched_move_task
 ()
Git-Commit-ID: f7b8a47da17c9ee4998f2ca2018fcc424e953c0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7b8a47da17c9ee4998f2ca2018fcc424e953c0e
Gitweb:     http://git.kernel.org/tip/f7b8a47da17c9ee4998f2ca2018fcc424e953c0e
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Tue, 28 Oct 2014 08:24:34 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:07:30 +0100

sched: Remove lockdep check in sched_move_task()

sched_move_task() is the only interface to change sched_task_group:
cpu_cgrp_subsys methods and autogroup_move_group() use it.

Everything is synchronized by task_rq_lock(), so cpu_cgroup_attach()
is ordered with other users of sched_move_task(). This means we do no
need RCU here: if we've dereferenced a tg here, the .attach method
hasn't been called for it yet.

Thus, we should pass "true" to task_css_check() to silence lockdep
warnings.

Fixes: eeb61e53ea19 ("sched: Fix race between task_group and sched_task_group")
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414473874.8574.2.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240157c..6841fb4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7444,8 +7444,12 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		put_prev_task(rq, tsk);
 
-	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
-				lockdep_is_held(&tsk->sighand->siglock)),
+	/*
+	 * All callers are synchronized by task_rq_lock(); we do not use RCU
+	 * which is pointless here. Thus, we pass "true" to task_css_check()
+	 * to prevent lockdep warnings.
+	 */
+	tg = container_of(task_css_check(tsk, cpu_cgrp_id, true),
 			  struct task_group, css);
 	tg = autogroup_task_group(tsk, tg);
 	tsk->sched_task_group = tg;
