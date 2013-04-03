Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289Ab3DCTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:16:28 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:60771 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763270Ab3DCTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:16:24 -0400
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
        Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5/7] dump_stack: implement arch-specific hardware description in task dumps
Date: Wed,  3 Apr 2013 12:14:55 -0700
Message-Id: <1365016497-32033-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365016497-32033-1-git-send-email-tj@kernel.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
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
during boot and, if exists, printed out in a separate line with
"Hardware name:" label.

dmi_set_dump_stack_arch_desc() is added which sets arch-specific
description from DMI data.  It uses dmi_ids_string[] which is set from
dmi_present() used for DMI debug message.  It is superset of the
information x86 show_regs() is using.  The function is called from x86
and ia64 boot code right after dmi_scan_machine().

This makes the explicit DMI handling in warn_slowpath_common()
unnecessary.  Removed.

show_regs() isn't yet converted to use generic debug information
printing and this patch doesn't remove the duplicate DMI handling in
x86 show_regs().  The next patch will unify show_regs() handling and
remove the duplication.

An example WARN dump follows.

 WARNING: at /work/os/work/kernel/workqueue.c:4841 init_workqueues+0x35/0x505()
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #3
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
  0000000000000009 ffff88007c861e08 ffffffff81c614dc ffff88007c861e48
  ffffffff8108f500 ffffffff82228240 0000000000000040 ffffffff8234a08e
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c614dc>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a0c3>] init_workqueues+0x35/0x505
  ...

v2: Use the same string as the debug message from dmi_present() which
    also contains BIOS information.  Move hardware name into its own
    line as warn_slowpath_common() did.  This change was suggested by
    Bjorn Helgaas.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/ia64/kernel/setup.c    |  1 +
 arch/x86/kernel/setup.c     |  1 +
 drivers/firmware/dmi_scan.c | 13 +++++++++++++
 include/linux/dmi.h         |  2 ++
 include/linux/printk.h      |  5 +++++
 kernel/panic.c              |  6 ------
 kernel/printk.c             | 26 ++++++++++++++++++++++++++
 7 files changed, 48 insertions(+), 6 deletions(-)

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
index 5022307..b95159b 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -525,6 +525,19 @@ void __init dmi_scan_machine(void)
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
+	dump_stack_set_arch_desc("%s", dmi_ids_string);
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
index 7ce1f87..47827c0 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -145,6 +145,7 @@ extern void wake_up_klogd(void);
 
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
+void dump_stack_set_arch_desc(const char *fmt, ...);
 void dump_stack_print_info(const char *log_lvl);
 #else
 static inline __printf(1, 0)
@@ -184,6 +185,10 @@ static inline void setup_log_buf(int early)
 {
 }
 
+static inline void dump_stack_set_arch_desc(const char *fmt, ...)
+{
+}
+
 static inline void dump_stack_print_info(const char *log_lvl)
 {
 }
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
diff --git a/kernel/printk.c b/kernel/printk.c
index a00a285..f404b56 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2852,6 +2852,28 @@ void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
 
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
@@ -2866,6 +2888,10 @@ void dump_stack_print_info(const char *log_lvl)
 	       print_tainted(), init_utsname()->release,
 	       (int)strcspn(init_utsname()->version, " "),
 	       init_utsname()->version);
+
+	if (dump_stack_arch_desc_str[0] != '\0')
+		printk("%sHardware name: %s\n",
+		       log_lvl, dump_stack_arch_desc_str);
 }
 
 #endif
-- 
1.8.1.4

