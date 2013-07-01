Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3GAKKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:10:04 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51960 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3GAKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:10:02 -0400
Date: Mon, 1 Jul 2013 12:09:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug changes for v3.11
Message-ID: <20130701100958.GA17193@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   HEAD: 13bfd47a0ef68fc8b21e67873dbdf269c7db6b59 x86/tboot: Provide debugfs interfaces to access TXT log

Misc debuggability improvements:

 - Optimize the x86 CPU register printout a bit

 - Expose the tboot TXT log via debugfs

 - Small do_debug() cleanup

 Thanks,

	Ingo

------------------>
Dave Jones (1):
      x86/debug: Only print out DR registers if they are not power-on defaults

Qiaowei Ren (1):
      x86/tboot: Provide debugfs interfaces to access TXT log

Rusty Russell (1):
      x86: Remove weird PTR_ERR() in do_debug


 arch/x86/kernel/process_32.c | 11 +++++--
 arch/x86/kernel/process_64.c |  9 +++++-
 arch/x86/kernel/tboot.c      | 73 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c      |  2 +-
 4 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7305f7d..f84cfd1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -110,11 +110,16 @@ void __show_regs(struct pt_regs *regs, int all)
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
-	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
-			d0, d1, d2, d3);
-
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
+
+	/* Only print out debug registers if they are in their non-default state. */
+	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
+	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+		return;
+
+	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+			d0, d1, d2, d3);
 	printk(KERN_DEFAULT "DR6: %08lx DR7: %08lx\n",
 			d6, d7);
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 355ae06..a8b9abc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -105,11 +105,18 @@ void __show_regs(struct pt_regs *regs, int all)
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
-	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
+
+	/* Only print out debug registers if they are in their non-default state. */
+	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
+	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+		return;
+
+	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	printk(KERN_DEFAULT "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
+
 }
 
 void release_thread(struct task_struct *dead_task)
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..3ff42d2 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -31,6 +31,7 @@
 #include <linux/pfn.h>
 #include <linux/mm.h>
 #include <linux/tboot.h>
+#include <linux/debugfs.h>
 
 #include <asm/realmode.h>
 #include <asm/processor.h>
@@ -338,6 +339,73 @@ static struct notifier_block tboot_cpu_notifier __cpuinitdata =
 	.notifier_call = tboot_cpu_callback,
 };
 
+#ifdef CONFIG_DEBUG_FS
+
+#define TBOOT_LOG_UUID	{ 0x26, 0x25, 0x19, 0xc0, 0x30, 0x6b, 0xb4, 0x4d, \
+			  0x4c, 0x84, 0xa3, 0xe9, 0x53, 0xb8, 0x81, 0x74 }
+
+#define TBOOT_SERIAL_LOG_ADDR	0x60000
+#define TBOOT_SERIAL_LOG_SIZE	0x08000
+#define LOG_MAX_SIZE_OFF	16
+#define LOG_BUF_OFF		24
+
+static uint8_t tboot_log_uuid[16] = TBOOT_LOG_UUID;
+
+static ssize_t tboot_log_read(struct file *file, char __user *user_buf, size_t count, loff_t *ppos)
+{
+	void __iomem *log_base;
+	u8 log_uuid[16];
+	u32 max_size;
+	void *kbuf;
+	int ret = -EFAULT;
+
+	log_base = ioremap_nocache(TBOOT_SERIAL_LOG_ADDR, TBOOT_SERIAL_LOG_SIZE);
+	if (!log_base)
+		return ret;
+
+	memcpy_fromio(log_uuid, log_base, sizeof(log_uuid));
+	if (memcmp(&tboot_log_uuid, log_uuid, sizeof(log_uuid)))
+		goto err_iounmap;
+
+	max_size = readl(log_base + LOG_MAX_SIZE_OFF);
+	if (*ppos >= max_size) {
+		ret = 0;
+		goto err_iounmap;
+	}
+
+	if (*ppos + count > max_size)
+		count = max_size - *ppos;
+
+	kbuf = kmalloc(count, GFP_KERNEL);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	memcpy_fromio(kbuf, log_base + LOG_BUF_OFF + *ppos, count);
+	if (copy_to_user(user_buf, kbuf, count))
+		goto err_kfree;
+
+	*ppos += count;
+
+	ret = count;
+
+err_kfree:
+	kfree(kbuf);
+
+err_iounmap:
+	iounmap(log_base);
+
+	return ret;
+}
+
+static const struct file_operations tboot_log_fops = {
+	.read	= tboot_log_read,
+	.llseek	= default_llseek,
+};
+
+#endif /* CONFIG_DEBUG_FS */
+
 static __init int tboot_late_init(void)
 {
 	if (!tboot_enabled())
@@ -348,6 +416,11 @@ static __init int tboot_late_init(void)
 	atomic_set(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
 
+#ifdef CONFIG_DEBUG_FS
+	debugfs_create_file("tboot_log", S_IRUSR,
+			arch_debugfs_dir, NULL, &tboot_log_fops);
+#endif
+
 	acpi_os_set_prepare_sleep(&tboot_sleep);
 	return 0;
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 772e2a8..9340dfb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -437,7 +437,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
+	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 
