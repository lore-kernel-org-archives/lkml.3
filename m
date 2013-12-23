Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3LWWbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:31:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab3LWWbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 17:31:13 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/5] pid: get pid_t ppid of task in init_pid_ns
Date: Mon, 23 Dec 2013 17:27:35 -0500
Message-Id: <c6524d385bffe974c071e46f8b1c9b1df69a7d9d.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the functions task_ppid_nr_ns() and task_ppid_nr() to abstract the lookup
of the PPID (real_parent's pid_t) of a process, including rcu locking, in the
arbitrary and init_pid_ns.
This provides an alternative to sys_getppid(), which is relative to the child
process' pid namespace.

(informed by ebiederman's 6c621b7e)
Cc: stable@vger.kernel.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e27baee..7bf5ab2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1497,6 +1497,30 @@ static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 }
 
 
+static inline pid_t task_ppid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	pid_t pid;
+
+	rcu_read_lock();
+	pid = pid_alive(tsk) ?
+		task_pid_nr_ns(rcu_dereference(tsk->real_parent), ns) : 0;
+	rcu_read_unlock();
+
+	return pid;
+}
+
+static inline pid_t task_ppid_nr(struct task_struct *tsk)
+{
+	pid_t pid;
+
+	rcu_read_lock();
+	pid = pid_alive(tsk) ?
+		task_pid_nr(rcu_dereference(tsk->real_parent)) : 0;
+	rcu_read_unlock();
+
+	return pid;
+}
+
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
-- 
1.7.1

