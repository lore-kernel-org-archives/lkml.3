Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3IJVqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab3IJVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 08/16] binfmt_elf: Elf executable signature verification
Date: Tue, 10 Sep 2013 17:44:23 -0400
Message-Id: <1378849471-10521-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do elf executable signature verification (if one is present). If signature
is present, it should be valid. Validly signed executables are locked in
memory and a flag cred->proc_signed gets set to signify this process
executable contents are signed.

If file is unsigned, it can execute but it does not have the cred->proc_signed
set.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/Kconfig.binfmt    | 10 +++++++++
 fs/binfmt_elf.c      | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/cred.h |  2 ++
 kernel/cred.c        |  2 ++
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 370b24c..25ae6d3 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -23,6 +23,16 @@ config BINFMT_ELF
 	  ld.so (check the file <file:Documentation/Changes> for location and
 	  latest version).
 
+config BINFMT_ELF_SIG
+	bool "ELF binary signature verification"
+	depends on BINFMT_ELF
+	depends on INTEGRITY_ASYMMETRIC_KEYS
+	depends on IMA_APPRAISE
+	depends on SYSTEM_TRUSTED_KEYRING
+	default n
+	---help---
+	  Check ELF binary signature verfication.
+
 config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 100edcc..22a8272 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -34,6 +34,8 @@
 #include <linux/utsname.h>
 #include <linux/coredump.h>
 #include <linux/sched.h>
+#include <linux/ima.h>
+#include <keys/system_keyring.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -584,6 +586,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
 	struct pt_regs *regs = current_pt_regs();
+	char *signature = NULL;
+#ifdef CONFIG_BINFMT_ELF_SIG
+	unsigned int siglen = 0;
+	bool mlock_mappings = false;
+#endif
 	struct {
 		struct elfhdr elf_ex;
 		struct elfhdr interp_elf_ex;
@@ -725,6 +732,43 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	/* OK, This is the point of no return */
 	current->mm->def_flags = def_flags;
 
+#ifdef CONFIG_BINFMT_ELF_SIG
+	/*
+	 * If executable is digitally signed and ima memlock info present,
+	 * Lock down in memory
+	 */
+	retval = ima_file_signature_alloc(bprm->file, &signature);
+
+	/*
+	 * If there is an error getting signature, bail out. Having
+	 * no signature is fine though.
+	 */
+	if (retval < 0 && retval != -ENODATA && retval != -EOPNOTSUPP)
+		goto out_free_dentry;
+
+	if (signature != NULL) {
+		siglen = retval;
+		retval = ima_signature_type(signature);
+		if (retval == EVM_IMA_XATTR_DIGSIG &&
+		    ima_memlock_file(signature, siglen)) {
+			/*
+			 * Verify signature before locking down file. We don't
+			 * want to memlock executables with fake signatures
+			 */
+			retval = ima_appraise_file_digsig(
+					system_trusted_keyring,
+					bprm->file, signature, siglen);
+			if (retval) {
+				send_sig(SIGKILL, current, 0);
+				goto out_free_dentry;
+			}
+
+			mlock_mappings = true;
+			current->mm->def_flags |= VM_LOCKED;
+			set_bit(MMF_VM_LOCKED, &current->mm->flags);
+		}
+	}
+#endif
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
 	SET_PERSONALITY(loc->elf_ex);
@@ -895,6 +939,23 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out_free_dentry;
 	}
 
+#ifdef CONFIG_BINFMT_ELF_SIG
+	if (mlock_mappings) {
+		/*
+		 * File locked down in memory. Now it is safe against any
+		 * modifications on disk by raw disk writes. Verify signature.
+		 */
+		retval = ima_appraise_file_digsig(system_trusted_keyring,
+					bprm->file, signature, siglen);
+		if (retval) {
+			send_sig(SIGKILL, current, 0);
+			goto out_free_dentry;
+		}
+		/* Signature verification successful */
+		bprm->cred->proc_signed = true;
+	}
+#endif
+
 	if (elf_interpreter) {
 		unsigned long interp_map_addr = 0;
 
@@ -988,11 +1049,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	 */
 	ELF_PLAT_INIT(regs, reloc_func_desc);
 #endif
-
 	start_thread(regs, elf_entry, bprm->p);
 	retval = 0;
 out:
 	kfree(loc);
+	kfree(signature);
 out_ret:
 	return retval;
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..1f5f418 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -136,6 +136,8 @@ struct cred {
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	struct rcu_head	rcu;		/* RCU deletion hook */
+	bool	proc_signed;		/* Executable signature have been
+					 * verified post load */
 };
 
 extern void __put_cred(struct cred *);
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..589f1fa 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -299,6 +299,8 @@ struct cred *prepare_exec_creds(void)
 	new->process_keyring = NULL;
 #endif
 
+	/* proc_signed status will be evaluated again from executable file */
+	new->proc_signed = false;
 	return new;
 }
 
-- 
1.8.3.1

