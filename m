Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3IWVgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:36:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34881 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3IWVgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:36:33 -0400
Date: Mon, 23 Sep 2013 14:35:24 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] printk: report console names during cut-over
Message-ID: <20130923213523.GA23478@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reports the names of consoles as they're being disabled to help
identify which is which during cut-over. Helps answer the question
"which boot console actually got activated?" once the regular console
is running, mostly when debugging boot console failures.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - move disable message into unregister_console, suggested by Frederic
   Weisbecker.
---
 kernel/printk/printk.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..555ad2d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2358,21 +2358,18 @@ void register_console(struct console *newcon)
 	 * users know there might be something in the kernel's log buffer that
 	 * went to the bootconsole (that they do not see on the real console)
 	 */
+	printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+		(newcon->flags & CON_BOOT) ? "boot" : "" ,
+		newcon->name, newcon->index);
 	if (bcon &&
 	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
 	    !keep_bootcon) {
-		/* we need to iterate through twice, to make sure we print
-		 * everything out, before we unregister the console(s)
+		/* We need to iterate through all boot consoles, to make
+		 * sure we print everything out, before we unregister them.
 		 */
-		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
-			newcon->name, newcon->index);
 		for_each_console(bcon)
 			if (bcon->flags & CON_BOOT)
 				unregister_console(bcon);
-	} else {
-		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
-			(newcon->flags & CON_BOOT) ? "boot" : "" ,
-			newcon->name, newcon->index);
 	}
 }
 EXPORT_SYMBOL(register_console);
@@ -2382,6 +2379,10 @@ int unregister_console(struct console *console)
         struct console *a, *b;
 	int res;
 
+	printk(KERN_INFO "%sconsole [%s%d] disabled\n",
+		(console->flags & CON_BOOT) ? "boot" : "" ,
+		console->name, console->index);
+
 	res = _braille_unregister_console(console);
 	if (res)
 		return res;
@@ -2421,8 +2422,6 @@ static int __init printk_late_init(void)
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
-			printk(KERN_INFO "turn off boot console %s%d\n",
-				con->name, con->index);
 			unregister_console(con);
 		}
 	}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
