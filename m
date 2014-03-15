Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaCOXaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 19:30:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbaCOXaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 19:30:15 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH] audit: copy comm to avoid race in string printing
Date: Sat, 15 Mar 2014 19:29:16 -0400
Message-Id: <25427494a51f7e364cf2922175a6dd03238a7d1d.1394923956.git.rgb@redhat.com>
In-Reply-To: <20140315232846.GE27244@madcap2.tricolour.ca>
References: <20140315232846.GE27244@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 kernel/audit.c   |    5 ++---
 kernel/auditsc.c |    3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9239e5e..ecb08a5 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1883,7 +1883,7 @@ EXPORT_SYMBOL(audit_log_task_context);
 void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 {
 	const struct cred *cred;
-	char name[sizeof(tsk->comm)];
+	char comm[sizeof(tsk->comm)];
 	struct mm_struct *mm = tsk->mm;
 	char *tty;
 
@@ -1917,9 +1917,8 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 			 from_kgid(&init_user_ns, cred->fsgid),
 			 tty, audit_get_sessionid(tsk));
 
-	get_task_comm(name, tsk);
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, name);
+	audit_log_untrustedstring(ab, memcpy(comm, tsk->comm, sizeof(comm));
 
 	if (mm) {
 		down_read(&mm->mmap_sem);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8fffca8..dcddadd 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2434,6 +2434,7 @@ static void audit_log_task(struct audit_buffer *ab)
 	kuid_t auid, uid;
 	kgid_t gid;
 	unsigned int sessionid;
+	char comm[sizeof(current->comm)];
 	struct mm_struct *mm = current->mm;
 
 	auid = audit_get_loginuid(current);
@@ -2447,7 +2448,7 @@ static void audit_log_task(struct audit_buffer *ab)
 			 sessionid);
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", task_pid_nr(current));
-	audit_log_untrustedstring(ab, current->comm);
+	audit_log_untrustedstring(ab, memcpy(comm, current->comm, sizeof(comm));
 	if (mm) {
 		down_read(&mm->mmap_sem);
 		if (mm->exe_file)
-- 
1.7.1

