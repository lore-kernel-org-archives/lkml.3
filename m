Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaLWVh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:37:29 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:41573 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaLWVh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:37:27 -0500
Date: Tue, 23 Dec 2014 22:37:22 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dwalker@fifo99.com, Matt Mackall <mpm@selenic.com>,
        Satyam Sharma <satyam.sharma@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 3/3] netconsole: New console flag to dump full log buffer
Message-ID: <20141223223722.29210d1b@neptune.home>
In-Reply-To: <20141220224908.GB4466@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be default only log messages not yet seen by userspace are output when
enabling netconsole via module parameter (none when enabling dynamic
targets).

When using netconsole to centrally log kernel messages it's of interest
to have the whole kernel log sent over the same medium, even if netconsole
setup happens rather late during system boot. The big advantage of netconsole
over syslog for this task is that it usually allow catching much more
messages when system crashes/panics.

This causes dynamic netconsoles to request full kernel log when first
enabled.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
Note, with this kernel is too quick at sending packets for some receiving
machines to catch all of them. Either packets get dropped by the receiving
NIC if can't buffer enough until OS has time to empty the buffers or they
get lost between kernel and userspace socket if backlog is too small.

My test environment was 4core AMD APU with Gbit NIC to Marvell Kirkwood
SheevaPlug with Gbit NIC. About first 100 lines get through, then lines
start getting lost.

 drivers/net/netconsole.c |  3 ++-
 include/linux/console.h  |  1 +
 kernel/printk/printk.c   | 12 +++++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index a96cd8e..241c70f 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -661,7 +661,8 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	mutex_init(&nt->mutex);
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
 	snprintf(nt->console.name, sizeof(nt->console.name), "netcon-%s", name);
-	nt->console.flags = CON_ENABLED;
+	/* Dump existing printks when we register */
+	nt->console.flags = CON_ENABLED | CON_PRINTBUFFER | CON_PRINTALL;
 	nt->console.write = write_msg;
 	nt->console.loglevel = 0;
 
diff --git a/include/linux/console.h b/include/linux/console.h
index f3a8996..6f53a54 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -116,6 +116,7 @@ static inline int con_debug_leave(void)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
 #define CON_BRL		(32) /* Used for a braille device */
 #define CON_LOGLEVEL	(64) /* Per-console log-level filtering */
+#define CON_PRINTALL	(128) /* Extends CON_PRINTBUFFER */
 
 struct console {
 	char	name[16];
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8f09f30..193665d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2554,9 +2554,15 @@ void register_console(struct console *newcon)
 		 * for us.
 		 */
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		console_seq = syslog_seq;
-		console_idx = syslog_idx;
-		console_prev = syslog_prev;
+		if (newcon->flags & CON_PRINTALL) {
+			console_seq = log_first_seq;
+			console_idx = log_first_idx;
+			console_prev = LOG_NEWLINE;
+		} else {
+			console_seq = syslog_seq;
+			console_idx = syslog_idx;
+			console_prev = syslog_prev;
+		}
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
-- 
2.0.4

