Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaBSU7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaBSU7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:59:03 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, oleg@redhat.com, peterz@infradead.org,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH 1/5] pid: get pid_t ppid of task in init_pid_ns
Date: Wed, 19 Feb 2014 15:57:39 -0500
Message-Id: <696c3c3f38fa8bf38ea953da1f9f72db1e2a499d.1392842865.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1392842865.git.rgb@redhat.com>
References: <cover.1392842865.git.rgb@redhat.com>
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
 include/linux/sched.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb..685326f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1561,6 +1561,24 @@ static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 }
 
 
+static int pid_alive(const struct task_struct *p);
+static inline pid_t task_ppid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
+{
+	pid_t pid = 0;
+
+	rcu_read_lock();
+	if (pid_alive(tsk))
+		pid = task_tgid_nr_ns(rcu_dereference(tsk->real_parent), ns);
+	rcu_read_unlock();
+
+	return pid;
+}
+
+static inline pid_t task_ppid_nr(const struct task_struct *tsk)
+{
+	return task_ppid_nr_ns(tsk, &init_pid_ns);
+}
+
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
-- 
1.7.1

