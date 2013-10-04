Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3JDKas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:30:48 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45446 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3JDKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:30:45 -0400
Subject: [PATCH 01/19] Create elfcore-common.c for ELF class independent
 core generation helpers
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
Date: Fri, 04 Oct 2013 16:00:30 +0530
Message-ID: <20131004103030.1612.77716.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-7014-0000-0000-000003B729BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Move the common code, shared by both native and compat ELF core generation code
to a single instance.These functions could be re-used later for application
core dump infrastructure.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/Makefile                      |    1 
 fs/binfmt_elf.c                  |  156 -------------------------------------
 fs/elfcore-common.c              |  161 ++++++++++++++++++++++++++++++++++++++
 include/linux/elfcore-internal.h |   46 +++++++++++
 4 files changed, 209 insertions(+), 155 deletions(-)
 create mode 100644 fs/elfcore-common.c
 create mode 100644 include/linux/elfcore-internal.h

diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..70e7add 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
 obj-$(CONFIG_BINFMT_SCRIPT)	+= binfmt_script.o
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
+obj-$(CONFIG_ELF_CORE)         += elfcore-common.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 100edcc..6c8df47 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -37,7 +37,7 @@
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
-
+#include <linux/elfcore-internal.h>
 #ifndef user_long_t
 #define user_long_t long
 #endif
@@ -1095,124 +1095,6 @@ out:
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */
 
-/*
- * The purpose of always_dump_vma() is to make sure that special kernel mappings
- * that are useful for post-mortem analysis are included in every core dump.
- * In that way we ensure that the core dump is fully interpretable later
- * without matching up the same kernel and hardware config to see what PC values
- * meant. These special mappings include - vDSO, vsyscall, and other
- * architecture specific mappings
- */
-static bool always_dump_vma(struct vm_area_struct *vma)
-{
-	/* Any vsyscall mappings? */
-	if (vma == get_gate_vma(vma->vm_mm))
-		return true;
-	/*
-	 * arch_vma_name() returns non-NULL for special architecture mappings,
-	 * such as vDSO sections.
-	 */
-	if (arch_vma_name(vma))
-		return true;
-
-	return false;
-}
-
-/*
- * Decide what to dump of a segment, part, all or none.
- */
-static unsigned long vma_dump_size(struct vm_area_struct *vma,
-				   unsigned long mm_flags)
-{
-#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
-
-	/* always dump the vdso and vsyscall sections */
-	if (always_dump_vma(vma))
-		goto whole;
-
-	if (vma->vm_flags & VM_DONTDUMP)
-		return 0;
-
-	/* Hugetlb memory check */
-	if (vma->vm_flags & VM_HUGETLB) {
-		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
-			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
-			goto whole;
-		return 0;
-	}
-
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
-		return 0;
-
-	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
-		if (file_inode(vma->vm_file)->i_nlink == 0 ?
-		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
-			goto whole;
-		return 0;
-	}
-
-	/* Dump segments that have been written to.  */
-	if (vma->anon_vma && FILTER(ANON_PRIVATE))
-		goto whole;
-	if (vma->vm_file == NULL)
-		return 0;
-
-	if (FILTER(MAPPED_PRIVATE))
-		goto whole;
-
-	/*
-	 * If this looks like the beginning of a DSO or executable mapping,
-	 * check for an ELF header.  If we find one, dump the first page to
-	 * aid in determining what was mapped here.
-	 */
-	if (FILTER(ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
-		u32 __user *header = (u32 __user *) vma->vm_start;
-		u32 word;
-		mm_segment_t fs = get_fs();
-		/*
-		 * Doing it this way gets the constant folded by GCC.
-		 */
-		union {
-			u32 cmp;
-			char elfmag[SELFMAG];
-		} magic;
-		BUILD_BUG_ON(SELFMAG != sizeof word);
-		magic.elfmag[EI_MAG0] = ELFMAG0;
-		magic.elfmag[EI_MAG1] = ELFMAG1;
-		magic.elfmag[EI_MAG2] = ELFMAG2;
-		magic.elfmag[EI_MAG3] = ELFMAG3;
-		/*
-		 * Switch to the user "segment" for get_user(),
-		 * then put back what elf_core_dump() had in place.
-		 */
-		set_fs(USER_DS);
-		if (unlikely(get_user(word, header)))
-			word = 0;
-		set_fs(fs);
-		if (word == magic.cmp)
-			return PAGE_SIZE;
-	}
-
-#undef	FILTER
-
-	return 0;
-
-whole:
-	return vma->vm_end - vma->vm_start;
-}
-
-/* An ELF note in memory */
-struct memelfnote
-{
-	const char *name;
-	int type;
-	unsigned int datasz;
-	void *data;
-};
 
 static int notesize(struct memelfnote *en)
 {
@@ -1291,16 +1173,6 @@ static void fill_elf_note_phdr(struct elf_phdr *phdr, int sz, loff_t offset)
 	return;
 }
 
-static void fill_note(struct memelfnote *note, const char *name, int type, 
-		unsigned int sz, void *data)
-{
-	note->name = name;
-	note->type = type;
-	note->datasz = sz;
-	note->data = data;
-	return;
-}
-
 /*
  * fill up all the fields in prstatus from the given task struct, except
  * registers which need to be filled up separately.
@@ -1974,32 +1846,6 @@ static void free_note_info(struct elf_note_info *info)
 
 #endif
 
-static struct vm_area_struct *first_vma(struct task_struct *tsk,
-					struct vm_area_struct *gate_vma)
-{
-	struct vm_area_struct *ret = tsk->mm->mmap;
-
-	if (ret)
-		return ret;
-	return gate_vma;
-}
-/*
- * Helper function for iterating across a vma list.  It ensures that the caller
- * will visit `gate_vma' prior to terminating the search.
- */
-static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
-					struct vm_area_struct *gate_vma)
-{
-	struct vm_area_struct *ret;
-
-	ret = this_vma->vm_next;
-	if (ret)
-		return ret;
-	if (this_vma == gate_vma)
-		return NULL;
-	return gate_vma;
-}
-
 static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
 			     elf_addr_t e_shoff, int segs)
 {
diff --git a/fs/elfcore-common.c b/fs/elfcore-common.c
new file mode 100644
index 0000000..4886f15
--- /dev/null
+++ b/fs/elfcore-common.c
@@ -0,0 +1,161 @@
+/*
+ *
+ * Copyright 1993, 1994: Eric Youngdale (ericy@cais.com).
+ *
+ * Initial write up for ELF_CORE :
+ * Modelled on fs/exec.c:aout_core_dump()
+ *      Jeremy Fitzhardinge <jeremy@sw.oz.au>
+ *
+ * Moved common routines used by both native and compat ELF core generation
+ * from binfmt_elf.c to a single instance.
+ *     Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/elf.h>
+#include <asm/uaccess.h>
+#include <asm/param.h>
+#include <asm/page.h>
+#include <linux/elfcore-internal.h>
+
+static struct vm_area_struct *first_vma(struct task_struct *tsk,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret = tsk->mm->mmap;
+
+	if (ret)
+		return ret;
+	return gate_vma;
+}
+
+/*
+ * Helper function for iterating across a vma list.  It ensures that the caller
+ * will visit `gate_vma' prior to terminating the search.
+ */
+static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma)
+{
+	struct vm_area_struct *ret;
+
+	ret = this_vma->vm_next;
+	if (ret)
+		return ret;
+	if (this_vma == gate_vma)
+		return NULL;
+	return gate_vma;
+}
+
+/*
+ * The purpose of always_dump_vma() is to make sure that special kernel mappings
+ * that are useful for post-mortem analysis are included in every core dump.
+ * In that way we ensure that the core dump is fully interpretable later
+ * without matching up the same kernel and hardware config to see what PC values
+ * meant. These special mappings include - vDSO, vsyscall, and other
+ * architecture specific mappings
+ */
+static bool always_dump_vma(struct vm_area_struct *vma)
+{
+	/* Any vsyscall mappings? */
+	if (vma == get_gate_vma(vma->vm_mm))
+		return true;
+	/*
+ 	 * arch_vma_name() returns non-NULL for special architecture mappings,
+	 * such as vDSO sections.
+ 	 */
+	if (arch_vma_name(vma))
+		return true;
+
+	return false;
+}
+
+/*
+ *  Decide what to dump of a segment, part, all or none.
+ */
+static unsigned long vma_dump_size(struct vm_area_struct *vma,
+					unsigned long mm_flags)
+{
+#define FILTER(type)    (mm_flags & (1UL << MMF_DUMP_##type))
+
+	/* always dump the vdso and vsyscall sections */
+	if (always_dump_vma(vma))
+		goto whole;
+
+	if (vma->vm_flags & VM_DONTDUMP)
+		return 0;
+
+	/* Hugetlb memory check */
+	if (vma->vm_flags & VM_HUGETLB) {
+		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
+			goto whole;
+		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
+			goto whole;
+		return 0;
+	}
+
+	/* Do not dump I/O mapped devices or special mappings */
+	if (vma->vm_flags & VM_IO)
+		return 0;
+
+	/* By default, dump shared memory if mapped from an anonymous file. */
+	if (vma->vm_flags & VM_SHARED) {
+		if (file_inode(vma->vm_file)->i_nlink == 0 ?
+			FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
+				goto whole;
+		return 0;
+	}
+
+	/* Dump segments that have been written to.  */
+	if (vma->anon_vma && FILTER(ANON_PRIVATE))
+		goto whole;
+	if (vma->vm_file == NULL)
+		return 0;
+
+	if (FILTER(MAPPED_PRIVATE))
+		goto whole;
+
+	/*
+	 * If this looks like the beginning of a DSO or executable mapping,
+	 * check for an ELF header.  If we find one, dump the first page to
+	 * aid in determining what was mapped here.
+	 */
+ 	if (FILTER(ELF_HEADERS) &&
+		vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
+		u32 __user *header = (u32 __user *) vma->vm_start;
+
+		u32 word;
+		mm_segment_t fs = get_fs();
+ 		/*
+ 		 * Doing it this way gets the constant folded by GCC.
+  		 */
+ 		union {
+ 			u32 cmp;
+ 			char elfmag[SELFMAG];
+		} magic;
+		BUILD_BUG_ON(SELFMAG != sizeof word);
+		magic.elfmag[EI_MAG0] = ELFMAG0;
+		magic.elfmag[EI_MAG1] = ELFMAG1;
+		magic.elfmag[EI_MAG2] = ELFMAG2;
+		magic.elfmag[EI_MAG3] = ELFMAG3;
+		/*
+		 * Switch to the user "segment" for get_user(),
+		 * then put back what elf_core_dump() had in place.
+		 */
+		set_fs(USER_DS);
+ 		if (unlikely(get_user(word, header)))
+ 			word = 0;
+		set_fs(fs);
+		if (word == magic.cmp)
+			return PAGE_SIZE;
+	}
+
+#undef  FILTER
+
+	return 0;
+
+whole:
+	return vma->vm_end - vma->vm_start;
+}
+
diff --git a/include/linux/elfcore-internal.h b/include/linux/elfcore-internal.h
new file mode 100644
index 0000000..f6354f0
--- /dev/null
+++ b/include/linux/elfcore-internal.h
@@ -0,0 +1,46 @@
+/*
+ * Common routines for native and compat elf core generation.
+ *
+ * Copyright 1993, 1994: Eric Youngdale (ericy@cais.com).
+ *
+ * Modelled on fs/exec.c:aout_core_dump()
+ * Jeremy Fitzhardinge <jeremy@sw.oz.au>
+ *
+ * Moved the common routines from binfmt_elf.c to elfcore-common.c
+ *  - Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#ifndef __ELF_CORE_INTERNAL_H
+#define __ELF_CORE_INTERNAL_H
+
+#ifdef __KERNEL__
+
+/* An ELF note in memory */
+struct memelfnote
+{
+	const char *name;
+	int type;
+	unsigned int datasz;
+	void *data;
+};
+
+static void fill_note(struct memelfnote *note, const char *name, int type,
+			unsigned int sz, void *data)
+{
+	note->name = name;
+	note->type = type;
+	note->datasz = sz;
+	note->data = data;
+	return;
+}
+
+extern struct vm_area_struct *first_vma(struct task_struct *tsk,
+					struct vm_area_struct *gate_vma);
+extern struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+					struct vm_area_struct *gate_vma);
+extern unsigned long vma_dump_size(struct vm_area_struct *vma,
+					unsigned long mm_flags);
+
+#endif
+#endif
+

