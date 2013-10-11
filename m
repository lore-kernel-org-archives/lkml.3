Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab3JKUEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:04:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab3JKTl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Aloni <alonid@stratoscale.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Martin MOKREJS <mmokrejs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 052/135] fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oopsing
Date: Fri, 11 Oct 2013 12:38:53 -0700
Message-Id: <20131011193950.942422106@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Aloni <alonid@stratoscale.com>

commit 72023656961b8c81a168a7a6762d589339d0d7ec upstream.

A high setting of max_map_count, and a process core-dumping with a large
enough vm_map_count could result in an NT_FILE note not being written,
and the kernel crashing immediately later because it has assumed
otherwise.

Reproduction of the oops-causing bug described here:

    https://lkml.org/lkml/2013/8/30/50

Rge ussue originated in commit 2aa362c49c31 ("coredump: extend core dump
note section to contain file names of mapped file") from Oct 4, 2012.

This patch make that section optional in that case.  fill_files_note()
should signify the error, and also let the info struct in
elf_core_dump() be zero-initialized so that we can check for the
optionally written note.

[akpm@linux-foundation.org: avoid abusing E2BIG, remove a couple of not-really-needed local variables]
[akpm@linux-foundation.org: fix sparse warning]
Signed-off-by: Dan Aloni <alonid@stratoscale.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Reported-by: Martin MOKREJS <mmokrejs@gmail.com>
Tested-by: Martin MOKREJS <mmokrejs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_elf.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1413,7 +1413,7 @@ static void fill_siginfo_note(struct mem
  *   long file_ofs
  * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
  */
-static void fill_files_note(struct memelfnote *note)
+static int fill_files_note(struct memelfnote *note)
 {
 	struct vm_area_struct *vma;
 	unsigned count, size, names_ofs, remaining, n;
@@ -1428,11 +1428,11 @@ static void fill_files_note(struct memel
 	names_ofs = (2 + 3 * count) * sizeof(data[0]);
  alloc:
 	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
-		goto err;
+		return -EINVAL;
 	size = round_up(size, PAGE_SIZE);
 	data = vmalloc(size);
 	if (!data)
-		goto err;
+		return -ENOMEM;
 
 	start_end_ofs = data + 2;
 	name_base = name_curpos = ((char *)data) + names_ofs;
@@ -1485,7 +1485,7 @@ static void fill_files_note(struct memel
 
 	size = name_curpos - (char *)data;
 	fill_note(note, "CORE", NT_FILE, size, data);
- err: ;
+	return 0;
 }
 
 #ifdef CORE_DUMP_USE_REGSET
@@ -1686,8 +1686,8 @@ static int fill_note_info(struct elfhdr
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	fill_files_note(&info->files);
-	info->size += notesize(&info->files);
+	if (fill_files_note(&info->files) == 0)
+		info->size += notesize(&info->files);
 
 	return 1;
 }
@@ -1719,7 +1719,8 @@ static int write_note_info(struct elf_no
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
-		if (first && !writenote(&info->files, file, foffset))
+		if (first && info->files.data &&
+				!writenote(&info->files, file, foffset))
 			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
@@ -1806,6 +1807,7 @@ static int elf_dump_thread_status(long s
 
 struct elf_note_info {
 	struct memelfnote *notes;
+	struct memelfnote *notes_files;
 	struct elf_prstatus *prstatus;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo;	/* NT_PRPSINFO */
 	struct list_head thread_list;
@@ -1896,9 +1898,12 @@ static int fill_note_info(struct elfhdr
 
 	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
 	fill_auxv_note(info->notes + 3, current->mm);
-	fill_files_note(info->notes + 4);
+	info->numnote = 4;
 
-	info->numnote = 5;
+	if (fill_files_note(info->notes + info->numnote) == 0) {
+		info->notes_files = info->notes + info->numnote;
+		info->numnote++;
+	}
 
 	/* Try to dump the FPU. */
 	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
@@ -1960,8 +1965,9 @@ static void free_note_info(struct elf_no
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
-	/* Free data allocated by fill_files_note(): */
-	vfree(info->notes[4].data);
+	/* Free data possibly allocated by fill_files_note(): */
+	if (info->notes_files)
+		vfree(info->notes_files->data);
 
 	kfree(info->prstatus);
 	kfree(info->psinfo);
@@ -2044,7 +2050,7 @@ static int elf_core_dump(struct coredump
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	struct elf_note_info info;
+	struct elf_note_info info = { };
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;


