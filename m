Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaGHTT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:19:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755744AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.495355144@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 043/125] powerpc: Fix 64 bit builds with binutils 2.24
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/Makefile              | 4 +++-
 arch/powerpc/include/asm/ppc_asm.h | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -69,7 +69,9 @@ LDFLAGS_vmlinux	:= $(LDFLAGS_vmlinux-yy)
 
 CFLAGS-$(CONFIG_PPC64)	:= -mminimal-toc -mtraceback=no -mcall-aixdesc
 CFLAGS-$(CONFIG_PPC32)	:= -ffixed-r2 -mmultiple
-KBUILD_CPPFLAGS	+= -Iarch/$(ARCH)
+asinstr := $(call as-instr,lis 9$(comma)foo@high,-DHAVE_AS_ATHIGH=1)
+
+KBUILD_CPPFLAGS	+= -Iarch/$(ARCH) $(asinstr)
 KBUILD_AFLAGS	+= -Iarch/$(ARCH)
 KBUILD_CFLAGS	+= -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y)
 CPP		= $(CC) -E $(KBUILD_CFLAGS)
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -292,11 +292,16 @@ n:
  *      ld	rY,ADDROFF(name)(rX)
  */
 #ifdef __powerpc64__
+#ifdef HAVE_AS_ATHIGH
+#define __AS_ATHIGH high
+#else
+#define __AS_ATHIGH h
+#endif
 #define LOAD_REG_IMMEDIATE(reg,expr)		\
 	lis     (reg),(expr)@highest;		\
 	ori     (reg),(reg),(expr)@higher;	\
 	rldicr  (reg),(reg),32,31;		\
-	oris    (reg),(reg),(expr)@h;		\
+	oris    reg,reg,(expr)@__AS_ATHIGH;	\
 	ori     (reg),(reg),(expr)@l;
 
 #define LOAD_REG_ADDR(reg,name)			\

