Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936276AbaFIJ1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283AbaFIJ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 135/146] powerpc: Fix 64 bit builds with binutils 2.24
Date: Mon,  9 Jun 2014 10:51:10 +0200
Message-Id: <737585cd59617a76c1be68e3ab3350fba47bdf81.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/Makefile              | 4 +++-
 arch/powerpc/include/asm/ppc_asm.h | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 51cfb78d4061..994337bb529c 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -114,7 +114,9 @@ endif
 
 CFLAGS-$(CONFIG_TUNE_CELL) += $(call cc-option,-mtune=cell)
 
-KBUILD_CPPFLAGS	+= -Iarch/$(ARCH)
+asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
+
+KBUILD_CPPFLAGS	+= -Iarch/$(ARCH) $(asinstr)
 KBUILD_AFLAGS	+= -Iarch/$(ARCH)
 KBUILD_CFLAGS	+= -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y)
 CPP		= $(CC) -E $(KBUILD_CFLAGS)
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 0d2d0f03163b..e6d03c7a8031 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -378,11 +378,16 @@ n:
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
1.9.3

