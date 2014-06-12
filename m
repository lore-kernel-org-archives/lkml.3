Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaFLSsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:48:46 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:26097 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbaFLSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:48:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoIAC71mVNbsHy//2dsb2JhbABagw2qdQUBAQEBAQEFAZkegQsXdYQxLyOBGjeIRgG4OJoVF4VciH+ESASPaIpKizCIIoM+Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/debug/debug_core.c: Logging clean-up
Date: Thu, 12 Jun 2014 20:48:38 +0200
Message-Id: <1402598918-5729-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert printk( to pr_foo()
-Add pr_fmt
-Coalesce formats

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/debug/debug_core.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1adf62b..b21ff5f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -27,6 +27,9 @@
  * version 2. This program is licensed "as is" without any warranty of any
  * kind, whether express or implied.
  */
+
+#define pr_fmt(fmt) "KGDB: " fmt
+
 #include <linux/pid_namespace.h>
 #include <linux/clocksource.h>
 #include <linux/serial_core.h>
@@ -196,8 +199,8 @@ int __weak kgdb_validate_break_address(unsigned long addr)
 		return err;
 	err = kgdb_arch_remove_breakpoint(&tmp);
 	if (err)
-		printk(KERN_ERR "KGDB: Critical breakpoint error, kernel "
-		   "memory destroyed at: %lx", addr);
+		pr_err("Critical breakpoint error, kernel memory destroyed at: %lx",
+		       addr);
 	return err;
 }
 
@@ -256,8 +259,8 @@ int dbg_activate_sw_breakpoints(void)
 		error = kgdb_arch_set_breakpoint(&kgdb_break[i]);
 		if (error) {
 			ret = error;
-			printk(KERN_INFO "KGDB: BP install failed: %lx",
-			       kgdb_break[i].bpt_addr);
+			pr_info("BP install failed: %lx",
+				kgdb_break[i].bpt_addr);
 			continue;
 		}
 
@@ -319,8 +322,8 @@ int dbg_deactivate_sw_breakpoints(void)
 			continue;
 		error = kgdb_arch_remove_breakpoint(&kgdb_break[i]);
 		if (error) {
-			printk(KERN_INFO "KGDB: BP remove failed: %lx\n",
-			       kgdb_break[i].bpt_addr);
+			pr_info("BP remove failed: %lx\n",
+				kgdb_break[i].bpt_addr);
 			ret = error;
 		}
 
@@ -367,7 +370,7 @@ int dbg_remove_all_break(void)
 			goto setundefined;
 		error = kgdb_arch_remove_breakpoint(&kgdb_break[i]);
 		if (error)
-			printk(KERN_ERR "KGDB: breakpoint remove failed: %lx\n",
+			pr_err("breakpoint remove failed: %lx\n",
 			       kgdb_break[i].bpt_addr);
 setundefined:
 		kgdb_break[i].state = BP_UNDEFINED;
@@ -400,9 +403,9 @@ static int kgdb_io_ready(int print_wait)
 	if (print_wait) {
 #ifdef CONFIG_KGDB_KDB
 		if (!dbg_kdb_mode)
-			printk(KERN_CRIT "KGDB: waiting... or $3#33 for KDB\n");
+			pr_crit("waiting... or $3#33 for KDB\n");
 #else
-		printk(KERN_CRIT "KGDB: Waiting for remote debugger\n");
+		pr_crit("Waiting for remote debugger\n");
 #endif
 	}
 	return 1;
@@ -430,8 +433,7 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 		exception_level = 0;
 		kgdb_skipexception(ks->ex_vector, ks->linux_regs);
 		dbg_activate_sw_breakpoints();
-		printk(KERN_CRIT "KGDB: re-enter error: breakpoint removed %lx\n",
-			addr);
+		pr_crit("re-enter error: breakpoint removed %lx\n", addr);
 		WARN_ON_ONCE(1);
 
 		return 1;
@@ -444,7 +446,7 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 		panic("Recursive entry to debugger");
 	}
 
-	printk(KERN_CRIT "KGDB: re-enter exception: ALL breakpoints killed\n");
+	pr_crit("re-enter exception: ALL breakpoints killed\n");
 #ifdef CONFIG_KGDB_KDB
 	/* Allow kdb to debug itself one level */
 	return 0;
@@ -795,15 +797,15 @@ static struct console kgdbcons = {
 static void sysrq_handle_dbg(int key)
 {
 	if (!dbg_io_ops) {
-		printk(KERN_CRIT "ERROR: No KGDB I/O module available\n");
+		pr_crit("ERROR: No KGDB I/O module available\n");
 		return;
 	}
 	if (!kgdb_connected) {
 #ifdef CONFIG_KGDB_KDB
 		if (!dbg_kdb_mode)
-			printk(KERN_CRIT "KGDB or $3#33 for KDB\n");
+			pr_crit("KGDB or $3#33 for KDB\n");
 #else
-		printk(KERN_CRIT "Entering KGDB\n");
+		pr_crit("Entering KGDB\n");
 #endif
 	}
 
@@ -945,7 +947,7 @@ static void kgdb_initial_breakpoint(void)
 {
 	kgdb_break_asap = 0;
 
-	printk(KERN_CRIT "kgdb: Waiting for connection from remote gdb...\n");
+	pr_crit("Waiting for connection from remote gdb...\n");
 	kgdb_breakpoint();
 }
 
@@ -964,8 +966,7 @@ int kgdb_register_io_module(struct kgdb_io *new_dbg_io_ops)
 	if (dbg_io_ops) {
 		spin_unlock(&kgdb_registration_lock);
 
-		printk(KERN_ERR "kgdb: Another I/O driver is already "
-				"registered with KGDB.\n");
+		pr_err("Another I/O driver is already registered with KGDB.\n");
 		return -EBUSY;
 	}
 
@@ -981,8 +982,7 @@ int kgdb_register_io_module(struct kgdb_io *new_dbg_io_ops)
 
 	spin_unlock(&kgdb_registration_lock);
 
-	printk(KERN_INFO "kgdb: Registered I/O driver %s.\n",
-	       new_dbg_io_ops->name);
+	pr_info("Registered I/O driver %s.\n", new_dbg_io_ops->name);
 
 	/* Arm KGDB now. */
 	kgdb_register_callbacks();
@@ -1017,8 +1017,7 @@ void kgdb_unregister_io_module(struct kgdb_io *old_dbg_io_ops)
 
 	spin_unlock(&kgdb_registration_lock);
 
-	printk(KERN_INFO
-		"kgdb: Unregistered I/O driver %s, debugger disabled.\n",
+	pr_info("Unregistered I/O driver %s, debugger disabled.\n",
 		old_dbg_io_ops->name);
 }
 EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
-- 
1.9.1

