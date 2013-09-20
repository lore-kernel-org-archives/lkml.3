Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3ITPeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:34:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54041 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab3ITPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:34:14 -0400
Date: Fri, 20 Sep 2013 08:34:01 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RESEND] printk: report boot console names during cut-over
Message-ID: <20130920153400.GA32516@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reports the names of boot consoles as they're being disabled to
help identify which is which during cut-over. Helps answer the question
"which boot console actually got activated?" once the regular console
is running, mostly when debugging boot console failures.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/printk/printk.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..0dc54c9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2361,14 +2361,18 @@ void register_console(struct console *newcon)
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
-		for_each_console(bcon)
-			if (bcon->flags & CON_BOOT)
+		for_each_console(bcon) {
+			if (bcon->flags & CON_BOOT) {
+				printk(KERN_INFO "console [%s%d] enabled, "
+					"bootconsole [%s%d] disabled\n",
+					newcon->name, newcon->index,
+					bcon->name, bcon->index);
 				unregister_console(bcon);
+			}
+		}
 	} else {
 		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
 			(newcon->flags & CON_BOOT) ? "boot" : "" ,
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
