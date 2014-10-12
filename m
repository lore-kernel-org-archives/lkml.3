Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaJLLKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:10:32 -0400
Received: from mx1.polytechnique.org ([129.104.30.34]:52403 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaJLLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:09:57 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] um: Use char[] for linker script address declarations
Date: Sun, 12 Oct 2014 13:02:12 +0200
Message-Id: <1413111733-10763-2-git-send-email-nicolas.iooss_linux@m4x.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413111733-10763-1-git-send-email-nicolas.iooss_linux@m4x.org>
References: <1413111733-10763-1-git-send-email-nicolas.iooss_linux@m4x.org>
X-AV-Checked: ClamAV using ClamSMTP at svoboda.polytechnique.org (Sun Oct 12 13:03:23 2014 +0200 (CEST))
X-Spam-Flag: No, tests=bogofilter, spamicity=0.000000, queueID=0DC3F1408EEFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linker script defines some variables which are declared either with
type char[] in include/asm-generic/sections.h or with a meaningless
integer type in arch/um/include/asm/sections.h.

Fix this inconsistency by declaring every variable char[].

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 arch/um/include/asm/sections.h | 4 ++--
 arch/um/kernel/physmem.c       | 4 ++--
 arch/um/kernel/skas/mmu.c      | 4 ++--
 arch/um/kernel/um_arch.c       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/um/include/asm/sections.h b/arch/um/include/asm/sections.h
index 3a6ebcc65519..cafcf684d947 100644
--- a/arch/um/include/asm/sections.h
+++ b/arch/um/include/asm/sections.h
@@ -3,7 +3,7 @@
 
 #include <asm-generic/sections.h>
 
-extern char __binary_start;
-extern int __syscall_stub_start, __syscall_stub_end;
+extern char __binary_start[];
+extern char __syscall_stub_start[], __syscall_stub_end[];
 
 #endif
diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index db05c067665a..c833a5dec1e7 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -100,8 +100,8 @@ void __init setup_physmem(unsigned long start, unsigned long reserve_end,
 	 * Special kludge - This page will be mapped in to userspace processes
 	 * from physmem_fd, so it needs to be written out there.
 	 */
-	os_seek_file(physmem_fd, __pa(&__syscall_stub_start));
-	os_write_file(physmem_fd, &__syscall_stub_start, PAGE_SIZE);
+	os_seek_file(physmem_fd, __pa(__syscall_stub_start));
+	os_write_file(physmem_fd, __syscall_stub_start, PAGE_SIZE);
 	os_fsync_file(physmem_fd);
 
 	bootmap_size = init_bootmem(pfn, pfn + delta);
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index d2a0a4c0cd91..e40ce29bdc2c 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -108,7 +108,7 @@ void uml_setup_stubs(struct mm_struct *mm)
 		return;
 
 	ret = init_stub_pte(mm, STUB_CODE,
-			    (unsigned long) &__syscall_stub_start);
+			    (unsigned long) __syscall_stub_start);
 	if (ret)
 		goto out;
 
@@ -116,7 +116,7 @@ void uml_setup_stubs(struct mm_struct *mm)
 	if (ret)
 		goto out;
 
-	mm->context.stub_pages[0] = virt_to_page(&__syscall_stub_start);
+	mm->context.stub_pages[0] = virt_to_page(__syscall_stub_start);
 	mm->context.stub_pages[1] = virt_to_page(mm->context.id.stack);
 
 	/* dup_mmap already holds mmap_sem */
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 02c21f6e0983..5dd632203dca 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -313,7 +313,7 @@ int __init linux_main(int argc, char **argv)
 		physmem_size += UML_ROUND_UP(brk_start) - UML_ROUND_UP(&_end);
 	}
 
-	uml_physmem = (unsigned long) &__binary_start & PAGE_MASK;
+	uml_physmem = (unsigned long) __binary_start & PAGE_MASK;
 
 	/* Reserve up to 4M after the current brk */
 	uml_reserved = ROUND_4M(brk_start) + (1 << 22);
-- 
2.1.1

