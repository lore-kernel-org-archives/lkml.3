Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab3CLTi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:38:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:39004 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753611Ab3CLTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:25 -0400
Message-Id: <20130312193823.633034113@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:25 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 02/14] KDB: fix errant character in KDB show regs
Content-Disposition: inline; filename=kdb-fix-show-regs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When KDB prints the process regs and backtrace, every line is preceeded
with the character 'd'.  This is the level argument to printk which
is not interpreted when KDB is printing.  Skip over this possible
printk level in the outgoing string to fix this.

Here is a small sample:

dRIP: 0010:[<ffffffff814e96ca>]  [<ffffffff814e96ca>] poll_idle+0x4a/0x90
dRSP: 0018:ffff88081d5eddd8  EFLAGS: 00000246
dRAX: 0000000400000000 RBX: 00000216ae7fbf5d RCX: 0000021658a8e600
dRDX: ffff88081d5ec010 RSI: ffffffff819a7d20 RDI: ffffffff8193c140

Cc: Tim Bird <tim.bird@am.sony.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/kdb/kdb_io.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- linux.orig/kernel/debug/kdb/kdb_io.c
+++ linux/kernel/debug/kdb/kdb_io.c
@@ -559,6 +559,7 @@ int vkdb_printf(const char *fmt, va_list
 	int retlen = 0;
 	int fnd, len;
 	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
+	const char *ostring;
 	char *moreprompt = "more> ";
 	struct console *c = console_drivers;
 	static DEFINE_SPINLOCK(kdb_printf_lock);
@@ -690,20 +691,21 @@ kdb_printit:
 	/*
 	 * Write to all consoles.
 	 */
-	retlen = strlen(kdb_buffer);
+	ostring = printk_skip_level(kdb_buffer);
+	retlen = strlen(ostring);
 	if (!dbg_kdb_mode && kgdb_connected) {
-		gdbstub_msg_write(kdb_buffer, retlen);
+		gdbstub_msg_write(ostring, retlen);
 	} else {
 		if (dbg_io_ops && !dbg_io_ops->is_console) {
 			len = retlen;
-			cp = kdb_buffer;
+			cp = (char *)ostring;
 			while (len--) {
 				dbg_io_ops->write_char(*cp);
 				cp++;
 			}
 		}
 		while (c) {
-			c->write(c, kdb_buffer, retlen);
+			c->write(c, ostring, retlen);
 			touch_nmi_watchdog();
 			c = c->next;
 		}
@@ -711,7 +713,7 @@ kdb_printit:
 	if (logging) {
 		saved_loglevel = console_loglevel;
 		console_loglevel = 0;
-		printk(KERN_INFO "%s", kdb_buffer);
+		pr_info("%s", ostring);
 	}
 
 	if (KDB_STATE(PAGER)) {
@@ -723,10 +725,10 @@ kdb_printit:
 		int got = 0;
 		len = retlen;
 		while (len--) {
-			if (kdb_buffer[len] == '\n') {
+			if (ostring[len] == '\n') {
 				kdb_nextline++;
 				got = 0;
-			} else if (kdb_buffer[len] == '\r') {
+			} else if (ostring[len] == '\r') {
 				got = 0;
 			} else {
 				got++;

-- 
