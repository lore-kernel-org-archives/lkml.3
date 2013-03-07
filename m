Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3CGMNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:13:32 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49748 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3CGMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] TTY: add tty_port_tty_wakeup helper
Date: Thu,  7 Mar 2013 13:12:29 +0100
Message-Id: <1362658360-26629-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows for cleaning up on a considerable amount of places. They did
port_get, wakeup, kref_put. Now the only thing needed is to call
tty_port_tty_wakeup which does exactly that.

One exception is ifx6x60 where tty_wakeup was open-coded. We now call
tty_wakeup properly there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/um/drivers/line.c                  |  8 +-------
 drivers/isdn/capi/capi.c                |  7 +------
 drivers/isdn/gigaset/interface.c        |  6 +-----
 drivers/net/usb/hso.c                   | 13 ++-----------
 drivers/s390/char/sclp_tty.c            |  9 ++-------
 drivers/s390/char/sclp_vt220.c          |  8 +-------
 drivers/staging/fwserial/fwserial.c     | 10 ++--------
 drivers/staging/serqt_usb2/serqt_usb2.c |  7 +------
 drivers/tty/ehv_bytechan.c              |  6 +-----
 drivers/tty/hvc/hvsi.c                  |  7 +------
 drivers/tty/nozomi.c                    |  6 +-----
 drivers/tty/serial/ifx6x60.c            | 33 ++-------------------------------
 drivers/tty/tty_port.c                  | 16 ++++++++++++++++
 drivers/usb/class/cdc-acm.c             |  7 +------
 drivers/usb/serial/digi_acceleport.c    | 17 +++--------------
 drivers/usb/serial/io_edgeport.c        | 28 +++++-----------------------
 drivers/usb/serial/keyspan_pda.c        |  6 ++----
 drivers/usb/serial/mos7720.c            |  8 ++------
 drivers/usb/serial/mos7840.c            |  7 ++-----
 drivers/usb/serial/ti_usb_3410_5052.c   |  7 ++-----
 drivers/usb/serial/usb-serial.c         | 10 +---------
 include/linux/tty.h                     |  1 +
 22 files changed, 51 insertions(+), 176 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index f1b3857..cc206ed 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -248,7 +248,6 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty;
 	int err;
 
 	/*
@@ -267,12 +266,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	}
 	spin_unlock(&line->lock);
 
-	tty = tty_port_tty_get(&line->port);
-	if (tty == NULL)
-		return IRQ_NONE;
-
-	tty_wakeup(tty);
-	tty_kref_put(tty);
+	tty_port_tty_wakeup(&line->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 89562a8..ac6f72b 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -569,7 +569,6 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 {
 	struct capidev *cdev = ap->private;
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
-	struct tty_struct *tty;
 	struct capiminor *mp;
 	u16 datahandle;
 	struct capincci *np;
@@ -627,11 +626,7 @@ static void capi_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 			 CAPIMSG_U16(skb->data, CAPIMSG_BASELEN + 4 + 2));
 		kfree_skb(skb);
 		capiminor_del_ack(mp, datahandle);
-		tty = tty_port_tty_get(&mp->port);
-		if (tty) {
-			tty_wakeup(tty);
-			tty_kref_put(tty);
-		}
+		tty_port_tty_wakeup(&mp->port);
 		handle_minor_send(mp);
 
 	} else {
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index e2b5396..600c79b 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -487,12 +487,8 @@ static const struct tty_operations if_ops = {
 static void if_wake(unsigned long data)
 {
 	struct cardstate *cs = (struct cardstate *)data;
-	struct tty_struct *tty = tty_port_tty_get(&cs->port);
 
-	if (tty) {
-		tty_wakeup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_wakeup(&cs->port);
 }
 
 /*** interface to common ***/
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index e2dd324..a7714b4 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1925,7 +1925,6 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 {
 	struct hso_serial *serial = urb->context;
 	int status = urb->status;
-	struct tty_struct *tty;
 
 	/* sanity check */
 	if (!serial) {
@@ -1941,11 +1940,7 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 		return;
 	}
 	hso_put_activity(serial->parent);
-	tty = tty_port_tty_get(&serial->port);
-	if (tty) {
-		tty_wakeup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_wakeup(&serial->port);
 	hso_kick_transmit(serial);
 
 	D1(" ");
@@ -2008,12 +2003,8 @@ static void ctrl_callback(struct urb *urb)
 		put_rxbuf_data_and_resubmit_ctrl_urb(serial);
 		spin_unlock(&serial->serial_lock);
 	} else {
-		struct tty_struct *tty = tty_port_tty_get(&serial->port);
 		hso_put_activity(serial->parent);
-		if (tty) {
-			tty_wakeup(tty);
-			tty_kref_put(tty);
-		}
+		tty_port_tty_wakeup(&serial->port);
 		/* response to a write command */
 		hso_kick_transmit(serial);
 	}
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 14b4cb8..7ed7a59 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -107,7 +107,6 @@ sclp_tty_write_room (struct tty_struct *tty)
 static void
 sclp_ttybuf_callback(struct sclp_buffer *buffer, int rc)
 {
-	struct tty_struct *tty;
 	unsigned long flags;
 	void *page;
 
@@ -125,12 +124,8 @@ sclp_ttybuf_callback(struct sclp_buffer *buffer, int rc)
 					    struct sclp_buffer, list);
 		spin_unlock_irqrestore(&sclp_tty_lock, flags);
 	} while (buffer && sclp_emit_buffer(buffer, sclp_ttybuf_callback));
-	/* check if the tty needs a wake up call */
-	tty = tty_port_tty_get(&sclp_port);
-	if (tty != NULL) {
-		tty_wakeup(tty);
-		tty_kref_put(tty);
-	}
+
+	tty_port_tty_wakeup(&sclp_port);
 }
 
 static inline void
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 6c92f62..5aaaa2e 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -114,7 +114,6 @@ static struct sclp_register sclp_vt220_register = {
 static void
 sclp_vt220_process_queue(struct sclp_vt220_request *request)
 {
-	struct tty_struct *tty;
 	unsigned long flags;
 	void *page;
 
@@ -139,12 +138,7 @@ sclp_vt220_process_queue(struct sclp_vt220_request *request)
 	} while (__sclp_vt220_emit(request));
 	if (request == NULL && sclp_vt220_flush_later)
 		sclp_vt220_emit_current();
-	/* Check if the tty needs a wake up call */
-	tty = tty_port_tty_get(&sclp_vt220_port);
-	if (tty) {
-		tty_wakeup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_wakeup(&sclp_vt220_port);
 }
 
 #define SCLP_BUFFER_MAX_RETRY		1
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 5a6fb44..5c64e3a 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -744,7 +744,6 @@ static void fwtty_tx_complete(struct fw_card *card, int rcode,
 			      struct fwtty_transaction *txn)
 {
 	struct fwtty_port *port = txn->port;
-	struct tty_struct *tty;
 	int len;
 
 	fwtty_dbg(port, "rcode: %d", rcode);
@@ -769,13 +768,8 @@ static void fwtty_tx_complete(struct fw_card *card, int rcode,
 		port->stats.dropped += txn->dma_pended.len;
 	}
 
-	if (len < WAKEUP_CHARS) {
-		tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			tty_wakeup(tty);
-			tty_kref_put(tty);
-		}
-	}
+	if (len < WAKEUP_CHARS)
+		tty_port_tty_wakeup(&port->port);
 }
 
 static int fwtty_tx(struct fwtty_port *port, bool drain)
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index b1bb1a6..8a6e5ea 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -264,7 +264,6 @@ static void ProcessRxChar(struct usb_serial_port *port, unsigned char data)
 
 static void qt_write_bulk_callback(struct urb *urb)
 {
-	struct tty_struct *tty;
 	int status;
 	struct quatech_port *quatech_port;
 
@@ -278,11 +277,7 @@ static void qt_write_bulk_callback(struct urb *urb)
 
 	quatech_port = urb->context;
 
-	tty = tty_port_tty_get(&quatech_port->port->port);
-
-	if (tty)
-		tty_wakeup(tty);
-	tty_kref_put(tty);
+	tty_port_tty_wakeup(&quatech_port->port->port);
 }
 
 static void qt_interrupt_callback(struct urb *urb)
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index ed92622..6d0c27c 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -472,13 +472,9 @@ static void ehv_bc_tx_dequeue(struct ehv_bc_data *bc)
 static irqreturn_t ehv_bc_tty_tx_isr(int irq, void *data)
 {
 	struct ehv_bc_data *bc = data;
-	struct tty_struct *ttys = tty_port_tty_get(&bc->port);
 
 	ehv_bc_tx_dequeue(bc);
-	if (ttys) {
-		tty_wakeup(ttys);
-		tty_kref_put(ttys);
-	}
+	tty_port_tty_wakeup(&bc->port);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index ef95a15..4190199 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -861,7 +861,6 @@ static void hvsi_write_worker(struct work_struct *work)
 {
 	struct hvsi_struct *hp =
 		container_of(work, struct hvsi_struct, writer.work);
-	struct tty_struct *tty;
 	unsigned long flags;
 #ifdef DEBUG
 	static long start_j = 0;
@@ -895,11 +894,7 @@ static void hvsi_write_worker(struct work_struct *work)
 		start_j = 0;
 #endif /* DEBUG */
 		wake_up_all(&hp->emptyq);
-		tty = tty_port_tty_get(&hp->port);
-		if (tty) {
-			tty_wakeup(tty);
-			tty_kref_put(tty);
-		}
+		tty_port_tty_wakeup(&hp->port);
 	}
 
 out:
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 2dff197..2e5bbdc 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -791,7 +791,6 @@ static int send_data(enum port_type index, struct nozomi *dc)
 	const u8 toggle = port->toggle_ul;
 	void __iomem *addr = port->ul_addr[toggle];
 	const u32 ul_size = port->ul_size[toggle];
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
 	size = kfifo_out(&port->fifo_ul, dc->send_buf,
@@ -799,7 +798,6 @@ static int send_data(enum port_type index, struct nozomi *dc)
 
 	if (size == 0) {
 		DBG4("No more data to send, disable link:");
-		tty_kref_put(tty);
 		return 0;
 	}
 
@@ -809,10 +807,8 @@ static int send_data(enum port_type index, struct nozomi *dc)
 	write_mem32(addr, (u32 *) &size, 4);
 	write_mem32(addr + 4, (u32 *) dc->send_buf, size);
 
-	if (tty)
-		tty_wakeup(tty);
+	tty_port_tty_wakeup(&port->port);
 
-	tty_kref_put(tty);
 	return 1;
 }
 
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 68d7ce9..d723d41 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -443,25 +443,6 @@ static void ifx_spi_setup_spi_header(unsigned char *txbuffer, int tx_count,
 }
 
 /**
- *	ifx_spi_wakeup_serial	-	SPI space made
- *	@port_data: our SPI device
- *
- *	We have emptied the FIFO enough that we want to get more data
- *	queued into it. Poke the line discipline via tty_wakeup so that
- *	it will feed us more bits
- */
-static void ifx_spi_wakeup_serial(struct ifx_spi_device *ifx_dev)
-{
-	struct tty_struct *tty;
-
-	tty = tty_port_tty_get(&ifx_dev->tty_port);
-	if (!tty)
-		return;
-	tty_wakeup(tty);
-	tty_kref_put(tty);
-}
-
-/**
  *	ifx_spi_prepare_tx_buffer	-	prepare transmit frame
  *	@ifx_dev: our SPI device
  *
@@ -506,7 +487,7 @@ static int ifx_spi_prepare_tx_buffer(struct ifx_spi_device *ifx_dev)
 			tx_count += temp_count;
 			if (temp_count == queue_length)
 				/* poke port to get more data */
-				ifx_spi_wakeup_serial(ifx_dev);
+				tty_port_tty_wakeup(&ifx_dev->tty_port);
 			else /* more data in port, use next SPI message */
 				ifx_dev->spi_more = 1;
 		}
@@ -683,8 +664,6 @@ static void ifx_spi_insert_flip_string(struct ifx_spi_device *ifx_dev,
 static void ifx_spi_complete(void *ctx)
 {
 	struct ifx_spi_device *ifx_dev = ctx;
-	struct tty_struct *tty;
-	struct tty_ldisc *ldisc = NULL;
 	int length;
 	int actual_length;
 	unsigned char more;
@@ -762,15 +741,7 @@ complete_exit:
 			 */
 			ifx_spi_power_state_clear(ifx_dev,
 						  IFX_SPI_POWER_DATA_PENDING);
-			tty = tty_port_tty_get(&ifx_dev->tty_port);
-			if (tty) {
-				ldisc = tty_ldisc_ref(tty);
-				if (ldisc) {
-					ldisc->ops->write_wakeup(tty);
-					tty_ldisc_deref(ldisc);
-				}
-				tty_kref_put(tty);
-			}
+			tty_port_tty_wakeup(&ifx_dev->tty_port);
 		}
 	}
 }
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index b7ff59d..8bb757c 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -233,6 +233,22 @@ void tty_port_hangup(struct tty_port *port)
 EXPORT_SYMBOL(tty_port_hangup);
 
 /**
+ * tty_port_tty_wakeup - helper to wake up a tty
+ *
+ * @port: tty port
+ */
+void tty_port_tty_wakeup(struct tty_port *port)
+{
+	struct tty_struct *tty = tty_port_tty_get(port);
+
+	if (tty) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
+	}
+}
+EXPORT_SYMBOL_GPL(tty_port_tty_wakeup);
+
+/**
  *	tty_port_carrier_raised	-	carrier raised check
  *	@port: tty port
  *
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8ac25ad..755766e 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -475,15 +475,10 @@ static void acm_write_bulk(struct urb *urb)
 static void acm_softint(struct work_struct *work)
 {
 	struct acm *acm = container_of(work, struct acm, work);
-	struct tty_struct *tty;
 
 	dev_vdbg(&acm->data->dev, "%s\n", __func__);
 
-	tty = tty_port_tty_get(&acm->port);
-	if (!tty)
-		return;
-	tty_wakeup(tty);
-	tty_kref_put(tty);
+	tty_port_tty_wakeup(&acm->port);
 }
 
 /*
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index ebe45fa..3119158 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -210,7 +210,6 @@ struct digi_port {
 
 /* Local Function Declarations */
 
-static void digi_wakeup_write(struct usb_serial_port *port);
 static void digi_wakeup_write_lock(struct work_struct *work);
 static int digi_write_oob_command(struct usb_serial_port *port,
 	unsigned char *buf, int count, int interruptible);
@@ -374,20 +373,10 @@ static void digi_wakeup_write_lock(struct work_struct *work)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
-	digi_wakeup_write(port);
+	tty_port_tty_wakeup(&port->port);
 	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
 }
 
-static void digi_wakeup_write(struct usb_serial_port *port)
-{
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	if (tty) {
-		tty_wakeup(tty);
-		tty_kref_put(tty);
-	}
-}
-
-
 /*
  *  Digi Write OOB Command
  *
@@ -1044,7 +1033,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 		}
 	}
 	/* wake up processes sleeping on writes immediately */
-	digi_wakeup_write(port);
+	tty_port_tty_wakeup(&port->port);
 	/* also queue up a wakeup at scheduler time, in case we */
 	/* lost the race in write_chan(). */
 	schedule_work(&priv->dp_wakeup_work);
@@ -1522,7 +1511,7 @@ static int digi_read_oob_callback(struct urb *urb)
 				/* port must be open to use tty struct */
 				if (rts) {
 					tty->hw_stopped = 0;
-					digi_wakeup_write(port);
+					tty_port_tty_wakeup(&port->port);
 				}
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index b00e5cb..44e5208 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -565,7 +565,6 @@ static void edge_interrupt_callback(struct urb *urb)
 	struct device *dev;
 	struct edgeport_port *edge_port;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 	unsigned char *data = urb->transfer_buffer;
 	int length = urb->actual_length;
 	int bytes_avail;
@@ -644,12 +643,7 @@ static void edge_interrupt_callback(struct urb *urb)
 
 					/* tell the tty driver that something
 					   has changed */
-					tty = tty_port_tty_get(
-						&edge_port->port->port);
-					if (tty) {
-						tty_wakeup(tty);
-						tty_kref_put(tty);
-					}
+					tty_port_tty_wakeup(&edge_port->port->port);
 					/* Since we have more credit, check
 					   if more data can be sent */
 					send_more_port_data(edge_serial,
@@ -738,7 +732,6 @@ static void edge_bulk_in_callback(struct urb *urb)
 static void edge_bulk_out_data_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
-	struct tty_struct *tty;
 	int status = urb->status;
 
 	if (status) {
@@ -747,14 +740,8 @@ static void edge_bulk_out_data_callback(struct urb *urb)
 			__func__, status);
 	}
 
-	tty = tty_port_tty_get(&edge_port->port->port);
-
-	if (tty && edge_port->open) {
-		/* let the tty driver wakeup if it has a special
-		   write_wakeup function */
-		tty_wakeup(tty);
-	}
-	tty_kref_put(tty);
+	if (edge_port->open)
+		tty_port_tty_wakeup(&edge_port->port->port);
 
 	/* Release the Write URB */
 	edge_port->write_in_progress = false;
@@ -773,7 +760,6 @@ static void edge_bulk_out_data_callback(struct urb *urb)
 static void edge_bulk_out_cmd_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
-	struct tty_struct *tty;
 	int status = urb->status;
 
 	atomic_dec(&CmdUrbs);
@@ -794,13 +780,9 @@ static void edge_bulk_out_cmd_callback(struct urb *urb)
 		return;
 	}
 
-	/* Get pointer to tty */
-	tty = tty_port_tty_get(&edge_port->port->port);
-
 	/* tell the tty driver that something has changed */
-	if (tty && edge_port->open)
-		tty_wakeup(tty);
-	tty_kref_put(tty);
+	if (edge_port->open)
+		tty_port_tty_wakeup(&edge_port->port->port);
 
 	/* we have completed the command */
 	edge_port->commandPending = false;
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 3b17d5d..2230223 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -104,10 +104,8 @@ static void keyspan_pda_wakeup_write(struct work_struct *work)
 	struct keyspan_pda_private *priv =
 		container_of(work, struct keyspan_pda_private, wakeup_work);
 	struct usb_serial_port *port = priv->port;
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	if (tty)
-		tty_wakeup(tty);
-	tty_kref_put(tty);
+
+	tty_port_tty_wakeup(&port->port);
 }
 
 static void keyspan_pda_request_unthrottle(struct work_struct *work)
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index e0ebec3..e956eae 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -932,7 +932,6 @@ static void mos7720_bulk_in_callback(struct urb *urb)
 static void mos7720_bulk_out_data_callback(struct urb *urb)
 {
 	struct moschip_port *mos7720_port;
-	struct tty_struct *tty;
 	int status = urb->status;
 
 	if (status) {
@@ -946,11 +945,8 @@ static void mos7720_bulk_out_data_callback(struct urb *urb)
 		return ;
 	}
 
-	tty = tty_port_tty_get(&mos7720_port->port->port);
-
-	if (tty && mos7720_port->open)
-		tty_wakeup(tty);
-	tty_kref_put(tty);
+	if (mos7720_port->open)
+		tty_port_tty_wakeup(&mos7720_port->port->port);
 }
 
 /*
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 809fb32..08284d2 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -814,7 +814,6 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 {
 	struct moschip_port *mos7840_port;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 	int status = urb->status;
 	int i;
 
@@ -837,10 +836,8 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 	if (mos7840_port_paranoia_check(port, __func__))
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (tty && mos7840_port->open)
-		tty_wakeup(tty);
-	tty_kref_put(tty);
+	if (mos7840_port->open)
+		tty_port_tty_wakeup(&port->port);
 
 }
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 39cb9b8..437f2d5 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1227,7 +1227,6 @@ static void ti_send(struct ti_port *tport)
 {
 	int count, result;
 	struct usb_serial_port *port = tport->tp_port;
-	struct tty_struct *tty = tty_port_tty_get(&port->port);	/* FIXME */
 	unsigned long flags;
 
 	spin_lock_irqsave(&tport->tp_lock, flags);
@@ -1268,14 +1267,12 @@ static void ti_send(struct ti_port *tport)
 	}
 
 	/* more room in the buffer for new writes, wakeup */
-	if (tty)
-		tty_wakeup(tty);
-	tty_kref_put(tty);
+	tty_port_tty_wakeup(&port->port);
+
 	wake_up_interruptible(&tport->tp_write_wait);
 	return;
 unlock:
 	spin_unlock_irqrestore(&tport->tp_lock, flags);
-	tty_kref_put(tty);
 	return;
 }
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index a19ed74..2df8484 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -541,16 +541,8 @@ static void usb_serial_port_work(struct work_struct *work)
 {
 	struct usb_serial_port *port =
 		container_of(work, struct usb_serial_port, work);
-	struct tty_struct *tty;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-
-	dev_dbg(tty->dev, "%s - port %d\n", __func__, port->number);
-
-	tty_wakeup(tty);
-	tty_kref_put(tty);
+	tty_port_tty_wakeup(&port->port);
 }
 
 static void kill_traffic(struct usb_serial_port *port)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4c6a079..fc056d4 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -516,6 +516,7 @@ extern int tty_port_carrier_raised(struct tty_port *port);
 extern void tty_port_raise_dtr_rts(struct tty_port *port);
 extern void tty_port_lower_dtr_rts(struct tty_port *port);
 extern void tty_port_hangup(struct tty_port *port);
+extern void tty_port_tty_wakeup(struct tty_port *port);
 extern int tty_port_block_til_ready(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
 extern int tty_port_close_start(struct tty_port *port,
-- 
1.8.1.4


