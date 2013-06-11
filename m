Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3FKNMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:12:47 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49524 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3FKNMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:12:45 -0400
X-Nat-Received: from [202.181.97.72]:49460 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1370956363.15889
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 1/4] LSM: Add security_bprm_aborting_creds() hook.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
Message-Id: <201306112212.JHI90114.HOOLMVJFStQFFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Jun 2013 22:12:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11062013 #10379665, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 27dfd0d7652917601a53f4439678097c8ce67b2b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 11 Jun 2013 21:26:53 +0900
Subject: [PATCH 1/4] LSM: Add security_bprm_aborting_creds() hook.

Add a LSM hook which is called only when an execve operation failed after
prepare_bprm_creds() succeeded. This hook is used by TOMOYO for synchronously
cleaning up resources allocated during an execve operation.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c                |    1 +
 include/linux/security.h |   11 +++++++++++
 security/capability.c    |    5 +++++
 security/security.c      |    5 +++++
 4 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6430195..f71b2ae 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1175,6 +1175,7 @@ void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		security_bprm_aborting_creds(bprm);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
diff --git a/include/linux/security.h b/include/linux/security.h
index 40560f4..6f03e37 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -232,6 +232,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	linux_binprm structure.  This hook is a good place to perform state
  *	changes on the process such as clearing out non-inheritable signal
  *	state.  This is called immediately after commit_creds().
+ * @bprm_aborting_creds:
+ *	This hook is called when an execve operation failed after
+ *	prepare_bprm_creds() succeeded so that we can synchronously clean up
+ *	resources used by an execve operation.
+ *	@bprm points to the linux_binprm structure.
  * @bprm_secureexec:
  *	Return a boolean value (0 or 1) indicating whether a "secure exec"
  *	is required.  The flag is passed in the auxiliary table
@@ -1426,6 +1431,7 @@ struct security_operations {
 	int (*bprm_secureexec) (struct linux_binprm *bprm);
 	void (*bprm_committing_creds) (struct linux_binprm *bprm);
 	void (*bprm_committed_creds) (struct linux_binprm *bprm);
+	void (*bprm_aborting_creds) (struct linux_binprm *bprm);
 
 	int (*sb_alloc_security) (struct super_block *sb);
 	void (*sb_free_security) (struct super_block *sb);
@@ -1714,6 +1720,7 @@ int security_bprm_set_creds(struct linux_binprm *bprm);
 int security_bprm_check(struct linux_binprm *bprm);
 void security_bprm_committing_creds(struct linux_binprm *bprm);
 void security_bprm_committed_creds(struct linux_binprm *bprm);
+void security_bprm_aborting_creds(struct linux_binprm *bprm);
 int security_bprm_secureexec(struct linux_binprm *bprm);
 int security_sb_alloc(struct super_block *sb);
 void security_sb_free(struct super_block *sb);
@@ -1954,6 +1961,10 @@ static inline void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
 }
 
+static inline void security_bprm_aborting_creds(struct linux_binprm *bprm)
+{
+}
+
 static inline int security_bprm_secureexec(struct linux_binprm *bprm)
 {
 	return cap_bprm_secureexec(bprm);
diff --git a/security/capability.c b/security/capability.c
index 1728d4e..34b6f09 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -40,6 +40,10 @@ static void cap_bprm_committed_creds(struct linux_binprm *bprm)
 {
 }
 
+static void cap_bprm_aborting_creds(struct linux_binprm *bprm)
+{
+}
+
 static int cap_sb_alloc_security(struct super_block *sb)
 {
 	return 0;
@@ -916,6 +920,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, bprm_set_creds);
 	set_to_cap_if_null(ops, bprm_committing_creds);
 	set_to_cap_if_null(ops, bprm_committed_creds);
+	set_to_cap_if_null(ops, bprm_aborting_creds);
 	set_to_cap_if_null(ops, bprm_check_security);
 	set_to_cap_if_null(ops, bprm_secureexec);
 	set_to_cap_if_null(ops, sb_alloc_security);
diff --git a/security/security.c b/security/security.c
index a3dce87..7123178 100644
--- a/security/security.c
+++ b/security/security.c
@@ -235,6 +235,11 @@ void security_bprm_committed_creds(struct linux_binprm *bprm)
 	security_ops->bprm_committed_creds(bprm);
 }
 
+void security_bprm_aborting_creds(struct linux_binprm *bprm)
+{
+	security_ops->bprm_aborting_creds(bprm);
+}
+
 int security_bprm_secureexec(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_secureexec(bprm);
-- 
1.7.1
