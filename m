Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaKUSkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:40:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaKUSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:40:24 -0500
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
Subject: [PATCH RESEND] Kbuild: Add an option to enable GCC VTA
Date: Fri, 21 Nov 2014 10:40:00 -0800
Message-Id: <1416595200-22359-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recent codegen issues, gcc -fvar-tracking-assignments was
unconditionally disabled in commit 2062afb4f804a ("Fix gcc-4.9.0
miscompilation of load_balance() in scheduler").  However, this reduces
the debuginfo coverage for variable locations, especially in inline
functions.  VTA is certainly not perfect either in those cases, but it
is much better than without.  With compiler versions that have fixed the
codegen bugs, we would prefer to have the better details for SystemTap,
and surely other debuginfo consumers like perf will benefit as well.

This patch simply makes CONFIG_DEBUG_INFO_VTA an option.  I considered
Frank and Linus's discussion of a cc-option-like -fcompare-debug test,
but I'm convinced that a narrow test of an arch-specific codegen issue
is not really useful.  GCC has their own regression tests for this, so
I'd suggest GCC_COMPARE_DEBUG=-fvar-tracking-assignments-toggle is more
useful for kernel developers to test confidence.

In fact, I ran into a couple more issues when testing for this patch[1],
although neither of those had any codegen impact.
 [1] https://bugzilla.redhat.com/show_bug.cgi?id=1140872

With gcc-4.9.2-1.fc22, I can now build v3.18-rc5 with Fedora's i686 and
x86_64 configs, and this is completely clean with GCC_COMPARE_DEBUG.

Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Michel Dänzer <michel@daenzer.net>
Signed-off-by: Josh Stone <jistone@redhat.com>
---
 Makefile          |  4 ++++
 lib/Kconfig.debug | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 00d618bbe8e7..a289efbe7e28 100644
--- a/Makefile
+++ b/Makefile
@@ -704,7 +704,11 @@ KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 endif
 
+ifdef CONFIG_DEBUG_INFO_VTA
+KBUILD_CFLAGS   += $(call cc-option, -fvar-tracking-assignments)
+else
 KBUILD_CFLAGS   += $(call cc-option, -fno-var-tracking-assignments)
+endif
 
 ifdef CONFIG_DEBUG_INFO
 ifdef CONFIG_DEBUG_INFO_SPLIT
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4e35a5d767ed..27410417de1d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -165,7 +165,23 @@ config DEBUG_INFO_DWARF4
 	  Generate dwarf4 debug info. This requires recent versions
 	  of gcc and gdb. It makes the debug information larger.
 	  But it significantly improves the success of resolving
-	  variables in gdb on optimized code.
+	  variables in gdb on optimized code.  The gcc docs also
+	  recommend enabling -fvar-tracking-assignments for maximum
+	  benefit. (see DEBUG_INFO_VTA)
+
+config DEBUG_INFO_VTA
+	bool "Enable var-tracking-assignments for debuginfo"
+	depends on DEBUG_INFO
+	help
+	  Enable gcc -fvar-tracking-assignments for improved debug
+	  information on variable locations in optimized code.  Per
+	  gcc, DEBUG_INFO_DWARF4 is recommended for best use of VTA.
+
+	  VTA has been implicated in codegen bugs (gcc PR61801,
+	  PR61904), so this may deserve some caution.  One can set
+	  GCC_COMPARE_DEBUG=-fvar-tracking-assignments-toggle in the
+	  environment to automatically compile everything both ways,
+	  generating an error if anything differs.
 
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
-- 
2.1.0

