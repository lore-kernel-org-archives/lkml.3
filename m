Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaFDU2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:28:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFDU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:28:04 -0400
Date: Wed, 4 Jun 2014 13:27:38 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-xw8ibgdemucl9fz3i1bymu6w@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kevin@koconnor.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kevin@koconnor.net, tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, build:
  Change code16gcc.h from a C header to an assembly header
Git-Commit-ID: a9cfccee6604854aebc70215610b9788667f4fec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9cfccee6604854aebc70215610b9788667f4fec
Gitweb:     http://git.kernel.org/tip/a9cfccee6604854aebc70215610b9788667f4fec
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 4 Jun 2014 13:16:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 4 Jun 2014 13:16:48 -0700

x86, build: Change code16gcc.h from a C header to an assembly header

By changing code16gcc.h from a C header to an assembly header and use
the -Wa,... option to gcc to force it to be added to the assembly
input, we can avoid the problems with gcc reordering code bits on us.

If we have -m16, we still use it, of course.

Suggested-by: Kevin O'Connor <kevin@koconnor.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-xw8ibgdemucl9fz3i1bymu6w@git.kernel.org
---
 arch/x86/Makefile         |  9 +++------
 arch/x86/boot/code16gcc.h | 24 ++++++++++--------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 602f57e..a98cc90 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -15,12 +15,9 @@ endif
 # that way we can complain to the user if the CPU is insufficient.
 #
 # The -m16 option is supported by GCC >= 4.9 and clang >= 3.5. For
-# older versions of GCC, we need to play evil and unreliable tricks to
-# attempt to ensure that our asm(".code16gcc") is first in the asm
-# output.
-CODE16GCC_CFLAGS := -m32 -include $(srctree)/arch/x86/boot/code16gcc.h \
-		    $(call cc-option, -fno-toplevel-reorder,\
-		      $(call cc-option, -fno-unit-at-a-time))
+# older versions of GCC, include an *assembly* header to make sure that
+# gcc doesn't play any games behind our back.
+CODE16GCC_CFLAGS := -m32 -Wa,$(srctree)/arch/x86/boot/code16gcc.h
 M16_CFLAGS	 := $(call cc-option, -m16, $(CODE16GCC_CFLAGS))
 
 REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
diff --git a/arch/x86/boot/code16gcc.h b/arch/x86/boot/code16gcc.h
index d93e480..5ff4265 100644
--- a/arch/x86/boot/code16gcc.h
+++ b/arch/x86/boot/code16gcc.h
@@ -1,15 +1,11 @@
-/*
- * code16gcc.h
- *
- * This file is -include'd when compiling 16-bit C code.
- * Note: this asm() needs to be emitted before gcc emits any code.
- * Depending on gcc version, this requires -fno-unit-at-a-time or
- * -fno-toplevel-reorder.
- *
- * Hopefully gcc will eventually have a real -m16 option so we can
- * drop this hack long term.
- */
+#
+# code16gcc.h
+#
+# This file is added to the assembler via -Wa when compiling 16-bit C code.
+# This is done this way instead via asm() to make sure gcc does not reorder
+# things around us.
+#
+# gcc 4.9+ has a real -m16 option so we can drop this hack long term.
+#
 
-#ifndef __ASSEMBLY__
-asm(".code16gcc");
-#endif
+	.code16gcc
