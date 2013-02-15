Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3BOQyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:54:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab3BOQyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:54:44 -0500
Date: Fri, 15 Feb 2013 17:54:40 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        jslaby@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH] printk: Remove separate printk_sched buffers and
 use printk buf instead
Message-ID: <20130215165440.GA12734@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
 <20130206230220.GA18329@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206230220.GA18329@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes addition to Steven's patch from this thread...

>From bda93cfa4133c41e8f10dcd371d1f025d94b85dc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 6 Feb 2013 19:15:30 +0100
Subject: [PATCH 2/3] printk: Remove per-cpu printk flags

There's no need to have printk flags percpu. Just make a single variable
operated by atomic operations from it. It also has an advantage that any
cpu can do the printing / wakeup work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index ed630fa..2fe917d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1986,28 +1986,24 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-/*
- * Delayed printk version, for scheduler-internal messages:
- */
-#define PRINTK_BUF_SIZE		512
+#define PRINTK_PENDING_WAKEUP	1
+#define PRINTK_PENDING_OUTPUT	2
 
-#define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_OUTPUT	0x02
-
-static DEFINE_PER_CPU(int, printk_pending);
+static unsigned long printk_pending;
 
 void printk_tick(void)
 {
-	if (__this_cpu_read(printk_pending)) {
-		int pending = __this_cpu_xchg(printk_pending, 0);
-		if (pending & PRINTK_PENDING_OUTPUT) {
+	if (printk_pending) {
+		unsigned long pending = xchg(&printk_pending, 0);
+
+		if (test_bit(PRINTK_PENDING_OUTPUT, &pending)) {
 			if (console_trylock())
 				console_unlock();
 			else
 				/* Try again later */
-				__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+				set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
 		}
-		if (pending & PRINTK_PENDING_WAKEUP)
+		if (test_bit(PRINTK_PENDING_WAKEUP, &pending))
 			wake_up_interruptible(&log_wait);
 	}
 }
@@ -2016,13 +2012,13 @@ int printk_needs_cpu(int cpu)
 {
 	if (cpu_is_offline(cpu))
 		printk_tick();
-	return __this_cpu_read(printk_pending);
+	return printk_pending;
 }
 
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+		set_bit(PRINTK_PENDING_WAKEUP, &printk_pending);
 }
 
 static void console_cont_flush(char *text, size_t size)
@@ -2497,7 +2493,7 @@ int printk_sched(const char *fmt, ...)
 	r = vprintk_emit(0, -2, NULL, 0, fmt, args);
 	va_end(args);
 
-	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+	set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
 
 	return r;
 }
-- 
1.7.1

