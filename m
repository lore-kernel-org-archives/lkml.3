Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJLLKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:10:00 -0400
Received: from mx1.polytechnique.org ([129.104.30.34]:46206 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJLLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:09:57 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] um: Create asm/sections.h
Date: Sun, 12 Oct 2014 13:02:11 +0200
Message-Id: <1413111733-10763-1-git-send-email-nicolas.iooss_linux@m4x.org>
X-Mailer: git-send-email 2.1.2
X-AV-Checked: ClamAV using ClamSMTP at svoboda.polytechnique.org (Sun Oct 12 13:03:12 2014 +0200 (CEST))
X-Spam-Flag: No, tests=bogofilter, spamicity=0.000000, queueID=C86A91408EEE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/kernel/dyn.lds.S and arch/um/kernel/uml.lds.S define some
UML-specific symbols.  These symbols are used in the kernel part of UML
with extern declarations.

Move these declarations to a new header, asm/sections.h, like other
architectures do.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 arch/um/include/asm/Kbuild     | 1 -
 arch/um/include/asm/sections.h | 9 +++++++++
 arch/um/kernel/physmem.c       | 3 +--
 arch/um/kernel/skas/mmu.c      | 3 +--
 arch/um/kernel/um_arch.c       | 2 --
 5 files changed, 11 insertions(+), 7 deletions(-)
 create mode 100644 arch/um/include/asm/sections.h

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 244b12c8cb39..21fd5c647442 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -23,7 +23,6 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += scatterlist.h
-generic-y += sections.h
 generic-y += switch_to.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/um/include/asm/sections.h b/arch/um/include/asm/sections.h
new file mode 100644
index 000000000000..3a6ebcc65519
--- /dev/null
+++ b/arch/um/include/asm/sections.h
@@ -0,0 +1,9 @@
+#ifndef __UM_SECTIONS_H
+#define __UM_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+extern char __binary_start;
+extern int __syscall_stub_start, __syscall_stub_end;
+
+#endif
diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index 30fdd5d0067b..db05c067665a 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/pfn.h>
 #include <asm/page.h>
+#include <asm/sections.h>
 #include <as-layout.h>
 #include <init.h>
 #include <kern.h>
@@ -75,8 +76,6 @@ void map_memory(unsigned long virt, unsigned long phys, unsigned long len,
 	}
 }
 
-extern int __syscall_stub_start;
-
 void __init setup_physmem(unsigned long start, unsigned long reserve_end,
 			  unsigned long len, unsigned long long highmem)
 {
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index 007d5503f49b..d2a0a4c0cd91 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -8,12 +8,11 @@
 #include <linux/slab.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 #include <as-layout.h>
 #include <os.h>
 #include <skas.h>
 
-extern int __syscall_stub_start;
-
 static int init_stub_pte(struct mm_struct *mm, unsigned long proc,
 			 unsigned long kernel)
 {
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 016adf0985d5..02c21f6e0983 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -259,8 +259,6 @@ EXPORT_SYMBOL(end_iomem);
 
 #define MIN_VMALLOC (32 * 1024 * 1024)
 
-extern char __binary_start;
-
 int __init linux_main(int argc, char **argv)
 {
 	unsigned long avail, diff;
-- 
2.1.1

