Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKGUOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:14:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaKGUOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:14:42 -0500
Date: Fri, 7 Nov 2014 21:14:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] proc: task_state: move the main seq_printf() outside
	of rcu_read_lock()
Message-ID: <20141107201451.GA22243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_state() does seq_printf() under rcu_read_lock(), but this is only
needed for task_tgid_nr_ns() and task_numa_group_id(). We can calculate
tgid/ngid and drop rcu lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7c8d9ae..800e30f 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -158,7 +158,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	struct group_info *group_info;
 	int g;
 	const struct cred *cred;
-	pid_t ppid, tpid;
+	pid_t ppid, tpid, tgid, ngid;
 	unsigned int max_fds = 0;
 
 	rcu_read_lock();
@@ -170,12 +170,16 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
+
+	tgid = task_tgid_nr_ns(p, ns);
+	ngid = task_numa_group_id(p);
 	cred = get_task_cred(p);
 
 	task_lock(p);
 	if (p->files)
 		max_fds = files_fdtable(p->files)->max_fds;
 	task_unlock(p);
+	rcu_read_unlock();
 
 	seq_printf(m,
 		"State:\t%s\n"
@@ -188,10 +192,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"Gid:\t%d\t%d\t%d\t%d\n"
 		"FDSize:\t%d\nGroups:\t",
 		get_task_state(p),
-		task_tgid_nr_ns(p, ns),
-		task_numa_group_id(p),
-		pid_nr_ns(pid, ns),
-		ppid, tpid,
+		tgid, ngid, pid_nr_ns(pid, ns), ppid, tpid,
 		from_kuid_munged(user_ns, cred->uid),
 		from_kuid_munged(user_ns, cred->euid),
 		from_kuid_munged(user_ns, cred->suid),
@@ -201,7 +202,6 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		from_kgid_munged(user_ns, cred->sgid),
 		from_kgid_munged(user_ns, cred->fsgid),
 		max_fds);
-	rcu_read_unlock();
 
 	group_info = cred->group_info;
 	for (g = 0; g < group_info->ngroups; g++)
-- 
1.5.5.1

