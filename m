Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaILWQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:16:03 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40990 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILWQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:16:01 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-metag@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] tty/metag_da: Add console_poll module parameter
Date: Fri, 12 Sep 2014 23:15:22 +0100
Message-Id: <1410560122-12362-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the metag_da console channel is write only, it doesn't get
polled for incoming data. This is for performance & latency reasons as
polling blocks the processor for a significant amount of time waiting
for the JTAG probe to respond to the request and restart the thread.
This means that the console channel cannot be used for a login prompt,
so ttyDA2 is usually used instead.

In a virtual environment with a virtual DA such as QEMU however the
polling is much cheaper as the request can be handled immediately. It is
useful to be able to enable polling in such an environment in order to
get both the kernel log and a usable login prompt on the same DA
channel.

Add a console_poll module parameter which allows polling to be enabled
for the console channel. It defaults to off as that is the current
behaviour for good reason on real hardware.

It can be enabled by appending metag_da.console_poll to the kernel
command line.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Guenter Roeck <linux@roeck-us.net>
---
 drivers/tty/metag_da.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/metag_da.c b/drivers/tty/metag_da.c
index 7332e2c..3774600 100644
--- a/drivers/tty/metag_da.c
+++ b/drivers/tty/metag_da.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/serial.h>
@@ -70,6 +71,15 @@ static struct tty_driver *channel_driver;
 static struct timer_list put_timer;
 static struct task_struct *dashtty_thread;
 
+/*
+ * The console_poll parameter determines whether the console channel should be
+ * polled for input.
+ * By default the console channel isn't polled at all, in order to avoid the
+ * overhead, but that means it isn't possible to have a login on /dev/console.
+ */
+static bool console_poll;
+module_param(console_poll, bool, S_IRUGO);
+
 #define RX_BUF_SIZE 1024
 
 enum {
@@ -353,7 +363,7 @@ static int dashtty_port_activate(struct tty_port *port, struct tty_struct *tty)
 	 * possible to have a login on /dev/console.
 	 *
 	 */
-	if (dport != &dashtty_ports[CONSOLE_CHANNEL])
+	if (console_poll || dport != &dashtty_ports[CONSOLE_CHANNEL])
 		if (atomic_inc_return(&num_channels_need_poll) == 1)
 			add_poll_timer(&poll_timer);
 
@@ -372,7 +382,7 @@ static void dashtty_port_shutdown(struct tty_port *port)
 	unsigned int count;
 
 	/* stop reading */
-	if (dport != &dashtty_ports[CONSOLE_CHANNEL])
+	if (console_poll || dport != &dashtty_ports[CONSOLE_CHANNEL])
 		if (atomic_dec_and_test(&num_channels_need_poll))
 			del_timer_sync(&poll_timer);
 
-- 
1.8.5.5

