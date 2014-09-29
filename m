Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaI2L7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:59:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbaI2L7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:17 -0400
From: Hannes Reinecke <hare@suse.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/38] Externalize string buffer for printk
Date: Mon, 29 Sep 2014 13:58:57 +0200
Message-Id: <1411991947-130166-29-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits off the actual logging from vprintk_emit()
into printk_emit_string(), with vprintk_emit() just being a
simple wrapper for formatting the message into a
static buffer.

With that the caller can pass in a local buffer for
printk_emit_string() without increasing the overall stack size.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/printk.h |  5 +++++
 kernel/printk/printk.c | 36 ++++++++++++++++++++++++------------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f..9639900 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -130,6 +130,11 @@ int vprintk_emit(int facility, int level,
 		 const char *dict, size_t dictlen,
 		 const char *fmt, va_list args);
 
+asmlinkage
+int printk_emit_string(int facility, int level,
+		       const char *dict, size_t dictlen,
+		       char *textbuf, size_t text_len);
+
 asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index d13675e..303a1fe 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1618,22 +1618,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    const char *dict, size_t dictlen,
 			    const char *fmt, va_list args)
 {
-	static int recursion_bug;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len = 0;
-	enum log_flags lflags = 0;
-	unsigned long flags;
-	int this_cpu;
-	int printed_len = 0;
-	bool in_sched = false;
-	/* cpu currently holding logbuf_lock in this function */
-	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 	if (level == SCHED_MESSAGE_LOGLEVEL) {
-		level = -1;
-		in_sched = true;
-
 		/*
 		 * The printf needs to come first; we need the syslog
 		 * prefix which might be passed-in as a parameter.
@@ -1644,6 +1633,24 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	text_len += vscnprintf(text + text_len,
 			       sizeof(textbuf) - text_len, fmt, args);
+	return printk_emit_string(facility, level, dict, dictlen,
+				  textbuf, text_len);
+}
+EXPORT_SYMBOL(vprintk_emit);
+
+asmlinkage int printk_emit_string(int facility, int level,
+				  const char *dict, size_t dictlen,
+				  char *textbuf, size_t text_len)
+{
+	static int recursion_bug;
+	char *text = textbuf;
+	enum log_flags lflags = 0;
+	unsigned long flags;
+	int this_cpu;
+	int printed_len = 0;
+	bool in_sched = false;
+	/* cpu currently holding logbuf_lock in this function */
+	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1652,6 +1659,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 	local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
+	if (level == SCHED_MESSAGE_LOGLEVEL) {
+		level = -1;
+		in_sched = true;
+	}
+
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
@@ -1789,7 +1801,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	return printed_len;
 }
-EXPORT_SYMBOL(vprintk_emit);
+EXPORT_SYMBOL(printk_emit_string);
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-- 
1.8.5.2

