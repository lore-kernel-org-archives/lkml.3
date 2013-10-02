Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3JBHUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:20:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52669 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3JBHUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:20:00 -0400
From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>
Subject: [PATCH RFC] fs/binfmt_elf: fix memory map for PIE applications
Date: Wed,  2 Oct 2013 10:19:55 +0300
Message-Id: <1380698395-5784-1-git-send-email-timo.teras@iki.fi>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/*/include/asm/elf.h comments say:
  ELF_ET_DYN_BASE is the location that an ET_DYN program is loaded
  if exec'ed.  Typical use of this is to invoke "./ld.so someprog"
  to test out a new version of the loader.  We need to make sure
  that it is out of the way of the program that it will "exec",
  and that there is sufficient room for the brk.

In case we have main application linked as PIE, this can cause
problems as the main program itself is being loaded to this
alternate address. And this allows limited heap size. While
this is inevitable when exec'ing the interpreter directly,
we should do better for PIE applications.

This fixes the loader to detect PIE application by checking if
elf_interpreter is requested. This images are loaded to beginning
of the address space instead of the specially crafted place for elf
interpreter. This allows full heap address space for PIE applications
and fixes random "out of memory" errors.

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
---
 fs/binfmt_elf.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

It might make sense to define ELF_ET_DYN_APP_BASE or similar
so that architectures can specify the load address of ET_DYN
applications.

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 100edcc..f1508c7 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -802,21 +802,19 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
+			if (elf_interpreter)
+				load_bias = 0x00400000UL;
+			else
+				load_bias = ELF_ET_DYN_BASE;
 #ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
 			/* Memory randomization might have been switched off
 			 * in runtime via sysctl or explicit setting of
 			 * personality flags.
-			 * If that is the case, retain the original non-zero
-			 * load_bias value in order to establish proper
-			 * non-randomized mappings.
 			 */
 			if (current->flags & PF_RANDOMIZE)
-				load_bias = 0;
-			else
-				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#else
-			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
+				load_bias += (get_random_int() & STACK_RND_MASK) << PAGE_SHIFT;
 #endif
+			load_bias = ELF_PAGESTART(vaddr + load_bias);
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-- 
1.8.4

