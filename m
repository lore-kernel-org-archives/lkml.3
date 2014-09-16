Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaIPKR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:17:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14947 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393AbaIPKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:17:44 -0400
X-IronPort-AV: E=Sophos;i="5.04,534,1406563200"; 
   d="scan'208";a="36021427"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: [RESEND][PATCH 2/2] /proc/PID/status: show all sets of pid according to ns
Date: Tue, 16 Sep 2014 18:17:27 +0800
Message-ID: <1410862647-14213-3-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1410862647-14213-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1410862647-14213-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If some issues occurred inside a container guest, host user
could not know which process is in trouble just by guest pid:
the users of container guest only knew the pid inside containers.
This will bring obstacle for trouble shooting.

This patch adds four fields: NStgid, NSpid, NSpgid and NSsid:
a) In init_pid_ns, nothing changed;

b) In one pidns, will tell the pid inside containers:
NStgid:	21776 	5 	1
NSpid:	21776 	5 	1
NSpgid:	21776 	5 	1
NSsid:	21729 	1 	0
** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.

c) If pidns is nested, it depends on which pidns are you in.
NStgid:	5 	1
NSpid:	5 	1
NSpgid:	5 	1
NSsid:	1 	0
** Views from level 1

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
v2: add two new fields: NStgid and NSpid.
    keep fields of Tgid and Pid unchanged for back compatibility.
v3: add another two fielsd: NSpgid and NSsid.

 fs/proc/array.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cd3653e..c30875d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -193,6 +193,23 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
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
+	seq_puts(m, "\nNSpgid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d ",
+			task_pgrp_nr_ns(p, pid->numbers[g].ns));
+	seq_puts(m, "\nNSsid:");
+	for (g = ns->level; g <= pid->level; g++)
+		seq_printf(m, "\t%d ",
+			task_session_nr_ns(p, pid->numbers[g].ns));
+	seq_putc(m, '\n');
 
 	task_lock(p);
 	if (p->files)
-- 
1.9.0

