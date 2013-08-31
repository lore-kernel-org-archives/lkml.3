Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3HaGVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:21:04 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44458 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3HaGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:21:01 -0400
From: Dan Aloni <alonid@stratoscale.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mmokrejs@gmail.com, Al Viro <viro@zeniv.linux.org.uk>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH linux-next] Prevent a coredump with a large vm_map_count from Oopsing
Date: Sat, 31 Aug 2013 09:20:42 +0300
Message-Id: <1377930042-32442-1-git-send-email-alonid@stratoscale.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130830065707.GA31940@gmail.com>
References: <20130830065707.GA31940@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A high setting of max_map_count, and a process core-dumping with
a large enough vm_map_count could result in an NT_FILE note not
being written, and the kernel crashing immediately later because
it has assumed otherwise.

Reproduction of the bug described here:

    https://lkml.org/lkml/2013/8/30/50

Issue originating in 2aa362c49 (from Oct 4, 2012).

This patch make that section optional in that case.
fill_files_note() should signify the error, and also let the info
struct in elf_core_dump() be zero-initialized so that we can check
for the optionally written note.

Cc'ed original signers.

Cc'ed Al Viro because it is trivially relies on his linux-next
tree changes.

Signed-off-by: Dan Aloni <alonid@stratoscale.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/binfmt_elf.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index dc82279..e1a323a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1429,7 +1429,7 @@ static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
  *   long file_ofs
  * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
  */
-static void fill_files_note(struct memelfnote *note)
+static int fill_files_note(struct memelfnote *note)
 {
 	struct vm_area_struct *vma;
 	unsigned count, size, names_ofs, remaining, n;
@@ -1444,11 +1444,11 @@ static void fill_files_note(struct memelfnote *note)
 	names_ofs = (2 + 3 * count) * sizeof(data[0]);
  alloc:
 	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
-		goto err;
+		return -E2BIG;
 	size = round_up(size, PAGE_SIZE);
 	data = vmalloc(size);
 	if (!data)
-		goto err;
+		return -ENOMEM;
 
 	start_end_ofs = data + 2;
 	name_base = name_curpos = ((char *)data) + names_ofs;
@@ -1501,7 +1501,7 @@ static void fill_files_note(struct memelfnote *note)
 
 	size = name_curpos - (char *)data;
 	fill_note(note, "CORE", NT_FILE, size, data);
- err: ;
+	return 0;
 }
 
 #ifdef CORE_DUMP_USE_REGSET
@@ -1623,6 +1623,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
 	unsigned int i;
+	int ret;
 
 	info->size = 0;
 	info->thread = NULL;
@@ -1702,8 +1703,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	fill_files_note(&info->files);
-	info->size += notesize(&info->files);
+	ret = fill_files_note(&info->files);
+	if (!ret)
+		info->size += notesize(&info->files);
 
 	return 1;
 }
@@ -1735,7 +1737,7 @@ static int write_note_info(struct elf_note_info *info,
 			return 0;
 		if (first && !writenote(&info->auxv, cprm))
 			return 0;
-		if (first && !writenote(&info->files, cprm))
+		if (first && info->files.data && !writenote(&info->files, cprm))
 			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
@@ -1822,6 +1824,7 @@ static int elf_dump_thread_status(long signr, struct elf_thread_status *t)
 
 struct elf_note_info {
 	struct memelfnote *notes;
+	struct memelfnote *notes_files;
 	struct elf_prstatus *prstatus;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo;	/* NT_PRPSINFO */
 	struct list_head thread_list;
@@ -1865,6 +1868,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
+	int ret;
 
 	if (!elf_note_info_init(info))
 		return 0;
@@ -1912,9 +1916,13 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 
 	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
 	fill_auxv_note(info->notes + 3, current->mm);
-	fill_files_note(info->notes + 4);
+	info->numnote = 4;
 
-	info->numnote = 5;
+	ret = fill_files_note(info->notes + info->numnote);
+	if (!ret) {
+		info->notes_files = info->notes + info->numnote;
+		info->numnote++;
+	}
 
 	/* Try to dump the FPU. */
 	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
@@ -1976,8 +1984,9 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
-	/* Free data allocated by fill_files_note(): */
-	vfree(info->notes[4].data);
+	/* Free data possibly allocated by fill_files_note(): */
+	if (info->notes_files)
+		vfree(info->notes_files->data);
 
 	kfree(info->prstatus);
 	kfree(info->psinfo);
@@ -2059,7 +2068,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff;
-	struct elf_note_info info;
+	struct elf_note_info info = {0, };
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
-- 
1.8.1.4

