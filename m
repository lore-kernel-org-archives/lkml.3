Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaBZBJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:09:31 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61848 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaBZBJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:26 -0500
From: behanw@converseincode.com
To: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH 1/5] kbuild: LLVMLinux: Add Kbuild support for building kernel with Clang
Date: Tue, 25 Feb 2014 17:08:39 -0800
Message-Id: <1393376923-21892-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Add support to toplevel Makefile for compiling with clang, both for
HOSTCC and CC. Use cc-option to prevent gcc option from breaking clang, and
from clang options from breaking gcc.

Clang 3.4 semantics are the same as gcc semantics for unsupported flags. For
unsupported warnings clang 3.4 returns true but shows a warning and gcc shows
a warning and returns false.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
---
 Makefile | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 831b36a..c4ab30d 100644
--- a/Makefile
+++ b/Makefile
@@ -247,6 +247,15 @@ HOSTCXX      = g++
 HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
 HOSTCXXFLAGS = -O2
 
+ifeq ($(shell $(HOSTCC) -v 2>&1 | grep -c "clang version"), 1)
+HOSTCOMPILER := clang
+HOSTCFLAGS  += -Wno-unused-value -Wno-unused-parameter \
+		-Wno-missing-field-initializers -fno-delete-null-pointer-checks
+else
+HOSTCOMPILER := gcc
+endif
+export HOSTCOMPILER
+
 # Decide whether to build built-in, modular, or both.
 # Normally, just do built-in.
 
@@ -323,6 +332,12 @@ endif
 
 export quiet Q KBUILD_VERBOSE
 
+ifeq ($(shell $(CC) -v 2>&1 | grep -c "clang version"), 1)
+COMPILER := clang
+else
+COMPILER := gcc
+endif
+export COMPILER
 
 # Look for make include files relative to root of kernel src
 MAKEFLAGS += --include-dir=$(srctree)
@@ -382,7 +397,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
-		   -fno-delete-null-pointer-checks
+		   $(call cc-option,-fno-delete-null-pointer-checks,)
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
@@ -620,9 +635,24 @@ else
 endif
 KBUILD_CFLAGS += $(stackp-flag)
 
+ifeq ($(COMPILER),clang)
+KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
+KBUILD_CPPFLAGS += $(call cc-option,-Wno-unknown-warning-option,)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, format-invalid-specifier)
+KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
+# Quiet clang warning: comparison of unsigned expression < 0 is always false
+KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
+# CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the
+# source of a reference will be _MergedGlobals and not on of the whitelisted names.
+# See modpost pattern 2
+KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
+else
+
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
+endif
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
-- 
1.8.3.2

