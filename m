Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaJ0KSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:18:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:53153 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaJ0KSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:18:31 -0400
Message-ID: <1414405105.19914.169.camel@tkhai>
Subject: [PATCH] sched: Fix race between task_group and sched_task_group
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Mon, 27 Oct 2014 14:18:25 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 kernel/sched/core.c |    6 ++++++
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



