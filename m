Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaJHT6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:58:34 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:49078 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaJHT6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:30 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] serial_core: Remove call to driver-specific TIO[GS]RS485]
Date: Wed,  8 Oct 2014 21:57:38 +0200
Message-Id: <1412798258-23655-13-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once there is no more handlers for TIOC[GS]RS485 there is no need to
call the driver specific ioctl when the generic implementation is
missing.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/serial_core.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6015fd2..b59c925 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1154,9 +1154,6 @@ static int uart_get_icount(struct tty_struct *tty,
 static int uart_get_rs485_config(struct uart_port *port,
 			 struct serial_rs485 __user *rs485)
 {
-	if (!port->rs485_config)
-		return -ENOIOCTLCMD;
-
 	if (copy_to_user(rs485, &port->rs485, sizeof(port->rs485)))
 		return -EFAULT;
 	return 0;
@@ -1250,7 +1247,12 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd,
 	 * All these rely on hardware being present and need to be
 	 * protected against the tty being hung up.
 	 */
+
 	switch (cmd) {
+	case TIOCSERGETLSR: /* Get line status register */
+		ret = uart_get_lsr_info(tty, state, uarg);
+		break;
+
 	case TIOCGRS485:
 		ret = uart_get_rs485_config(state->uart_port, uarg);
 		break;
@@ -1258,15 +1260,6 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case TIOCSRS485:
 		ret = uart_set_rs485_config(state->uart_port, uarg);
 		break;
-	}
-	if (ret != -ENOIOCTLCMD)
-		goto out;
-
-	switch (cmd) {
-	case TIOCSERGETLSR: /* Get line status register */
-		ret = uart_get_lsr_info(tty, state, uarg);
-		break;
-
 	default: {
 		struct uart_port *uport = state->uart_port;
 		if (uport->ops->ioctl)
-- 
2.1.1

