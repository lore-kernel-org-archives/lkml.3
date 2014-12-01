Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaLALGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:06:23 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:35218 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753142AbaLALGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:06:20 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44259000"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCH v9 2/3] /proc/PID/status: show all sets of pid according to ns
Date: Mon, 1 Dec 2014 19:06:17 +0800
Message-ID: <1417431978-24723-3-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417431978-24723-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1417431978-24723-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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
NStgid:	21776   5       1
NSpid:  21776   5       1
NSpgid:	21776   5       1
NSsid:  21729   1       0
** Process id is 21776 in level 0, 5 in level 1, 1 in level 2.

c) If pidns is nested, it depends on which pidns are you in.
NStgid: 5       1
NSpid:  5       1
NSpgid: 5       1
NSsid:  1       0
** Views from level 1

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
No change since v3
v3: add another two fielsd: NSpgid and NSsid.
v2: add two new fields: NStgid and NSpid.
    keep fields of Tgid and Pid unchanged for back compatibility.

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
1.9.3

