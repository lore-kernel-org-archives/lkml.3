Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3JDKbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:10 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33569 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3JDKbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:09 -0400
Subject: [PATCH 02/19] Make vma_dump_size() generic
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
Date: Fri, 04 Oct 2013 16:00:46 +0530
Message-ID: <20131004103043.1612.56980.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-9264-0000-0000-000004A75AE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

vma_dump_size calculates the file size of a vma area in the core file. It
assumes the vma belongs to the "current". Make it generic to work for any task.
This will be reused by application core dump infrastructure.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/binfmt_elf.c                  |    6 +++---
 fs/elfcore-common.c              |   24 ++++++++++++++++--------
 include/linux/elfcore-internal.h |    4 ++--
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 6c8df47..107bbd3 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1870,7 +1870,7 @@ static size_t elf_core_vma_data_size(struct vm_area_struct *gate_vma,
 
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 	     vma = next_vma(vma, gate_vma))
-		size += vma_dump_size(vma, mm_flags);
+		size += vma_dump_size(current, vma, mm_flags);
 	return size;
 }
 
@@ -1994,7 +1994,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
+		phdr.p_filesz = vma_dump_size(current, vma, cprm->mm_flags);
 		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -2029,7 +2029,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 		unsigned long addr;
 		unsigned long end;
 
-		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
+		end = vma->vm_start + vma_dump_size(current, vma, cprm->mm_flags);
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
diff --git a/fs/elfcore-common.c b/fs/elfcore-common.c
index 4886f15..48f1a9d 100644
--- a/fs/elfcore-common.c
+++ b/fs/elfcore-common.c
@@ -21,7 +21,7 @@
 #include <asm/page.h>
 #include <linux/elfcore-internal.h>
 
-static struct vm_area_struct *first_vma(struct task_struct *tsk,
+struct vm_area_struct *first_vma(struct task_struct *tsk,
 					struct vm_area_struct *gate_vma)
 {
 	struct vm_area_struct *ret = tsk->mm->mmap;
@@ -35,7 +35,7 @@ static struct vm_area_struct *first_vma(struct task_struct *tsk,
  * Helper function for iterating across a vma list.  It ensures that the caller
  * will visit `gate_vma' prior to terminating the search.
  */
-static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
+struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
 					struct vm_area_struct *gate_vma)
 {
 	struct vm_area_struct *ret;
@@ -56,7 +56,7 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
  * meant. These special mappings include - vDSO, vsyscall, and other
  * architecture specific mappings
  */
-static bool always_dump_vma(struct vm_area_struct *vma)
+bool always_dump_vma(struct vm_area_struct *vma)
 {
 	/* Any vsyscall mappings? */
 	if (vma == get_gate_vma(vma->vm_mm))
@@ -74,7 +74,7 @@ static bool always_dump_vma(struct vm_area_struct *vma)
 /*
  *  Decide what to dump of a segment, part, all or none.
  */
-static unsigned long vma_dump_size(struct vm_area_struct *vma,
+unsigned long vma_dump_size(struct task_struct *p, struct vm_area_struct *vma,
 					unsigned long mm_flags)
 {
 #define FILTER(type)    (mm_flags & (1UL << MMF_DUMP_##type))
@@ -143,10 +143,18 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		 * Switch to the user "segment" for get_user(),
 		 * then put back what elf_core_dump() had in place.
 		 */
-		set_fs(USER_DS);
- 		if (unlikely(get_user(word, header)))
- 			word = 0;
-		set_fs(fs);
+		if (p->mm == current->mm) {
+			mm_segment_t fs = get_fs();
+			set_fs(USER_DS);
+			if (unlikely(get_user(word, header)))
+				word = 0;
+			set_fs(fs);
+		} else {
+			int bytes = access_process_vm(p, (unsigned long)header,
+						&word, sizeof (word), 0);
+			if (bytes != sizeof(word))
+				word = 0;
+		}		
 		if (word == magic.cmp)
 			return PAGE_SIZE;
 	}
diff --git a/include/linux/elfcore-internal.h b/include/linux/elfcore-internal.h
index f6354f0..9e9cd93 100644
--- a/include/linux/elfcore-internal.h
+++ b/include/linux/elfcore-internal.h
@@ -38,9 +38,9 @@ extern struct vm_area_struct *first_vma(struct task_struct *tsk,
 					struct vm_area_struct *gate_vma);
 extern struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
 					struct vm_area_struct *gate_vma);
-extern unsigned long vma_dump_size(struct vm_area_struct *vma,
+extern unsigned long vma_dump_size(struct task_struct *task,
+					struct vm_area_struct *vma,
 					unsigned long mm_flags);
 
 #endif
 #endif
-

