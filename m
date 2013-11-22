Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3KVSGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:06:33 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41169 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3KVSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:06:32 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH staging-next 1/4] staging/fwserial: Rip out rx buffering
Date: Fri, 22 Nov 2013 13:06:08 -0500
Message-Id: <1385143571-3571-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 128 ++++++++----------------------------
 drivers/staging/fwserial/fwserial.h |  16 -----
 drivers/tty/tty_buffer.c            |   1 +
 3 files changed, 28 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index ff92f34..c96f62e 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -456,16 +456,27 @@ static int fwtty_write_port_status(struct fwtty_port *port)
 	return err;
 }
 
-static void __fwtty_throttle(struct fwtty_port *port, struct tty_struct *tty)
+static void fwtty_throttle_port(struct fwtty_port *port)
 {
+	struct tty_struct *tty;
 	unsigned old;
 
+	tty = tty_port_tty_get(&port->port);
+	if (!tty)
+		return;
+
+	spin_lock_bh(&port->lock);
+
 	old = port->mctrl;
 	port->mctrl |= OOB_RX_THROTTLE;
 	if (C_CRTSCTS(tty))
 		port->mctrl &= ~TIOCM_RTS;
 	if (~old & OOB_RX_THROTTLE)
 		__fwtty_write_port_status(port);
+
+	spin_unlock_bh(&port->lock);
+
+	tty_kref_put(tty);
 }
 
 /**
@@ -532,74 +543,8 @@ static void fwtty_emit_breaks(struct work_struct *work)
 	port->icount.brk += brk;
 }
 
-static void fwtty_pushrx(struct work_struct *work)
-{
-	struct fwtty_port *port = to_port(work, push);
-	struct tty_struct *tty;
-	struct buffered_rx *buf, *next;
-	int n, c = 0;
-
-	spin_lock_bh(&port->lock);
-	list_for_each_entry_safe(buf, next, &port->buf_list, list) {
-		n = tty_insert_flip_string_fixed_flag(&port->port, buf->data,
-						      TTY_NORMAL, buf->n);
-		c += n;
-		port->buffered -= n;
-		if (n < buf->n) {
-			if (n > 0) {
-				memmove(buf->data, buf->data + n, buf->n - n);
-				buf->n -= n;
-			}
-			tty = tty_port_tty_get(&port->port);
-			if (tty) {
-				__fwtty_throttle(port, tty);
-				tty_kref_put(tty);
-			}
-			break;
-		} else {
-			list_del(&buf->list);
-			kfree(buf);
-		}
-	}
-	if (c > 0)
-		tty_flip_buffer_push(&port->port);
-
-	if (list_empty(&port->buf_list))
-		clear_bit(BUFFERING_RX, &port->flags);
-	spin_unlock_bh(&port->lock);
-}
-
-static int fwtty_buffer_rx(struct fwtty_port *port, unsigned char *d, size_t n)
-{
-	struct buffered_rx *buf;
-	size_t size = (n + sizeof(struct buffered_rx) + 0xFF) & ~0xFF;
-
-	if (port->buffered + n > HIGH_WATERMARK) {
-		fwtty_err_ratelimited(port, "overflowed rx buffer: buffered: %d new: %zu wtrmk: %d\n",
-				      port->buffered, n, HIGH_WATERMARK);
-		return 0;
-	}
-	buf = kmalloc(size, GFP_ATOMIC);
-	if (!buf)
-		return 0;
-	INIT_LIST_HEAD(&buf->list);
-	buf->n = n;
-	memcpy(buf->data, d, n);
-
-	spin_lock_bh(&port->lock);
-	list_add_tail(&buf->list, &port->buf_list);
-	port->buffered += n;
-	if (port->buffered > port->stats.watermark)
-		port->stats.watermark = port->buffered;
-	set_bit(BUFFERING_RX, &port->flags);
-	spin_unlock_bh(&port->lock);
-
-	return n;
-}
-
 static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 {
-	struct tty_struct *tty;
 	int c, n = len;
 	unsigned lsr;
 	int err = 0;
@@ -636,31 +581,24 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 		goto out;
 	}
 
-	if (!test_bit(BUFFERING_RX, &port->flags)) {
-		c = tty_insert_flip_string_fixed_flag(&port->port, data,
-				TTY_NORMAL, n);
-		if (c > 0)
-			tty_flip_buffer_push(&port->port);
-		n -= c;
-
-		if (n) {
-			/* start buffering and throttling */
-			n -= fwtty_buffer_rx(port, &data[c], n);
-
-			tty = tty_port_tty_get(&port->port);
-			if (tty) {
-				spin_lock_bh(&port->lock);
-				__fwtty_throttle(port, tty);
-				spin_unlock_bh(&port->lock);
-				tty_kref_put(tty);
-			}
-		}
-	} else
-		n -= fwtty_buffer_rx(port, data, n);
+	c = tty_insert_flip_string_fixed_flag(&port->port, data, TTY_NORMAL, n);
+	if (c > 0)
+		tty_flip_buffer_push(&port->port);
+	n -= c;
 
 	if (n) {
 		port->overrun = true;
 		err = -EIO;
+		fwtty_err_ratelimited(port, "flip buffer overrun\n");
+
+	} else {
+		/* throttle the sender if remaining flip buffer space has
+		 * reached high watermark to avoid losing data which may be
+		 * in-flight. Since the AR request context is 32k, that much
+		 * data may have _already_ been acked.
+		 */
+		if (tty_buffer_space_avail(&port->port) < HIGH_WATERMARK)
+			fwtty_throttle_port(port);
 	}
 
 out:
@@ -1101,20 +1039,13 @@ static int fwtty_port_activate(struct tty_port *tty_port,
 static void fwtty_port_shutdown(struct tty_port *tty_port)
 {
 	struct fwtty_port *port = to_port(tty_port, port);
-	struct buffered_rx *buf, *next;
 
 	/* TODO: cancel outstanding transactions */
 
 	cancel_delayed_work_sync(&port->emit_breaks);
 	cancel_delayed_work_sync(&port->drain);
-	cancel_work_sync(&port->push);
 
 	spin_lock_bh(&port->lock);
-	list_for_each_entry_safe(buf, next, &port->buf_list, list) {
-		list_del(&buf->list);
-		kfree(buf);
-	}
-	port->buffered = 0;
 	port->flags = 0;
 	port->break_ctl = 0;
 	port->overrun = 0;
@@ -1264,8 +1195,6 @@ static void fwtty_unthrottle(struct tty_struct *tty)
 
 	profile_fifo_avail(port, port->stats.unthrottle);
 
-	schedule_work(&port->push);
-
 	spin_lock_bh(&port->lock);
 	port->mctrl &= ~OOB_RX_THROTTLE;
 	if (C_CRTSCTS(tty))
@@ -1523,8 +1452,7 @@ static void fwtty_debugfs_show_port(struct seq_file *m, struct fwtty_port *port)
 
 	seq_printf(m, " dr:%d st:%d err:%d lost:%d", stats.dropped,
 		   stats.tx_stall, stats.fifo_errs, stats.lost);
-	seq_printf(m, " pkts:%d thr:%d wtrmk:%d", stats.sent, stats.throttled,
-		   stats.watermark);
+	seq_printf(m, " pkts:%d thr:%d", stats.sent, stats.throttled);
 
 	if (port->port.console) {
 		seq_puts(m, "\n    ");
@@ -2302,8 +2230,6 @@ static int fwserial_create(struct fw_unit *unit)
 		INIT_DELAYED_WORK(&port->drain, fwtty_drain_tx);
 		INIT_DELAYED_WORK(&port->emit_breaks, fwtty_emit_breaks);
 		INIT_WORK(&port->hangup, fwtty_do_hangup);
-		INIT_WORK(&port->push, fwtty_pushrx);
-		INIT_LIST_HEAD(&port->buf_list);
 		init_waitqueue_head(&port->wait_tx);
 		port->max_payload = link_speed_to_max_payload(SCODE_100);
 		dma_fifo_init(&port->tx_fifo);
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 2463501..149b24d 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -166,7 +166,6 @@ struct stats {
 	unsigned	sent;
 	unsigned	lost;
 	unsigned	throttled;
-	unsigned	watermark;
 	unsigned	reads[DISTRIBUTION_MAX_INDEX + 1];
 	unsigned	writes[DISTRIBUTION_MAX_INDEX + 1];
 	unsigned	txns[DISTRIBUTION_MAX_INDEX + 1];
@@ -183,12 +182,6 @@ struct fwconsole_ops {
 #define FWCON_NOTIFY_ATTACH		1
 #define FWCON_NOTIFY_DETACH		2
 
-struct buffered_rx {
-	struct list_head	list;
-	size_t			n;
-	unsigned char		data[0];
-};
-
 /**
  * fwtty_port: structure used to track/represent underlying tty_port
  * @port: underlying tty_port
@@ -223,11 +216,6 @@ struct buffered_rx {
  *         The work can race with the writer but concurrent sending is
  *         prevented with the IN_TX flag. Scheduled under lock to
  *         limit scheduling when fifo has just been drained.
- * @push: work responsible for pushing buffered rx to the ldisc.
- *	  rx can become buffered if the tty buffer is filled before the
- *	  ldisc throttles the sender.
- * @buf_list: list of buffered rx yet to be sent to ldisc
- * @buffered: byte count of buffered rx
  * @tx_fifo: fifo used to store & block-up writes for dma to remote
  * @max_payload: max bytes transmissable per dma (based on peer's max_payload)
  * @status_mask: UART_LSR_* bitmask significant to rx (based on termios)
@@ -267,9 +255,6 @@ struct fwtty_port {
 	spinlock_t		   lock;
 	unsigned		   mctrl;
 	struct delayed_work	   drain;
-	struct work_struct	   push;
-	struct list_head	   buf_list;
-	int			   buffered;
 	struct dma_fifo		   tx_fifo;
 	int			   max_payload;
 	unsigned		   status_mask;
@@ -291,7 +276,6 @@ struct fwtty_port {
 /* bit #s for flags field */
 #define IN_TX                      0
 #define STOP_TX                    1
-#define BUFFERING_RX		   2
 
 /* bitmasks for special mctrl/mstatus bits */
 #define OOB_RX_THROTTLE   0x00010000
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index c4fe20e..0f2211f 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -92,6 +92,7 @@ int tty_buffer_space_avail(struct tty_port *port)
 	int space = port->buf.mem_limit - atomic_read(&port->buf.mem_used);
 	return max(space, 0);
 }
+EXPORT_SYMBOL_GPL(tty_buffer_space_avail);
 
 static void tty_buffer_reset(struct tty_buffer *p, size_t size)
 {
-- 
1.8.1.2

