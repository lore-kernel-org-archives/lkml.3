Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbaKNDV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:21:58 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:53756 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbaKNDV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:21:57 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>,
        Jan Kara <jack@suse.cz>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Alex Elder <elder@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile type
Date: Thu, 13 Nov 2014 22:21:21 -0500
Message-Id: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove volatile type qualifier and use ACCESS_ONCE() in its place for each
access. Using volatile is not recommended as documented in
Documentation/volatile-considered-harmful.txt.

Here logbuf_cpu is a local variable and it is not clear how it is being accessed
concurrently. We should remove volatile accesses entirely here, but for now make
a safer change of using ACCESS_ONCE().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/printk/printk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e748971..4790191 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1624,7 +1624,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int printed_len = 0;
 	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
-	static volatile unsigned int logbuf_cpu = UINT_MAX;
+	static unsigned int logbuf_cpu = UINT_MAX;
 
 	if (level == LOGLEVEL_SCHED) {
 		level = LOGLEVEL_DEFAULT;
@@ -1641,7 +1641,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
-	if (unlikely(logbuf_cpu == this_cpu)) {
+	if (unlikely(ACCESS_ONCE(logbuf_cpu) == this_cpu)) {
 		/*
 		 * If a crash is occurring during printk() on this CPU,
 		 * then try to get the crash message out but make sure
@@ -1659,7 +1659,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	lockdep_off();
 	raw_spin_lock(&logbuf_lock);
-	logbuf_cpu = this_cpu;
+	ACCESS_ONCE(logbuf_cpu) = this_cpu;
 
 	if (unlikely(recursion_bug)) {
 		static const char recursion_msg[] =
@@ -1754,7 +1754,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 						 dict, dictlen, text, text_len);
 	}
 
-	logbuf_cpu = UINT_MAX;
+	ACCESS_ONCE(logbuf_cpu) = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
 	lockdep_on();
 	local_irq_restore(flags);
-- 
1.9.1

