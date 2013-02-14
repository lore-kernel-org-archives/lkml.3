Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab3BNKL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:11:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48688 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933850Ab3BNKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:11:56 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 02/13] vmcore: round up buffer size of ELF headers by PAGE_SIZE
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:11:54 +0900
Message-ID: <20130214101154.22466.21769.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To satisfy mmap() page-size boundary requirement, reound up buffer
size of ELF headers by PAGE_SIZE. The resulting value becomes offset
of ELF note segments and it's assigned in unique PT_NOTE program
header entry.

Also, some part that assumes past ELF headers' size is replaced by
this new rounded-up value.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 85714c3..5010ead 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -313,7 +313,7 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	phdr.p_flags   = 0;
 	note_off = sizeof(Elf64_Ehdr) +
 			(ehdr_ptr->e_phnum - nr_ptnote +1) * sizeof(Elf64_Phdr);
-	phdr.p_offset  = note_off;
+	phdr.p_offset  = roundup(note_off, PAGE_SIZE);
 	phdr.p_vaddr   = phdr.p_paddr = 0;
 	phdr.p_filesz  = phdr.p_memsz = phdr_sz;
 	phdr.p_align   = 0;
@@ -331,6 +331,8 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 
+	*elfsz = roundup(*elfsz, PAGE_SIZE);
+
 	return 0;
 }
 
@@ -431,9 +433,8 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr)); /* PT_NOTE hdr */
 
 	/* First program header is PT_NOTE header. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr) +
-			phdr_ptr->p_memsz; /* Note sections */
+	vmcore_off = phdr_ptr->p_offset + roundup(phdr_ptr->p_memsz,
+						  PAGE_SIZE);
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
 		if (phdr_ptr->p_type != PT_LOAD)

