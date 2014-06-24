Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaFXUbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:31:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaFXUbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:31:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 50/65] powerpc: Fix 64 bit builds with binutils 2.24
Date: Tue, 24 Jun 2014 13:30:10 -0700
Message-Id: <1403641825-12825-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 7998eb3dc700aaf499f93f50b3d77da834ef9e1d upstream.

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

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/Makefile              | 4 +++-
 arch/powerpc/include/asm/ppc_asm.h | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index b639852..d47e1df 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -79,7 +79,9 @@ CFLAGS-$(CONFIG_POWER7_CPU) += $(call cc-option,-mcpu=power7)
 
 CFLAGS-$(CONFIG_TUNE_CELL) += $(call cc-option,-mtune=cell)
 
-KBUILD_CPPFLAGS	+= -Iarch/$(ARCH)
+asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
+
+KBUILD_CPPFLAGS	+= -Iarch/$(ARCH) $(asinstr)
 KBUILD_AFLAGS	+= -Iarch/$(ARCH)
 KBUILD_CFLAGS	+= -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y)
 CPP		= $(CC) -E $(KBUILD_CFLAGS)
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index ea2a86e..ce5ad32 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -309,11 +309,16 @@ n:
  *      ld	rY,ADDROFF(name)(rX)
  */
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

