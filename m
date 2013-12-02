Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3LBPT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab3LBPTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:19:53 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/3] Introduce FW_INFO* functions and messages
Date: Mon,  2 Dec 2013 10:19:37 -0500
Message-Id: <1385997579-22240-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1385997579-22240-1-git-send-email-prarit@redhat.com>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging and tracking firmware bugs in the kernel has long been an issue
for system administrators.  The current kernel does not have a good
uniform method of reporting firmware bugs and the code in the kernel is a
mix of printk's and WARN_ONs.  This causes problems for both system
administrators and QA engineers who attempt to diagnose problems within
the kernel.

Using printk's is somewhat effective but lacks information useful for
reporting a bug such as the system vendor or model, BIOS revision, etc.
Using WARN_ONs is also questionable because the data like the backtrace
and the list of modules is usually unnecessary for firmware issues as the
warning stems from one call path during system or driver initialization.
We have heard many complaints from users about the excess verbosity and
confusing stacktraces for these messages.

I'm proposing with this patch to do something similar to the WARN()
mechanism that is currently implemented in the kernel.  This
patchset introduces FW_INFO() and FW_INFO_DEV() which logs output like:

[  230.661137] [Firmware Info]: pci_bus 0000:00: at
/home/prarit_modules/prarit.c:21 Your BIOS is broken because it is
-ENOWORKY.
[  230.671076] [Firmware Info]: Intel Corporation SandyBridge Platform/To
be filled by O.E.M., BIOS RMLCRB.86I.R3.27.D685.1305151733 05/15/2013

instead of the verbose back traces we are currently seeing.  These messages
can be easily gleaned from /var/log/messages, etc., by automatic bug
reporting tools and system administrators to properly report bugs to
hardware vendors.

I found an improperly classified FW_INFO in arch/x86/kernel/cpu/amd.c
which that should be a FW_BUG.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/mmconfig-shared.c |   15 +++-----------
 include/asm-generic/bug.h      |   35 +++++++++++++++++++++++++++++++++
 include/linux/printk.h         |   13 ++++++-------
 kernel/panic.c                 |   42 ++++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c         |   12 ++++++++++++
 5 files changed, 98 insertions(+), 19 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..3cb0eff 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -498,15 +498,9 @@ static int __ref pci_mmcfg_check_reserved(struct device *dev,
 		if (is_mmconf_reserved(is_acpi_reserved, cfg, dev, 0))
 			return 1;
 
-		if (dev)
-			dev_info(dev, FW_INFO
-				 "MMCONFIG at %pR not reserved in "
-				 "ACPI motherboard resources\n",
+			FW_INFO_DEV(dev, dev, "MMCONFIG at %pR not reserved in ACPI motherboard resources\n",
 				 &cfg->res);
-		else
-			pr_info(FW_INFO PREFIX
-			       "MMCONFIG at %pR not reserved in "
-			       "ACPI motherboard resources\n",
+			FW_INFO(!dev, PREFIX "MMCONFIG at %pR not reserved in ACPI motherboard resources\n",
 			       &cfg->res);
 	}
 
@@ -707,10 +701,7 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 	cfg = pci_mmconfig_lookup(seg, start);
 	if (cfg) {
 		if (cfg->end_bus < end)
-			dev_info(dev, FW_INFO
-				 "MMCONFIG for "
-				 "domain %04x [bus %02x-%02x] "
-				 "only partially covers this bridge\n",
+			FW_INFO_DEV(1, dev, "MMCONFIG for domain %04x [bus %02x-%02x] only partially covers this bridge\n",
 				  cfg->segment, cfg->start_bus, cfg->end_bus);
 		mutex_unlock(&pci_mmcfg_lock);
 		return -EEXIST;
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7d10f96..b3cb4ed 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -68,12 +68,17 @@ void warn_slowpath_fmt(const char *file, const int line,
 extern __printf(4, 5)
 void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
+extern __printf(5, 6)
+void warn_slowpath_fmt_dev(const char *file, const int line,
+			   struct device *dev, int level, const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #define __WARN_printf_taint(taint, arg...)				\
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
+#define __WARN_printf_dev(dev, level, arg...)				\
+	warn_slowpath_fmt_dev(__FILE__, __LINE__, dev, level, arg)
 #else
 #define __WARN()		__WARN_TAINT(TAINT_WARN)
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
@@ -106,6 +111,25 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_on);					\
 })
 
+/*
+ * FW_INFO & FW_INFO_DEV are used to indicate that a firmware bug has
+ * been found, but no action has been taken in the kernel.
+ *
+ * FW_WARN & FW_WARN_DEV are used to indicate that a firmware bug has
+ * been found, and an error action has been taken in the kernel.
+ *
+ * FW_BUG & FW_BUG_DEV are used to indicate that a firmware bug has been
+ * found, and a corrective action has been taken in the kernel.  FW_BUG
+ * sets the TAINT_FIRMWARE_WORKAROUND flag.
+ */
+#define FW_INFO_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_dev(dev, 1, format);			\
+	unlikely(__ret_warn_on);					\
+})
+#define FW_INFO(condition, format...) FW_INFO_DEV(condition, NULL, format)
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -131,6 +155,17 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
 
+#define FW_INFO_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	dev_info(format);						\
+	unlikely(__ret_warn_on);					\
+})
+
+#define FW_INFO(condition, format...) ({				\
+	int __ret_warn_on = !!(condition);				\
+	pr_info(format);						\
+	unlikely(__ret_warn_on);					\
+})
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 6949258..db540cc 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -69,16 +69,9 @@ struct va_format {
  * FW_WARN
  * Use it for not that clear (e.g. could the kernel messed up things already?)
  * and medium priority BIOS bugs.
- *
- * FW_INFO
- * Use this one if you want to tell the user or vendor about something
- * suspicious, but generally harmless related to the firmware.
- *
- * Use it for information or very low priority BIOS bugs.
  */
 #define FW_BUG		"[Firmware Bug]: "
 #define FW_WARN		"[Firmware Warn]: "
-#define FW_INFO		"[Firmware Info]: "
 
 /*
  * HW_ERR
@@ -147,6 +140,7 @@ extern void wake_up_klogd(void);
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
+char *dump_hardware_arch_desc(void);
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
 #else
@@ -187,6 +181,11 @@ static inline void setup_log_buf(int early)
 {
 }
 
+static inline char *dump_hadware_arch_desc(void)
+{
+	return NULL;
+}
+
 static inline void dump_stack_set_arch_desc(const char *fmt, ...)
 {
 }
diff --git a/kernel/panic.c b/kernel/panic.c
index c00b4ce..ed24b3e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/device.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -445,6 +446,47 @@ void warn_slowpath_fmt_taint(const char *file, int line,
 }
 EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
+void warn_slowpath_fmt_dev(const char *file, int line,
+			   struct device *dev, int level, const char *fmt, ...)
+{
+	struct slowpath_args args;
+	static char fw_str[16] = "\0";
+
+	switch (level) {
+	case 1:
+		strcpy(fw_str, "[Firmware Info]");
+		break;
+	case 2:
+		strcpy(fw_str, "[Firmware Warn]");
+		break;
+	case 3:
+		strcpy(fw_str, "[Firmware Bug]");
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+		break;
+	default:
+		strcpy(fw_str, "[Firmware Bug]");
+		break;
+	}
+
+	if (dev)
+		pr_info("%s: %s %s ", fw_str,
+			dev_driver_string(dev), dev_name(dev));
+	pr_info("%s: at %s:%d\n", fw_str, file, line);
+
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	printk(KERN_WARNING "%s: %pV", fw_str, &args);
+	va_end(args.args);
+
+	if (dump_hardware_arch_desc())
+		pr_info("%s: System Info: %s\n", fw_str,
+			dump_hardware_arch_desc());
+	else
+		pr_info("%s: System Info: Hardware Unidentified\n", fw_str);
+}
+EXPORT_SYMBOL(warn_slowpath_fmt_dev);
+
+
 void warn_slowpath_null(const char *file, int line)
 {
 	warn_slowpath_common(file, line, __builtin_return_address(0),
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index be7c86b..3e4c634 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2869,6 +2869,18 @@ void __init dump_stack_set_arch_desc(const char *fmt, ...)
 }
 
 /**
+ * dump_hardware_arch_desc -- return generic hardware and firmware information
+ *
+ * Return a string with the hardware name and firmware version for this system
+ */
+char *dump_hardware_arch_desc(void)
+{
+	if (dump_stack_arch_desc_str[0] != '\0')
+		return dump_stack_arch_desc_str;
+	return NULL;
+}
+
+/**
  * dump_stack_print_info - print generic debug info for dump_stack()
  * @log_lvl: log level
  *
-- 
1.7.9.3

