Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaDVKDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:03:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:5718 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754468AbaDVKDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:03:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,900,1389715200"; 
   d="scan'208";a="29565887"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Subject: [PATCH] ns: Introduce pid_in_ns under /proc
Date: Tue, 22 Apr 2014 18:03:08 +0800
Message-ID: <1398160988-21577-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We lacked of convenient method of getting the pid inside containers.
If some issues occurred inside container guest, host user
could not know which process is in trouble just by guest pid:
the users of container guest only knew the pid inside containers.
This will bring obstacle for trouble shooting.

This patch introduces pid_in_ns:
If one process is in init_pid_ns, /proc/PID/pid_in_ns
equals to /proc/PID;
if one process is in pidns, /proc/PID/pid_in_ns
will tell the pid inside containers;
if pidns is nested, it depends on which pidns are you in.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 fs/proc/array.c    | 13 +++++++++++++
 fs/proc/base.c     |  1 +
 fs/proc/internal.h |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 64db2bc..8c3014b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -562,6 +562,19 @@ int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
 	return do_task_stat(m, ns, pid, task, 1);
 }
 
+int proc_pid_in_ns(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
+{
+        pid_t pid_in_ns;
+        int level;
+
+        level = pid->level;
+        pid_in_ns = task_pid_nr_ns(task, pid->numbers[level].ns);
+        seq_put_decimal_ull(m, 0, pid_in_ns);
+        seq_putc(m, '\n');
+        return 0;
+}
+
 int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0..42904b7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2574,6 +2574,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
+	ONE("pid_in_ns",  S_IRUGO, proc_pid_in_ns),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_pid_numa_maps_operations),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3ab6d14..573841a 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -155,6 +155,8 @@ extern int proc_pid_status(struct seq_file *, struct pid_namespace *,
 			   struct pid *, struct task_struct *);
 extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 			  struct pid *, struct task_struct *);
+extern int proc_pid_in_ns(struct seq_file *, struct pid_namespace *,
+			  struct pid *, struct task_struct *);
 
 /*
  * base.c
-- 
1.9.0

