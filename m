Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3I0NWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:22:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab3I0NWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:22:46 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Subject: [PATCH] RFC: Introduce FW_INFO* functions
Date: Fri, 27 Sep 2013 09:22:37 -0400
Message-Id: <1380288157-25248-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging and tracking firmware bugs in the kernel has long been an issue
for system administrators.  The current kernel does not have a good
uniform method of reporting firmware bugs and the code in the kernel is a
mix of printk's and WARN_ONs.  This causes problems for both system
administrators and QA engineers who attempt to diagnose problems within
the kernel.

Using printk's is somewhat effective but lacks information useful
for reporting a bug such as the system vendor or model, BIOS revision,
etc.  Using WARN_ONs is also questionable because much of the data like the
backtrace and the list of modules is unnecessary for firmware issues as
the warning stems from one call path during system or driver
initialization.  We have heard many complaints from users about the excess
verbosity of these messages.

I'm proposing with this patch to do something similar to the WARN()
mechanism that is currently implemented in the kernel.  This
patchset introduces FW_INFO() and FW_INFO_DEV() which logs output

[  230.661137] [Firmware Info]: pci_bus 0000:00: at
/home/prarit_modules/prarit.c:21 Your BIOS is broken because it is
-ENOWORKY.
[  230.671076] [Firmware Info]: Intel Corporation SandyBridge Platform/To
be filled by O.E.M., BIOS RMLCRB.86I.R3.27.D685.1305151733 05/15/2013

instead of the verbose back traces we are currently seeing.  These messages
can be easily cleaned from /var/log/messages, etc., by automatic bug
reporting tools and system administrators to properly report bugs to
hardware vendors.

For the RFC I've only implemented FW_INFO and FW_INFO_DEV as an example to
gauge interest and gather comments on the patch.  A full patchset would
also include FW_BUG and FW_WARN replacements.  Even in doing only this
simple FW_INFO modification I found an improperly classified FW_INFO in
arch/x86/kernel/cpu/amd.c which that should be a FW_WARN.  For now, I am
leaving it as a FW_INFO and will fix it when I implement the FW_BUG for
the "full" patchset.

Comments are appreciated and welcomed.  Thanks in advance for reviewing.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org
---
 arch/x86/kernel/cpu/amd.c      |    3 +--
 arch/x86/pci/mmconfig-shared.c |   15 +++------------
 include/asm-generic/bug.h      |   24 ++++++++++++++++++++++++
 include/linux/printk.h         |   13 ++++++-------
 kernel/panic.c                 |   24 ++++++++++++++++++++++++
 kernel/printk/printk.c         |   12 ++++++++++++
 6 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 903a264..a806ed4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -620,8 +620,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 			rdmsrl(0xc0011005, value);
 			if (value & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
-				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
-				  "disabled Topology Extensions Support\n");
+				FW_INFO(1, "CPU: Re-enabling disabled Topology Extensions Support\n");
 			}
 		}
 	}
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 5596c7b..1cdf930 100644
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
index 7d10f96..3a6152a 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -68,12 +68,17 @@ void warn_slowpath_fmt(const char *file, const int line,
 extern __printf(4, 5)
 void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
+extern __printf(4, 5)
+void warn_slowpath_fmt_dev(const char *file, const int line,
+			   struct device *dev, const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #define __WARN_printf_taint(taint, arg...)				\
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
+#define __WARN_printf_dev(dev, arg...)				\
+	warn_slowpath_fmt_dev(__FILE__, __LINE__, dev, arg)
 #else
 #define __WARN()		__WARN_TAINT(TAINT_WARN)
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
@@ -106,6 +111,14 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_on);					\
 })
 
+#define FW_INFO_DEV(condition, dev, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_dev(dev, format);			\
+	unlikely(__ret_warn_on);					\
+})
+#define FW_INFO(condition, format...) FW_INFO_DEV(condition, NULL, format)
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -131,6 +144,17 @@ extern void warn_slowpath_null(const char *file, const int line);
 
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
index e6131a78..86f2fa0 100644
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
index b6c482c..d5355ed 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/device.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -445,6 +446,29 @@ void warn_slowpath_fmt_taint(const char *file, int line,
 }
 EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
+void warn_slowpath_fmt_dev(const char *file, int line,
+			   struct device *dev, const char *fmt, ...)
+{
+	struct slowpath_args args;
+
+	pr_info("[Firmware Info]: ");
+	if (dev)
+		pr_cont("%s %s: ",
+			dev_driver_string(dev), dev_name(dev));
+	pr_cont("at %s:%d ", file, line);
+
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	vprintk(args.fmt, args.args);
+	va_end(args.args);
+	if (dump_hardware_arch_desc())
+		pr_info("[Firmware Info]: %s\n", dump_hardware_arch_desc());
+	else
+		pr_info("[Firmware Info]: Hardware Unidentified\n");
+}
+EXPORT_SYMBOL(warn_slowpath_fmt_dev);
+
+
 void warn_slowpath_null(const char *file, int line)
 {
 	warn_slowpath_common(file, line, __builtin_return_address(0),
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..3c1e92c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2870,6 +2870,18 @@ void __init dump_stack_set_arch_desc(const char *fmt, ...)
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

