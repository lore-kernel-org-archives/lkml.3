Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaLWVWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:22:16 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:59856 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaLWVWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:22:15 -0500
Date: Tue, 23 Dec 2014 22:22:10 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 1/3] printk: Use a flag to indicate console-private loglevel
Message-ID: <20141223222210.76336cd5@neptune.home>
In-Reply-To: <20141220224908.GB4466@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to set loglevel for a given console that is not affected by
global loglevel as adjusted via syslog(2), add a flag to the console and
choose the level to match against msg level depending on this flag.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
This depends on Daniel's patch "printk: add per console loglevel"
and modifies the way its filtering is applied.


 include/linux/console.h |  1 +
 kernel/printk/printk.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index 99020d5..f3a8996 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -115,6 +115,7 @@ static inline int con_debug_leave(void)
 #define CON_BOOT	(8)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
 #define CON_BRL		(32) /* Used for a braille device */
+#define CON_LOGLEVEL	(64) /* Per-console log-level filtering */
 
 struct console {
 	char	name[16];
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 218d94d..8f09f30 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1399,12 +1399,12 @@ static void call_console_drivers(int level, const char *text, size_t len)
 
 	trace_console(text, len);
 
-	if (level >= console_loglevel && !ignore_loglevel)
-		return;
 	if (!console_drivers)
 		return;
 
 	for_each_console(con) {
+		if (!ignore_loglevel && level >= (con->flags & CON_LOGLEVEL ? con->loglevel : console_loglevel))
+			continue;
 		if (exclusive_console && con != exclusive_console)
 			continue;
 		if (!(con->flags & CON_ENABLED))
@@ -1414,9 +1414,6 @@ static void call_console_drivers(int level, const char *text, size_t len)
 		if (!cpu_online(smp_processor_id()) &&
 		    !(con->flags & CON_ANYTIME))
 			continue;
-		if (con->loglevel && !ignore_loglevel &&
-		    level >= con->loglevel)
-			continue;
 		con->write(con, text, len);
 	}
 }
@@ -2512,7 +2509,10 @@ void register_console(struct console *newcon)
 		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
 
-		newcon->loglevel = c->loglevel;
+		if (c->loglevel) {
+			newcon->loglevel = c->loglevel;
+			newcon->flags |= CON_LOGLEVEL;
+		}
 		newcon->flags |= CON_ENABLED;
 		newcon->index = c->index;
 		if (i == selected_console) {
-- 
2.0.4

