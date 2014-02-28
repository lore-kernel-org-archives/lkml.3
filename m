Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaB1GX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:23:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:59317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaB1GXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:23:24 -0500
Message-ID: <1393568591.6018.27.camel@marge.simpson.net>
Subject: [patch] rt,sched,numa: Move task_numa_free() to
 __put_task_struct(), which -rt offloads
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Date: Fri, 28 Feb 2014 07:23:11 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:ESmJ2EyC+91rv5oTS0Dytlzd+UK2WKibgQNaErsE7f/
 9G91mxLOmuUPVSerjY4W90HtMw0KXGboRy7VZ27u4e7dD+iM+9
 TsvGE8urfjrpw/9uE1ly1MnuZn4TP+ajl5igJ+LzdOOM2qmxgQ
 uURzOm6+YID6tUPC8rnyN4wEbl6NQwgaveGoae/Op1zTfLgYda
 QfDEvaRzPVhSv01Cie/qY8nuY21X74aQxNafWlurf5TjWHdW4l
 EFhcr5XL2/b2dR5/Q6Trec43CmHaVPAFuvOq+qU6C0aGSU0V8M
 YGk9CvNfZQLToftb5LY+9uyDKFLJCvvYN2twCtZ4u/r9nvSpy5
 m6GqwFefAnGbL/ayWMdYN4nVDDgloghvn/1ulo3Fx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bad idea:
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

Signed-off-by: Mike Galbraith <bitbucket@online.de>

diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c6cd42..332688e5e7b4 100644
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
index 6edbef296ece..94a963fd040e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2149,8 +2149,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
-		task_numa_free(prev);
-
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
 


