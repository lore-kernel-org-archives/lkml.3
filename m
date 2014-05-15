Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaEOQeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:34:11 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42813 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaEOQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:34:09 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alan Modra <amodra@gmail.com>
Subject: [PATCH] powerpc: Fix 64 bit builds with binutils 2.24
Date: Thu, 15 May 2014 09:33:42 -0700
Message-Id: <1400171622-20572-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With binutils 2.24, various 64 bit builds fail with relocation errors
such as

arch/powerpc/kernel/built-in.o: In function `exc_debug_crit_book3e':
	(.text+0x165ee): relocation truncated to fit: R_PPC64_ADDR16_HI
	against symbol `interrupt_base_book3e' defined in .text section
	in arch/powerpc/kernel/built-in.o
arch/powerpc/kernel/built-in.o: In function `exc_debug_crit_book3e':
	(.text+0x16602): relocation truncated to fit: R_PPC64_ADDR16_HI
	against symbol `interrupt_end_book3e' defined in .text section
	in arch/powerpc/kernel/built-in.o

The assembler maintainer says:

 I changed the ABI, something that had to be done but unfortunately
 happens to break the booke kernel code.  When building up a 64-bit
 value with lis, ori, shl, oris, ori or similar sequences, you now
 should use @high and @higha in place of @h and @ha.  @h and @ha
 (and their associated relocs R_PPC64_ADDR16_HI and R_PPC64_ADDR16_HA)
 now report overflow if the value is out of 32-bit signed range.
 ie. @h and @ha assume you're building a 32-bit value. This is needed
 to report out-of-range -mcmodel=medium toc pointer offsets in @toc@h
 and @toc@ha expressions, and for consistency I did the same for all
 other @h and @ha relocs.

Replacing @h with @high in one strategic location fixes the relocation
errors. This has to be done conditionally since the assembler either
supports @h or @high but not both.

Cc: Alan Modra <amodra@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
All my test targets build with both binutils 2.23 and 2.24
with this patch applied.

The patch generates two checkpatch errors, but I consider those to be
false positives. checkpatch requests spaces after , in the assembler
instructions.

Please consider adding Cc: stable.

 arch/powerpc/Makefile              | 4 +++-
 arch/powerpc/include/asm/ppc_asm.h | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 4c0cedf..ce4c68a 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -150,7 +150,9 @@ endif
 
 CFLAGS-$(CONFIG_TUNE_CELL) += $(call cc-option,-mtune=cell)
 
-KBUILD_CPPFLAGS	+= -Iarch/$(ARCH)
+asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
+
+KBUILD_CPPFLAGS	+= -Iarch/$(ARCH) $(asinstr)
 KBUILD_AFLAGS	+= -Iarch/$(ARCH)
 KBUILD_CFLAGS	+= -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y)
 CPP		= $(CC) -E $(KBUILD_CFLAGS)
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 6586a40..cded7c1 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -318,11 +318,16 @@ n:
 	addi	reg,reg,(name - 0b)@l;
 
 #ifdef __powerpc64__
+#ifdef HAVE_AS_ATHIGH
+#define __AS_ATHIGH high
+#else
+#define __AS_ATHIGH h
+#endif
 #define LOAD_REG_IMMEDIATE(reg,expr)		\
 	lis     reg,(expr)@highest;		\
 	ori     reg,reg,(expr)@higher;	\
 	rldicr  reg,reg,32,31;		\
-	oris    reg,reg,(expr)@h;		\
+	oris    reg,reg,(expr)@__AS_ATHIGH;	\
 	ori     reg,reg,(expr)@l;
 
 #define LOAD_REG_ADDR(reg,name)			\
-- 
1.9.1

