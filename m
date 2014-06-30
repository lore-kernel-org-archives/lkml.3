Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaF3Spr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:45:47 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49799 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaF3Spq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:45:46 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
Date: Mon, 30 Jun 2014 11:45:30 -0700
Message-Id: <1404153930-26568-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc:allmodconfig has been failing for some time with the following
error.

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

A number of attempts to fix the problem by moving around code have been
unsuccessful and resulted in failed builds for some configurations and
the discovery of toolchain bugs.

Fix the problem by disabling RELOCATABLE for COMPILE_TEST builds instead.
While this is less than perfect, it avoids substantial code changes
which would otherwise be necessary just to make COMPILE_TEST builds
happy and might have undesired side effects.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/powerpc/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index bd6dd6e..fefe7c8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -414,7 +414,7 @@ config KEXEC
 config CRASH_DUMP
 	bool "Build a kdump crash kernel"
 	depends on PPC64 || 6xx || FSL_BOOKE || (44x && !SMP)
-	select RELOCATABLE if PPC64 || 44x || FSL_BOOKE
+	select RELOCATABLE if (PPC64 && !COMPILE_TEST) || 44x || FSL_BOOKE
 	help
 	  Build a kernel suitable for use as a kdump capture kernel.
 	  The same kernel binary can be used as production kernel and dump
@@ -1017,6 +1017,7 @@ endmenu
 if PPC64
 config RELOCATABLE
 	bool "Build a relocatable kernel"
+	depends on !COMPILE_TEST
 	select NONSTATIC_KERNEL
 	help
 	  This builds a kernel image that is capable of running anywhere
-- 
1.9.1

