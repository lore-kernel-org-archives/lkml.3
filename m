Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3JIAPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:15:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3JIAO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:14:58 -0400
Date: Wed, 09 Oct 2013 01:14:57 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 05/13] binfmt_elf: convert writing actual dump pages
 to dump_emit()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThQX-0002wa-Mm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_elf.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 666a5a5..bc01aaf 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2093,7 +2093,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 
 	offset += sizeof(*elf);				/* Elf header */
 	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
-	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
@@ -2157,7 +2156,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 		goto end_coredump;
 
 	size = cprm->written;
-	cprm->written = foffset;	/* will disappear */
  	/* write out the notes section */
 	if (!write_note_info(&info, cprm))
 		goto end_coredump;
@@ -2170,6 +2168,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!dump_seek(cprm->file, dataoff - foffset))
 		goto end_coredump;
 
+	cprm->written = size;
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
@@ -2184,9 +2183,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 			page = get_dump_page(addr);
 			if (page) {
 				void *kaddr = kmap(page);
-				stop = ((size += PAGE_SIZE) > cprm->limit) ||
-					!dump_write(cprm->file, kaddr,
-						    PAGE_SIZE);
+				stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
 				kunmap(page);
 				page_cache_release(page);
 			} else
@@ -2196,16 +2193,11 @@ static int elf_core_dump(struct coredump_params *cprm)
 		}
 	}
 
-	cprm->written = size;
 	if (!elf_core_write_extra_data(cprm))
 		goto end_coredump;
-	size = cprm->written;
 
 	if (e_phnum == PN_XNUM) {
-		size += sizeof(*shdr4extnum);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, shdr4extnum,
-				   sizeof(*shdr4extnum)))
+		if (!dump_emit(cprm, shdr4extnum, sizeof(*shdr4extnum)))
 			goto end_coredump;
 	}
 
-- 
1.7.2.5


