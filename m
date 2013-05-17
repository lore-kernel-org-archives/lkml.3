Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3EQQoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:44:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65304 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab3EQQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:44:12 -0400
From: Will Deacon <will.deacon@arm.com>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        david.daney@cavium.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH] arm64: extable: sort the exception table at build time
Date: Fri, 17 May 2013 17:43:41 +0100
Message-Id: <1368809021-25130-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As is done for other architectures, sort the exception table at
build-time rather than during boot.

Since sortextable appears to be a standalone C program relying on the
host elf.h to provide EM_AARCH64, I've had to add a conditional check in
order to allow cross-compilation on machines that aren't running a
bleeding-edge libc-dev.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/kernel/vmlinux.lds.S | 15 +++++++--------
 scripts/sortextable.c           |  5 +++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 48347dc..fb8fd90 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -7,6 +7,7 @@ config ARM64
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
+	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 3fae2be..3d527726 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -57,6 +57,13 @@ SECTIONS
 
 	RO_DATA(PAGE_SIZE)
 
+	. = ALIGN(8);
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+		__start___ex_table = .;
+		*(__ex_table)
+		__stop___ex_table = .;
+	}
+
 	_etext = .;			/* End of text and rodata section */
 
 	. = ALIGN(PAGE_SIZE);
@@ -99,14 +106,6 @@ SECTIONS
 		READ_MOSTLY_DATA(64)
 
 		/*
-		 * The exception fixup table (might need resorting at runtime)
-		 */
-		. = ALIGN(32);
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-
-		/*
 		 * and the usual data section
 		 */
 		DATA_DATA
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index 1f10e89..f9ce116 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -31,6 +31,10 @@
 #include <tools/be_byteshift.h>
 #include <tools/le_byteshift.h>
 
+#ifndef EM_AARCH64
+#define EM_AARCH64	183
+#endif
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
@@ -249,6 +253,7 @@ do_file(char const *const fname)
 		custom_sort = sort_relative_table;
 		break;
 	case EM_ARM:
+	case EM_AARCH64:
 	case EM_MIPS:
 		break;
 	}  /* end switch */
-- 
1.8.2.2

