Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaKNJM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:12:29 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52964 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaKNJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:12:23 -0500
From: Vineeth Vijayan <vvijayan@mvista.com>
To: Michael Ellerman <mpe@ellerman.id.au>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Vineeth Vijayan <vvijayan@mvista.com>
Subject: [PATCH] [powerpc] Fix Text randomization
Date: Fri, 14 Nov 2014 14:42:05 +0530
Message-Id: <1415956325-10124-1-git-send-email-vvijayan@mvista.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no way to disable TEXT randomization on a PPC32/PPC64
machine. Text randomization happens even in the case of "echo 0 >
/proc/sys/kernel/randomize_va_space"

This happens due to the incorrect definition of ELF_ET_DYN_BASE
at arch/powerpc/include/asm/elf.h

The function randomize_et_dyn is redundant and is removed.

Signed-off-by: Vineeth Vijayan <vvijayan@mvista.com>
---
 arch/powerpc/Kconfig           |    1 +
 arch/powerpc/include/asm/elf.h |    3 +--
 arch/powerpc/kernel/process.c  |    9 ---------
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 88eace4..868a3c4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -88,6 +88,7 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select OF
 	select OF_EARLY_FLATTREE
 	select OF_RESERVED_MEM
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 888d8f3..3793675 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -28,8 +28,7 @@
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-extern unsigned long randomize_et_dyn(unsigned long base);
-#define ELF_ET_DYN_BASE		(randomize_et_dyn(0x20000000))
+#define ELF_ET_DYN_BASE		(0x20000000)
 
 #define ELF_CORE_EFLAGS (is_elf2_task() ? 2 : 0)
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 923cd2d..e50467e 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1665,12 +1665,3 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	return ret;
 }
 
-unsigned long randomize_et_dyn(unsigned long base)
-{
-	unsigned long ret = PAGE_ALIGN(base + brk_rnd());
-
-	if (ret < base)
-		return base;
-
-	return ret;
-}
-- 
1.7.9.5

