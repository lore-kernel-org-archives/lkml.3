Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaBHPoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 10:44:09 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:47091 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbaBHPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 10:44:07 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgQAIpP9lJXQADb/2dsb2JhbABZKIJkgz69DgICgQcXdIJmHCMYgQI3iAkBy3AXjn0dhCIEiUeOYwGKT4dSgzov
Date: Sat, 8 Feb 2014 15:45:22 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>
Subject: [PATCH 1/1] kernel: panic: display reason at end + pr_emerg
Message-Id: <20140208154522.aa927a34df7b018c5eee47ef@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, booting without initrd specified on 80x25 screen
gives a call trace followed by atkbd : Spurious ACK.
Original message ("VFS: Unable to mount root fs") is not available.
Of course this could happen in other situations...

-This patch displays panic reason after call trace which could help
lot of people even if it's not the very last line on screen.

-Converting all panic.c printk(KERN_EMERG to pr_emerg(

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/panic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..b71d520 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -100,7 +100,7 @@ void panic(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	pr_emerg("Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
@@ -141,7 +141,7 @@ void panic(const char *fmt, ...)
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
 		 */
-		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+		pr_emerg("Rebooting in %d seconds..", panic_timeout);
 
 		for (i = 0; i < panic_timeout * 1000; i += PANIC_TIMER_STEP) {
 			touch_nmi_watchdog();
@@ -165,7 +165,7 @@ void panic(const char *fmt, ...)
 		extern int stop_a_enabled;
 		/* Make sure the user can actually press Stop-A (L1-A) */
 		stop_a_enabled = 1;
-		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+		pr_emerg("Press Stop-A (L1-A) to return to the boot prom\n");
 	}
 #endif
 #if defined(CONFIG_S390)
@@ -176,6 +176,7 @@ void panic(const char *fmt, ...)
 		disabled_wait(caller);
 	}
 #endif
+	pr_emerg("---[ end Kernel panic - not syncing: %s\n", buf);
 	local_irq_enable();
 	for (i = 0; ; i += PANIC_TIMER_STEP) {
 		touch_softlockup_watchdog();
-- 
1.8.1.4

