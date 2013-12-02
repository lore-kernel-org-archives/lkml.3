Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab3LBVM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:12:26 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:53351 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3LBVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:10:51 -0500
From: William Roberts <bill.c.roberts@gmail.com>
To: linux-audit@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rgb@redhat.com, viro@zeniv.linux.org.uk
Cc: sds@tycho.nsa.gov, William Roberts <wroberts@tresys.com>
Subject: [PATCH 2/3] proc: Update get proc_pid_cmdline() to use mm.h helpers
Date: Mon,  2 Dec 2013 13:10:38 -0800
Message-Id: <1386018639-18916-3-git-send-email-wroberts@tresys.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
References: <1386018639-18916-1-git-send-email-wroberts@tresys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-factor proc_pid_cmdline() to use get_cmdline_length() and
copy_cmdline() helpers from mm.h

Signed-off-by: William Roberts <wroberts@tresys.com>
---
 fs/proc/base.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 03c8d74..fb4eda5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -203,37 +203,22 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
-	unsigned int len;
+	unsigned int len = 0;
 	struct mm_struct *mm = get_task_mm(task);
 	if (!mm)
-		goto out;
-	if (!mm->arg_end)
-		goto out_mm;	/* Shh! No looking before we're done */
+		return 0;
 
- 	len = mm->arg_end - mm->arg_start;
- 
+	len = get_cmdline_length(mm);
+	if (!len)
+		goto mm_out;
+
+	/*The caller of this allocates a page */
 	if (len > PAGE_SIZE)
 		len = PAGE_SIZE;
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
+
+	res = copy_cmdline(task, mm, buffer, len);
+mm_out:
 	mmput(mm);
-out:
 	return res;
 }
 
-- 
1.7.9.5

