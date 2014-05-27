Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaE0HyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:54:21 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:40625 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaE0HyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:54:19 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Behan Webster <behanw@converseincode.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Makefile: Fix unrecognized cross-compiler command line options
Date: Tue, 27 May 2014 09:54:12 +0200
Message-Id: <1401177252-11919-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures that setup CROSS_COMPILE in their arch/*/Makefile
(arc, blackfin, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
cc-option and cc-disable-warning may check against the wrong compiler,
causing errors like

    cc1: error: unrecognized command line option "-Wno-maybe-uninitialized"

if the host gcc supports a compiler option, while the cross compiler
doesn't support that option.

Move all logic using cc-option or cc-disable-warning below the inclusion
of the arch's Makefile to fix this.

Introduced by
  - commit e74fc973b6e531fef1fce8b101ffff05ecfb774c ("Turn off
    -Wmaybe-uninitialized when building with -Os"),
  - commit 61163efae02040f66a95c8ed17f4407951ba58fa ("kbuild: LLVMLinux:
    Add Kbuild support for building kernel with Clang").

As -Wno-maybe-uninitialized requires a quite recent gcc (gcc 4.6.3 on
Ubuntu 12.04 LTS doesn't support it), this only showed up recently (gcc
4.8.2 on Ubuntu 14.04 LTS does support it).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Perhaps all KBUILD_* definitions can be moved below the inclusion of the
arch's Makefile, to make it less likely to happen again?
But that's definitely post-3.15 material.

 Makefile | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index cf3412d78ff1..da910e09fc9a 100644
--- a/Makefile
+++ b/Makefile
@@ -395,8 +395,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration \
-		   -Wno-format-security \
-		   $(call cc-option,-fno-delete-null-pointer-checks,)
+		   -Wno-format-security
+
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
 KBUILD_AFLAGS   := -D__ASSEMBLY__
@@ -594,14 +594,16 @@ endif # $(dot-config)
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
+KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
+
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
 else
 KBUILD_CFLAGS	+= -O2
 endif
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
-
 ifdef CONFIG_READABLE_ASM
 # Disable optimizations that make assembler listings hard to read.
 # reorder blocks reorders the control in the function
-- 
1.9.1

