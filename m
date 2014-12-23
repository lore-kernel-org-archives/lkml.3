Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbaLWKUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:20:46 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:3689 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754628AbaLWKUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:20:42 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45757518"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: [resend][PATCH v9 2/3] /proc/PID/status: show all sets of pid according to ns
Date: Tue, 23 Dec 2014 18:20:38 +0800
Message-ID: <1419330039-29207-3-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419330039-29207-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1419330039-29207-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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
  NStgid: 21776   5       1
  NSpid:  21776   5       1
  NSpgid: 21776   5       1
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
v9: rebased on 3.19-rc1
No change from v4-v8
v3: add another two fielsd: NSpgid and NSsid.
v2: add two new fields: NStgid and NSpid.
    keep fields of Tgid and Pid unchanged for back compatibility.

 fs/proc/array.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index bd117d0..35205d4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -208,6 +208,22 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
 
+	seq_puts(m, "\nNStgid:");
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
 	seq_putc(m, '\n');
 }
 
-- 
1.9.3

