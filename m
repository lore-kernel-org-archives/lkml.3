Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaIKImG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:42:06 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:64092 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 03/10] binfmt_elf: allow arch code to examine PT_LOPROC ... PT_HIPROC headers
Date: Thu, 11 Sep 2014 08:30:16 +0100
Message-ID: <1410420623-11691-4-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS is introducing new variants of its O32 ABI which differ in their
handling of floating point, in order to enable a gradual transition
towards a world where mips32 binaries can take advantage of new hardware
features only available when configured for certain FP modes. In order
to do this ELF binaries are being augmented with a new section that
indicates, amongst other things, the FP mode requirements of the binary.
The presence & location of such a section is indicated by a program
header in the PT_LOPROC ... PT_HIPROC range.

In order to allow the MIPS architecture code to examine the program
header & section in question, pass all program headers in this range
to an architecture-specific arch_elf_pt_proc function. This function
may return an error if the header is deemed invalid or unsuitable for
the system, in which case that error will be returned from
load_elf_binary and upwards through the execve syscall.

A means is required for the architecture code to make a decision once
it is known that all such headers have been seen, but before it is too
late to return from an execve syscall. For this purpose the
arch_check_elf function is added, and called once, after all PT_LOPROC
to PT_HIPROC headers have been passed to arch_elf_pt_proc but before
the code which invoked execve has been lost. This enables the
architecture code to make a decision based upon all the headers present
in an ELF binary and its interpreter, as is required to forbid
conflicting FP ABI requirements between an ELF & its interpreter.

In order to allow data to be stored throughout the calls to the above
functions, struct arch_elf_state is introduced.

Finally a variant of the SET_PERSONALITY macro is introduced which
accepts a pointer to the struct arch_elf_state, allowing it to act
based upon state observed from the architecture specific program
headers.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 fs/Kconfig.binfmt   |  3 +++
 fs/binfmt_elf.c     | 36 ++++++++++++++++++++++++--
 include/linux/elf.h | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 370b24c..c055d56 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -30,6 +30,9 @@ config COMPAT_BINFMT_ELF
 config ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	bool
 
+config ARCH_BINFMT_ELF_STATE
+	bool
+
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 61dabe0..ceabb0d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -611,6 +611,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		struct elfhdr elf_ex;
 		struct elfhdr interp_elf_ex;
 	} *loc;
+	struct arch_elf_state arch_state = INIT_ARCH_ELF_STATE;
 
 	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
 	if (!loc) {
@@ -705,12 +706,21 @@ static int load_elf_binary(struct linux_binprm *bprm)
 
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < loc->elf_ex.e_phnum; i++, elf_ppnt++)
-		if (elf_ppnt->p_type == PT_GNU_STACK) {
+		switch (elf_ppnt->p_type) {
+		case PT_GNU_STACK:
 			if (elf_ppnt->p_flags & PF_X)
 				executable_stack = EXSTACK_ENABLE_X;
 			else
 				executable_stack = EXSTACK_DISABLE_X;
 			break;
+
+		case PT_LOPROC ... PT_HIPROC:
+			retval = arch_elf_pt_proc(&loc->elf_ex, elf_ppnt,
+						  bprm->file, false,
+						  &arch_state);
+			if (retval)
+				goto out_free_dentry;
+			break;
 		}
 
 	/* Some simple consistency checks for the interpreter */
@@ -728,8 +738,30 @@ static int load_elf_binary(struct linux_binprm *bprm)
 						   interpreter);
 		if (!interp_elf_phdata)
 			goto out_free_dentry;
+
+		/* Pass PT_LOPROC..PT_HIPROC headers to arch code */
+		elf_ppnt = interp_elf_phdata;
+		for (i = 0; i < loc->interp_elf_ex.e_phnum; i++, elf_ppnt++)
+			switch (elf_ppnt->p_type) {
+			case PT_LOPROC ... PT_HIPROC:
+				retval = arch_elf_pt_proc(&loc->interp_elf_ex,
+							  elf_ppnt, interpreter,
+							  true, &arch_state);
+				if (retval)
+					goto out_free_dentry;
+				break;
+			}
 	}
 
+	/*
+	 * Allow arch code to reject the ELF at this point, whilst it's
+	 * still possible to return an error to the code that invoked
+	 * the exec syscall.
+	 */
+	retval = arch_check_elf(&loc->elf_ex, !!interpreter, &arch_state);
+	if (retval)
+		goto out_free_dentry;
+
 	/* Flush all traces of the currently running executable */
 	retval = flush_old_exec(bprm);
 	if (retval)
@@ -737,7 +769,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
-	SET_PERSONALITY(loc->elf_ex);
+	SET_PERSONALITY2(loc->elf_ex, &arch_state);
 	if (elf_read_implies_exec(loc->elf_ex, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 67a5fa7..6bd1504 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -15,6 +15,11 @@
 	set_personality(PER_LINUX | (current->personality & (~PER_MASK)))
 #endif
 
+#ifndef SET_PERSONALITY2
+#define SET_PERSONALITY2(ex, state) \
+	SET_PERSONALITY(ex)
+#endif
+
 #if ELF_CLASS == ELFCLASS32
 
 extern Elf32_Dyn _DYNAMIC [];
@@ -37,6 +42,74 @@ extern Elf64_Dyn _DYNAMIC [];
 
 #endif
 
+#ifndef CONFIG_ARCH_BINFMT_ELF_STATE
+
+/**
+ * struct arch_elf_state - arch-specific ELF loading state
+ *
+ * This structure is used to preserve architecture specific data during
+ * the loading of an ELF file, throughout the checking of architecture
+ * specific ELF headers & through to the point where the ELF load is
+ * known to be proceeding (ie. SET_PERSONALITY).
+ *
+ * This implementation is a dummy for architectures which require no
+ * specific state.
+ */
+struct arch_elf_state {
+};
+
+#define INIT_ARCH_ELF_STATE {}
+
+/**
+ * arch_elf_pt_proc() - check a PT_LOPROC..PT_HIPROC ELF program header
+ * @ehdr:	The main ELF header
+ * @phdr:	The program header to check
+ * @elf:	The open ELF file
+ * @is_interp:	True if the phdr is from the interpreter of the ELF being
+ *		loaded, else false.
+ * @state:	Architecture-specific state preserved throughout the process
+ *		of loading the ELF.
+ *
+ * Inspects the program header phdr to validate its correctness and/or
+ * suitability for the system. Called once per ELF program header in the
+ * range PT_LOPROC to PT_HIPROC, for both the ELF being loaded and its
+ * interpreter.
+ *
+ * Return: Zero to proceed with the ELF load, non-zero to fail the ELF load
+ *         with that return code.
+ */
+static inline int arch_elf_pt_proc(struct elfhdr *ehdr,
+				   struct elf_phdr *phdr,
+				   struct file *elf, bool is_interp,
+				   struct arch_elf_state *state)
+{
+	/* Dummy implementation, always proceed */
+	return 0;
+}
+
+/**
+ * arch_elf_pt_proc() - check a PT_LOPROC..PT_HIPROC ELF program header
+ * @ehdr:	The main ELF header
+ * @has_interp:	True if the ELF has an interpreter, else false.
+ * @state:	Architecture-specific state preserved throughout the process
+ *		of loading the ELF.
+ *
+ * Provides a final opportunity for architecture code to reject the loading
+ * of the ELF & cause an exec syscall to return an error. This is called after
+ * all program headers to be checked by arch_elf_pt_proc have been.
+ *
+ * Return: Zero to proceed with the ELF load, non-zero to fail the ELF load
+ *         with that return code.
+ */
+static inline int arch_check_elf(struct elfhdr *ehdr, bool has_interp,
+				 struct arch_elf_state *state)
+{
+	/* Dummy implementation, always proceed */
+	return 0;
+}
+
+#endif /* !CONFIG_ARCH_BINFMT_ELF_STATE */
+
 /* Optional callbacks to write extra ELF notes. */
 struct file;
 struct coredump_params;
-- 
2.0.4

