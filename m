Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3KUAkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:40:10 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:44161 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3KUAkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:40:05 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v2] fs: binfmt_elf: Add ELF header consistency checks
Date: Wed, 20 Nov 2013 21:34:31 -0300
Message-Id: <1384994071-12283-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The member 'e_ehsize' that holds the ELF header size is compared
with the elfhdr struct size. If not equal, goes out.
If 'e_phoff' holds 0 the object has no program header table, so
goes out.
Ensures the file being loaded has the correct data encoding, checking
'e_ident[EI_DATA]' against 'ELF_DATA'.

Besides the checks being in accordance with the ELF Specifications,
they increase the binary consistency reducing the use of malformed ones.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/binfmt_elf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 571a423..326ca39 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -603,14 +603,20 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (memcmp(loc->elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 		goto out;
 
+	if (loc->elf_ex.e_ehsize != sizeof(struct elfhdr))
+		goto out;
 	if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
 		goto out;
 	if (!elf_check_arch(&loc->elf_ex))
 		goto out;
+	if (loc->elf_ex.e_ident[EI_DATA] != ELF_DATA)
+		goto out;
 	if (!bprm->file->f_op->mmap)
 		goto out;
 
 	/* Now read in all of the header information */
+	if (loc->elf_ex.e_phoff == 0)
+		goto out;
 	if (loc->elf_ex.e_phentsize != sizeof(struct elf_phdr))
 		goto out;
 	if (loc->elf_ex.e_phnum < 1 ||
-- 
1.8.4.2

