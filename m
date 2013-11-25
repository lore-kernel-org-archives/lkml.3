Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3KYXXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:23:14 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:63139 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133Ab3KYXXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:23:12 -0500
To: mingo@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        felipe.contreras@gmail.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-Id: <705bbe0f70fb20759151642ba0176a6414ec9f7a.1385418410.git.jbaron@akamai.com>
In-Reply-To: <cover.1385418410.git.jbaron@akamai.com>
References: <cover.1385418410.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 3/3 v3] powerpc: cleanup panic_timeout
Date: Mon, 25 Nov 2013 23:23:11 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default CONFIG_PANIC_TIMEOUT to 180 seconds on powerpc. The pSeries continue
to set the timeout to 10 seconds at run-time. Thus, there's a small window
where we don't have the correct value on pSeries, but if this is only run-time
discoverable we don't have a better option. In any case, if the user changes
the default setting of 180 seconds, we honor that user setting.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/powerpc/Kconfig                   | 4 ++++
 arch/powerpc/include/asm/setup.h       | 1 +
 arch/powerpc/kernel/setup_32.c         | 3 ---
 arch/powerpc/kernel/setup_64.c         | 3 ---
 arch/powerpc/platforms/pseries/setup.c | 2 +-
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b44b52c..b2be8e8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -147,6 +147,10 @@ config EARLY_PRINTK
 	bool
 	default y
 
+config PANIC_TIMEOUT
+	int
+	default 180
+
 config COMPAT
 	bool
 	default y if PPC64
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 703a841..11ba86e 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -26,6 +26,7 @@ extern void reloc_got2(unsigned long);
 void check_for_initrd(void);
 void do_init_bootmem(void);
 void setup_panic(void);
+#define ARCH_PANIC_TIMEOUT 180
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index b903dc5..2b0da27 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -296,9 +296,6 @@ void __init setup_arch(char **cmdline_p)
 	if (cpu_has_feature(CPU_FTR_UNIFIED_ID_CACHE))
 		ucache_bsize = icache_bsize = dcache_bsize;
 
-	/* reboot on panic */
-	panic_timeout = 180;
-
 	if (ppc_md.panic)
 		setup_panic();
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 4085aaa..856dd4e 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -588,9 +588,6 @@ void __init setup_arch(char **cmdline_p)
 	dcache_bsize = ppc64_caches.dline_size;
 	icache_bsize = ppc64_caches.iline_size;
 
-	/* reboot on panic */
-	panic_timeout = 180;
-
 	if (ppc_md.panic)
 		setup_panic();
 
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index c1f1908..6f76ae4 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -470,7 +470,7 @@ static long pseries_little_endian_exceptions(void)
 
 static void __init pSeries_setup_arch(void)
 {
-	panic_timeout = 10;
+	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);
 
 	/* Discover PIC type and setup ppc_md accordingly */
 	pseries_discover_pic();
-- 
1.8.2

