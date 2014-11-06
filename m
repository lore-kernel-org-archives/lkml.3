Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaKFP1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:27:32 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49227 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:27:30 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RESEND PATCH 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
Date: Thu,  6 Nov 2014 15:27:06 +0000
Message-Id: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411555097-16924-1-git-send-email-daniel.thompson@linaro.org>
References: <1411555097-16924-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when kdb traps printk messages then the raw log level prefix
(consisting of '\001' followed by a numeral) does not get stripped off
before the message is issued to the various I/O handlers supported by
kdb. This causes annoying visual noise as well as causing problems
grepping for ^. It is also a change of behaviour compared to normal usage
of printk() usage. For example <SysRq>-h ends up with different to that of
kdb's "sr h".

This patch addresses the problem by stripping log levels from messages
before they are issued to the I/O handlers.

printk(), which is used as an I/O handler for logging purposes, is
handled as a special case; if the caller provided a log level then this
will be preserved.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
---

Notes:
    This patch is tested both on arm (kgdboc=ttyAMA0) and x86_64
    (kgdboc=kdb,ttyS0).
    

 kernel/debug/kdb/kdb_io.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 7c70812..381f297 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -691,19 +691,22 @@ kdb_printit:
 	 * Write to all consoles.
 	 */
 	retlen = strlen(kdb_buffer);
+	cp = kdb_buffer;
+	if (cp[0] == KERN_SOH_ASCII && cp[1] != '\0')
+		cp += 2;
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
@@ -711,7 +714,10 @@ kdb_printit:
 	if (logging) {
 		saved_loglevel = console_loglevel;
 		console_loglevel = CONSOLE_LOGLEVEL_SILENT;
-		printk(KERN_INFO "%s", kdb_buffer);
+		if (cp == kdb_buffer)
+			printk(KERN_INFO "%s", kdb_buffer);
+		else
+			printk("%s", kdb_buffer);
 	}

 	if (KDB_STATE(PAGER)) {
--
1.9.3

