Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3B1XEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:04:39 -0500
Received: from longford.logfs.org ([213.229.74.203]:58548 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3B1XEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:04:36 -0500
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
        Jeff Moyer <jmoyer@redhat.com>, Joern Engel <joern@logfs.org>
Subject: [PATCH 3/9] printk: add CON_ALLDATA console flag
Date: Thu, 28 Feb 2013 16:39:56 -0500
Message-Id: <1362087602-8979-4-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1362087602-8979-1-git-send-email-joern@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consoles like netconsole and blockconsole the loglevel filtering
really doesn't make any sense.  If a line gets printed at all, please
send it down to that console, no questions asked.

For vga_con, it is a completely different matter, as the user sitting in
front of his console could get spammed by messages while trying to login
or similar.  So ignore_loglevel doesn't work as a one-size-fits-all
approach.  Add a per-console flag instead so that netconsole and
blockconsole can opt-in.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 include/linux/console.h |    1 +
 kernel/printk.c         |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index dedb082..eed92ad 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -116,6 +116,7 @@ static inline int con_debug_leave(void)
 #define CON_BOOT	(8)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
 #define CON_BRL		(32) /* Used for a braille device */
+#define CON_ALLDATA	(64) /* per-console ignore_loglevel */
 
 struct console {
 	char	name[16];
diff --git a/kernel/printk.c b/kernel/printk.c
index 267ce78..5221c59 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1261,8 +1261,6 @@ static void call_console_drivers(int level, const char *text, size_t len)
 
 	trace_console(text, 0, len, len);
 
-	if (level >= console_loglevel && !ignore_loglevel)
-		return;
 	if (!console_drivers)
 		return;
 
@@ -1276,6 +1274,9 @@ static void call_console_drivers(int level, const char *text, size_t len)
 		if (!cpu_online(smp_processor_id()) &&
 		    !(con->flags & CON_ANYTIME))
 			continue;
+		if (level >= console_loglevel && !ignore_loglevel &&
+		    !(con->flags & CON_ALLDATA))
+			continue;
 		con->write(con, text, len);
 	}
 }
-- 
1.7.10.4

