Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3JDKbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:33 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55418 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3JDKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:31 -0400
Subject: [PATCH 05/19] Export the reusable ELF core generation routines
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:01:17 +0530
Message-ID: <20131004103117.1612.24104.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-5140-0000-0000-000003EF1141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Export the ELF class specific core generation helper functions via
elfcore-internal.h

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/binfmt_elf.c                  |   10 +++++-----
 include/linux/elfcore-internal.h |   28 +++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4eee017..3f13203 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1137,7 +1137,7 @@ static int writenote(struct memelfnote *men, struct file *file,
 }
 #undef DUMP_WRITE
 
-static void fill_elf_header(struct elfhdr *elf, int segs,
+void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags)
 {
 	memset(elf, 0, sizeof(*elf));
@@ -1177,7 +1177,7 @@ static void fill_elf_note_phdr(struct elf_phdr *phdr, int sz, loff_t offset)
  * fill up all the fields in prstatus from the given task struct, except
  * registers which need to be filled up separately.
  */
-static void fill_prstatus(struct elf_prstatus *prstatus,
+void fill_prstatus(struct elf_prstatus *prstatus,
 		struct task_struct *p, long signr)
 {
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
@@ -1210,7 +1210,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	cputime_to_timeval(p->signal->cstime, &prstatus->pr_cstime);
 }
 
-static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
+int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 		       struct mm_struct *mm)
 {
 	const struct cred *cred;
@@ -1265,7 +1265,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	return 0;
 }
 
-static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
+void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
 {
 	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
 	int i = 0;
@@ -1858,7 +1858,7 @@ static void free_note_info(struct elf_note_info *info)
 
 #endif
 
-static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
+void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
 			     elf_addr_t e_shoff, int segs)
 {
 	elf->e_shoff = e_shoff;
diff --git a/include/linux/elfcore-internal.h b/include/linux/elfcore-internal.h
index 9e9cd93..8c5323a 100644
--- a/include/linux/elfcore-internal.h
+++ b/include/linux/elfcore-internal.h
@@ -14,7 +14,7 @@
 #define __ELF_CORE_INTERNAL_H
 
 #ifdef __KERNEL__
-
+#include <linux/elfcore.h>
 /* An ELF note in memory */
 struct memelfnote
 {
@@ -42,5 +42,31 @@ extern unsigned long vma_dump_size(struct task_struct *task,
 					struct vm_area_struct *vma,
 					unsigned long mm_flags);
 
+/* Core dump generation routines for native ELF class */
+extern void fill_elf_header(struct elfhdr *elf, int segs,
+				u16 machine, u32 flags);
+extern void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr,
+				elf_addr_t e_shoff, int segs);
+extern void fill_prstatus(struct elf_prstatus *prstatus,
+				struct task_struct *p, long signr);
+extern int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
+				struct mm_struct *mm);
+extern void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm);
+
+/* compat ELF class variant of the above helpers*/
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+#include <linux/elfcore-compat.h>
+
+extern void compat_fill_extnum_info(struct elf32_hdr *elf, struct elf32_shdr *shdr,
+					Elf32_Addr e_shoff, int segs);
+extern void compat_fill_prstatus(struct compat_elf_prstatus *prstatus,
+					struct task_struct *p, long signr);
+extern int compat_fill_psinfo(struct compat_elf_prpsinfo *psinfo, struct task_struct *p,
+				struct mm_struct *mm);
+extern void compat_fill_auxv_note(struct memelfnote *note, struct mm_struct *mm);
+extern void compat_fill_elf_header(struct elf32_hdr *elf, int segs,
+					u16 machine, u32 flags);
+#endif /* CONFIG_COMPAT_BINFMT_ELF */
+
 #endif
 #endif

