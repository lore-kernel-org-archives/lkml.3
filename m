Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaHEQRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:17:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64278 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbaHEQRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:17:44 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] Kbuild: x86: Eliminate duplicate command line options
Date: Tue,  5 Aug 2014 18:16:51 +0200
Message-Id: <1407255411-30404-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The options -mno-mmx and -mno-sse are unconditionally added to
KBUILD_CFLAGS in both branches of an ifeq and through a $(cc-option)
further down. We can safely remove the first instances.

In fact, since the -mno-mmx and -mno-sse options were introduced
simultaneous with the other two options in the $(cc-option) [according
to http://www.gnu.org/software/gcc/gcc-3.1/changes.html], and since
the former were unconditionally used, one can deduce that only gcc
versions knowing about all four are supported. So also eliminate the
$(cc-option) wrap.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/x86/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c65fd96..202f849 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -50,9 +50,6 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
-        # Don't autogenerate MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
-
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
         KBUILD_CFLAGS += -fno-pic
@@ -80,8 +77,7 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
-        # Don't autogenerate traditional x87, MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        # Don't autogenerate traditional x87 instructions
         KBUILD_CFLAGS += $(call cc-option,-mno-80387)
         KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
 
@@ -168,7 +164,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 #
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
-KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
 KBUILD_CFLAGS += $(mflags-y)
-- 
1.9.2

