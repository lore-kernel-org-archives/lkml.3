Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3JIAOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:14:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60564 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3JIAOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:14:38 -0400
Date: Wed, 09 Oct 2013 01:14:37 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 03/13] switch elf_core_write_extra_phdrs() to
 dump_emit()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThQD-0002vt-MH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/elfcore.c |    6 ++----
 arch/x86/um/elfcore.c      |    7 ++-----
 fs/binfmt_elf.c            |    4 ++--
 fs/binfmt_elf_fdpic.c      |    4 +++-
 include/linux/elfcore.h    |    5 +++--
 kernel/elfcore.c           |   10 +++-------
 6 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
index bac1639..798ce54 100644
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -11,8 +11,7 @@ Elf64_Half elf_core_extra_phdrs(void)
 	return GATE_EHDR->e_phnum;
 }
 
-int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
-			       unsigned long limit)
+int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 {
 	const struct elf_phdr *const gate_phdrs =
 		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
@@ -35,8 +34,7 @@ int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 			phdr.p_offset += ofs;
 		}
 		phdr.p_paddr = 0; /* match other core phdrs */
-		*size += sizeof(phdr);
-		if (*size > limit || !dump_write(file, &phdr, sizeof(phdr)))
+		if (!dump_emit(cprm, &phdr, sizeof(phdr)))
 			return 0;
 	}
 	return 1;
diff --git a/arch/x86/um/elfcore.c b/arch/x86/um/elfcore.c
index 6bb49b6..fc21f98 100644
--- a/arch/x86/um/elfcore.c
+++ b/arch/x86/um/elfcore.c
@@ -11,8 +11,7 @@ Elf32_Half elf_core_extra_phdrs(void)
 	return vsyscall_ehdr ? (((struct elfhdr *)vsyscall_ehdr)->e_phnum) : 0;
 }
 
-int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
-			       unsigned long limit)
+int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 {
 	if ( vsyscall_ehdr ) {
 		const struct elfhdr *const ehdrp =
@@ -32,9 +31,7 @@ int elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
 				phdr.p_offset += ofs;
 			}
 			phdr.p_paddr = 0; /* match other core phdrs */
-			*size += sizeof(phdr);
-			if (*size > limit
-			    || !dump_write(file, &phdr, sizeof(phdr)))
+			if (!dump_emit(cprm, &phdr, sizeof(phdr)))
 				return 0;
 		}
 	}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4bdf6b6..aba4199 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2152,11 +2152,11 @@ static int elf_core_dump(struct coredump_params *cprm)
 		if (!dump_emit(cprm, &phdr, sizeof(phdr)))
 			goto end_coredump;
 	}
-	size = cprm->written;
 
-	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
+	if (!elf_core_write_extra_phdrs(cprm, offset))
 		goto end_coredump;
 
+	size = cprm->written;
 	cprm->written = foffset;	/* will disappear */
  	/* write out the notes section */
 	if (!write_note_info(&info, cprm))
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index ea4c627..44db8b9 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1791,9 +1791,11 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 			goto end_coredump;
 	}
 
-	if (!elf_core_write_extra_phdrs(cprm->file, offset, &size, cprm->limit))
+	cprm->written = size;
+	if (!elf_core_write_extra_phdrs(cprm, offset))
 		goto end_coredump;
 
+	size = cprm->written;
  	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
 		if (!writenote(notes + i, cprm->file, &foffset))
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index cdd3d13..1b92a8c 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -6,6 +6,8 @@
 #include <asm/elf.h>
 #include <uapi/linux/elfcore.h>
 
+struct coredump_params;
+
 static inline void elf_core_copy_regs(elf_gregset_t *elfregs, struct pt_regs *regs)
 {
 #ifdef ELF_CORE_COPY_REGS
@@ -63,8 +65,7 @@ static inline int elf_core_copy_task_xfpregs(struct task_struct *t, elf_fpxregse
  */
 extern Elf_Half elf_core_extra_phdrs(void);
 extern int
-elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
-			   unsigned long limit);
+elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset);
 extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
 extern size_t elf_core_extra_data_size(void);
diff --git a/kernel/elfcore.c b/kernel/elfcore.c
index ff915ef..e556751 100644
--- a/kernel/elfcore.c
+++ b/kernel/elfcore.c
@@ -1,23 +1,19 @@
 #include <linux/elf.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-
-#include <asm/elf.h>
-
+#include <linux/binfmts.h>
 
 Elf_Half __weak elf_core_extra_phdrs(void)
 {
 	return 0;
 }
 
-int __weak elf_core_write_extra_phdrs(struct file *file, loff_t offset, size_t *size,
-				      unsigned long limit)
+int __weak elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 {
 	return 1;
 }
 
-int __weak elf_core_write_extra_data(struct file *file, size_t *size,
-				     unsigned long limit)
+int __weak elf_core_write_extra_data(struct coredump_params *cprm)
 {
 	return 1;
 }
-- 
1.7.2.5


