Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3HaNvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 09:51:31 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:59438 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3HaNva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 09:51:30 -0400
Date: Sat, 31 Aug 2013 16:51:23 +0300
From: Dan Aloni <alonid@stratoscale.com>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH linux-next] Prevent a coredump with a large vm_map_count
 from Oopsing
Message-ID: <20130831135122.GA11096@gmail.com>
References: <20130830065707.GA31940@gmail.com>
 <1377930042-32442-1-git-send-email-alonid@stratoscale.com>
 <5221F1D9.9030001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5221F1D9.9030001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Aug 31, 2013 at 03:38:33PM +0200, Martin MOKREJŠ wrote:
> Hi Dan,
>   thank you for your work on my issue. I would like to test it on 3.10.9 where
> I faced the problem initially.

Sure, see the attached patch for 3.10.9.

-- 
Dan Aloni

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Prevent-a-coredump-with-a-large-max_map_count-from-O.patch"

>From e323d3b4fdc1e61c3c39dfb3733d8b8c56f63b00 Mon Sep 17 00:00:00 2001
From: Dan Aloni <alonid@stratoscale.com>
Date: Sat, 31 Aug 2013 00:13:43 +0300
Subject: [PATCH 1/1] Prevent a coredump with a large max_map_count from
 Oopsing

A high setting of max_map_count, and a process core-dumping with
a large enough vm_map_count could result in a NT_FILE note not
being written, and the kernel crashing immediately later because
it has assumed otherwise.

Reproduction of the bug described here:

    https://lkml.org/lkml/2013/8/30/50

This patch make that section optional in that case.
fill_files_note() should signify the error, and also let the info
struct in elf_core_dump() be zero-initialized so that we can check
for optionally written note.

Cc'ed original signers.

Signed-off-by: Dan Aloni <alonid@stratoscale.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/binfmt_elf.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8a0b0e..1c4a425 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1415,7 +1415,7 @@ static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
  *   long file_ofs
  * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
  */
-static void fill_files_note(struct memelfnote *note)
+static int fill_files_note(struct memelfnote *note)
 {
 	struct vm_area_struct *vma;
 	unsigned count, size, names_ofs, remaining, n;
@@ -1430,11 +1430,11 @@ static void fill_files_note(struct memelfnote *note)
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
@@ -1487,7 +1487,7 @@ static void fill_files_note(struct memelfnote *note)
 
 	size = name_curpos - (char *)data;
 	fill_note(note, "CORE", NT_FILE, size, data);
- err: ;
+	return 0;
 }
 
 #ifdef CORE_DUMP_USE_REGSET
@@ -1609,6 +1609,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	struct elf_prpsinfo *psinfo;
 	struct core_thread *ct;
 	unsigned int i;
+	int ret;
 
 	info->size = 0;
 	info->thread = NULL;
@@ -1688,8 +1689,9 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
-	fill_files_note(&info->files);
-	info->size += notesize(&info->files);
+	ret = fill_files_note(&info->files);
+	if (!ret)
+		info->size += notesize(&info->files);
 
 	return 1;
 }
@@ -1721,7 +1723,8 @@ static int write_note_info(struct elf_note_info *info,
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
-		if (first && !writenote(&info->files, file, foffset))
+		if (first && info->files.data && !writenote(&info->files,
+							    file, foffset))
 			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
@@ -1808,6 +1811,7 @@ static int elf_dump_thread_status(long signr, struct elf_thread_status *t)
 
 struct elf_note_info {
 	struct memelfnote *notes;
+	struct memelfnote *notes_files;
 	struct elf_prstatus *prstatus;	/* NT_PRSTATUS */
 	struct elf_prpsinfo *psinfo;	/* NT_PRPSINFO */
 	struct list_head thread_list;
@@ -1851,6 +1855,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  siginfo_t *siginfo, struct pt_regs *regs)
 {
 	struct list_head *t;
+	int ret;
 
 	if (!elf_note_info_init(info))
 		return 0;
@@ -1898,9 +1903,13 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 
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
@@ -1962,8 +1971,9 @@ static void free_note_info(struct elf_note_info *info)
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
-	/* Free data allocated by fill_files_note(): */
-	vfree(info->notes[4].data);
+	/* Free data possibly allocated by fill_files_note(): */
+	if (info->notes_files)
+		vfree(info->notes_files->data);
 
 	kfree(info->prstatus);
 	kfree(info->psinfo);
@@ -2046,7 +2056,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
 	loff_t offset = 0, dataoff, foffset;
-	struct elf_note_info info;
+	struct elf_note_info info = {0, };
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
-- 
1.8.1.4


--IJpNTDwzlM2Ie8A6--
