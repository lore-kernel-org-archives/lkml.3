Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3IKF3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:29:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab3IKE5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:24 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Dogma-kj3BsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=azy-ZEZ-4e4A:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=WG6wbt25S0_cMdkusm8A:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=8cWDjPa7BZ2atV5C:21 a=G_M8EXvhF572Z49J:21 a=zGeAQBdw19wRWUxX:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042912.875914270@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [124/251] ARM: allow kuser helpers to be removed from the vector page
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0124-ARM-allow-kuser-helpers-to-be-removed-from-the-vecto.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit f6f91b0d9fd971c630cef908dde8fe8795aefbf8 ]

Provide a kernel configuration option to allow the kernel user helpers
to be removed from the vector page, thereby preventing their use with
ROP (return orientated programming) attacks.  This option is only
visible for CPU architectures which natively support all the operations
which kernel user helpers would normally provide, and must be enabled
with caution.

Cc: <stable@vger.kernel.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/entry-armv.S |    3 +++
 arch/arm/kernel/traps.c      |   23 ++++++++++++++---------
 arch/arm/mm/Kconfig          |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 4c28aff..5492d72 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -795,6 +795,7 @@ ENDPROC(__switch_to)
 	.endr
 	.endm
 
+#ifdef CONFIG_KUSER_HELPERS
 	.align	5
 	.globl	__kuser_helper_start
 __kuser_helper_start:
@@ -981,6 +982,8 @@ __kuser_helper_version:				@ 0xffff0ffc
 	.globl	__kuser_helper_end
 __kuser_helper_end:
 
+#endif
+
  THUMB(	.thumb	)
 
 /*
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 366aa93..1392beb 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -807,23 +807,32 @@ void __init trap_init(void)
 	return;
 }
 
-static void __init kuser_get_tls_init(unsigned long vectors)
+#ifdef CONFIG_KUSER_HELPERS
+static void __init kuser_init(void *vectors)
 {
+	extern char __kuser_helper_start[], __kuser_helper_end[];
+	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+
+	memcpy(vectors + 0x1000 - kuser_sz, __kuser_helper_start, kuser_sz);
+
 	/*
 	 * vectors + 0xfe0 = __kuser_get_tls
 	 * vectors + 0xfe8 = hardware TLS instruction at 0xffff0fe8
 	 */
 	if (tls_emu || has_tls_reg)
-		memcpy((void *)vectors + 0xfe0, (void *)vectors + 0xfe8, 4);
+		memcpy(vectors + 0xfe0, vectors + 0xfe8, 4);
+}
+#else
+static void __init kuser_init(void *vectors)
+{
 }
+#endif
 
 void __init early_trap_init(void *vectors_base)
 {
 	unsigned long vectors = (unsigned long)vectors_base;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
-	extern char __kuser_helper_start[], __kuser_helper_end[];
-	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
 	unsigned i;
 
 	vectors_page = vectors_base;
@@ -844,12 +853,8 @@ void __init early_trap_init(void *vectors_base)
 	 */
 	memcpy((void *)vectors, __vectors_start, __vectors_end - __vectors_start);
 	memcpy((void *)vectors + 0x1000, __stubs_start, __stubs_end - __stubs_start);
-	memcpy((void *)vectors + 0x1000 - kuser_sz, __kuser_helper_start, kuser_sz);
 
-	/*
-	 * Do processor specific fixups for the kuser helpers
-	 */
-	kuser_get_tls_init(vectors);
+	kuser_init(vectors_base);
 
 	/*
 	 * Copy signal return handlers into the vector page, and
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 101b968..8d194df 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -400,24 +400,28 @@ config CPU_32v3
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v4
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v4T
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v5
 	bool
 	select TLS_REG_EMUL if SMP || !MMU
 	select NEEDS_SYSCALL_FOR_CMPXCHG if SMP
 	select CPU_USE_DOMAINS if MMU
+	select NEED_KUSER_HELPERS
 
 config CPU_32v6
 	bool
@@ -735,6 +739,7 @@ config CPU_BPREDICT_DISABLE
 
 config TLS_REG_EMUL
 	bool
+	select NEED_KUSER_HELPERS
 	help
 	  An SMP system using a pre-ARMv6 processor (there are apparently
 	  a few prototypes like that in existence) and therefore access to
@@ -742,11 +747,40 @@ config TLS_REG_EMUL
 
 config NEEDS_SYSCALL_FOR_CMPXCHG
 	bool
+	select NEED_KUSER_HELPERS
 	help
 	  SMP on a pre-ARMv6 processor?  Well OK then.
 	  Forget about fast user space cmpxchg support.
 	  It is just not possible.
 
+config NEED_KUSER_HELPERS
+	bool
+
+config KUSER_HELPERS
+	bool "Enable kuser helpers in vector page" if !NEED_KUSER_HELPERS
+	default y
+	help
+	  Warning: disabling this option may break user programs.
+
+	  Provide kuser helpers in the vector page.  The kernel provides
+	  helper code to userspace in read only form at a fixed location
+	  in the high vector page to allow userspace to be independent of
+	  the CPU type fitted to the system.  This permits binaries to be
+	  run on ARMv4 through to ARMv7 without modification.
+
+	  However, the fixed address nature of these helpers can be used
+	  by ROP (return orientated programming) authors when creating
+	  exploits.
+
+	  If all of the binaries and libraries which run on your platform
+	  are built specifically for your platform, and make no use of
+	  these helpers, then you can turn this option off.  However,
+	  when such an binary or library is run, it will receive a SIGILL
+	  signal, which will terminate the program.
+
+	  Say N here only if you are absolutely certain that you do not
+	  need these helpers; otherwise, the safe option is to say Y.
+
 config DMA_CACHE_RWFO
 	bool "Enable read/write for ownership DMA cache maintenance"
 	depends on CPU_V6K && SMP
-- 
1.7.10.4


