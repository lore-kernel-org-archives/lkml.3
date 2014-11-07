Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaKGUOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaKGUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:14:39 -0500
Date: Fri, 7 Nov 2014 21:14:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] proc: task_state: deuglify the max_fds calculation
Message-ID: <20141107201448.GA22236@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. The usage of fdt looks very ugly, it can't be NULL if ->files is
   not NULL. We can use "unsigned int max_fds" instead.

2. This also allows to move seq_printf(max_fds) outside of task_lock()
   and join it with the previous seq_printf(). See also the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index b5810c2..7c8d9ae 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -157,9 +157,9 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
 	int g;
-	struct fdtable *fdt = NULL;
 	const struct cred *cred;
 	pid_t ppid, tpid;
+	unsigned int max_fds = 0;
 
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
@@ -171,6 +171,12 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
 	cred = get_task_cred(p);
+
+	task_lock(p);
+	if (p->files)
+		max_fds = files_fdtable(p->files)->max_fds;
+	task_unlock(p);
+
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -179,7 +185,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
 		"Uid:\t%d\t%d\t%d\t%d\n"
-		"Gid:\t%d\t%d\t%d\t%d\n",
+		"Gid:\t%d\t%d\t%d\t%d\n"
+		"FDSize:\t%d\nGroups:\t",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
 		task_numa_group_id(p),
@@ -192,16 +199,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		from_kgid_munged(user_ns, cred->gid),
 		from_kgid_munged(user_ns, cred->egid),
 		from_kgid_munged(user_ns, cred->sgid),
-		from_kgid_munged(user_ns, cred->fsgid));
-
-	task_lock(p);
-	if (p->files)
-		fdt = files_fdtable(p->files);
-	seq_printf(m,
-		"FDSize:\t%d\n"
-		"Groups:\t",
-		fdt ? fdt->max_fds : 0);
-	task_unlock(p);
+		from_kgid_munged(user_ns, cred->fsgid),
+		max_fds);
 	rcu_read_unlock();
 
 	group_info = cred->group_info;
-- 
1.5.5.1

