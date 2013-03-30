Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3C3C2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 22:28:02 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:51294 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab3C3C17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 22:27:59 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] dump_stack: implement arch-specific hardware description in task dumps
Date: Fri, 29 Mar 2013 19:27:07 -0700
Message-Id: <1364610428-2074-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364610428-2074-1-git-send-email-tj@kernel.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 and ia64 can acquire extra hardware identification information
from DMI and print it along with task dumps; however, the usage isn't
consistent.

* x86 show_regs() collects vendor, product and board strings and print
  them out with PID, comm and utsname.  Some of the information is
  printed again later in the same dump.

* warn_slowpath_common() explicitly accesses the DMI board and prints
  it out with "Hardware name:" label.  This applies to both x86 and
  ia64 but is irrelevant on all other archs.

* ia64 doesn't show DMI information on other non-WARN dumps.

This patch introduces arch-specific hardware description used by
dump_stack().  It can be set by calling dump_stack_set_arch_desc()
during boot and printed out along with utsname.

dmi_set_dump_stack_arch_desc() is added which sets arch-specific
description from DMI data.  It uses the same information and
formatting as x86 show_regs() is using.  The function is called from
x86 and ia64 boot code right after dmi_scan_machine().

This makes the explicit DMI handling in warn_slowpath_common()
unnecessary.  Removed.

show_regs() isn't yet converted to use generic debug information
printing and this patch doesn't remove the duplicate DMI handling in
x86 show_regs().  The next patch will unify show_regs() handling and
remove the duplication.

An example WARN dump follows.

 WARNING: at /work/os/work/kernel/workqueue.c:4840 init_workqueues+0x35/0x505()
 Modules linked in:
 Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1-work+ #18 empty empty/S3992
  0000000000000009 ffff88007c861e08 ffffffff81c61525 ffff88007c861e48
  ffffffff8108f500 ffffffff82228240 0000000000000040 ffffffff8234a041
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c61525>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a076>] init_workqueues+0x35/0x505
  ...

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/ia64/kernel/setup.c    |  1 +
 arch/x86/kernel/setup.c     |  1 +
 drivers/firmware/dmi_scan.c | 26 ++++++++++++++++++++++++++
 include/linux/dmi.h         |  2 ++
 include/linux/printk.h      |  1 +
 kernel/panic.c              |  6 ------
 lib/dump_stack.c            | 26 ++++++++++++++++++++++++--
 7 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 2029cc0..13bfdd2 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1063,6 +1063,7 @@ check_bugs (void)
 static int __init run_dmi_scan(void)
 {
 	dmi_scan_machine();
+	dmi_set_dump_stack_arch_desc();
 	return 0;
 }
 core_initcall(run_dmi_scan);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc9..91b9e7c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -970,6 +970,7 @@ void __init setup_arch(char **cmdline_p)
 		efi_init();
 
 	dmi_scan_machine();
+	dmi_set_dump_stack_arch_desc();
 
 	/*
 	 * VMware detection requires dmi to be available, so this
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 4cd392d..9e7766b 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -521,6 +521,32 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ * dmi_set_dump_stack_arch_desc - set arch description for dump_stack()
+ *
+ * Invoke dump_stack_set_arch_desc() with DMI system information so that
+ * DMI identifiers are printed out on task dumps.  Arch boot code should
+ * call this function after dmi_scan_machine() if it wants to print out DMI
+ * identifiers on task dumps.
+ */
+void __init dmi_set_dump_stack_arch_desc(void)
+{
+	const char *vendor, *product, *board;
+
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor)
+		vendor = "";
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product)
+		product = "";
+
+	/* Board Name is optional */
+	board = dmi_get_system_info(DMI_BOARD_NAME);
+
+	dump_stack_set_arch_desc("%s %s%s%s", vendor, product,
+				 board ? "/" : "", board ? board : "");
+}
+
+/**
  *	dmi_matches - check if dmi_system_id structure matches system DMI data
  *	@dmi: pointer to the dmi_system_id structure to check
  */
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index f156cca..b6eb7a0 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -99,6 +99,7 @@ extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
 extern void dmi_scan_machine(void);
+extern void dmi_set_dump_stack_arch_desc(void);
 extern bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp);
 extern int dmi_name_in_vendors(const char *str);
 extern int dmi_name_in_serial(const char *str);
@@ -114,6 +115,7 @@ static inline const char * dmi_get_system_info(int field) { return NULL; }
 static inline const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from) { return NULL; }
 static inline void dmi_scan_machine(void) { return; }
+static inline void dmi_set_dump_stack_arch_desc(void) { }
 static inline bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp)
 {
 	if (yearp)
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 952c1b2..73788ff 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -177,6 +177,7 @@ static inline void setup_log_buf(int early)
 }
 #endif
 
+extern void dump_stack_set_arch_desc(const char *fmt, ...);
 extern void dump_stack_print_info(const char *log_lvl);
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 7c57cc9..167ec09 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -22,7 +22,6 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
-#include <linux/dmi.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -400,13 +399,8 @@ struct slowpath_args {
 static void warn_slowpath_common(const char *file, int line, void *caller,
 				 unsigned taint, struct slowpath_args *args)
 {
-	const char *board;
-
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (board)
-		printk(KERN_WARNING "Hardware name: %s\n", board);
 
 	if (args)
 		vprintk(args->fmt, args->args);
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 5a67cfc..93573ec 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -8,6 +8,28 @@
 #include <linux/utsname.h>
 #include <linux/export.h>
 
+static char dump_stack_arch_desc_str[128];
+
+/**
+ * dump_stack_set_arch_desc - set arch-specific str to show with task dumps
+ * @fmt: printf-style format string
+ * @...: arguments for the format string
+ *
+ * The configured string will be printed right after utsname during task
+ * dumps.  Usually used to add arch-specific system identifiers.  If an
+ * arch wants to make use of such an ID string, it should initialize this
+ * as soon as possible during boot.
+ */
+void __init dump_stack_set_arch_desc(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vsnprintf(dump_stack_arch_desc_str, sizeof(dump_stack_arch_desc_str),
+		  fmt, args);
+	va_end(args);
+}
+
 /**
  * dump_stack_print_info - print generic debug info for dump_stack()
  * @log_lvl: log level
@@ -17,11 +39,11 @@
  */
 void dump_stack_print_info(const char *log_lvl)
 {
-	printk("%sPid: %d, comm: %.20s %s %s %.*s\n",
+	printk("%sPid: %d, comm: %.20s %s %s %.*s %s\n",
 	       log_lvl, current->pid, current->comm, print_tainted(),
 	       init_utsname()->release,
 	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
+	       init_utsname()->version, dump_stack_arch_desc_str);
 }
 
 /**
-- 
1.8.1.4

