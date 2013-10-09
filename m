Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3JIAOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:14:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3JIAOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:14:48 -0400
Date: Wed, 09 Oct 2013 01:14:47 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 04/13] switch elf_core_write_extra_data() to
 dump_emit()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThQN-0002wC-MY@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/elfcore.c |    6 ++----
 arch/x86/um/elfcore.c      |    8 ++------
 fs/binfmt_elf.c            |    4 +++-
 fs/binfmt_elf_fdpic.c      |    4 +++-
 include/linux/elfcore.h    |    2 +-
 5 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
index 798ce54..04bc8fd 100644
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -40,8 +40,7 @@ int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 	return 1;
 }
 
-int elf_core_write_extra_data(struct file *file, size_t *size,
-			      unsigned long limit)
+int elf_core_write_extra_data(struct coredump_params *cprm)
 {
 	const struct elf_phdr *const gate_phdrs =
 		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
@@ -52,8 +51,7 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
 			void *addr = (void *)gate_phdrs[i].p_vaddr;
 			size_t memsz = PAGE_ALIGN(gate_phdrs[i].p_memsz);
 
-			*size += memsz;
-			if (*size > limit || !dump_write(file, addr, memsz))
+			if (!dump_emit(cprm, addr, memsz))
 				return 0;
 			break;
 		}
diff --git a/arch/x86/um/elfcore.c b/arch/x86/um/elfcore.c
index fc21f98..7bb89a2 100644
--- a/arch/x86/um/elfcore.c
+++ b/arch/x86/um/elfcore.c
@@ -38,8 +38,7 @@ int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 	return 1;
 }
 
-int elf_core_write_extra_data(struct file *file, size_t *size,
-			      unsigned long limit)
+int elf_core_write_extra_data(struct coredump_params *cprm)
 {
 	if ( vsyscall_ehdr ) {
 		const struct elfhdr *const ehdrp =
@@ -52,10 +51,7 @@ int elf_core_write_extra_data(struct file *file, size_t *size,
 			if (phdrp[i].p_type == PT_LOAD) {
 				void *addr = (void *) phdrp[i].p_vaddr;
 				size_t filesz = phdrp[i].p_filesz;
-
-				*size += filesz;
-				if (*size > limit
-				    || !dump_write(file, addr, filesz))
+				if (!dump_emit(cprm, addr, filesz))
 					return 0;
 			}
 		}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index aba4199..666a5a5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2196,8 +2196,10 @@ static int elf_core_dump(struct coredump_params *cprm)
 		}
 	}
 
-	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
+	cprm->written = size;
+	if (!elf_core_write_extra_data(cprm))
 		goto end_coredump;
+	size = cprm->written;
 
 	if (e_phnum == PN_XNUM) {
 		size += sizeof(*shdr4extnum);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 44db8b9..77bf7e3 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1818,8 +1818,10 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
 				    cprm->mm_flags) < 0)
 		goto end_coredump;
 
-	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
+	cprm->written = size;
+	if (!elf_core_write_extra_data(cprm))
 		goto end_coredump;
+	size = cprm->written;
 
 	if (e_phnum == PN_XNUM) {
 		size += sizeof(*shdr4extnum);
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 1b92a8c..698d51a 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -67,7 +67,7 @@ extern Elf_Half elf_core_extra_phdrs(void);
 extern int
 elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset);
 extern int
-elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
+elf_core_write_extra_data(struct coredump_params *cprm);
 extern size_t elf_core_extra_data_size(void);
 
 #endif /* _LINUX_ELFCORE_H */
-- 
1.7.2.5


