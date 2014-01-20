Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaATL2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:28:23 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49648 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaATL2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:28:20 -0500
Date: Mon, 20 Jan 2014 12:28:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/debug changes for v3.14
Message-ID: <20140120112815.GA9337@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-debug-for-linus

   # HEAD: b71d47c14fba6270c0b5a0d56639bf042017025b powerpc: Clean up panic_timeout usage

Currently there are two methods to set the panic_timeout: via 
'panic=X' boot commandline option, or via /proc/sys/kernel/panic.

This tree adds a third panic_timeout configuration method: 
configuration via Kconfig, via CONFIG_PANIC_TIMEOUT=X - useful to 
distros that generally want their kernel defaults to come with the 
.config.

CONFIG_PANIC_TIMEOUT defaults to 0, which was the previous default 
value of panic_timeout.

Doing that unearthed a few arch trickeries regarding arch-special 
panic_timeout values and related complications - hopefully all 
resolved to the satisfaction of everyone.

 Thanks,

	Ingo

------------------>
Jason Baron (2):
      panic: Make panic_timeout configurable
      powerpc: Clean up panic_timeout usage

Ralf Baechle (1):
      MIPS: Remove panic_timeout settings


 arch/mips/ar7/setup.c                  | 1 -
 arch/mips/emma/markeins/setup.c        | 3 ---
 arch/mips/netlogic/xlp/setup.c         | 1 -
 arch/mips/netlogic/xlr/setup.c         | 1 -
 arch/mips/sibyte/swarm/setup.c         | 2 --
 arch/powerpc/Kconfig                   | 4 ++++
 arch/powerpc/include/asm/setup.h       | 1 +
 arch/powerpc/kernel/setup_32.c         | 3 ---
 arch/powerpc/kernel/setup_64.c         | 3 ---
 arch/powerpc/platforms/pseries/setup.c | 2 +-
 include/linux/kernel.h                 | 9 +++++++++
 kernel/panic.c                         | 2 +-
 lib/Kconfig.debug                      | 9 +++++++++
 13 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/mips/ar7/setup.c b/arch/mips/ar7/setup.c
index 9a357ff..820b7a3 100644
--- a/arch/mips/ar7/setup.c
+++ b/arch/mips/ar7/setup.c
@@ -92,7 +92,6 @@ void __init plat_mem_setup(void)
 	_machine_restart = ar7_machine_restart;
 	_machine_halt = ar7_machine_halt;
 	pm_power_off = ar7_machine_power_off;
-	panic_timeout = 3;
 
 	io_base = (unsigned long)ioremap(AR7_REGS_BASE, 0x10000);
 	if (!io_base)
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index d710058..9100122 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -111,9 +111,6 @@ void __init plat_mem_setup(void)
 	iomem_resource.start = EMMA2RH_IO_BASE;
 	iomem_resource.end = EMMA2RH_ROM_BASE - 1;
 
-	/* Reboot on panic */
-	panic_timeout = 180;
-
 	markeins_sio_setup();
 }
 
diff --git a/arch/mips/netlogic/xlp/setup.c b/arch/mips/netlogic/xlp/setup.c
index 6d981bb..54e75c7 100644
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
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d4e98d1..2ac0277 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -393,6 +393,15 @@ extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int sysctl_panic_on_stackoverflow;
+/*
+ * Only to be used by arch init code. If the user over-wrote the default
+ * CONFIG_PANIC_TIMEOUT, honor it.
+ */
+static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
+{
+	if (panic_timeout == arch_default_timeout)
+		panic_timeout = timeout;
+}
 extern const char *print_tainted(void);
 enum lockdep_ok {
 	LOCKDEP_STILL_OK,
diff --git a/kernel/panic.c b/kernel/panic.c
index c00b4ce..6d63003 100644
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
index db25707..6982094 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -761,6 +761,15 @@ config PANIC_ON_OOPS_VALUE
 	default 0 if !PANIC_ON_OOPS
 	default 1 if PANIC_ON_OOPS
 
+config PANIC_TIMEOUT
+	int "panic timeout"
+	default 0
+	help
+	  Set the timeout value (in seconds) until a reboot occurs when the
+	  the kernel panics. If n = 0, then we wait forever. A timeout
+	  value n > 0 will wait n seconds before rebooting, while a timeout
+	  value n < 0 will reboot immediately.
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
