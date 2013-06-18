Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab3FRL65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:58:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab3FRLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>,
        Matthew Gretton-Dann <matthew.gretton-dann@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 46/93] ARM: 7743/1: compressed/head.S: work around new binutils warning
Date: Tue, 18 Jun 2013 12:42:54 +0100
Message-Id: <1371555821-12820-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit da94a829305f1c217cfdf6771cb1faca0917e3b9 upstream.

In August 2012, Matthew Gretton-Dann checked a change into binutils
labelled "Error on obsolete & warn on deprecated registers", apparently as
part of ARMv8 support. Apparently, this was supposed to emit the message
"Warning: This coprocessor register access is deprecated in ARMv8" when
using certain mcr/mrc instructions and building for ARMv8. Unfortunately,
the message that is actually emitted appears to be '(null)', which is
less helpful in comparison.

Even more unfortunately, this is biting us on every single kernel
build with a new gas, because arch/arm/boot/compressed/head.S and some
other files in that directory are built with -march=all since kernel
commit 80cec14a8 "[ARM] Add -march=all to assembly file build in
arch/arm/boot/compressed" back in v2.6.28.

This patch reverts Russell's nice solution and instead marks the head.S
file to be built for armv7-a, which fortunately lets us build all
instructions in that file without warnings even on the broken binutils.

Without this patch, building anything results in:

arch/arm/boot/compressed/head.S: Assembler messages:
arch/arm/boot/compressed/head.S:565: Warning: (null)
arch/arm/boot/compressed/head.S:676: Warning: (null)
arch/arm/boot/compressed/head.S:698: Warning: (null)
arch/arm/boot/compressed/head.S:722: Warning: (null)
arch/arm/boot/compressed/head.S:726: Warning: (null)
arch/arm/boot/compressed/head.S:957: Warning: (null)
arch/arm/boot/compressed/head.S:996: Warning: (null)
arch/arm/boot/compressed/head.S:997: Warning: (null)
arch/arm/boot/compressed/head.S:1027: Warning: (null)
arch/arm/boot/compressed/head.S:1035: Warning: (null)
arch/arm/boot/compressed/head.S:1046: Warning: (null)
arch/arm/boot/compressed/head.S:1060: Warning: (null)
arch/arm/boot/compressed/head.S:1092: Warning: (null)
arch/arm/boot/compressed/head.S:1094: Warning: (null)
arch/arm/boot/compressed/head.S:1095: Warning: (null)
arch/arm/boot/compressed/head.S:1102: Warning: (null)
arch/arm/boot/compressed/head.S:1134: Warning: (null)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Gretton-Dann <matthew.gretton-dann@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backport to 3.5:
  - adjusted asflags-y in Makefile ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/compressed/Makefile      | 2 +-
 arch/arm/boot/compressed/head-sa1100.S | 1 +
 arch/arm/boot/compressed/head-shark.S  | 1 +
 arch/arm/boot/compressed/head.S        | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index bb26756..8504174 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -126,7 +126,7 @@ KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
 ccflags-y := -fpic -fno-builtin -I$(obj)
-asflags-y := -Wa,-march=all
+asflags-y :=
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
 KBSS_SZ = $(shell $(CROSS_COMPILE)size $(obj)/../../../../vmlinux | \
diff --git a/arch/arm/boot/compressed/head-sa1100.S b/arch/arm/boot/compressed/head-sa1100.S
index 6179d94..3115e31 100644
--- a/arch/arm/boot/compressed/head-sa1100.S
+++ b/arch/arm/boot/compressed/head-sa1100.S
@@ -11,6 +11,7 @@
 #include <asm/mach-types.h>
 
 		.section        ".start", "ax"
+		.arch	armv4
 
 __SA1100_start:
 
diff --git a/arch/arm/boot/compressed/head-shark.S b/arch/arm/boot/compressed/head-shark.S
index 089c560..92b5689 100644
--- a/arch/arm/boot/compressed/head-shark.S
+++ b/arch/arm/boot/compressed/head-shark.S
@@ -18,6 +18,7 @@
 	
 		.section	".start", "ax"
 
+		.arch armv4
 		b	__beginning
 	
 __ofw_data:	.long	0				@ the number of memory blocks
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index bc67cbf..a7ae392 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 
+	.arch	armv7-a
 /*
  * Debugging stuff
  *
-- 
1.8.1.2

