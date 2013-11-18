Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3KRVEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:04:40 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:40679 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab3KRVEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:04:37 -0500
To: mingo@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v2] panic: Make panic_timeout configurable
Message-Id: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
Date: Mon, 18 Nov 2013 21:04:36 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic_timeout value can be set via the command line option 'panic=x', or via
/proc/sys/kernel/panic, however that is not sufficient when the panic occurs
before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
so that we can set the desired value from the .config.

The default panic_timeout value continues to be 0 - wait forever, except for
powerpc and mips, which have been defaulted to 180 and 5 respectively. This
is in keeping with the fact that these arches already set panic_timeout in
their arch init code. However, I found three exceptions- two in mips and one in
powerpc where the settings didn't match these default values. In those cases, I
left the arch code so it continues to override, in case the user has not changed
from the default. It would nice if these arches had one default value, or if we
could determine the correct setting at compile-time.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---

-Restrict arch defaults to arch/ code
-add set_arch_panic_timeout(), in case .config specifies a non-default timeout

 arch/mips/Kconfig                      |  4 ++++
 arch/mips/ar7/setup.c                  |  2 +-
 arch/mips/emma/markeins/setup.c        |  2 +-
 arch/mips/include/asm/setup.h          |  2 ++
 arch/mips/netlogic/xlp/setup.c         |  1 -
 arch/mips/netlogic/xlr/setup.c         |  1 -
 arch/mips/sibyte/swarm/setup.c         |  2 --
 arch/powerpc/Kconfig                   |  4 ++++
 arch/powerpc/include/asm/setup.h       |  1 +
 arch/powerpc/kernel/setup_32.c         |  3 ---
 arch/powerpc/kernel/setup_64.c         |  3 ---
 arch/powerpc/platforms/pseries/setup.c |  2 +-
 include/linux/kernel.h                 |  9 +++++++++
 kernel/panic.c                         |  2 +-
 lib/Kconfig.debug                      | 11 +++++++++++
 15 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 650de39..0c21758 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -837,6 +837,10 @@ config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
+config PANIC_TIMEOUT
+	int
+	default 5
+
 #
 # Select some configuration options automatically based on user selections.
 #
diff --git a/arch/mips/ar7/setup.c b/arch/mips/ar7/setup.c
index 9a357ff..46e7abc 100644
--- a/arch/mips/ar7/setup.c
+++ b/arch/mips/ar7/setup.c
@@ -92,7 +92,7 @@ void __init plat_mem_setup(void)
 	_machine_restart = ar7_machine_restart;
 	_machine_halt = ar7_machine_halt;
 	pm_power_off = ar7_machine_power_off;
-	panic_timeout = 3;
+	set_arch_panic_timeout(3, ARCH_PANIC_TIMEOUT);
 
 	io_base = (unsigned long)ioremap(AR7_REGS_BASE, 0x10000);
 	if (!io_base)
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index d710058..03a47a7 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -112,7 +112,7 @@ void __init plat_mem_setup(void)
 	iomem_resource.end = EMMA2RH_ROM_BASE - 1;
 
 	/* Reboot on panic */
-	panic_timeout = 180;
+	set_arch_panic_timeout(180, ARCH_PANIC_TIMEOUT);
 
 	markeins_sio_setup();
 }
diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
index d7bfdeb..9d1b53c 100644
--- a/arch/mips/include/asm/setup.h
+++ b/arch/mips/include/asm/setup.h
@@ -24,4 +24,6 @@ extern unsigned long ebase;
 extern void per_cpu_trap_init(bool);
 extern void cpu_cache_init(void);
 
+#define ARCH_PANIC_TIMEOUT 5
+
 #endif /* __SETUP_H */
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
index 1f97e2b..f5f710a 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -444,7 +444,7 @@ static void pSeries_machine_kexec(struct kimage *image)
 
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
index db25707..e3086d0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -761,6 +761,17 @@ config PANIC_ON_OOPS_VALUE
 	default 0 if !PANIC_ON_OOPS
 	default 1 if PANIC_ON_OOPS
 
+config PANIC_TIMEOUT
+	int "panic timeout"
+	default 0
+	help
+	  Set the timeout value (in seconds) until a reboot occurs when the
+	  the kernel panics. If n = 0, then we wait forever. A timeout
+	  value n > 0 will wait n seconds before rebooting, while a timeout
+	  value n < 0 will reboot immediately. Note: If left at the default
+	  setting, some architectures (mips, powerpc) may override this setting
+	  in early boot.
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.8.2

