Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaKGSsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:48:09 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46393 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaKGSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:48:07 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Joe Perches <joe@perches.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
Date: Fri,  7 Nov 2014 18:47:50 +0000
Message-Id: <1415386070-18850-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
References: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when kdb traps printk messages then the raw log level prefix
(consisting of '\001' followed by a numeral) does not get stripped off
before the message is issued to the various I/O handlers supported by
kdb. This causes annoying visual noise as well as causing problems
grepping for ^. It is also a change of behaviour compared to normal usage
of printk() usage. For example <SysRq>-h ends up with different output to
that of kdb's "sr h".

This patch addresses the problem by stripping log levels from messages
before they are issued to the I/O handlers. printk() which can also
act as an i/o handler in some cases is special cased; if the caller
provided a log level then the prefix will be preserved when sent to
printk().

The addition of non-printable characters to the output of kdb commands is a
regression, albeit and extremely elderly one, introduced by commit
04d2c8c83d0e ("printk: convert the format for KERN_<LEVEL> to a 2 byte
pattern"). Note also that this patch does *not* restore the original
behaviour from v3.5. Instead it makes printk() from within a kdb command
display the message without any prefix (i.e. like printk() normally does).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: stable@vger.kernel.org
---

Notes:
    This patch is tested both on arm (kgdboc=ttyAMA0) and x86_64
    (kgdboc=kdb,ttyS0).
    
    v3:
    
    * Introduce enum kdb_msgsrc to further improve the fidelity of messages
      that hit the log (Joe Perches). The output of "sr h" benefits a lot
      from this change.
    
    v2:
    
    * Adopt printk_skip_level() to skip the header characters (Joe Perches).
    
    * Update patch description to describe the addition of non-printable
      characters to kdb output as a regression and Cc: stable@ (Joe Perches).
    

 include/linux/kdb.h       |  8 +++++++-
 kernel/debug/kdb/kdb_io.c | 22 +++++++++++++---------
 kernel/printk/printk.c    |  2 +-
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 290db1269c4c..204901ae003a 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -112,8 +112,14 @@ typedef enum {
 	KDB_REASON_SYSTEM_NMI,	/* In NMI due to SYSTEM cmd; regs valid */
 } kdb_reason_t;

+enum kdb_msgsrc {
+	KDB_MSGSRC_INTERNAL, /* direct call to kdb_printf() */
+	KDB_MSGSRC_PRINTK, /* trapped from printk() */
+};
+
 extern int kdb_trap_printk;
-extern __printf(1, 0) int vkdb_printf(const char *fmt, va_list args);
+extern __printf(2, 0) int vkdb_printf(enum kdb_msgsrc src, const char *fmt,
+				      va_list args);
 extern __printf(1, 2) int kdb_printf(const char *, ...);
 typedef __printf(1, 2) int (*kdb_printf_t)(const char *, ...);

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 7c70812caea5..a550afb99ebe 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -548,7 +548,7 @@ static int kdb_search_string(char *searched, char *searchfor)
 	return 0;
 }

-int vkdb_printf(const char *fmt, va_list ap)
+int vkdb_printf(enum kdb_msgsrc src, const char *fmt, va_list ap)
 {
 	int diag;
 	int linecount;
@@ -691,19 +691,20 @@ kdb_printit:
 	 * Write to all consoles.
 	 */
 	retlen = strlen(kdb_buffer);
+	cp = (char *) printk_skip_level(kdb_buffer);
 	if (!dbg_kdb_mode && kgdb_connected) {
-		gdbstub_msg_write(kdb_buffer, retlen);
+		gdbstub_msg_write(cp, retlen - (cp - kdb_buffer));
 	} else {
 		if (dbg_io_ops && !dbg_io_ops->is_console) {
-			len = retlen;
-			cp = kdb_buffer;
+			len = retlen - (cp - kdb_buffer);
+			cp2 = cp;
 			while (len--) {
-				dbg_io_ops->write_char(*cp);
-				cp++;
+				dbg_io_ops->write_char(*cp2);
+				cp2++;
 			}
 		}
 		while (c) {
-			c->write(c, kdb_buffer, retlen);
+			c->write(c, cp, retlen - (cp - kdb_buffer));
 			touch_nmi_watchdog();
 			c = c->next;
 		}
@@ -711,7 +712,10 @@ kdb_printit:
 	if (logging) {
 		saved_loglevel = console_loglevel;
 		console_loglevel = CONSOLE_LOGLEVEL_SILENT;
-		printk(KERN_INFO "%s", kdb_buffer);
+		if (printk_get_level(kdb_buffer) || src == KDB_MSGSRC_PRINTK)
+			printk("%s", kdb_buffer);
+		else
+			pr_info("%s", kdb_buffer);
 	}

 	if (KDB_STATE(PAGER)) {
@@ -844,7 +848,7 @@ int kdb_printf(const char *fmt, ...)
 	int r;

 	va_start(ap, fmt);
-	r = vkdb_printf(fmt, ap);
+	r = vkdb_printf(KDB_MSGSRC_INTERNAL, fmt, ap);
 	va_end(ap);

 	return r;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84b1cb7..3a884ab1b9cb 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1836,7 +1836,7 @@ asmlinkage __visible int printk(const char *fmt, ...)
 #ifdef CONFIG_KGDB_KDB
 	if (unlikely(kdb_trap_printk)) {
 		va_start(args, fmt);
-		r = vkdb_printf(fmt, args);
+		r = vkdb_printf(KDB_MSGSRC_PRINTK, fmt, args);
 		va_end(args);
 		return r;
 	}
--
1.9.3

