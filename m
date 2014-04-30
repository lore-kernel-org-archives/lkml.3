Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaD3J4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:56:20 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:61339 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbaD3J4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:56:15 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v8 4/8] ftrace: Add arm64 support to recordmcount
Date: Wed, 30 Apr 2014 18:54:32 +0900
Message-Id: <1398851676-16389-5-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recordmcount utility under scripts is run, after compiling each object,
to find out all the locations of calling _mcount() and put them into
specific seciton named __mcount_loc.
Then linker collects all such information into a table in the kernel image
(between __start_mcount_loc and __stop_mcount_loc) for later use by ftrace.

This patch adds arm64 specific definitions to identify such locations.
There are two types of implementation, C and Perl. On arm64, only C version
is used to build the kernel now that CONFIG_HAVE_C_RECORDMCOUNT is on.
But Perl version is also maintained.

This patch also contains a workaround just in case where a header file,
elf.h, on host machine doesn't have definitions of EM_AARCH64 nor
R_AARCH64_ABS64. Without them, compiling C version of recordmcount will
fail.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig      |    2 ++
 scripts/recordmcount.c  |    7 +++++++
 scripts/recordmcount.pl |    5 +++++
 3 files changed, 14 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..f467285 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -30,12 +30,14 @@ config ARM64
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 9c22317..e11aa4a 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -40,6 +40,11 @@
 #define R_METAG_NONE                     3
 #endif
 
+#ifndef EM_AARCH64
+#define EM_AARCH64	183
+#define R_AARCH64_ABS64	257
+#endif
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
@@ -347,6 +352,8 @@ do_file(char const *const fname)
 	case EM_ARM:	 reltype = R_ARM_ABS32;
 			 altmcount = "__gnu_mcount_nc";
 			 break;
+	case EM_AARCH64:
+			 reltype = R_AARCH64_ABS64; gpfx = '_'; break;
 	case EM_IA_64:	 reltype = R_IA64_IMM64;   gpfx = '_'; break;
 	case EM_METAG:	 reltype = R_METAG_ADDR32;
 			 altmcount = "_mcount_wrapper";
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 91280b8..397b6b8 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -279,6 +279,11 @@ if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24|THM_CALL)" .
 			"\\s+(__gnu_mcount_nc|mcount)\$";
 
+} elsif ($arch eq "arm64") {
+    $alignment = 3;
+    $section_type = '%progbits';
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_AARCH64_CALL26\\s+_mcount\$";
+    $type = ".quad";
 } elsif ($arch eq "ia64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
     $type = "data8";
-- 
1.7.9.5

