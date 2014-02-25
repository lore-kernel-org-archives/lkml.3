Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBYJYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:24:33 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39892 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaBYJY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:24:26 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v4 4/7] ftrace: Add arm64 support to recordmcount
Date: Tue, 25 Feb 2014 18:23:13 +0900
Message-Id: <1393320196-2942-5-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
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

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig      |    2 ++
 scripts/recordmcount.c  |    4 ++++
 scripts/recordmcount.pl |    5 +++++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b176bc0..6954959 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -27,6 +27,7 @@ config ARM64
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
@@ -34,6 +35,7 @@ config ARM64
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_GENERIC_DMA_COHERENT
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 9c22317..b92d9f7 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -347,6 +347,10 @@ do_file(char const *const fname)
 	case EM_ARM:	 reltype = R_ARM_ABS32;
 			 altmcount = "__gnu_mcount_nc";
 			 break;
+	case EM_AARCH64:
+			 reltype = R_AARCH64_ABS64;
+			 altmcount = "_mcount";
+			 break;
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

