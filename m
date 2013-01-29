Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3A2DgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:36:03 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:47729 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756394Ab3A2Dfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 10/11] staging/fwserial: Fix premature unthrottle
Date: Mon, 28 Jan 2013 22:34:44 -0500
Message-Id: <1359430485-5301-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unthrottle may restart the writer before the rx push
has a chance to start emptying the rx buffer, resulting in an
overflowed rx buffer and lost data.

Perform the actual device unthrottle with the rx push instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 912ab77..121beff 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -463,6 +463,14 @@ static void __fwtty_throttle(struct fwtty_port *port, struct tty_struct *tty)
 		__fwtty_write_port_status(port);
 }
 
+static void __fwtty_unthrottle(struct fwtty_port *port, struct tty_struct *tty)
+{
+	port->mctrl &= ~OOB_RX_THROTTLE;
+	if (C_CRTSCTS(tty))
+		port->mctrl |= TIOCM_RTS;
+	__fwtty_write_port_status(port);
+}
+
 /**
  * fwtty_do_hangup - wait for ldisc to deliver all pending rx; only then hangup
  *
@@ -527,14 +535,15 @@ static void fwtty_emit_breaks(struct work_struct *work)
 	port->icount.brk += brk;
 }
 
-static void fwtty_pushrx(struct work_struct *work)
+static void fwtty_pushrx(struct fwtty_port *port, struct tty_struct *tty)
 {
-	struct fwtty_port *port = to_port(work, push);
-	struct tty_struct *tty;
 	struct buffered_rx *buf, *next;
 	int n, c = 0;
 
 	spin_lock_bh(&port->lock);
+
+	__fwtty_unthrottle(port, tty);
+
 	list_for_each_entry_safe(buf, next, &port->buf_list, list) {
 		n = tty_insert_flip_string_fixed_flag(&port->port, buf->data,
 						      TTY_NORMAL, buf->n);
@@ -545,11 +554,7 @@ static void fwtty_pushrx(struct work_struct *work)
 				memmove(buf->data, buf->data + n, buf->n - n);
 				buf->n -= n;
 			}
-			tty = tty_port_tty_get(&port->port);
-			if (tty) {
-				__fwtty_throttle(port, tty);
-				tty_kref_put(tty);
-			}
+			__fwtty_throttle(port, tty);
 			break;
 		} else {
 			list_del(&buf->list);
@@ -1264,14 +1269,7 @@ static void fwtty_unthrottle(struct tty_struct *tty)
 
 	profile_fifo_avail(port, port->stats.unthrottle);
 
-	schedule_work(&port->push);
-
-	spin_lock_bh(&port->lock);
-	port->mctrl &= ~OOB_RX_THROTTLE;
-	if (C_CRTSCTS(tty))
-		port->mctrl |= TIOCM_RTS;
-	__fwtty_write_port_status(port);
-	spin_unlock_bh(&port->lock);
+	fwtty_pushrx(port, tty);
 }
 
 static int check_msr_delta(struct fwtty_port *port, unsigned long mask,
-- 
1.8.1.1

