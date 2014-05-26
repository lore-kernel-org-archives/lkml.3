Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaEZKFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:05:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4489 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbaEZKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:05:21 -0400
X-IronPort-AV: E=Sophos;i="4.98,912,1392134400"; 
   d="scan'208";a="31011205"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Subject: [PATCH] /proc/pid/status: show all sets of pid according to ns
Date: Mon, 26 May 2014 18:05:28 +0800
Message-ID: <1401098728-2001-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a direct method of getting the pid inside containers.
If some issues occurred inside a container guest, host user
could not know which process is in trouble just by guest pid:
the users of container guest only knew the pid inside containers.
This will bring obstacle for trouble shooting.

This patch expands fields of Tgid and Pid:
a) In init_pid_ns, nothing changed;

b) In one pidns, they will tell the pid inside containers:
Tgid:	1628 	9 	3
Pid:	1628 	9 	3
** process id is 1628 in level 0, 9 in level 1, 3 in level 2.

c) If pidns is nested, it depends on which pidns are you in.
Tgid:	9 	3
Pid:	9 	3
** Views from level 1 for Pid 1628 in host.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 fs/proc/array.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 64db2bc..eef20dd 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -173,17 +173,23 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	cred = get_task_cred(p);
 	seq_printf(m,
 		"State:\t%s\n"
-		"Tgid:\t%d\n"
-		"Ngid:\t%d\n"
-		"Pid:\t%d\n"
+		"Ngid:\t%d\n",
+		get_task_state(p),
+		task_numa_group_id(p));
+	seq_puts(m, "Tgid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d ",
+		task_tgid_nr_ns(p, pid->numbers[g].ns));
+	seq_puts(m, "\nPid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d ",
+		task_pid_nr_ns(p, pid->numbers[g].ns));
+	seq_putc(m, '\n');
+	seq_printf(m,
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
-		get_task_state(p),
-		task_tgid_nr_ns(p, ns),
-		task_numa_group_id(p),
-		pid_nr_ns(pid, ns),
 		ppid, tpid,
 		from_kuid_munged(user_ns, cred->uid),
 		from_kuid_munged(user_ns, cred->euid),
-- 
1.9.0

