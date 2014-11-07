Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaKGUOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:14:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaKGUOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:14:45 -0500
Date: Fri, 7 Nov 2014 21:14:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] proc: task_state: ptrace_parent() doesn't need
	pid_alive() check
Message-ID: <20141107201454.GA22246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p->ptrace != 0 means that release_task(p) was not called, so pid_alive()
buys nothing and we can remove this check. Other callers already use it
directly without additional checks.

Note: with or without this patch ptrace_parent() can return the pointer
to the freed task, this will be explained/fixed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 800e30f..bd117d0 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -157,19 +157,18 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
 	int g;
+	struct task_struct *tracer;
 	const struct cred *cred;
-	pid_t ppid, tpid, tgid, ngid;
+	pid_t ppid, tpid = 0, tgid, ngid;
 	unsigned int max_fds = 0;
 
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
-	tpid = 0;
-	if (pid_alive(p)) {
-		struct task_struct *tracer = ptrace_parent(p);
-		if (tracer)
-			tpid = task_pid_nr_ns(tracer, ns);
-	}
+
+	tracer = ptrace_parent(p);
+	if (tracer)
+		tpid = task_pid_nr_ns(tracer, ns);
 
 	tgid = task_tgid_nr_ns(p, ns);
 	ngid = task_numa_group_id(p);
-- 
1.5.5.1

