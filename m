Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3IJVqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3IJVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 11/16] ptrace: Do not allow ptrace() from unsigned process to signed one
Date: Tue, 10 Sep 2013 17:44:26 -0400
Message-Id: <1378849471-10521-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not allow unsigned processes to ptrace() signed ones otherwise they can
modify the address space of signed processes and whole purpose of signature
verification is defeated.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/binfmt_elf.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 security/commoncap.c | 11 +++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 22a8272..8f2286e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -568,6 +568,43 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 #endif
 }
 
+#ifdef CONFIG_BINFMT_ELF_SIG
+/* check if current is being ptraced by tracer which is unsigned */
+static bool ptraced_by_unsafe_tracer(void)
+{
+	struct task_struct *child = current, *parent;
+	bool ret = false;
+	const struct cred *tcred;
+
+	/* Make sure parent does not change due to tracer ptrace detach */
+	read_lock(&tasklist_lock);
+
+	if (!child->ptrace) {
+		ret = false;
+		goto out;
+	}
+
+	parent = child->parent;
+	rcu_read_lock();
+	tcred = __task_cred(parent);
+	if (!tcred->proc_signed)
+		ret = true;
+	rcu_read_unlock();
+
+	/*
+	 * Make sure parent is memlocked too otherwise it might be signed
+	 * but still being swapped out and is open to address space
+	 * modifications.
+	 */
+	if (!test_bit(MMF_VM_LOCKED, &parent->mm->flags))
+		ret = true;
+
+out:
+	read_unlock(&tasklist_lock);
+	return ret;
+}
+#endif
+
 static int load_elf_binary(struct linux_binprm *bprm)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
@@ -951,8 +988,16 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			send_sig(SIGKILL, current, 0);
 			goto out_free_dentry;
 		}
-		/* Signature verification successful */
-		bprm->cred->proc_signed = true;
+
+		/*
+		 * Signature verification successful. If this process is
+		 * is being ptraced at the time of exec() and tracer is
+		 * not signed, do not set proc_signed, otherwise unsigned
+		 * tracer could change signed tracee's address space,
+		 * effectively nullifying singature checking.
+		 */
+		if (!ptraced_by_unsafe_tracer())
+			bprm->cred->proc_signed = true;
 	}
 #endif
 
diff --git a/security/commoncap.c b/security/commoncap.c
index c44b6fe..4d7f90e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -146,6 +146,12 @@ int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 	rcu_read_lock();
 	cred = current_cred();
 	child_cred = __task_cred(child);
+
+	if (mode != PTRACE_MODE_READ && child_cred->proc_signed &&
+	    !cred->proc_signed) {
+		ret = -EPERM;
+		goto out;
+	}
 	if (cred->user_ns == child_cred->user_ns &&
 	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
 		goto out;
@@ -178,6 +184,11 @@ int cap_ptrace_traceme(struct task_struct *parent)
 	rcu_read_lock();
 	cred = __task_cred(parent);
 	child_cred = current_cred();
+
+	if (child_cred->proc_signed && !cred->proc_signed) {
+		ret = -EPERM;
+		goto out;
+	}
 	if (cred->user_ns == child_cred->user_ns &&
 	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
 		goto out;
-- 
1.8.3.1

