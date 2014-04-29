Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbaD2LmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:42:23 -0400
Received: from mout.gmx.net ([212.227.15.15]:56167 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933759AbaD2LmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:42:19 -0400
Message-ID: <535F9015.5090309@gmx.de>
Date: Tue, 29 Apr 2014 13:42:13 +0200
From: Alexander Naumann <alexandernaumann@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Patchset for kernel 3.10 (fixing lockup in printk)
X-Enigmail-Version: 1.5.2
Content-Type: multipart/mixed;
 boundary="------------080809080208060304090407"
X-Provags-ID: V03:K0:Lt12UYWFTZmj15aVnp4xVybUExJOaPWfUec8bZ7yLGCPOoTGkA5
 wNJV0fKAsatxbHlf+lIrO0E5r2Tg06OgvUkaXh2XMVBAi6OtzM21ce25pcL/SOznQSq1CEF
 T3j1ejQL4Ceb8dkHUqR13lyVZ4u/kMv34437KsZqqZSh6W97gNMItC25j4hisBc+Fze04HW
 tTubiSQRT01d+PlSnotYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080809080208060304090407
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hallo all,

attached to this mail you will find a couple of patches fixing one bug I
have with kernel 3.10 (all subreleases).
These patches have been developed originally by Jan Kara (jack@suse.cz,
I guess you
know him better than I do) for kernel 3.13 and can be found here:
https://lkml.org/lkml/2014/3/25/343
I just have backported them to kernel 3.10.

Also I have created (at least it was a try by myself) a bugentry on
kernel.org:
https://bugzilla.kernel.org/show_bug.cgi?id=71231
(I have to update it yet)

Summarize:
Creating lots of output on console that is going to be printed on serial
port too (via kernel command line "console=ttyS0") will hang several
systems (mostly Dell servers with multiple CPUs).
I can easily reproduce this behaviour by creating about 50 virtual LUNs
via fibrechannel at once.
This patch from Jan introduces a buffering and better locking in printk
(as far as I understood him or his patches right).

Without this patches I get teh following stacktraces and the system is
not responding after a couple of seconds:

  119.504736] Code: 00 48 89 f0 48 c7 06 00 00 00 00 48 89 e5 48 87 07
48 85 c0 75 09 c7 46 08 01 00 00 00 5d c3 48 89 30 8b 46 08 85 c0 75 f4
f3 90 <8b> 46 08 85 c0 74 f7 5d c3 0f 1f 44 00 00 48 8b 16 55 48 89 e5 [
 119.504740] NMI backtrace for cpu 44
[  119.504746] CPU: 44 PID: 21877 Comm: lsscsi Not tainted 3.10.32-64bit #1
[  119.504748] Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS
1.0.1 02/19/2010
[  119.504751] task: ffff881063510d60 ti: ffff88106351c000 task.ti:
ffff88106351c000
[  119.504760] RIP: 0010:[<ffffffff8105e505>]  [<ffffffff8105e505>]
mspin_lock+0x35/0x40
[  119.504763] RSP: 0018:ffff88106351db38  EFLAGS: 00000246
[  119.504765] RAX: 0000000000000000 RBX: ffffffff81aa9220 RCX:
0000000000000028
[  119.504768] RDX: ffff88106351dfd8 RSI: ffff88106351db60 RDI:
ffffffff81aa9240
[  119.504770] RBP: ffff88106351db38 R08: 70722f3374736f68 R09:
fefefefefefefeff
[  119.504772] R10: ffff88086ddc5bc0 R11: 8f8dd0cc8b8c9097 R12:
ffff88106351db60
[  119.504774] R13: ffffffff81aa9240 R14: ffff881063510d60 R15:
ffff88106351dca8
[  119.504777] FS:  0000000000000000(0000) GS:ffff88046fd60000(0063)
knlGS:00000000f762f8d0
[  119.504780] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  119.504782] CR2: 00000000f777c000 CR3: 00000010684ea000 CR4:
00000000000007e0
[  119.504785] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  119.504788] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  119.504789] Stack:
[  119.504794]  ffff88106351dba8 ffffffff81766d5d ffff88106351db58
ffff88106351dfd8
[  119.504798]  ffff88106351dba8 ffff881066ebfb90 ffff881000000000
ffffffff00000003
[  119.504803]  ffff88106351db98 ffffffff81aa9220 ffff88106351dc98
ffff88046c3a94d0
[  119.504804] Call Trace:
[  119.504812]  [<ffffffff81766d5d>] __mutex_lock_slowpath+0x5d/0x1d0
[  119.504817]  [<ffffffff817667dd>] mutex_lock+0x1d/0x40
[  119.504823]  [<ffffffff81156ba5>] sysfs_dentry_revalidate+0x35/0x100
[  119.504828]  [<ffffffff810ff389>] lookup_fast+0x299/0x2e0
[  119.504833]  [<ffffffff810ff586>] ? __inode_permission+0x46/0x70
[  119.504838]  [<ffffffff810ff79a>] link_path_walk+0x19a/0x810
[  119.504843]  [<ffffffff810ff994>] link_path_walk+0x394/0x810
[  119.504848]  [<ffffffff810b9b8f>] ? release_pages+0x18f/0x1e0
[  119.504853]  [<ffffffff81103094>] path_openat.isra.72+0x94/0x460
[  119.504859]  [<ffffffff810cbf84>] ? tlb_flush_mmu+0x54/0x90
[  119.504864]  [<ffffffff810d2c79>] ? unmap_region+0xd9/0x120
[  119.504869]  [<ffffffff8110368c>] do_filp_open+0x3c/0x90
[  119.504875]  [<ffffffff8110ee52>] ? __alloc_fd+0x42/0x100
[  119.504882]  [<ffffffff810f3a3f>] do_sys_open+0xef/0x1d0
[  119.504888]  [<ffffffff8113a036>] compat_SyS_open+0x16/0x20
[  119.504893]  [<ffffffff8176b598>] sysenter_dispatch+0x7/0x25
[  119.504938] Code: f0 48 c7 06 00 00 00 00 48 89 e5 48 87 07 48 85 c0
75 09 c7 46 08 01 00 00 00 5d c3 48 89 30 8b 46 08 85 c0 75 f4 f3 90 8b
46 08 <85> c0 74 f7 5d c3 0f 1f 44 00 00 48 8b 16 55 48 89 e5 48 85 d2 [
 119.504942] NMI backtrace for cpu 45
[  119.504946] CPU: 45 PID: 0 Comm: swapper/45 Not tainted 3.10.32-64bit #1
[  119.504949] Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS
1.0.1 02/19/2010
[  119.504952] task: ffff88046dcd6b00 ti: ffff88046dcf6000 task.ti:
ffff88046dcf6000
[  119.504960] RIP: 0010:[<ffffffff8102318a>]  [<ffffffff8102318a>]
mwait_idle_with_hints+0x5a/0x70
[  119.504962] RSP: 0018:ffff88046dcf7dd8  EFLAGS: 00000046
[  119.504965] RAX: 0000000000000000 RBX: ffff88106d07d46c RCX:
0000000000000001
[  119.504967] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000000
[  119.504970] RBP: ffff88046dcf7dd8 R08: ffff88046dcf7fd8 R09:
000000000000001c
[  119.504972] R10: 0000000000000166 R11: 00000000016f1e50 R12:
0000000000000001
[  119.504975] R13: ffff88106d07d400 R14: 0000000000000001 R15:
ffffffffa0004830
[  119.504978] FS:  0000000000000000(0000) GS:ffff88086fd60000(0000)
knlGS:0000000000000000
[  119.504981] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  119.504984] CR2: 00000000f7746000 CR3: 000000046cb57000 CR4:
00000000000007e0
[  119.504986] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  119.504989] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  119.504989] Stack:
[  119.504994]  ffff88046dcf7de8 ffffffff810231cd ffff88046dcf7df8
ffffffffa0001515
[  119.504999]  ffff88046dcf7e28 ffffffffa000164a 00000000000000f5
ffff88106c669000
[  119.505003]  ffffffffa00047c0 0000001aaf4aa38f ffff88046dcf7e88
ffffffff8164e83a
[  119.505004] Call Trace:
[  119.505010]  [<ffffffff810231cd>]
acpi_processor_ffh_cstate_enter+0x2d/0x30
[  119.505021]  [<ffffffffa0001515>] acpi_idle_do_entry+0x10/0x2b
[processor]
[  119.505028]  [<ffffffffa000164a>] acpi_idle_enter_c1+0x5c/0x81
[processor]
[  119.505035]  [<ffffffff8164e83a>] cpuidle_enter_state+0x4a/0xe0
[  119.505041]  [<ffffffff8164e96e>] cpuidle_idle_call+0x9e/0x160
[  119.505046]  [<ffffffff8106092d>] ? __atomic_notifier_call_chain+0xd/0x10
[  119.505052]  [<ffffffff8100af49>] arch_cpu_idle+0x9/0x30
[  119.505057]  [<ffffffff81073241>] cpu_startup_entry+0x91/0x180
[  119.505063]  [<ffffffff81b4be73>] start_secondary+0x1a0/0x1a4


Should these patches be merged into kernel 3.10 line?
And maybe also to 3.12? Or is there any other better solution?

Best regards,
Alex





--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch8_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch8_8.diff"

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 74826b1e2529..3c6d5aec501a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2621,18 +2621,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
-	printk.offload_chars=
+	printk.offload_chars=	[KNL]
 			Printing to console can be relatively slow especially
 			in case of serial console. When there is intensive
 			printing happening from several cpus (as is the case
 			during boot), a cpu can be spending significant time
 			(seconds or more) doing printing. To avoid softlockups,
 			lost interrupts, and similar problems other cpus
-			will take over printing after the currently printing
-			cpu has printed 'printk.offload_chars' characters.
-			Higher value means possibly longer interrupt and other
-			latencies but lower overhead of printing due to handing
-			over of printing.
+			will take over printing (if CONFIG_PRINTK_OFFLOAD=y)
+			after the currently printing cpu has printed
+			'printk.offload_chars' characters. Higher value means
+			possibly longer interrupt and other latencies but
+			lower overhead of printing due to handing over of
+			printing.
 			Format: <number> (0 = disabled)
 			default: 1000
 
diff --git a/init/Kconfig b/init/Kconfig
index 009a797dd242..45aa7368d92f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1343,6 +1343,20 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PRINTK_OFFLOAD
+	default y
+	bool "Enable support for offloading printing to different CPU"
+	depends on PRINTK
+	help
+	  Printing to console can be relatively slow especially in case of
+	  serial console. On large machines when there is intensive printing
+	  happening from several cpus (as is the case during boot), a cpu can
+	  be spending significant time (seconds or more) doing printing. To
+	  avoid softlockups, lost interrupts, and similar problems other cpus
+	  will take over printing after the currently printing cpu has printed
+	  certain number of characters (tunable via 'printk.offload_chars'
+	  kernel parameter).
+
 config BUG
 	bool "BUG() support" if EXPERT
 	default y
diff --git a/kernel/printk.c b/kernel/printk.c
index 1c0577383af5..c3ad3b834f68 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -103,6 +103,7 @@ enum {
 };
 static long printk_handover_state;
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /*
  * Number of kernel threads for offloading printing. We need at least two so
  * that they can hand over printing from one to another one and thus switch
@@ -116,6 +117,7 @@ static DEFINE_MUTEX(printk_kthread_mutex);
 
 /* Wait queue printing kthreads sleep on when idle */
 static DECLARE_WAIT_QUEUE_HEAD(print_queue); 
+#endif	/* CONFIG_PRINTK_OFFLOAD */
 
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
@@ -284,6 +286,7 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 static int offload_chars_set(const char *val, const struct kernel_param *kp);
 static struct kernel_param_ops offload_chars_ops = {
 	.set = offload_chars_set,
@@ -302,6 +305,7 @@ module_param_cb(offload_chars, &offload_chars_ops, &printk_offload_chars,
 		   S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
 	" cpu after this number of characters");
+#endif
 
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
@@ -2021,6 +2025,7 @@ int console_trylock(void)
 }
 EXPORT_SYMBOL(console_trylock);
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /*
  * This is a version of console_lock() which spins to acquire console_sem.
  * It is only for use by threads that take care of flushing printk buffer so
@@ -2052,6 +2057,7 @@ static int console_lock_try_spin(void)
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 	return 1;
 }
+#endif
 
 int is_console_locked(void)
 {
@@ -2087,6 +2093,7 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /*
  * Returns true iff there is other cpu waiting to take over printing. This
  * function also takes are of setting PRINTK_HANDOVER_B if we want to hand over
@@ -2113,6 +2120,7 @@ static bool cpu_stop_printing(int printed_chars)
 	}
 	return false;
 }
+#endif
 
 /**
  * console_unlock - unlock the console system
@@ -2155,10 +2163,12 @@ again:
 		size_t len;
 		int level;
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 		if (cpu_stop_printing(printed_chars)) {
 			hand_over = true;
 			break;
 		}
+#endif
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		if (seen_seq != log_next_seq) {
@@ -2576,6 +2586,7 @@ int unregister_console(struct console *console)
 }
 EXPORT_SYMBOL(unregister_console);
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /* Kthread which takes over printing from a CPU which asks for help */
 static int printing_task(void *arg)
 {
@@ -2638,6 +2649,7 @@ static int offload_chars_set(const char *val, const struct kernel_param *kp)
 	mutex_unlock(&printk_kthread_mutex);
 	return 0;
 }
+#endif	/* CONFIG_PRINTK_OFFLOAD */
 
 static int __init printk_late_init(void)
 {
@@ -2650,9 +2662,11 @@ static int __init printk_late_init(void)
 	}
 	hotcpu_notifier(console_cpu_notify, 0);
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 	mutex_lock(&printk_kthread_mutex);
 	printk_start_offload_kthreads();
 	mutex_unlock(&printk_kthread_mutex);
+#endif
 
 	return 0;
 }
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch2_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch2_8.diff"

diff --git a/kernel/printk.c b/kernel/printk/printk.c
index bd7ee2a9f960..7a8ffd89875c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -249,9 +249,6 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int logbuf_cpu = UINT_MAX;
-
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1332,36 +1329,22 @@ static inline int can_use_console(unsigned int cpu)
  * messages from a 'printk'. Return true (and with the
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
  */
 static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
 {
-	int retval = 0, wake = 0;
-
-	if (console_trylock()) {
-		retval = 1;
-
-		/*
-		 * If we can't use the console, we need to release
-		 * the console semaphore by hand to avoid flushing
-		 * the buffer. We need to hold the console semaphore
-		 * in order to do this test safely.
-		 */
-		if (!can_use_console(cpu)) {
-			console_locked = 0;
-			wake = 1;
-			retval = 0;
-		}
-	}
-	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&logbuf_lock);
-	if (wake)
+	if (!console_trylock())
+		return 0;
+	/*
+	 * If we can't use the console, we need to release the console
+	 * semaphore by hand to avoid flushing the buffer. We need to hold the
+	 * console semaphore in order to do this test safely.
+	 */
+	if (!can_use_console(cpu)) {
+		console_locked = 0;
 		up(&console_sem);
-	return retval;
+		return 0;
+	}
+	return 1;
 }
 
 int printk_delay_msec __read_mostly;
@@ -1494,6 +1477,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	/* cpu currently holding logbuf_lock in this function */
+	static volatile unsigned int logbuf_cpu = UINT_MAX;
+
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1609,13 +1595,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 	printed_len += text_len;
 
+	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
-	 *
-	 * The console_trylock_for_printk() function will release 'logbuf_lock'
-	 * regardless of whether it actually gets the console semaphore or not.
 	 */
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch7_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch7_8.diff"

diff --git a/include/linux/console.h b/include/linux/console.h
index 7571a16bd653..c61c169f85b3 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -150,6 +150,7 @@ extern int console_trylock(void);
 extern void console_unlock(void);
 extern void console_conditional_schedule(void);
 extern void console_unblank(void);
+extern void console_flush(void);
 extern struct tty_driver *console_device(int *);
 extern void console_stop(struct console *);
 extern void console_start(struct console *);
diff --git a/kernel/printk.c b/kernel/printk.c
index 8d981b2b5bb1..1c0577383af5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2306,6 +2306,28 @@ struct tty_driver *console_device(int *index)
 }
 
 /*
+ * Wait until all messages accumulated in the printk buffer are printed to
+ * console. Note that as soon as this function returns, new messages may be
+ * added to the printk buffer by other CPUs.
+ */
+void console_flush(void)
+{
+	bool retry;
+	unsigned long flags;
+
+	while (1) {
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		retry = console_seq != log_next_seq;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		if (!retry || console_suspended)
+			break;
+		/* Cycle console_sem to wait for outstanding printing */
+		console_lock();
+		console_unlock();
+	}
+}
+
+/*
  * Prevent further output on the passed console device so that (for example)
  * serial drivers can disable console output before suspending a port, and can
  * re-enable output afterwards.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 84571e09c907..14ac740e0c7f 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -21,5 +21,6 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
+#include <linux/console.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -574,6 +575,14 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 		return ret;
 	}
 
+	/*
+	 * If there are lots of outstanding messages, printing them can take a
+	 * long time and all cpus would be spinning waiting for the printing to
+	 * finish thus triggering NMI watchdog, RCU lockups etc. Wait for the
+	 * printing here to avoid these.
+	 */
+	console_flush();
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&msdata, MULTI_STOP_PREPARE);
 	return stop_cpus(cpu_online_mask, multi_cpu_stop, &msdata);
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch6_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch6_8.diff"

diff --git a/kernel/printk.c b/kernel/printk.c
index cb7e06850eb5..8d981b2b5bb1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -109,6 +109,10 @@ static long printk_handover_state;
  * CPUs.
  */
 #define PRINTING_TASKS 2
+/* Pointers to printing kthreads */
+static struct task_struct *printing_kthread[PRINTING_TASKS];
+/* Serialization of changes to printk_offload_chars and kthread creation */
+static DEFINE_MUTEX(printk_kthread_mutex);
 
 /* Wait queue printing kthreads sleep on when idle */
 static DECLARE_WAIT_QUEUE_HEAD(print_queue); 
@@ -280,6 +284,12 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+static int offload_chars_set(const char *val, const struct kernel_param *kp);
+static struct kernel_param_ops offload_chars_ops = {
+	.set = offload_chars_set,
+	.get = param_get_uint,
+};
+
 /*
  * How many characters can we print in one call of printk before asking
  * other cpus to continue printing. 0 means infinity. Tunable via
@@ -288,7 +298,7 @@ static u32 log_buf_len = __LOG_BUF_LEN;
  */
 static unsigned int __read_mostly printk_offload_chars = 1000;
 
-module_param_named(offload_chars, printk_offload_chars, uint,
+module_param_cb(offload_chars, &offload_chars_ops, &printk_offload_chars,
 		   S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
 	" cpu after this number of characters");
@@ -2571,32 +2581,56 @@ static int printing_task(void *arg)
 	return 0;
 }
 
-static int __init printk_late_init(void)
+static void printk_start_offload_kthreads(void)
 {
-	struct console *con;
 	int i;
 	struct task_struct *task;
 
-	for_each_console(con) {
-		if (!keep_bootcon && con->flags & CON_BOOT) {
-			printk(KERN_INFO "turn off boot console %s%d\n",
-				con->name, con->index);
-			unregister_console(con);
-		}
-	}
-	hotcpu_notifier(console_cpu_notify, 0);
-
-	/* Does any handover of printing have any sence? */
-	if (num_possible_cpus() <= 1)
-		return 0;
-
+	/* Does handover of printing make any sense? */
+	if (printk_offload_chars == 0 || num_possible_cpus() <= 1)
+		return;
 	for (i = 0; i < PRINTING_TASKS; i++) {
+		if (printing_kthread[i])
+			continue;
 		task = kthread_run(printing_task, NULL, "print/%d", i);
 		if (IS_ERR(task)) {
 			pr_err("printk: Cannot create printing thread: %ld\n",
 			       PTR_ERR(task));
 		}
+		printing_kthread[i] = task;
 	}
+}
+
+static int offload_chars_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	/* Protect against parallel change of printk_offload_chars */
+	mutex_lock(&printk_kthread_mutex);
+	ret = param_set_uint(val, kp);
+	if (ret) {
+		mutex_unlock(&printk_kthread_mutex);
+		return ret;
+	}
+	printk_start_offload_kthreads();
+	mutex_unlock(&printk_kthread_mutex);
+	return 0;
+}
+
+static int __init printk_late_init(void)
+{
+	struct console *con;
+
+	for_each_console(con) {
+		if (!keep_bootcon && con->flags & CON_BOOT) {
+			unregister_console(con);
+		}
+	}
+	hotcpu_notifier(console_cpu_notify, 0);
+
+	mutex_lock(&printk_kthread_mutex);
+	printk_start_offload_kthreads();
+	mutex_unlock(&printk_kthread_mutex);
 
 	return 0;
 }
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch1_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch1_8.diff"

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 4dae9cbe9259..bd7ee2a9f960 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -206,8 +206,7 @@ struct printk_log {
 };
 
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters. It is also
- * used in interesting ways to provide interlocking in console_unlock();
+ * The logbuf_lock protects kmsg buffer, indices, counters.
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch5_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch5_8.diff"

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda7077f..74826b1e2529 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2621,6 +2621,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
+	printk.offload_chars=
+			Printing to console can be relatively slow especially
+			in case of serial console. When there is intensive
+			printing happening from several cpus (as is the case
+			during boot), a cpu can be spending significant time
+			(seconds or more) doing printing. To avoid softlockups,
+			lost interrupts, and similar problems other cpus
+			will take over printing after the currently printing
+			cpu has printed 'printk.offload_chars' characters.
+			Higher value means possibly longer interrupt and other
+			latencies but lower overhead of printing due to handing
+			over of printing.
+			Format: <number> (0 = disabled)
+			default: 1000
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 91c554e027c5..cb7e06850eb5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -45,6 +45,7 @@
 #include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 
@@ -87,6 +88,31 @@ static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
+/* State machine for handing over printing */
+enum {
+	/*
+	 * Set by the holder of console_sem if currently printing task wants to
+	 * hand over printing. Cleared before console_sem is released.
+	 */
+	PRINTK_HANDOVER_B,
+	/*
+	 * Set if there's someone spinning on console_sem to take over printing.
+	 * Cleared after acquiring console_sem.
+	 */
+	PRINTK_CONSOLE_SPIN_B,
+};
+static long printk_handover_state;
+
+/*
+ * Number of kernel threads for offloading printing. We need at least two so
+ * that they can hand over printing from one to another one and thus switch
+ * CPUs.
+ */
+#define PRINTING_TASKS 2
+
+/* Wait queue printing kthreads sleep on when idle */
+static DECLARE_WAIT_QUEUE_HEAD(print_queue); 
+
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
 	.name = "console_lock"
@@ -254,6 +280,19 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * How many characters can we print in one call of printk before asking
+ * other cpus to continue printing. 0 means infinity. Tunable via
+ * printk.offload_chars kernel parameter. Our default 1000 means about
+ * 0.1s maximum latency due to printing.
+ */
+static unsigned int __read_mostly printk_offload_chars = 1000;
+
+module_param_named(offload_chars, printk_offload_chars, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
+	" cpu after this number of characters");
+
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1942,6 +1981,7 @@ void console_lock(void)
 	if (console_suspended)
 		return;
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 1;
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
@@ -1964,12 +2004,45 @@ int console_trylock(void)
 		return 0;
 	}
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 0;
 	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
 
+/*
+ * This is a version of console_lock() which spins to acquire console_sem.
+ * It is only for use by threads that take care of flushing printk buffer so
+ * that they can be sure they are not preempted while waiting for console_sem.
+ *
+ * The function returns 1 if we acquired console_sem, 0 if we failed (either
+ * someone else is already spinning, someone acquired console_sem, or console
+ * is suspended).
+ */
+static int console_lock_try_spin(void)
+{
+	WARN_ON_ONCE(preemptible());
+	/* Someone already spinning? Don't waste cpu time... */
+	if (test_and_set_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+		return 0;
+	while (down_trylock(&console_sem)) {
+		/* Someone else took console_sem? */
+		if (!test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+			return 0;
+		cpu_relax();
+	}
+	printk_handover_state = 0;
+	if (console_suspended) {
+		up(&console_sem);
+		return 0;
+	}
+	console_locked = 1;
+	console_may_schedule = 0;
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
+	return 1;
+}
+
 int is_console_locked(void)
 {
 	return console_locked;
@@ -2004,15 +2077,44 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+/*
+ * Returns true iff there is other cpu waiting to take over printing. This
+ * function also takes are of setting PRINTK_HANDOVER_B if we want to hand over
+ * printing to some other cpu.
+ */
+static bool cpu_stop_printing(int printed_chars)
+{
+	/* Oops? Print everything now to maximize chances user will see it */
+	if (oops_in_progress)
+		return false;
+	if (!printk_offload_chars || printed_chars < printk_offload_chars)
+		return false;
+	/* Someone is spinning on console_sem? Give away to him. */
+	if (test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+		return true;
+	if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state)) {
+		set_bit(PRINTK_HANDOVER_B, &printk_handover_state);
+		/*
+		 * Paired with barrier in prepare_to_wait_exclusive() in
+		 * printing_task()
+		 */
+		smp_mb();
+		wake_up(&print_queue);
+	}
+	return false;
+}
+
 /**
  * console_unlock - unlock the console system
  *
  * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * While the console_lock was held, console output may have been buffered by
+ * printk(). If this is the case, console_unlock() emits the output prior to
+ * releasing the lock. However we need not write all the data in the buffer if
+ * we would hog the CPU for too long. In such case we try to hand over printing
+ * to a different cpu.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
@@ -2025,6 +2127,8 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	bool hand_over = false;
+	int printed_chars = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2041,6 +2145,11 @@ again:
 		size_t len;
 		int level;
 
+		if (cpu_stop_printing(printed_chars)) {
+			hand_over = true;
+			break;
+		}
+
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		if (seen_seq != log_next_seq) {
 			wake_klogd = true;
@@ -2054,8 +2163,10 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == log_next_seq) {
+			raw_spin_unlock(&logbuf_lock);
 			break;
+		}
 
 		msg = log_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
@@ -2086,31 +2197,39 @@ skip:
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
+		printed_chars += len;
 		local_irq_restore(flags);
 	}
-	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	raw_spin_unlock(&logbuf_lock);
-
+	/* Save modification of printk_handover_state in the common fast path */
+	if (test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
+		clear_bit(PRINTK_HANDOVER_B, &printk_handover_state);
+	console_locked = 0;
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 	up(&console_sem);
 
 	/*
-	 * Someone could have filled up the buffer again, so re-check if there's
-	 * something to flush. In case we cannot trylock the console_sem again,
-	 * there's a new owner and the console_unlock() from them will do the
-	 * flush, no worries.
+	 * Subtlety: We have interrupts disabled iff hand_over == false (to
+	 * save one cli/sti pair in the fast path.
 	 */
-	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (!hand_over) {
+		/*
+		 * Someone could have filled up the buffer again, so re-check
+		 * if there's something to flush. In case we cannot trylock the
+		 * console_sem again, there's a new owner and the
+		 * console_unlock() from them will do the flush, no worries.
+		 */
+		raw_spin_lock(&logbuf_lock);
+		retry = console_seq != log_next_seq;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
-		goto again;
+		if (retry && console_trylock())
+			goto again;
+	}
 
 	if (wake_klogd)
 		wake_up_klogd();
@@ -2148,6 +2267,7 @@ void console_unblank(void)
 		console_lock();
 
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 0;
 	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
@@ -2424,9 +2544,38 @@ int unregister_console(struct console *console)
 }
 EXPORT_SYMBOL(unregister_console);
 
+/* Kthread which takes over printing from a CPU which asks for help */
+static int printing_task(void *arg)
+{
+	DEFINE_WAIT(wait);
+
+	while (1) {
+		prepare_to_wait_exclusive(&print_queue, &wait,
+					  TASK_INTERRUPTIBLE);
+		if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
+			schedule();
+		finish_wait(&print_queue, &wait);
+		/*
+		 * We don't want to be scheduled away once we got the CPU (that
+		 * would be especially problematic if we hold console_sem at
+		 * that moment since noone else could print to console). So
+		 * disable preemption and spin on console_sem. We shouldn't
+		 * spin for long since printing CPU drops console_sem as soon
+		 * as it notices there is someone spinning on it.
+		 */
+		preempt_disable();
+		if (console_lock_try_spin())
+			console_unlock();
+		preempt_enable();
+	}
+	return 0;
+}
+
 static int __init printk_late_init(void)
 {
 	struct console *con;
+	int i;
+	struct task_struct *task;
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
@@ -2434,6 +2583,19 @@ static int __init printk_late_init(void)
 		}
 	}
 	hotcpu_notifier(console_cpu_notify, 0);
+
+	/* Does any handover of printing have any sence? */
+	if (num_possible_cpus() <= 1)
+		return 0;
+
+	for (i = 0; i < PRINTING_TASKS; i++) {
+		task = kthread_run(printing_task, NULL, "print/%d", i);
+		if (IS_ERR(task)) {
+			pr_err("printk: Cannot create printing thread: %ld\n",
+			       PTR_ERR(task));
+		}
+	}
+
 	return 0;
 }
 late_initcall(printk_late_init);
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch3_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch3_8.diff"

diff --git a/kernel/printk.c b/kernel/printk.c
index 7a8ffd89875c..56649edfae9c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1314,10 +1314,9 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1330,8 +1329,10 @@ static inline int can_use_console(unsigned int cpu)
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1501,7 +1502,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1597,17 +1599,22 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
+
+	/*
+	 * Disable preemption to avoid being preempted while holding
+	 * console_sem which would prevent anyone from printing to console
+	 */
+	preempt_disable();
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
 	 */
-	if (console_trylock_for_printk(this_cpu))
+	if (console_trylock_for_printk())
 		console_unlock();
-
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
+	preempt_enable();
 
 	return printed_len;
 }
-- 
1.8.1.4

  



--------------080809080208060304090407
Content-Type: text/x-patch;
 name="patch4_8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch4_8.diff"

diff --git a/kernel/printk.c b/kernel/printk.c
index 56649edfae9c..91c554e027c5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -68,6 +68,9 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
+/* Deferred messaged from sched code are marked by this special level */
+#define SCHED_MESSAGE_LOGLEVEL -2
+
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -206,7 +209,9 @@ struct printk_log {
 };
 
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters.
+ * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
+ * within the scheduler's rq lock. It must be released before calling
+ * console_unlock() or anything else that might wake up a process.
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
@@ -1473,14 +1478,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 	static int recursion_bug;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
-	size_t text_len;
+	size_t text_len = 0;
 	enum log_flags lflags = 0;
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
+	if (level == SCHED_MESSAGE_LOGLEVEL) {
+		level = -1;
+		in_sched = true;
+	}
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1527,7 +1537,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * The printf needs to come first; we need the syslog
 	 * prefix which might be passed-in as a parameter.
 	 */
-	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
+	if (in_sched)
+		text_len = scnprintf(text, sizeof(textbuf),
+				     KERN_WARNING "[sched_delayed] ");
+
+	text_len += vscnprintf(text + text_len,
+			       sizeof(textbuf) - text_len, fmt, args);
 
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
@@ -1602,6 +1617,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 	lockdep_on();
 	local_irq_restore(flags);
 
+	/* If called from the scheduler, we can not call up(). */
+	if (in_sched)
+		return printed_len;
+
 	/*
 	 * Disable preemption to avoid being preempted while holding
 	 * console_sem which would prevent anyone from printing to console
@@ -2423,21 +2442,19 @@ late_initcall(printk_late_init);
 /*
  * Delayed printk version, for scheduler-internal messages:
  */
-#define PRINTK_BUF_SIZE		512
-
 #define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_SCHED	0x02
+#define PRINTK_PENDING_OUTPUT	0x02
 
 static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
 static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
-	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
-		printk(KERN_WARNING "[sched_delayed] %s", buf);
+	if (pending & PRINTK_PENDING_OUTPUT) {
+		/* If trylock fails, someone else is doing the printing */
+		if (console_trylock())
+			console_unlock();
 	}
 
 	if (pending & PRINTK_PENDING_WAKEUP)
@@ -2461,21 +2478,15 @@ void wake_up_klogd(void)
 
 int printk_sched(const char *fmt, ...)
 {
-	unsigned long flags;
 	va_list args;
-	char *buf;
 	int r;
 
-	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
-
 	va_start(args, fmt);
-	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
 	va_end(args);
 
-	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
-	local_irq_restore(flags);
 
 	return r;
 }
-- 
1.8.1.4

  



--------------080809080208060304090407--
