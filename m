Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaCKMlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:41:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbaCKMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:40:50 -0400
Date: Tue, 11 Mar 2014 05:40:13 -0700
From: tip-bot for Mike Galbraith <tipbot@zytor.com>
Message-ID: <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bitbucket@online.de, mgorman@suse.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bitbucket@online.de, mgorman@suse.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <1393568591.6018.27.camel@marge.simpson.net>
References: <1393568591.6018.27.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Move task_numa_free()
  to __put_task_struct()
Git-Commit-ID: 156654f491dd8d52687a5fbe1637f472a52ce75b
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

Commit-ID:  156654f491dd8d52687a5fbe1637f472a52ce75b
Gitweb:     http://git.kernel.org/tip/156654f491dd8d52687a5fbe1637f472a52ce75b
Author:     Mike Galbraith <bitbucket@online.de>
AuthorDate: Fri, 28 Feb 2014 07:23:11 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:05:43 +0100

sched/numa: Move task_numa_free() to __put_task_struct()

Bad idea on -rt:

[  908.026136]  [<ffffffff8150ad6a>] rt_spin_lock_slowlock+0xaa/0x2c0
[  908.026145]  [<ffffffff8108f701>] task_numa_free+0x31/0x130
[  908.026151]  [<ffffffff8108121e>] finish_task_switch+0xce/0x100
[  908.026156]  [<ffffffff81509c0a>] thread_return+0x48/0x4ae
[  908.026160]  [<ffffffff8150a095>] schedule+0x25/0xa0
[  908.026163]  [<ffffffff8150ad95>] rt_spin_lock_slowlock+0xd5/0x2c0
[  908.026170]  [<ffffffff810658cf>] get_signal_to_deliver+0xaf/0x680
[  908.026175]  [<ffffffff8100242d>] do_signal+0x3d/0x5b0
[  908.026179]  [<ffffffff81002a30>] do_notify_resume+0x90/0xe0
[  908.026186]  [<ffffffff81513176>] int_signal+0x12/0x17
[  908.026193]  [<00007ff2a388b1d0>] 0x7ff2a388b1cf

and since upstream does not mind where we do this, be a bit nicer ...

Signed-off-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1393568591.6018.27.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/fork.c       | 1 +
 kernel/sched/core.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..332688e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -237,6 +237,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	task_numa_free(tsk);
 	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dd89c27..9e126a2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2151,8 +2151,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
-		task_numa_free(prev);
-
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
 
