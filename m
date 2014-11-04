Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaKDQFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:05:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:15176 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754637AbaKDQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:29 -0500
Message-Id: <20141104160223.146433028@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH 11/12 v3] printk: Add per_cpu printk func to allow printk to be diverted
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0011-printk-Add-per_cpu-printk-func-to-allow-printk-to-be.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Being able to divert printk to call another function besides the normal
logging is useful for such things like NMI handling. If some functions
are to be called from NMI that does printk() it is possible to lock up
the box if the nmi handler triggers when another printk is happening.

One example of this use is to perform a stack trace on all CPUs via NMI.
But if the NMI is to do the printk() it can cause the system to lock up.
By allowing the printk to be diverted to another function that can safely
record the printk output and then print it when it in a safe context
then NMIs will be safe to call these functions like show_regs().

Link: http://lkml.kernel.org/p/20140619213952.209176403@goodmis.org

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/percpu.h |  3 +++
 include/linux/printk.h |  2 ++
 kernel/printk/printk.c | 38 +++++++++++++++++++++++++++++---------
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a3aa63e47637..ba2e85a0ff5b 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -134,4 +134,7 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type),		\
 						__alignof__(type))
 
+/* To avoid include hell, as printk can not declare this, we declare it here */
+DECLARE_PER_CPU(printk_func_t, printk_func);
+
 #endif /* __LINUX_PERCPU_H */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f73ac4..3bbd979d32fb 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -162,6 +162,8 @@ extern int kptr_restrict;
 
 extern void wake_up_klogd(void);
 
+typedef int(*printk_func_t)(const char *fmt, va_list args);
+
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84b1cb7..f7b723f98cb9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1807,6 +1807,30 @@ asmlinkage int printk_emit(int facility, int level,
 }
 EXPORT_SYMBOL(printk_emit);
 
+int vprintk_default(const char *fmt, va_list args)
+{
+	int r;
+
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(kdb_trap_printk)) {
+		r = vkdb_printf(fmt, args);
+		return r;
+	}
+#endif
+	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(vprintk_default);
+
+/*
+ * This allows printk to be diverted to another function per cpu.
+ * This is useful for calling printk functions from within NMI
+ * without worrying about race conditions that can lock up the
+ * box.
+ */
+DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
+
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -1830,19 +1854,15 @@ EXPORT_SYMBOL(printk_emit);
  */
 asmlinkage __visible int printk(const char *fmt, ...)
 {
+	printk_func_t vprintk_func;
 	va_list args;
 	int r;
 
-#ifdef CONFIG_KGDB_KDB
-	if (unlikely(kdb_trap_printk)) {
-		va_start(args, fmt);
-		r = vkdb_printf(fmt, args);
-		va_end(args);
-		return r;
-	}
-#endif
 	va_start(args, fmt);
-	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+	preempt_disable();
+	vprintk_func = this_cpu_read(printk_func);
+	r = vprintk_func(fmt, args);
+	preempt_enable();
 	va_end(args);
 
 	return r;
-- 
2.1.1


