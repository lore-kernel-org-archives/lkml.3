Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbaIWT0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:26:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65264 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbaIWT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:26:33 -0400
From: behanw@converseincode.com
To: mq@suse.cz
Cc: linux-kernel@vger.kernel.org, Behan Webster <behanw@converseincode.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Tom Gundersen <teg@jklm.no>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] kbuild, LLVMLinux: Fix asm-offset generation to work with clang
Date: Tue, 23 Sep 2014 12:25:31 -0700
Message-Id: <1411500331-9861-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

When using clang with -no-integerated-as clang will use the gnu assembler instead
of the integrated assembler. However clang will still perform asm error checking
before sending the inline assembly language to gas.

The generation of asm-offsets from within C code is dependent on gcc's blind
passing of whatever is in asm() through to gas. Arbirary text is
passed through which is then modified by a sed script into the appropriate .h
and .S code. Since the arbitrary text is not valid assembly language, clang fails.

This can be fixed by making the arbitrary text into an ASM comment and then
updating the sed scripts accordingly to work as expected.

This solution works for both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
Cc: Jan Moskyto Matejka <mq@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 Kbuild                 | 8 ++++----
 include/linux/kbuild.h | 6 +++---
 scripts/mod/Makefile   | 8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Kbuild b/Kbuild
index b8b708a..2f509c9 100644
--- a/Kbuild
+++ b/Kbuild
@@ -52,10 +52,10 @@ targets += arch/$(SRCARCH)/kernel/asm-offsets.s
 
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
-	"/^->/{s:->#\(.*\):/* \1 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
-	s:->::; p;}"
+	"/^@->/{s:->#\(.*\):/* \1 */:; \
+	s:^@->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:^@->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:@->::; p;}"
 endef
 
 quiet_cmd_offsets = GEN     $@
diff --git a/include/linux/kbuild.h b/include/linux/kbuild.h
index 22a7219..75fa2c3 100644
--- a/include/linux/kbuild.h
+++ b/include/linux/kbuild.h
@@ -2,14 +2,14 @@
 #define __LINUX_KBUILD_H
 
 #define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+	asm volatile("\n@->" #sym " %0 " #val : : "i" (val))
 
-#define BLANK() asm volatile("\n->" : : )
+#define BLANK() asm volatile("\n@->" : : )
 
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem))
 
 #define COMMENT(x) \
-	asm volatile("\n->#" x)
+	asm volatile("\n@->#" x)
 
 #endif
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index c11212f..86f6b85 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -6,10 +6,10 @@ modpost-objs	:= modpost.o file2alias.o sumversion.o
 devicetable-offsets-file := devicetable-offsets.h
 
 define sed-y
-	"/^->/{s:->#\(.*\):/* \1 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
-	s:->::; p;}"
+	"/^@->/{s:@->#\(.*\):/* \1 */:; \
+	s:^@->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:^@->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:@->::; p;}"
 endef
 
 quiet_cmd_offsets = GEN     $@
-- 
1.9.1

