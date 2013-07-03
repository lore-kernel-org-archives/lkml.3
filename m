Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185Ab3GCTFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:05:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965017Ab3GCTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:30 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ks695Uw5kcoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=P3JAR91pB_gA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=drOt6m5kAAAA:8 a=xYyZaYpZ8SH__yWiF3EA:9 a=JTMqrY5UvyEA:10 a=ESTKKtUg-DoA:10 a=jeBq3FmKZ4MA:10 a=8Fo4ON0U07m9uQIN:21 a=toCVZS6a6G0qPWZD:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184059.860838833@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Matthew Gretton-Dann <matthew.gretton-dann@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [089/141] ARM: 7743/1: compressed/head.S: work around new binutils warning
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0089-ARM-7743-1-compressed-head.S-work-around-new-binutil.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit da94a829305f1c217cfdf6771cb1faca0917e3b9 ]

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
Cc: stable@vger.kernel.org
Cc: Matthew Gretton-Dann <matthew.gretton-dann@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/boot/compressed/Makefile      |    2 +-
 arch/arm/boot/compressed/head-sa1100.S |    1 +
 arch/arm/boot/compressed/head-shark.S  |    1 +
 arch/arm/boot/compressed/head.S        |    1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index bb26756..90a482b 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -126,7 +126,7 @@ KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
 ccflags-y := -fpic -fno-builtin -I$(obj)
-asflags-y := -Wa,-march=all
+asflags-y := -DZIMAGE
 
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
1.7.10.4


