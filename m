Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab3DJJMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:12:31 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38983 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965030Ab3DJJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:12:28 -0400
Message-ID: <51652CF5.1080009@gmail.com>
Date: Wed, 10 Apr 2013 11:12:21 +0200
From: Wladislav Wiebe <wladislav.kw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: ralf@linux-mips.org, linux-mips@linux-mips.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Makefile: workaround printk recursion bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wladislav Wiebe <wladislav.kw@gmail.com>

Function tracing is broken due to removal of selecting FRAME_POINTER with
FUNCTION_TRACER as result of commit: b732d439cb43336cd6d7e804ecb2c81193ef63b0

Latest commit ad8c396936e328f5344e1881afde9e28d5f2045f "MIPS: Unbreak
function tracer for 64-bit kernel." fixes just the early startup hang,
but on MIPS64/CAVIUM_OCTEON2 are still random printk recursion bugs
which cause also Kernel hangs, especially on late startup phase when
network drivers get loaded. This patch enable for CAVIUM_OCTEON2/64 Bit
architecture -fno-omit-frame-pointer cflag when FUNCTION_TRACER get
enabled. This will fix random Kernel hangs with "BUG: recent printk
recursion!" from linux/kernel/printk.c.

Maybe there exist a other solution in mcount handling, since in the
commit message from Al Cooper is mentioned that "MIPS frame pointers are
generally considered to be useless because they cannot be used to unwind
the stack. Unfortunately the MIPS function tracing code has bugs that
are masked by the use of frame pointers. This commit fixes the bugs so
that MIPS frame pointers don't need to be enabled."

But this is just a solution for MIPS32 - on a symmetric multiprocessing
@MIPS64/CAVIUM_OCTEON2 it doesn't work properly.

Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
---
 arch/mips/Makefile |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 6f7978f..8befe31 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -119,6 +119,15 @@ cflags-$(CONFIG_SB1XXX_CORELIS)	+= $(call cc-option,-mno-sched-prolog) \
 				   -fno-omit-frame-pointer

 #
+# FTrace depended compiler options, currently only needed by MIPS64/OCTEON2.
+#
+ifdef CONFIG_64BIT
+ifdef CONFIG_CAVIUM_OCTEON2
+cflags-$(CONFIG_FUNCTION_TRACER) += $(call cc-option,-fno-omit-frame-pointer)
+endif
+endif
+
+#
 # CPU-dependent compiler/assembler options for optimization.
 #
 cflags-$(CONFIG_CPU_R3000)	+= -march=r3000
-- 
1.7.9.5

