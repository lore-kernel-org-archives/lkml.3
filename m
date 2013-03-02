Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3CEHF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:05:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50389 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3CEHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:05:24 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 05/20] vmcore: round up buffer size of ELF headers by
 PAGE_SIZE
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:36:16 +0900
Message-ID: <20130302083616.31252.73787.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To satisfy mmap() page-size boundary requirement, round up buffer size
of ELF headers by PAGE_SIZE. The resulting value becomes offset of ELF
note segments and it's assigned in unique PT_NOTE program header
entry.

Also, some part that assumes past ELF headers' size is replaced by
this new rounded-up value.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 1b02d01..c511cf4 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -340,7 +340,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	phdr.p_flags   = 0;
 	note_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -353,6 +353,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 out:
 	return 0;
 }
@@ -449,7 +450,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	phdr.p_flags   = 0;
 	note_off = ehdr_ptr->e_phoff +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf32_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -462,6 +463,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
 out:
 	return 0;
 }
@@ -482,9 +484,8 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 	phdr_ptr = (Elf64_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
+						  PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)
@@ -519,9 +520,8 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 	phdr_ptr = (Elf32_Phdr*)(elfptr + ehdr_ptr->e_phoff); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
+						 PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)

