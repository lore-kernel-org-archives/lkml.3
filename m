Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3KHUnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:43:12 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:52953 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757521Ab3KHUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:43:08 -0500
To: akpm@linux-foundation.org, mingo@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH] panic: Make panic_timeout configurable
Message-Id: <20131108204307.49C6AFE076@prod-mail-relay02.akamai.com>
Date: Fri,  8 Nov 2013 20:43:07 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic_timeout can be set via the command line option 'panic=x', or via
/proc/sys/kernel/panic, however that is not sufficient when the panic occurs
before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
so that we can set the desired value from the .config, instead of carrying a
patch for it.

The default panic_timeout value continues to be 0 - wait forever, except for
powerpc and mips, which have been defaulted to 180 and 5 respectively. This
is in keeping with the fact that these arches already set panic_timeout in
their arch init code. However, I found two exceptions- one in mips and one in
powerpc where settings didn't match these default values. In those two cases,
I left the arch code so it continues to override. Perhaps, these cases can
be converted to the default?

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/mips/netlogic/xlp/setup.c |  1 -
 arch/mips/netlogic/xlr/setup.c |  1 -
 arch/mips/sibyte/swarm/setup.c |  2 --
 arch/powerpc/kernel/setup_32.c |  3 ---
 arch/powerpc/kernel/setup_64.c |  3 ---
 kernel/panic.c                 |  2 +-
 lib/Kconfig.debug              | 12 ++++++++++++
 7 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/mips/netlogic/xlp/setup.c b/arch/mips/netlogic/xlp/setup.c
index 76a7131..8fa1042 100644
--- a/arch/mips/netlogic/xlp/setup.c
+++ b/arch/mips/netlogic/xlp/setup.c
@@ -92,7 +92,6 @@ static void __init xlp_init_mem_from_bars(void)
 
 void __init plat_mem_setup(void)
 {
-	panic_timeout	= 5;
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
 	pm_power_off	= nlm_linux_exit;
diff --git a/arch/mips/netlogic/xlr/setup.c b/arch/mips/netlogic/xlr/setup.c
index 214d123..921be5f 100644
--- a/arch/mips/netlogic/xlr/setup.c
+++ b/arch/mips/netlogic/xlr/setup.c
@@ -92,7 +92,6 @@ static void nlm_linux_exit(void)
 
 void __init plat_mem_setup(void)
 {
-	panic_timeout	= 5;
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
 	pm_power_off	= nlm_linux_exit;
diff --git a/arch/mips/sibyte/swarm/setup.c b/arch/mips/sibyte/swarm/setup.c
index 41707a2..3462c83 100644
--- a/arch/mips/sibyte/swarm/setup.c
+++ b/arch/mips/sibyte/swarm/setup.c
@@ -134,8 +134,6 @@ void __init plat_mem_setup(void)
 #error invalid SiByte board configuration
 #endif
 
-	panic_timeout = 5;  /* For debug.  */
-
 	board_be_handler = swarm_be_handler;
 
 	if (xicor_probe())
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index a4bbcae..6de656a 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -298,9 +298,6 @@ void __init setup_arch(char **cmdline_p)
 	if (cpu_has_feature(CPU_FTR_UNIFIED_ID_CACHE))
 		ucache_bsize = icache_bsize = dcache_bsize;
 
-	/* reboot on panic */
-	panic_timeout = 180;
-
 	if (ppc_md.panic)
 		setup_panic();
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 278ca93..ea7270a1 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -590,9 +590,6 @@ void __init setup_arch(char **cmdline_p)
 	dcache_bsize = ppc64_caches.dline_size;
 	icache_bsize = ppc64_caches.iline_size;
 
-	/* reboot on panic */
-	panic_timeout = 180;
-
 	if (ppc_md.panic)
 		setup_panic();
 
diff --git a/kernel/panic.c b/kernel/panic.c
index b6c482c..b59c0ac 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -33,7 +33,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 
-int panic_timeout;
+int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ebef88f..22b746e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -761,6 +761,18 @@ config PANIC_ON_OOPS_VALUE
 	default 0 if !PANIC_ON_OOPS
 	default 1 if PANIC_ON_OOPS
 
+config PANIC_TIMEOUT
+	int "panic timeout"
+	default 0 if (!PPC && !MIPS)
+	default 180 if PPC
+	default 5 if MIPS
+	help
+	  Set the timeout value (in seconds) until a reboot occurs when the
+	  the kernel panics. If n = 0, then we wait forever. A timeout
+	  value n > 0 will wait n seconds before rebooting, while a timeout
+	  value n < 0 will reboot immediately. Note: some architectures
+	  hard code a value here, which will override this setting.
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.8.2

