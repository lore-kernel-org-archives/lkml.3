Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaE1KY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:24:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:47681 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbaE1KYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:24:24 -0400
X-IronPort-AV: E=Sophos;i="4.98,927,1392134400"; 
   d="scan'208";a="31124538"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Subject: [PATCH v2] /proc/pid/status: show all sets of pid according to ns
Date: Wed, 28 May 2014 18:24:43 +0800
Message-ID: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a direct method of getting the pid inside containers.
If some issues occurred inside container guest, host user
could not know which process is in trouble just by guest pid:
the users of container guest only knew the pid inside containers.
This will bring obstacle for trouble shooting.

This patch adds two fields:

NStgid and NSpid.

a) In init_pid_ns, nothing changed;

b) In one pidns, will tell the pid inside containers:
NStgid:	1628 	9 	3
NSpid:	1628 	9 	3
** Process id is 1628 in level 0, 9 in level 1, 3 in level 2.

c) If pidns is nested, it depends on which pidns are you in.
NStgid:	9 	3
NSpid:	9 	3
** Views from level 1

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
v2: add two new fields: NStgid and NSpid.
    keep fields of Tgid and Pid unchanged for back compatibility.

 fs/proc/array.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 64db2bc..9b7e65c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -193,6 +193,15 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		from_kgid_munged(user_ns, cred->egid),
 		from_kgid_munged(user_ns, cred->sgid),
 		from_kgid_munged(user_ns, cred->fsgid));
+	seq_puts(m, "NStgid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d ",
+			task_tgid_nr_ns(p, pid->numbers[g].ns));
+	seq_puts(m, "\nNSpid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d ",
+			task_pid_nr_ns(p, pid->numbers[g].ns));
+	seq_putc(m, '\n');
 
 	task_lock(p);
 	if (p->files)
-- 
1.9.0

