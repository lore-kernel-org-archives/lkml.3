Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733AbaFTHr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:47:28 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41224 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbaFTHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:47:25 -0400
Date: Fri, 20 Jun 2014 09:47:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.16-rc2
Message-ID: <20140620094719.6d9e43de@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062007-2966-0000-0000-00000042E432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

A couple of bug fixes, a debug change for qdio, an update for the
default config, and one small extension.

The watchdog module based on diagnose 0x288 is converted to the
watchdog API and it now works under LPAR as well.

Fabian Frederick (1):
      s390/qdio: replace shift loop by ilog2

Heiko Carstens (1):
      s390: update default configuration

Kees Cook (1):
      s390: avoid format strings leaking into names

Martin Schwidefsky (2):
      s390/uaccess: always load the kernel ASCE after task switch
      s390/compat: correct ucontext layout for high gprs

Michael Veigel (1):
      s390/ap_bus: Make modules parameters visible in sysfs

Peter Oberparleiter (1):
      s390/sclp_vt220: Enable ASCII console per default

Philipp Hachtmann (2):
      s390/watchdog: use watchdog API
      s390/watchdog: add support for LPAR operation (diag288)

Sebastian Ott (6):
      s390/cio: silence lockdep warning
      s390/airq: silence lockdep warning
      s390/cio: set device name as early as possible
      s390/ccwgroup: obtain extra reference for asynchronous processing
      s390/ccwgroup: fix an uninitialized return code
      s390/ccwgroup: use ccwgroup_ungroup wrapper

Stefan Raspl (1):
      qdio: Keep device-specific dbf entries

 arch/s390/configs/default_defconfig     |    5 +-
 arch/s390/configs/gcov_defconfig        |    5 +-
 arch/s390/configs/performance_defconfig |    5 +-
 arch/s390/configs/zfcpdump_defconfig    |    3 +-
 arch/s390/defconfig                     |    8 +-
 arch/s390/include/asm/mmu_context.h     |   33 ++-
 arch/s390/include/asm/switch_to.h       |    4 -
 arch/s390/include/uapi/asm/ucontext.h   |    8 +-
 arch/s390/kernel/compat_linux.h         |    4 +-
 drivers/s390/block/dcssblk.c            |    2 +-
 drivers/s390/char/Makefile              |    1 -
 drivers/s390/char/sclp_vt220.c          |    2 -
 drivers/s390/char/vmlogrdr.c            |    2 +-
 drivers/s390/char/vmwatchdog.c          |  338 -------------------------------
 drivers/s390/cio/airq.c                 |   13 +-
 drivers/s390/cio/ccwgroup.c             |   28 +--
 drivers/s390/cio/cio.c                  |    2 +
 drivers/s390/cio/device.c               |   71 +++----
 drivers/s390/cio/qdio_debug.c           |   79 +++++++-
 drivers/s390/cio/qdio_debug.h           |    2 +-
 drivers/s390/cio/qdio_main.c            |   16 +-
 drivers/s390/crypto/ap_bus.c            |    4 +-
 drivers/s390/crypto/zcrypt_api.c        |    2 +-
 drivers/watchdog/Kconfig                |    7 +-
 drivers/watchdog/Makefile               |    1 +
 drivers/watchdog/diag288_wdt.c          |  316 +++++++++++++++++++++++++++++
 26 files changed, 505 insertions(+), 456 deletions(-)
 delete mode 100644 drivers/s390/char/vmwatchdog.c
 create mode 100644 drivers/watchdog/diag288_wdt.c

diff --git a/arch/s390/configs/default_defconfig b/arch/s390/configs/default_defconfig
index 8df022c..fd09a10 100644
--- a/arch/s390/configs/default_defconfig
+++ b/arch/s390/configs/default_defconfig
@@ -45,7 +45,8 @@ CONFIG_SOLARIS_X86_PARTITION=y
 CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_CFQ_GROUP_IOSCHED=y
 CONFIG_DEFAULT_DEADLINE=y
-CONFIG_MARCH_Z9_109=y
+CONFIG_MARCH_Z196=y
+CONFIG_TUNE_ZEC12=y
 CONFIG_NR_CPUS=256
 CONFIG_PREEMPT=y
 CONFIG_HZ_100=y
@@ -240,7 +241,6 @@ CONFIG_IP_VS_PE_SIP=m
 CONFIG_NF_CONNTRACK_IPV4=m
 # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
 CONFIG_NF_TABLES_IPV4=m
-CONFIG_NFT_REJECT_IPV4=m
 CONFIG_NFT_CHAIN_ROUTE_IPV4=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NF_TABLES_ARP=m
@@ -456,6 +456,7 @@ CONFIG_TN3270_FS=y
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_NOWAYOUT=y
 CONFIG_SOFT_WATCHDOG=m
+CONFIG_DIAG288_WATCHDOG=m
 # CONFIG_HID is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_INFINIBAND=m
diff --git a/arch/s390/configs/gcov_defconfig b/arch/s390/configs/gcov_defconfig
index c81a74e..b061180 100644
--- a/arch/s390/configs/gcov_defconfig
+++ b/arch/s390/configs/gcov_defconfig
@@ -45,7 +45,8 @@ CONFIG_SOLARIS_X86_PARTITION=y
 CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_CFQ_GROUP_IOSCHED=y
 CONFIG_DEFAULT_DEADLINE=y
-CONFIG_MARCH_Z9_109=y
+CONFIG_MARCH_Z196=y
+CONFIG_TUNE_ZEC12=y
 CONFIG_NR_CPUS=256
 CONFIG_HZ_100=y
 CONFIG_MEMORY_HOTPLUG=y
@@ -238,7 +239,6 @@ CONFIG_IP_VS_PE_SIP=m
 CONFIG_NF_CONNTRACK_IPV4=m
 # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
 CONFIG_NF_TABLES_IPV4=m
-CONFIG_NFT_REJECT_IPV4=m
 CONFIG_NFT_CHAIN_ROUTE_IPV4=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NF_TABLES_ARP=m
@@ -453,6 +453,7 @@ CONFIG_TN3270_FS=y
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_NOWAYOUT=y
 CONFIG_SOFT_WATCHDOG=m
+CONFIG_DIAG288_WATCHDOG=m
 # CONFIG_HID is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_INFINIBAND=m
diff --git a/arch/s390/configs/performance_defconfig b/arch/s390/configs/performance_defconfig
index b5ba8fe..d279baa 100644
--- a/arch/s390/configs/performance_defconfig
+++ b/arch/s390/configs/performance_defconfig
@@ -43,7 +43,8 @@ CONFIG_SOLARIS_X86_PARTITION=y
 CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_CFQ_GROUP_IOSCHED=y
 CONFIG_DEFAULT_DEADLINE=y
-CONFIG_MARCH_Z9_109=y
+CONFIG_MARCH_Z196=y
+CONFIG_TUNE_ZEC12=y
 CONFIG_NR_CPUS=256
 CONFIG_HZ_100=y
 CONFIG_MEMORY_HOTPLUG=y
@@ -236,7 +237,6 @@ CONFIG_IP_VS_PE_SIP=m
 CONFIG_NF_CONNTRACK_IPV4=m
 # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
 CONFIG_NF_TABLES_IPV4=m
-CONFIG_NFT_REJECT_IPV4=m
 CONFIG_NFT_CHAIN_ROUTE_IPV4=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NF_TABLES_ARP=m
@@ -451,6 +451,7 @@ CONFIG_TN3270_FS=y
 CONFIG_WATCHDOG=y
 CONFIG_WATCHDOG_NOWAYOUT=y
 CONFIG_SOFT_WATCHDOG=m
+CONFIG_DIAG288_WATCHDOG=m
 # CONFIG_HID is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_INFINIBAND=m
diff --git a/arch/s390/configs/zfcpdump_defconfig b/arch/s390/configs/zfcpdump_defconfig
index cef073c..948e0e0 100644
--- a/arch/s390/configs/zfcpdump_defconfig
+++ b/arch/s390/configs/zfcpdump_defconfig
@@ -8,7 +8,8 @@ CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_IBM_PARTITION=y
 CONFIG_DEFAULT_DEADLINE=y
-CONFIG_MARCH_Z9_109=y
+CONFIG_MARCH_Z196=y
+CONFIG_TUNE_ZEC12=y
 # CONFIG_COMPAT is not set
 CONFIG_NR_CPUS=2
 # CONFIG_HOTPLUG_CPU is not set
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 4557cb7..2e56498 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -135,8 +135,8 @@ CONFIG_PROVE_LOCKING=y
 CONFIG_LOCK_STAT=y
 CONFIG_DEBUG_LOCKDEP=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
-CONFIG_DEBUG_WRITECOUNT=y
 CONFIG_DEBUG_LIST=y
+CONFIG_DEBUG_PI_LIST=y
 CONFIG_DEBUG_SG=y
 CONFIG_DEBUG_NOTIFIERS=y
 CONFIG_PROVE_RCU=y
@@ -199,4 +199,10 @@ CONFIG_CRYPTO_SHA512_S390=m
 CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_AES_S390=m
 CONFIG_CRC7=m
+# CONFIG_XZ_DEC_X86 is not set
+# CONFIG_XZ_DEC_POWERPC is not set
+# CONFIG_XZ_DEC_IA64 is not set
+# CONFIG_XZ_DEC_ARM is not set
+# CONFIG_XZ_DEC_ARMTHUMB is not set
+# CONFIG_XZ_DEC_SPARC is not set
 CONFIG_CMM=m
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index c28f32a..3815bfe 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -33,10 +33,9 @@ static inline int init_new_context(struct task_struct *tsk,
 
 static inline void set_user_asce(struct mm_struct *mm)
 {
-	pgd_t *pgd = mm->pgd;
-
-	S390_lowcore.user_asce = mm->context.asce_bits | __pa(pgd);
-	set_fs(current->thread.mm_segment);
+	S390_lowcore.user_asce = mm->context.asce_bits | __pa(mm->pgd);
+	if (current->thread.mm_segment.ar4)
+		__ctl_load(S390_lowcore.user_asce, 7, 7);
 	set_cpu_flag(CIF_ASCE);
 }
 
@@ -70,12 +69,11 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	/* Clear old ASCE by loading the kernel ASCE. */
 	__ctl_load(S390_lowcore.kernel_asce, 1, 1);
 	__ctl_load(S390_lowcore.kernel_asce, 7, 7);
-	/* Delay loading of the new ASCE to control registers CR1 & CR7 */
-	set_cpu_flag(CIF_ASCE);
 	atomic_inc(&next->context.attach_count);
 	atomic_dec(&prev->context.attach_count);
 	if (MACHINE_HAS_TLB_LC)
 		cpumask_clear_cpu(cpu, &prev->context.cpu_attach_mask);
+	S390_lowcore.user_asce = next->context.asce_bits | __pa(next->pgd);
 }
 
 #define finish_arch_post_lock_switch finish_arch_post_lock_switch
@@ -84,17 +82,18 @@ static inline void finish_arch_post_lock_switch(void)
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
 
-	if (!mm)
-		return;
-	preempt_disable();
-	while (atomic_read(&mm->context.attach_count) >> 16)
-		cpu_relax();
-
-	cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
-	set_user_asce(mm);
-	if (mm->context.flush_mm)
-		__tlb_flush_mm(mm);
-	preempt_enable();
+	load_kernel_asce();
+	if (mm) {
+		preempt_disable();
+		while (atomic_read(&mm->context.attach_count) >> 16)
+			cpu_relax();
+
+		cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
+		if (mm->context.flush_mm)
+			__tlb_flush_mm(mm);
+		preempt_enable();
+	}
+	set_fs(current->thread.mm_segment);
 }
 
 #define enter_lazy_tlb(mm,tsk)	do { } while (0)
diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
index 29c81f8..df38c70 100644
--- a/arch/s390/include/asm/switch_to.h
+++ b/arch/s390/include/asm/switch_to.h
@@ -134,8 +134,4 @@ static inline void restore_access_regs(unsigned int *acrs)
 	prev = __switch_to(prev,next);					\
 } while (0)
 
-#define finish_arch_switch(prev) do {					     \
-	set_fs(current->thread.mm_segment);				     \
-} while (0)
-
 #endif /* __ASM_SWITCH_TO_H */
diff --git a/arch/s390/include/uapi/asm/ucontext.h b/arch/s390/include/uapi/asm/ucontext.h
index 200e063..3e077b2 100644
--- a/arch/s390/include/uapi/asm/ucontext.h
+++ b/arch/s390/include/uapi/asm/ucontext.h
@@ -16,7 +16,9 @@ struct ucontext_extended {
 	struct ucontext  *uc_link;
 	stack_t		  uc_stack;
 	_sigregs	  uc_mcontext;
-	unsigned long	  uc_sigmask[2];
+	sigset_t	  uc_sigmask;
+	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
+	unsigned char	  __unused[128 - sizeof(sigset_t)];
 	unsigned long	  uc_gprs_high[16];
 };
 
@@ -27,7 +29,9 @@ struct ucontext {
 	struct ucontext  *uc_link;
 	stack_t		  uc_stack;
 	_sigregs          uc_mcontext;
-	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+	sigset_t	  uc_sigmask;
+	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
+	unsigned char	  __unused[128 - sizeof(sigset_t)];
 };
 
 #endif /* !_ASM_S390_UCONTEXT_H */
diff --git a/arch/s390/kernel/compat_linux.h b/arch/s390/kernel/compat_linux.h
index 39ddfdb..70d4b7c 100644
--- a/arch/s390/kernel/compat_linux.h
+++ b/arch/s390/kernel/compat_linux.h
@@ -69,7 +69,9 @@ struct ucontext32 {
 	__u32			uc_link;	/* pointer */	
 	compat_stack_t		uc_stack;
 	_sigregs32		uc_mcontext;
-	compat_sigset_t		uc_sigmask;	/* mask last for extensibility */
+	compat_sigset_t		uc_sigmask;
+	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
+	unsigned char		__unused[128 - sizeof(compat_sigset_t)];
 };
 
 struct stat64_emu31;
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index ee0e85a..0f47175 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -593,7 +593,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->start = dcssblk_find_lowest_addr(dev_info);
 	dev_info->end = dcssblk_find_highest_addr(dev_info);
 
-	dev_set_name(&dev_info->dev, dev_info->segment_name);
+	dev_set_name(&dev_info->dev, "%s", dev_info->segment_name);
 	dev_info->dev.release = dcssblk_release_segment;
 	dev_info->dev.groups = dcssblk_dev_attr_groups;
 	INIT_LIST_HEAD(&dev_info->lh);
diff --git a/drivers/s390/char/Makefile b/drivers/s390/char/Makefile
index 629fcc2..78b6ace 100644
--- a/drivers/s390/char/Makefile
+++ b/drivers/s390/char/Makefile
@@ -19,7 +19,6 @@ obj-$(CONFIG_SCLP_VT220_TTY) += sclp_vt220.o
 obj-$(CONFIG_SCLP_CPI) += sclp_cpi.o
 obj-$(CONFIG_SCLP_ASYNC) += sclp_async.o
 
-obj-$(CONFIG_ZVM_WATCHDOG) += vmwatchdog.o
 obj-$(CONFIG_VMLOGRDR) += vmlogrdr.o
 obj-$(CONFIG_VMCP) += vmcp.o
 
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index cd9c919..b9a9f72 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -838,8 +838,6 @@ sclp_vt220_con_init(void)
 {
 	int rc;
 
-	if (!CONSOLE_IS_SCLP)
-		return 0;
 	rc = __sclp_vt220_init(sclp_console_pages);
 	if (rc)
 		return rc;
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index cf31d33..a8848db 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -761,7 +761,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 
 	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
 	if (dev) {
-		dev_set_name(dev, priv->internal_name);
+		dev_set_name(dev, "%s", priv->internal_name);
 		dev->bus = &iucv_bus;
 		dev->parent = iucv_root;
 		dev->driver = &vmlogrdr_driver;
diff --git a/drivers/s390/char/vmwatchdog.c b/drivers/s390/char/vmwatchdog.c
deleted file mode 100644
index d5eac98..0000000
--- a/drivers/s390/char/vmwatchdog.c
+++ /dev/null
@@ -1,338 +0,0 @@
-/*
- * Watchdog implementation based on z/VM Watchdog Timer API
- *
- * Copyright IBM Corp. 2004, 2009
- *
- * The user space watchdog daemon can use this driver as
- * /dev/vmwatchdog to have z/VM execute the specified CP
- * command when the timeout expires. The default command is
- * "IPL", which which cause an immediate reboot.
- */
-#define KMSG_COMPONENT "vmwatchdog"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
-
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/slab.h>
-#include <linux/suspend.h>
-#include <linux/watchdog.h>
-
-#include <asm/ebcdic.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
-#define MAX_CMDLEN 240
-#define MIN_INTERVAL 15
-static char vmwdt_cmd[MAX_CMDLEN] = "IPL";
-static bool vmwdt_conceal;
-
-static bool vmwdt_nowayout = WATCHDOG_NOWAYOUT;
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arnd Bergmann <arndb@de.ibm.com>");
-MODULE_DESCRIPTION("z/VM Watchdog Timer");
-module_param_string(cmd, vmwdt_cmd, MAX_CMDLEN, 0644);
-MODULE_PARM_DESC(cmd, "CP command that is run when the watchdog triggers");
-module_param_named(conceal, vmwdt_conceal, bool, 0644);
-MODULE_PARM_DESC(conceal, "Enable the CONCEAL CP option while the watchdog "
-		" is active");
-module_param_named(nowayout, vmwdt_nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
-		" (default=CONFIG_WATCHDOG_NOWAYOUT)");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
-static unsigned int vmwdt_interval = 60;
-static unsigned long vmwdt_is_open;
-static int vmwdt_expect_close;
-
-static DEFINE_MUTEX(vmwdt_mutex);
-
-#define VMWDT_OPEN	0	/* devnode is open or suspend in progress */
-#define VMWDT_RUNNING	1	/* The watchdog is armed */
-
-enum vmwdt_func {
-	/* function codes */
-	wdt_init   = 0,
-	wdt_change = 1,
-	wdt_cancel = 2,
-	/* flags */
-	wdt_conceal = 0x80000000,
-};
-
-static int __diag288(enum vmwdt_func func, unsigned int timeout,
-			    char *cmd, size_t len)
-{
-	register unsigned long __func asm("2") = func;
-	register unsigned long __timeout asm("3") = timeout;
-	register unsigned long __cmdp asm("4") = virt_to_phys(cmd);
-	register unsigned long __cmdl asm("5") = len;
-	int err;
-
-	err = -EINVAL;
-	asm volatile(
-		"	diag	%1,%3,0x288\n"
-		"0:	la	%0,0\n"
-		"1:\n"
-		EX_TABLE(0b,1b)
-		: "+d" (err) : "d"(__func), "d"(__timeout),
-		  "d"(__cmdp), "d"(__cmdl) : "1", "cc");
-	return err;
-}
-
-static int vmwdt_keepalive(void)
-{
-	/* we allocate new memory every time to avoid having
-	 * to track the state. static allocation is not an
-	 * option since that might not be contiguous in real
-	 * storage in case of a modular build */
-	static char *ebc_cmd;
-	size_t len;
-	int ret;
-	unsigned int func;
-
-	ebc_cmd = kmalloc(MAX_CMDLEN, GFP_KERNEL);
-	if (!ebc_cmd)
-		return -ENOMEM;
-
-	len = strlcpy(ebc_cmd, vmwdt_cmd, MAX_CMDLEN);
-	ASCEBC(ebc_cmd, MAX_CMDLEN);
-	EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
-
-	func = vmwdt_conceal ? (wdt_init | wdt_conceal) : wdt_init;
-	set_bit(VMWDT_RUNNING, &vmwdt_is_open);
-	ret = __diag288(func, vmwdt_interval, ebc_cmd, len);
-	WARN_ON(ret != 0);
-	kfree(ebc_cmd);
-	return ret;
-}
-
-static int vmwdt_disable(void)
-{
-	char cmd[] = {'\0'};
-	int ret = __diag288(wdt_cancel, 0, cmd, 0);
-	WARN_ON(ret != 0);
-	clear_bit(VMWDT_RUNNING, &vmwdt_is_open);
-	return ret;
-}
-
-static int __init vmwdt_probe(void)
-{
-	/* there is no real way to see if the watchdog is supported,
-	 * so we try initializing it with a NOP command ("BEGIN")
-	 * that won't cause any harm even if the following disable
-	 * fails for some reason */
-	char ebc_begin[] = {
-		194, 197, 199, 201, 213
-	};
-	if (__diag288(wdt_init, 15, ebc_begin, sizeof(ebc_begin)) != 0)
-		return -EINVAL;
-	return vmwdt_disable();
-}
-
-static int vmwdt_open(struct inode *i, struct file *f)
-{
-	int ret;
-	if (test_and_set_bit(VMWDT_OPEN, &vmwdt_is_open))
-		return -EBUSY;
-	ret = vmwdt_keepalive();
-	if (ret)
-		clear_bit(VMWDT_OPEN, &vmwdt_is_open);
-	return ret ? ret : nonseekable_open(i, f);
-}
-
-static int vmwdt_close(struct inode *i, struct file *f)
-{
-	if (vmwdt_expect_close == 42)
-		vmwdt_disable();
-	vmwdt_expect_close = 0;
-	clear_bit(VMWDT_OPEN, &vmwdt_is_open);
-	return 0;
-}
-
-static struct watchdog_info vmwdt_info = {
-	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
-	.firmware_version = 0,
-	.identity = "z/VM Watchdog Timer",
-};
-
-static int __vmwdt_ioctl(unsigned int cmd, unsigned long arg)
-{
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user((void __user *)arg, &vmwdt_info,
-					sizeof(vmwdt_info)))
-			return -EFAULT;
-		return 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, (int __user *)arg);
-	case WDIOC_GETTEMP:
-		return -EINVAL;
-	case WDIOC_SETOPTIONS:
-		{
-			int options, ret;
-			if (get_user(options, (int __user *)arg))
-				return -EFAULT;
-			ret = -EINVAL;
-			if (options & WDIOS_DISABLECARD) {
-				ret = vmwdt_disable();
-				if (ret)
-					return ret;
-			}
-			if (options & WDIOS_ENABLECARD) {
-				ret = vmwdt_keepalive();
-			}
-			return ret;
-		}
-	case WDIOC_GETTIMEOUT:
-		return put_user(vmwdt_interval, (int __user *)arg);
-	case WDIOC_SETTIMEOUT:
-		{
-			int interval;
-			if (get_user(interval, (int __user *)arg))
-				return -EFAULT;
-			if (interval < MIN_INTERVAL)
-				return -EINVAL;
-			vmwdt_interval = interval;
-		}
-		return vmwdt_keepalive();
-	case WDIOC_KEEPALIVE:
-		return vmwdt_keepalive();
-	}
-	return -EINVAL;
-}
-
-static long vmwdt_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
-{
-	int rc;
-
-	mutex_lock(&vmwdt_mutex);
-	rc = __vmwdt_ioctl(cmd, arg);
-	mutex_unlock(&vmwdt_mutex);
-	return (long) rc;
-}
-
-static ssize_t vmwdt_write(struct file *f, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	if(count) {
-		if (!vmwdt_nowayout) {
-			size_t i;
-
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
-			vmwdt_expect_close = 0;
-
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, buf+i))
-					return -EFAULT;
-				if (c == 'V')
-					vmwdt_expect_close = 42;
-			}
-		}
-		/* someone wrote to us, we should restart timer */
-		vmwdt_keepalive();
-	}
-	return count;
-}
-
-static int vmwdt_resume(void)
-{
-	clear_bit(VMWDT_OPEN, &vmwdt_is_open);
-	return NOTIFY_DONE;
-}
-
-/*
- * It makes no sense to go into suspend while the watchdog is running.
- * Depending on the memory size, the watchdog might trigger, while we
- * are still saving the memory.
- * We reuse the open flag to ensure that suspend and watchdog open are
- * exclusive operations
- */
-static int vmwdt_suspend(void)
-{
-	if (test_and_set_bit(VMWDT_OPEN, &vmwdt_is_open)) {
-		pr_err("The system cannot be suspended while the watchdog"
-			" is in use\n");
-		return notifier_from_errno(-EBUSY);
-	}
-	if (test_bit(VMWDT_RUNNING, &vmwdt_is_open)) {
-		clear_bit(VMWDT_OPEN, &vmwdt_is_open);
-		pr_err("The system cannot be suspended while the watchdog"
-			" is running\n");
-		return notifier_from_errno(-EBUSY);
-	}
-	return NOTIFY_DONE;
-}
-
-/*
- * This function is called for suspend and resume.
- */
-static int vmwdt_power_event(struct notifier_block *this, unsigned long event,
-			     void *ptr)
-{
-	switch (event) {
-	case PM_POST_HIBERNATION:
-	case PM_POST_SUSPEND:
-		return vmwdt_resume();
-	case PM_HIBERNATION_PREPARE:
-	case PM_SUSPEND_PREPARE:
-		return vmwdt_suspend();
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
-static struct notifier_block vmwdt_power_notifier = {
-	.notifier_call = vmwdt_power_event,
-};
-
-static const struct file_operations vmwdt_fops = {
-	.open    = &vmwdt_open,
-	.release = &vmwdt_close,
-	.unlocked_ioctl = &vmwdt_ioctl,
-	.write   = &vmwdt_write,
-	.owner   = THIS_MODULE,
-	.llseek  = noop_llseek,
-};
-
-static struct miscdevice vmwdt_dev = {
-	.minor      = WATCHDOG_MINOR,
-	.name       = "watchdog",
-	.fops       = &vmwdt_fops,
-};
-
-static int __init vmwdt_init(void)
-{
-	int ret;
-
-	ret = vmwdt_probe();
-	if (ret)
-		return ret;
-	ret = register_pm_notifier(&vmwdt_power_notifier);
-	if (ret)
-		return ret;
-	/*
-	 * misc_register() has to be the last action in module_init(), because
-	 * file operations will be available right after this.
-	 */
-	ret = misc_register(&vmwdt_dev);
-	if (ret) {
-		unregister_pm_notifier(&vmwdt_power_notifier);
-		return ret;
-	}
-	return 0;
-}
-module_init(vmwdt_init);
-
-static void __exit vmwdt_exit(void)
-{
-	unregister_pm_notifier(&vmwdt_power_notifier);
-	misc_deregister(&vmwdt_dev);
-}
-module_exit(vmwdt_exit);
diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
index 445564c..00bfbee 100644
--- a/drivers/s390/cio/airq.c
+++ b/drivers/s390/cio/airq.c
@@ -196,11 +196,11 @@ EXPORT_SYMBOL(airq_iv_release);
  */
 unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num)
 {
-	unsigned long bit, i;
+	unsigned long bit, i, flags;
 
 	if (!iv->avail || num == 0)
 		return -1UL;
-	spin_lock(&iv->lock);
+	spin_lock_irqsave(&iv->lock, flags);
 	bit = find_first_bit_inv(iv->avail, iv->bits);
 	while (bit + num <= iv->bits) {
 		for (i = 1; i < num; i++)
@@ -218,9 +218,8 @@ unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num)
 	}
 	if (bit + num > iv->bits)
 		bit = -1UL;
-	spin_unlock(&iv->lock);
+	spin_unlock_irqrestore(&iv->lock, flags);
 	return bit;
-
 }
 EXPORT_SYMBOL(airq_iv_alloc);
 
@@ -232,11 +231,11 @@ EXPORT_SYMBOL(airq_iv_alloc);
  */
 void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned long num)
 {
-	unsigned long i;
+	unsigned long i, flags;
 
 	if (!iv->avail || num == 0)
 		return;
-	spin_lock(&iv->lock);
+	spin_lock_irqsave(&iv->lock, flags);
 	for (i = 0; i < num; i++) {
 		/* Clear (possibly left over) interrupt bit */
 		clear_bit_inv(bit + i, iv->vector);
@@ -248,7 +247,7 @@ void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned long num)
 		while (iv->end > 0 && !test_bit_inv(iv->end - 1, iv->avail))
 			iv->end--;
 	}
-	spin_unlock(&iv->lock);
+	spin_unlock_irqrestore(&iv->lock, flags);
 }
 EXPORT_SYMBOL(airq_iv_free);
 
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index dfd7bc6..e443b0d 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -184,7 +184,7 @@ static ssize_t ccwgroup_ungroup_store(struct device *dev,
 				      const char *buf, size_t count)
 {
 	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
-	int rc;
+	int rc = 0;
 
 	/* Prevent concurrent online/offline processing and ungrouping. */
 	if (atomic_cmpxchg(&gdev->onoff, 0, 1) != 0)
@@ -196,11 +196,12 @@ static ssize_t ccwgroup_ungroup_store(struct device *dev,
 
 	if (device_remove_file_self(dev, attr))
 		ccwgroup_ungroup(gdev);
+	else
+		rc = -ENODEV;
 out:
 	if (rc) {
-		if (rc != -EAGAIN)
-			/* Release onoff "lock" when ungrouping failed. */
-			atomic_set(&gdev->onoff, 0);
+		/* Release onoff "lock" when ungrouping failed. */
+		atomic_set(&gdev->onoff, 0);
 		return rc;
 	}
 	return count;
@@ -227,6 +228,7 @@ static void ccwgroup_ungroup_workfn(struct work_struct *work)
 		container_of(work, struct ccwgroup_device, ungroup_work);
 
 	ccwgroup_ungroup(gdev);
+	put_device(&gdev->dev);
 }
 
 static void ccwgroup_release(struct device *dev)
@@ -412,8 +414,10 @@ static int ccwgroup_notifier(struct notifier_block *nb, unsigned long action,
 {
 	struct ccwgroup_device *gdev = to_ccwgroupdev(data);
 
-	if (action == BUS_NOTIFY_UNBIND_DRIVER)
+	if (action == BUS_NOTIFY_UNBIND_DRIVER) {
+		get_device(&gdev->dev);
 		schedule_work(&gdev->ungroup_work);
+	}
 
 	return NOTIFY_OK;
 }
@@ -582,11 +586,7 @@ void ccwgroup_driver_unregister(struct ccwgroup_driver *cdriver)
 					 __ccwgroup_match_all))) {
 		struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
 
-		mutex_lock(&gdev->reg_mutex);
-		__ccwgroup_remove_symlinks(gdev);
-		device_unregister(dev);
-		__ccwgroup_remove_cdev_refs(gdev);
-		mutex_unlock(&gdev->reg_mutex);
+		ccwgroup_ungroup(gdev);
 		put_device(dev);
 	}
 	driver_unregister(&cdriver->driver);
@@ -633,13 +633,7 @@ void ccwgroup_remove_ccwdev(struct ccw_device *cdev)
 	get_device(&gdev->dev);
 	spin_unlock_irq(cdev->ccwlock);
 	/* Unregister group device. */
-	mutex_lock(&gdev->reg_mutex);
-	if (device_is_registered(&gdev->dev)) {
-		__ccwgroup_remove_symlinks(gdev);
-		device_unregister(&gdev->dev);
-		__ccwgroup_remove_cdev_refs(gdev);
-	}
-	mutex_unlock(&gdev->reg_mutex);
+	ccwgroup_ungroup(gdev);
 	/* Release ccwgroup device reference for local processing. */
 	put_device(&gdev->dev);
 }
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 77f9c92d..2905d8b 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -602,6 +602,7 @@ void __init init_cio_interrupts(void)
 
 #ifdef CONFIG_CCW_CONSOLE
 static struct subchannel *console_sch;
+static struct lock_class_key console_sch_key;
 
 /*
  * Use cio_tsch to update the subchannel status and call the interrupt handler
@@ -686,6 +687,7 @@ struct subchannel *cio_probe_console(void)
 	if (IS_ERR(sch))
 		return sch;
 
+	lockdep_set_class(sch->lock, &console_sch_key);
 	isc_register(CONSOLE_ISC);
 	sch->config.isc = CONSOLE_ISC;
 	sch->config.intparm = (u32)(addr_t)sch;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index d8d9b5b..dfef5e6 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -678,18 +678,11 @@ static const struct attribute_group *ccwdev_attr_groups[] = {
 	NULL,
 };
 
-/* this is a simple abstraction for device_register that sets the
- * correct bus type and adds the bus specific files */
-static int ccw_device_register(struct ccw_device *cdev)
+static int ccw_device_add(struct ccw_device *cdev)
 {
 	struct device *dev = &cdev->dev;
-	int ret;
 
 	dev->bus = &ccw_bus_type;
-	ret = dev_set_name(&cdev->dev, "0.%x.%04x", cdev->private->dev_id.ssid,
-			   cdev->private->dev_id.devno);
-	if (ret)
-		return ret;
 	return device_add(dev);
 }
 
@@ -764,22 +757,46 @@ static void ccw_device_todo(struct work_struct *work);
 static int io_subchannel_initialize_dev(struct subchannel *sch,
 					struct ccw_device *cdev)
 {
-	cdev->private->cdev = cdev;
-	cdev->private->int_class = IRQIO_CIO;
-	atomic_set(&cdev->private->onoff, 0);
+	struct ccw_device_private *priv = cdev->private;
+	int ret;
+
+	priv->cdev = cdev;
+	priv->int_class = IRQIO_CIO;
+	priv->state = DEV_STATE_NOT_OPER;
+	priv->dev_id.devno = sch->schib.pmcw.dev;
+	priv->dev_id.ssid = sch->schid.ssid;
+	priv->schid = sch->schid;
+
+	INIT_WORK(&priv->todo_work, ccw_device_todo);
+	INIT_LIST_HEAD(&priv->cmb_list);
+	init_waitqueue_head(&priv->wait_q);
+	init_timer(&priv->timer);
+
+	atomic_set(&priv->onoff, 0);
+	cdev->ccwlock = sch->lock;
 	cdev->dev.parent = &sch->dev;
 	cdev->dev.release = ccw_device_release;
-	INIT_WORK(&cdev->private->todo_work, ccw_device_todo);
 	cdev->dev.groups = ccwdev_attr_groups;
 	/* Do first half of device_register. */
 	device_initialize(&cdev->dev);
+	ret = dev_set_name(&cdev->dev, "0.%x.%04x", cdev->private->dev_id.ssid,
+			   cdev->private->dev_id.devno);
+	if (ret)
+		goto out_put;
 	if (!get_device(&sch->dev)) {
-		/* Release reference from device_initialize(). */
-		put_device(&cdev->dev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_put;
 	}
-	cdev->private->flags.initialized = 1;
+	priv->flags.initialized = 1;
+	spin_lock_irq(sch->lock);
+	sch_set_cdev(sch, cdev);
+	spin_unlock_irq(sch->lock);
 	return 0;
+
+out_put:
+	/* Release reference from device_initialize(). */
+	put_device(&cdev->dev);
+	return ret;
 }
 
 static struct ccw_device * io_subchannel_create_ccwdev(struct subchannel *sch)
@@ -858,7 +875,7 @@ static void io_subchannel_register(struct ccw_device *cdev)
 	dev_set_uevent_suppress(&sch->dev, 0);
 	kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 	/* make it known to the system */
-	ret = ccw_device_register(cdev);
+	ret = ccw_device_add(cdev);
 	if (ret) {
 		CIO_MSG_EVENT(0, "Could not register ccw dev 0.%x.%04x: %d\n",
 			      cdev->private->dev_id.ssid,
@@ -923,26 +940,11 @@ io_subchannel_recog_done(struct ccw_device *cdev)
 
 static void io_subchannel_recog(struct ccw_device *cdev, struct subchannel *sch)
 {
-	struct ccw_device_private *priv;
-
-	cdev->ccwlock = sch->lock;
-
-	/* Init private data. */
-	priv = cdev->private;
-	priv->dev_id.devno = sch->schib.pmcw.dev;
-	priv->dev_id.ssid = sch->schid.ssid;
-	priv->schid = sch->schid;
-	priv->state = DEV_STATE_NOT_OPER;
-	INIT_LIST_HEAD(&priv->cmb_list);
-	init_waitqueue_head(&priv->wait_q);
-	init_timer(&priv->timer);
-
 	/* Increase counter of devices currently in recognition. */
 	atomic_inc(&ccw_device_init_count);
 
 	/* Start async. device sensing. */
 	spin_lock_irq(sch->lock);
-	sch_set_cdev(sch, cdev);
 	ccw_device_recognition(cdev);
 	spin_unlock_irq(sch->lock);
 }
@@ -1083,7 +1085,7 @@ static int io_subchannel_probe(struct subchannel *sch)
 		dev_set_uevent_suppress(&sch->dev, 0);
 		kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 		cdev = sch_get_cdev(sch);
-		rc = ccw_device_register(cdev);
+		rc = ccw_device_add(cdev);
 		if (rc) {
 			/* Release online reference. */
 			put_device(&cdev->dev);
@@ -1597,7 +1599,6 @@ int __init ccw_device_enable_console(struct ccw_device *cdev)
 	if (rc)
 		return rc;
 	sch->driver = &io_subchannel_driver;
-	sch_set_cdev(sch, cdev);
 	io_subchannel_recog(cdev, sch);
 	/* Now wait for the async. recognition to come to an end. */
 	spin_lock_irq(cdev->ccwlock);
@@ -1639,6 +1640,7 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
 		put_device(&sch->dev);
 		return ERR_PTR(-ENOMEM);
 	}
+	set_io_private(sch, io_priv);
 	cdev = io_subchannel_create_ccwdev(sch);
 	if (IS_ERR(cdev)) {
 		put_device(&sch->dev);
@@ -1646,7 +1648,6 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
 		return cdev;
 	}
 	cdev->drv = drv;
-	set_io_private(sch, io_priv);
 	ccw_device_set_int_class(cdev);
 	return cdev;
 }
diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index 4221b02..f1f3baa 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -7,6 +7,7 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/slab.h>
 #include <asm/debug.h>
 #include "qdio_debug.h"
 #include "qdio.h"
@@ -16,11 +17,51 @@ debug_info_t *qdio_dbf_error;
 
 static struct dentry *debugfs_root;
 #define QDIO_DEBUGFS_NAME_LEN	10
+#define QDIO_DBF_NAME_LEN	20
 
-void qdio_allocate_dbf(struct qdio_initialize *init_data,
+struct qdio_dbf_entry {
+	char dbf_name[QDIO_DBF_NAME_LEN];
+	debug_info_t *dbf_info;
+	struct list_head dbf_list;
+};
+
+static LIST_HEAD(qdio_dbf_list);
+static DEFINE_MUTEX(qdio_dbf_list_mutex);
+
+static debug_info_t *qdio_get_dbf_entry(char *name)
+{
+	struct qdio_dbf_entry *entry;
+	debug_info_t *rc = NULL;
+
+	mutex_lock(&qdio_dbf_list_mutex);
+	list_for_each_entry(entry, &qdio_dbf_list, dbf_list) {
+		if (strcmp(entry->dbf_name, name) == 0) {
+			rc = entry->dbf_info;
+			break;
+		}
+	}
+	mutex_unlock(&qdio_dbf_list_mutex);
+	return rc;
+}
+
+static void qdio_clear_dbf_list(void)
+{
+	struct qdio_dbf_entry *entry, *tmp;
+
+	mutex_lock(&qdio_dbf_list_mutex);
+	list_for_each_entry_safe(entry, tmp, &qdio_dbf_list, dbf_list) {
+		list_del(&entry->dbf_list);
+		debug_unregister(entry->dbf_info);
+		kfree(entry);
+	}
+	mutex_unlock(&qdio_dbf_list_mutex);
+}
+
+int qdio_allocate_dbf(struct qdio_initialize *init_data,
 		       struct qdio_irq *irq_ptr)
 {
-	char text[20];
+	char text[QDIO_DBF_NAME_LEN];
+	struct qdio_dbf_entry *new_entry;
 
 	DBF_EVENT("qfmt:%1d", init_data->q_format);
 	DBF_HEX(init_data->adapter_name, 8);
@@ -38,11 +79,34 @@ void qdio_allocate_dbf(struct qdio_initialize *init_data,
 	DBF_EVENT("irq:%8lx", (unsigned long)irq_ptr);
 
 	/* allocate trace view for the interface */
-	snprintf(text, 20, "qdio_%s", dev_name(&init_data->cdev->dev));
-	irq_ptr->debug_area = debug_register(text, 2, 1, 16);
-	debug_register_view(irq_ptr->debug_area, &debug_hex_ascii_view);
-	debug_set_level(irq_ptr->debug_area, DBF_WARN);
-	DBF_DEV_EVENT(DBF_ERR, irq_ptr, "dbf created");
+	snprintf(text, QDIO_DBF_NAME_LEN, "qdio_%s",
+					dev_name(&init_data->cdev->dev));
+	irq_ptr->debug_area = qdio_get_dbf_entry(text);
+	if (irq_ptr->debug_area)
+		DBF_DEV_EVENT(DBF_ERR, irq_ptr, "dbf reused");
+	else {
+		irq_ptr->debug_area = debug_register(text, 2, 1, 16);
+		if (!irq_ptr->debug_area)
+			return -ENOMEM;
+		if (debug_register_view(irq_ptr->debug_area,
+						&debug_hex_ascii_view)) {
+			debug_unregister(irq_ptr->debug_area);
+			return -ENOMEM;
+		}
+		debug_set_level(irq_ptr->debug_area, DBF_WARN);
+		DBF_DEV_EVENT(DBF_ERR, irq_ptr, "dbf created");
+		new_entry = kzalloc(sizeof(struct qdio_dbf_entry), GFP_KERNEL);
+		if (!new_entry) {
+			debug_unregister(irq_ptr->debug_area);
+			return -ENOMEM;
+		}
+		strlcpy(new_entry->dbf_name, text, QDIO_DBF_NAME_LEN);
+		new_entry->dbf_info = irq_ptr->debug_area;
+		mutex_lock(&qdio_dbf_list_mutex);
+		list_add(&new_entry->dbf_list, &qdio_dbf_list);
+		mutex_unlock(&qdio_dbf_list_mutex);
+	}
+	return 0;
 }
 
 static int qstat_show(struct seq_file *m, void *v)
@@ -300,6 +364,7 @@ int __init qdio_debug_init(void)
 
 void qdio_debug_exit(void)
 {
+	qdio_clear_dbf_list();
 	debugfs_remove(debugfs_root);
 	if (qdio_dbf_setup)
 		debug_unregister(qdio_dbf_setup);
diff --git a/drivers/s390/cio/qdio_debug.h b/drivers/s390/cio/qdio_debug.h
index dfac9bf..f33ce85 100644
--- a/drivers/s390/cio/qdio_debug.h
+++ b/drivers/s390/cio/qdio_debug.h
@@ -75,7 +75,7 @@ static inline void DBF_DEV_HEX(struct qdio_irq *dev, void *addr,
 	}
 }
 
-void qdio_allocate_dbf(struct qdio_initialize *init_data,
+int qdio_allocate_dbf(struct qdio_initialize *init_data,
 		       struct qdio_irq *irq_ptr);
 void qdio_setup_debug_entries(struct qdio_irq *irq_ptr,
 			      struct ccw_device *cdev);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 77466c4..848e3b6 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -409,17 +409,16 @@ static inline void qdio_stop_polling(struct qdio_q *q)
 		set_buf_state(q, q->u.in.ack_start, SLSB_P_INPUT_NOT_INIT);
 }
 
-static inline void account_sbals(struct qdio_q *q, int count)
+static inline void account_sbals(struct qdio_q *q, unsigned int count)
 {
-	int pos = 0;
+	int pos;
 
 	q->q_stats.nr_sbal_total += count;
 	if (count == QDIO_MAX_BUFFERS_MASK) {
 		q->q_stats.nr_sbals[7]++;
 		return;
 	}
-	while (count >>= 1)
-		pos++;
+	pos = ilog2(count);
 	q->q_stats.nr_sbals[pos]++;
 }
 
@@ -1234,12 +1233,10 @@ int qdio_free(struct ccw_device *cdev)
 		return -ENODEV;
 
 	DBF_EVENT("qfree:%4x", cdev->private->schid.sch_no);
+	DBF_DEV_EVENT(DBF_ERR, irq_ptr, "dbf abandoned");
 	mutex_lock(&irq_ptr->setup_mutex);
 
-	if (irq_ptr->debug_area != NULL) {
-		debug_unregister(irq_ptr->debug_area);
-		irq_ptr->debug_area = NULL;
-	}
+	irq_ptr->debug_area = NULL;
 	cdev->private->qdio_data = NULL;
 	mutex_unlock(&irq_ptr->setup_mutex);
 
@@ -1276,7 +1273,8 @@ int qdio_allocate(struct qdio_initialize *init_data)
 		goto out_err;
 
 	mutex_init(&irq_ptr->setup_mutex);
-	qdio_allocate_dbf(init_data, irq_ptr);
+	if (qdio_allocate_dbf(init_data, irq_ptr))
+		goto out_rel;
 
 	/*
 	 * Allocate a page for the chsc calls in qdio_establish.
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 8eec165..69ef4f8 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -77,12 +77,12 @@ MODULE_ALIAS("z90crypt");
  * Module parameter
  */
 int ap_domain_index = -1;	/* Adjunct Processor Domain Index */
-module_param_named(domain, ap_domain_index, int, 0000);
+module_param_named(domain, ap_domain_index, int, S_IRUSR|S_IRGRP);
 MODULE_PARM_DESC(domain, "domain index for ap devices");
 EXPORT_SYMBOL(ap_domain_index);
 
 static int ap_thread_flag = 0;
-module_param_named(poll_thread, ap_thread_flag, int, 0000);
+module_param_named(poll_thread, ap_thread_flag, int, S_IRUSR|S_IRGRP);
 MODULE_PARM_DESC(poll_thread, "Turn on/off poll thread, default is 0 (off).");
 
 static struct device *ap_root_device = NULL;
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 5222ebe..0e18c5d 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -356,7 +356,7 @@ struct zcrypt_ops *zcrypt_msgtype_request(unsigned char *name, int variant)
 
 	zops = __ops_lookup(name, variant);
 	if (!zops) {
-		request_module(name);
+		request_module("%s", name);
 		zops = __ops_lookup(name, variant);
 	}
 	if ((!zops) || (!try_module_get(zops->owner)))
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 74ec8fc..ac1f1de 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1295,14 +1295,17 @@ config WATCHDOG_RTAS
 
 # S390 Architecture
 
-config ZVM_WATCHDOG
-	tristate "z/VM Watchdog Timer"
+config DIAG288_WATCHDOG
+	tristate "System z diag288 Watchdog"
 	depends on S390
+	select WATCHDOG_CORE
 	help
 	  IBM s/390 and zSeries machines running under z/VM 5.1 or later
 	  provide a virtual watchdog timer to their guest that cause a
 	  user define Control Program command to be executed after a
 	  timeout.
+	  LPAR provides a very similar interface. This driver handles
+	  both.
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called vmwatchdog.
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 1b5f3d5..5a7fb1f 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -154,6 +154,7 @@ obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
 obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
 
 # S390 Architecture
+obj-$(CONFIG_DIAG288_WATCHDOG) += diag288_wdt.o
 
 # SUPERH (sh + sh64) Architecture
 obj-$(CONFIG_SH_WDT) += shwdt.o
diff --git a/drivers/watchdog/diag288_wdt.c b/drivers/watchdog/diag288_wdt.c
new file mode 100644
index 0000000..429494b
--- /dev/null
+++ b/drivers/watchdog/diag288_wdt.c
@@ -0,0 +1,316 @@
+/*
+ * Watchdog driver for z/VM and LPAR using the diag 288 interface.
+ *
+ * Under z/VM, expiration of the watchdog will send a "system restart" command
+ * to CP.
+ *
+ * The command can be altered using the module parameter "cmd". This is
+ * not recommended because it's only supported on z/VM but not whith LPAR.
+ *
+ * On LPAR, the watchdog will always trigger a system restart. the module
+ * paramter cmd is meaningless here.
+ *
+ *
+ * Copyright IBM Corp. 2004, 2013
+ * Author(s): Arnd Bergmann (arndb@de.ibm.com)
+ *	      Philipp Hachtmann (phacht@de.ibm.com)
+ *
+ */
+
+#define KMSG_COMPONENT "diag288_wdt"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/suspend.h>
+#include <asm/ebcdic.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#define MAX_CMDLEN 240
+#define DEFAULT_CMD "SYSTEM RESTART"
+
+#define MIN_INTERVAL 15     /* Minimal time supported by diag88 */
+#define MAX_INTERVAL 3600   /* One hour should be enough - pure estimation */
+
+#define WDT_DEFAULT_TIMEOUT 30
+
+/* Function codes - init, change, cancel */
+#define WDT_FUNC_INIT 0
+#define WDT_FUNC_CHANGE 1
+#define WDT_FUNC_CANCEL 2
+#define WDT_FUNC_CONCEAL 0x80000000
+
+/* Action codes for LPAR watchdog */
+#define LPARWDT_RESTART 0
+
+static char wdt_cmd[MAX_CMDLEN] = DEFAULT_CMD;
+static bool conceal_on;
+static bool nowayout_info = WATCHDOG_NOWAYOUT;
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arnd Bergmann <arndb@de.ibm.com>");
+MODULE_AUTHOR("Philipp Hachtmann <phacht@de.ibm.com>");
+
+MODULE_DESCRIPTION("System z diag288  Watchdog Timer");
+
+module_param_string(cmd, wdt_cmd, MAX_CMDLEN, 0644);
+MODULE_PARM_DESC(cmd, "CP command that is run when the watchdog triggers (z/VM only)");
+
+module_param_named(conceal, conceal_on, bool, 0644);
+MODULE_PARM_DESC(conceal, "Enable the CONCEAL CP option while the watchdog is active (z/VM only)");
+
+module_param_named(nowayout, nowayout_info, bool, 0444);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default = CONFIG_WATCHDOG_NOWAYOUT)");
+
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("vmwatchdog");
+
+static int __diag288(unsigned int func, unsigned int timeout,
+		     unsigned long action, unsigned int len)
+{
+	register unsigned long __func asm("2") = func;
+	register unsigned long __timeout asm("3") = timeout;
+	register unsigned long __action asm("4") = action;
+	register unsigned long __len asm("5") = len;
+	int err;
+
+	err = -EINVAL;
+	asm volatile(
+		"	diag	%1, %3, 0x288\n"
+		"0:	la	%0, 0\n"
+		"1:\n"
+		EX_TABLE(0b, 1b)
+		: "+d" (err) : "d"(__func), "d"(__timeout),
+		  "d"(__action), "d"(__len) : "1", "cc");
+	return err;
+}
+
+static int __diag288_vm(unsigned int  func, unsigned int timeout,
+			char *cmd, size_t len)
+{
+	return __diag288(func, timeout, virt_to_phys(cmd), len);
+}
+
+static int __diag288_lpar(unsigned int func, unsigned int timeout,
+			  unsigned long action)
+{
+	return __diag288(func, timeout, action, 0);
+}
+
+static int wdt_start(struct watchdog_device *dev)
+{
+	char *ebc_cmd;
+	size_t len;
+	int ret;
+	unsigned int func;
+
+	ret = -ENODEV;
+
+	if (MACHINE_IS_VM) {
+		ebc_cmd = kmalloc(MAX_CMDLEN, GFP_KERNEL);
+		if (!ebc_cmd)
+			return -ENOMEM;
+		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		ASCEBC(ebc_cmd, MAX_CMDLEN);
+		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
+
+		func = conceal_on ? (WDT_FUNC_INIT | WDT_FUNC_CONCEAL)
+			: WDT_FUNC_INIT;
+		ret = __diag288_vm(func, dev->timeout, ebc_cmd, len);
+		WARN_ON(ret != 0);
+		kfree(ebc_cmd);
+	}
+
+	if (MACHINE_IS_LPAR) {
+		ret = __diag288_lpar(WDT_FUNC_INIT,
+				     dev->timeout, LPARWDT_RESTART);
+	}
+
+	if (ret) {
+		pr_err("The watchdog cannot be activated\n");
+		return ret;
+	}
+	pr_info("The watchdog was activated\n");
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *dev)
+{
+	int ret;
+
+	ret = __diag288(WDT_FUNC_CANCEL, 0, 0, 0);
+	pr_info("The watchdog was deactivated\n");
+	return ret;
+}
+
+static int wdt_ping(struct watchdog_device *dev)
+{
+	char *ebc_cmd;
+	size_t len;
+	int ret;
+	unsigned int func;
+
+	ret = -ENODEV;
+
+	if (MACHINE_IS_VM) {
+		ebc_cmd = kmalloc(MAX_CMDLEN, GFP_KERNEL);
+		if (!ebc_cmd)
+			return -ENOMEM;
+		len = strlcpy(ebc_cmd, wdt_cmd, MAX_CMDLEN);
+		ASCEBC(ebc_cmd, MAX_CMDLEN);
+		EBC_TOUPPER(ebc_cmd, MAX_CMDLEN);
+
+		/*
+		 * It seems to be ok to z/VM to use the init function to
+		 * retrigger the watchdog. On LPAR WDT_FUNC_CHANGE must
+		 * be used when the watchdog is running.
+		 */
+		func = conceal_on ? (WDT_FUNC_INIT | WDT_FUNC_CONCEAL)
+			: WDT_FUNC_INIT;
+
+		ret = __diag288_vm(func, dev->timeout, ebc_cmd, len);
+		WARN_ON(ret != 0);
+		kfree(ebc_cmd);
+	}
+
+	if (MACHINE_IS_LPAR)
+		ret = __diag288_lpar(WDT_FUNC_CHANGE, dev->timeout, 0);
+
+	if (ret)
+		pr_err("The watchdog timer cannot be started or reset\n");
+	return ret;
+}
+
+static int wdt_set_timeout(struct watchdog_device * dev, unsigned int new_to)
+{
+	dev->timeout = new_to;
+	return wdt_ping(dev);
+}
+
+static struct watchdog_ops wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = wdt_start,
+	.stop = wdt_stop,
+	.ping = wdt_ping,
+	.set_timeout = wdt_set_timeout,
+};
+
+static struct watchdog_info wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	.firmware_version = 0,
+	.identity = "z Watchdog",
+};
+
+static struct watchdog_device wdt_dev = {
+	.parent = NULL,
+	.info = &wdt_info,
+	.ops = &wdt_ops,
+	.bootstatus = 0,
+	.timeout = WDT_DEFAULT_TIMEOUT,
+	.min_timeout = MIN_INTERVAL,
+	.max_timeout = MAX_INTERVAL,
+};
+
+/*
+ * It makes no sense to go into suspend while the watchdog is running.
+ * Depending on the memory size, the watchdog might trigger, while we
+ * are still saving the memory.
+ * We reuse the open flag to ensure that suspend and watchdog open are
+ * exclusive operations
+ */
+static int wdt_suspend(void)
+{
+	if (test_and_set_bit(WDOG_DEV_OPEN, &wdt_dev.status)) {
+		pr_err("Linux cannot be suspended while the watchdog is in use\n");
+		return notifier_from_errno(-EBUSY);
+	}
+	if (test_bit(WDOG_ACTIVE, &wdt_dev.status)) {
+		clear_bit(WDOG_DEV_OPEN, &wdt_dev.status);
+		pr_err("Linux cannot be suspended while the watchdog is in use\n");
+		return notifier_from_errno(-EBUSY);
+	}
+	return NOTIFY_DONE;
+}
+
+static int wdt_resume(void)
+{
+	clear_bit(WDOG_DEV_OPEN, &wdt_dev.status);
+	return NOTIFY_DONE;
+}
+
+static int wdt_power_event(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	switch (event) {
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return wdt_resume();
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return wdt_suspend();
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block wdt_power_notifier = {
+	.notifier_call = wdt_power_event,
+};
+
+static int __init diag288_init(void)
+{
+	int ret;
+	char ebc_begin[] = {
+		194, 197, 199, 201, 213
+	};
+
+	watchdog_set_nowayout(&wdt_dev, nowayout_info);
+
+	if (MACHINE_IS_VM) {
+		pr_info("The watchdog device driver detected a z/VM environment\n");
+		if (__diag288_vm(WDT_FUNC_INIT, 15,
+				 ebc_begin, sizeof(ebc_begin)) != 0) {
+			pr_err("The watchdog cannot be initialized\n");
+			return -EINVAL;
+		}
+	} else if (MACHINE_IS_LPAR) {
+		pr_info("The watchdog device driver detected an LPAR environment\n");
+		if (__diag288_lpar(WDT_FUNC_INIT, 30, LPARWDT_RESTART)) {
+			pr_err("The watchdog cannot be initialized\n");
+			return -EINVAL;
+		}
+	} else {
+		pr_err("Linux runs in an environment that does not support the diag288 watchdog\n");
+		return -ENODEV;
+	}
+
+	if (__diag288_lpar(WDT_FUNC_CANCEL, 0, 0)) {
+		pr_err("The watchdog cannot be deactivated\n");
+		return -EINVAL;
+	}
+
+	ret = register_pm_notifier(&wdt_power_notifier);
+	if (ret)
+		return ret;
+
+	ret = watchdog_register_device(&wdt_dev);
+	if (ret)
+		unregister_pm_notifier(&wdt_power_notifier);
+
+	return ret;
+}
+
+static void __exit diag288_exit(void)
+{
+	watchdog_unregister_device(&wdt_dev);
+	unregister_pm_notifier(&wdt_power_notifier);
+}
+
+module_init(diag288_init);
+module_exit(diag288_exit);

