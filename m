Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264AbaDJDXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934666AbaDJDVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Matthew Gretton-Dann <matthew.gretton-dann@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 033/134] ARM: 7743/1: compressed/head.S: work around new binutils warning
Date: Wed,  9 Apr 2014 20:22:29 -0700
Message-Id: <20140410032304.216699104@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Remove definition of asflags-y as it is now empty]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/compressed/Makefile      |    1 -
 arch/arm/boot/compressed/head-sa1100.S |    1 +
 arch/arm/boot/compressed/head-shark.S  |    1 +
 arch/arm/boot/compressed/head.S        |    1 +
 4 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -126,7 +126,6 @@ KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CF
 endif
 
 ccflags-y := -fpic -fno-builtin -I$(obj)
-asflags-y := -Wa,-march=all
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
 KBSS_SZ = $(shell $(CROSS_COMPILE)size $(obj)/../../../../vmlinux | \
--- a/arch/arm/boot/compressed/head-sa1100.S
+++ b/arch/arm/boot/compressed/head-sa1100.S
@@ -11,6 +11,7 @@
 #include <asm/mach-types.h>
 
 		.section        ".start", "ax"
+		.arch	armv4
 
 __SA1100_start:
 
--- a/arch/arm/boot/compressed/head-shark.S
+++ b/arch/arm/boot/compressed/head-shark.S
@@ -18,6 +18,7 @@
 	
 		.section	".start", "ax"
 
+		.arch armv4
 		b	__beginning
 	
 __ofw_data:	.long	0				@ the number of memory blocks
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 
+	.arch	armv7-a
 /*
  * Debugging stuff
  *


