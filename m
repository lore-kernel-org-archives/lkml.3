Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3LXLvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 06:51:50 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56183 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3LXLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 06:51:49 -0500
X-Nat-Received: from [202.181.97.72]:61149 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1387885905.32014
To: swhiteho@redhat.com, rpeterso@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] GFS2: Fix unsafe dereference in dump_holder()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201312242051.ECA46103.MFFVFOtHSJOLQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 24 Dec 2013 20:51:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24122013 #7223428, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From efee681e4ca6152d9549a50e93ca932b00f03014 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 24 Dec 2013 18:04:43 +0900
Subject: [PATCH] GFS2: Fix unsafe dereference in dump_holder()

Since we are not in RCU nor tasklist_lock held, we need to grab a reference on
the returned task_struct. Use get_pid_task()/get_task_comm() to safely read the
target task's comm name.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/gfs2/glock.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c8420f7..7bda965 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1654,15 +1654,22 @@ static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 {
 	struct task_struct *gh_owner = NULL;
 	char flags_buf[32];
+	char name[TASK_COMM_LEN];
 
 	if (gh->gh_owner_pid)
-		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
+		gh_owner = get_pid_task(gh->gh_owner_pid, PIDTYPE_PID);
+	if (gh_owner) {
+		get_task_comm(name, gh_owner);
+		put_task_struct(gh_owner);
+	} else {
+		strlcpy(name, "(ended)", sizeof(name));
+	}
 	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
 		       state2str(gh->gh_state),
 		       hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
 		       gh->gh_error,
 		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
-		       gh_owner ? gh_owner->comm : "(ended)",
+		       name,
 		       (void *)gh->gh_ip);
 	return 0;
 }
-- 
1.7.1
