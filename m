Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaAOSCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:02:33 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:50686 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaAOSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:02:20 -0500
From: William Roberts <bill.c.roberts@gmail.com>
To: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        sds@tycho.nsa.gov
Cc: William Roberts <wroberts@tresys.com>
Subject: [PATCH v3 2/3] proc: Update get proc_pid_cmdline() to use mm.h helpers
Date: Wed, 15 Jan 2014 13:02:13 -0500
Message-Id: <1389808934-4446-2-git-send-email-wroberts@tresys.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389808934-4446-1-git-send-email-wroberts@tresys.com>
References: <1389808934-4446-1-git-send-email-wroberts@tresys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-factor proc_pid_cmdline() to use get_cmdline() helper
from mm.h.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

Signed-off-by: William Roberts <wroberts@tresys.com>
---
 fs/proc/base.c |   36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 03c8d74..cfd178d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -200,41 +200,9 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-static int proc_pid_cmdline(struct task_struct *task, char * buffer)
+static int proc_pid_cmdline(struct task_struct *task, char *buffer)
 {
-	int res = 0;
-	unsigned int len;
-	struct mm_struct *mm = get_task_mm(task);
-	if (!mm)
-		goto out;
-	if (!mm->arg_end)
-		goto out_mm;	/* Shh! No looking before we're done */
-
- 	len = mm->arg_end - mm->arg_start;
- 
-	if (len > PAGE_SIZE)
-		len = PAGE_SIZE;
- 
-	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
-
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
-	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
-		len = strnlen(buffer, res);
-		if (len < res) {
-		    res = len;
-		} else {
-			len = mm->env_end - mm->env_start;
-			if (len > PAGE_SIZE - res)
-				len = PAGE_SIZE - res;
-			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
-			res = strnlen(buffer, res);
-		}
-	}
-out_mm:
-	mmput(mm);
-out:
-	return res;
+	return get_cmdline(task, buffer, PAGE_SIZE);
 }
 
 static int proc_pid_auxv(struct task_struct *task, char *buffer)
-- 
1.7.9.5

