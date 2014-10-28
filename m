Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaJ1LCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:02:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaJ1LCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:02:49 -0400
Date: Tue, 28 Oct 2014 04:01:30 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-eeb61e53ea19be0c4015b00b2e8b3b2185436f2b@git.kernel.org>
Cc: ktkhai@parallels.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org
Reply-To: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, ktkhai@parallels.com,
        peterz@infradead.org, mingo@kernel.org
In-Reply-To: <1414405105.19914.169.camel@tkhai>
References: <1414405105.19914.169.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix race between task_group and sched_task_group
Git-Commit-ID: eeb61e53ea19be0c4015b00b2e8b3b2185436f2b
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

Commit-ID:  eeb61e53ea19be0c4015b00b2e8b3b2185436f2b
Gitweb:     http://git.kernel.org/tip/eeb61e53ea19be0c4015b00b2e8b3b2185436f2b
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 27 Oct 2014 14:18:25 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:45:59 +0100

sched: Fix race between task_group and sched_task_group

The race may happen when somebody is changing task_group of a forking task.
Child's cgroup is the same as parent's after dup_task_struct() (there just
memory copying). Also, cfs_rq and rt_rq are the same as parent's.

But if parent changes its task_group before it's called cgroup_post_fork(),
we do not reflect this situation on child. Child's cfs_rq and rt_rq remain
the same, while child's task_group changes in cgroup_post_fork().

To fix this we introduce fork() method, which calls sched_move_task() directly.
This function changes sched_task_group on appropriate (also its logic has
no problem with freshly created tasks, so we shouldn't introduce something
special; we are able just to use it).

Possibly, this decides the Burke Libbey's problem: https://lkml.org/lkml/2014/10/24/456

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414405105.19914.169.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4499950..dde8adb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7833,6 +7833,11 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
 	sched_offline_group(tg);
 }
 
+static void cpu_cgroup_fork(struct task_struct *task)
+{
+	sched_move_task(task);
+}
+
 static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
 				 struct cgroup_taskset *tset)
 {
@@ -8205,6 +8210,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_free	= cpu_cgroup_css_free,
 	.css_online	= cpu_cgroup_css_online,
 	.css_offline	= cpu_cgroup_css_offline,
+	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
