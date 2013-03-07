Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3CGMNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:13:30 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49749 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3CGMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] TTY: add tty_port_tty_hangup helper
Date: Thu,  7 Mar 2013 13:12:30 +0100
Message-Id: <1362658360-26629-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows for cleaning up on a considerable amount of places. They did
port_get, hangup, kref_put. Now the only thing needed is to call
tty_port_tty_hangup which does exactly that. And they can also decide
whether to consider CLOCAL or completely ignore that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/um/drivers/chan_kern.c         |  6 +-----
 drivers/mmc/card/sdio_uart.c        | 13 ++---------
 drivers/net/usb/hso.c               |  7 +-----
 drivers/tty/cyclades.c              | 10 ++-------
 drivers/tty/moxa.c                  | 19 ++++++----------
 drivers/tty/n_gsm.c                 |  6 +-----
 drivers/tty/nozomi.c                |  9 +++-----
 drivers/tty/rocket.c                |  7 +-----
 drivers/tty/serial/ifx6x60.c        | 21 ++----------------
 drivers/tty/tty_port.c              | 17 +++++++++++++++
 drivers/usb/class/cdc-acm.c         | 24 ++++++---------------
 drivers/usb/serial/keyspan.c        | 43 +++++++++----------------------------
 drivers/usb/serial/option.c         |  9 ++------
 drivers/usb/serial/sierra.c         |  8 ++-----
 include/linux/tty.h                 |  1 +
 net/irda/ircomm/ircomm_tty_attach.c |  6 +-----
 16 files changed, 58 insertions(+), 148 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 15c553c..bf42825 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -568,11 +568,7 @@ void chan_interrupt(struct line *line, int irq)
 		reactivate_fd(chan->fd, irq);
 	if (err == -EIO) {
 		if (chan->primary) {
-			struct tty_struct *tty = tty_port_tty_get(&line->port);
-			if (tty != NULL) {
-				tty_hangup(tty);
-				tty_kref_put(tty);
-			}
+			tty_port_tty_hangup(&line->port, false);
 			if (line->chan_out != chan)
 				close_one_chan(line->chan_out, 1);
 		}
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index c931dfe..f093cea 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -134,7 +134,6 @@ static void sdio_uart_port_put(struct sdio_uart_port *port)
 static void sdio_uart_port_remove(struct sdio_uart_port *port)
 {
 	struct sdio_func *func;
-	struct tty_struct *tty;
 
 	BUG_ON(sdio_uart_table[port->index] != port);
 
@@ -155,12 +154,8 @@ static void sdio_uart_port_remove(struct sdio_uart_port *port)
 	sdio_claim_host(func);
 	port->func = NULL;
 	mutex_unlock(&port->func_lock);
-	tty = tty_port_tty_get(&port->port);
 	/* tty_hangup is async so is this safe as is ?? */
-	if (tty) {
-		tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_hangup(&port->port, false);
 	mutex_unlock(&port->port.mutex);
 	sdio_release_irq(func);
 	sdio_disable_func(func);
@@ -492,11 +487,7 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 			wake_up_interruptible(&port->port.open_wait);
 		else {
 			/* DCD drop - hang up if tty attached */
-			tty = tty_port_tty_get(&port->port);
-			if (tty) {
-				tty_hangup(tty);
-				tty_kref_put(tty);
-			}
+			tty_port_tty_hangup(&port->port, false);
 		}
 	}
 	if (status & UART_MSR_DCTS) {
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index a7714b4..cba1d46 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -3124,18 +3124,13 @@ static void hso_serial_ref_free(struct kref *ref)
 static void hso_free_interface(struct usb_interface *interface)
 {
 	struct hso_serial *hso_dev;
-	struct tty_struct *tty;
 	int i;
 
 	for (i = 0; i < HSO_SERIAL_TTY_MINORS; i++) {
 		if (serial_table[i] &&
 		    (serial_table[i]->interface == interface)) {
 			hso_dev = dev2ser(serial_table[i]);
-			tty = tty_port_tty_get(&hso_dev->port);
-			if (tty) {
-				tty_hangup(tty);
-				tty_kref_put(tty);
-			}
+			tty_port_tty_hangup(&hso_dev->port, false);
 			mutex_lock(&hso_dev->parent->mutex);
 			hso_dev->parent->usb_gone = 1;
 			mutex_unlock(&hso_dev->parent->mutex);
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 345bd0e..33f83fe 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1124,14 +1124,8 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 					readl(&info->u.cyz.ch_ctrl->rs_status);
 				if (dcd & C_RS_DCD)
 					wake_up_interruptible(&info->port.open_wait);
-				else {
-					struct tty_struct *tty;
-					tty = tty_port_tty_get(&info->port);
-					if (tty) {
-						tty_hangup(tty);
-						tty_kref_put(tty);
-					}
-				}
+				else
+					tty_port_tty_hangup(&info->port, false);
 			}
 			break;
 		case C_CM_MCTS:
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index adeac25..1deaca4 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -913,16 +913,12 @@ static void moxa_board_deinit(struct moxa_board_conf *brd)
 
 	/* pci hot-un-plug support */
 	for (a = 0; a < brd->numPorts; a++)
-		if (brd->ports[a].port.flags & ASYNC_INITIALIZED) {
-			struct tty_struct *tty = tty_port_tty_get(
-						&brd->ports[a].port);
-			if (tty) {
-				tty_hangup(tty);
-				tty_kref_put(tty);
-			}
-		}
+		if (brd->ports[a].port.flags & ASYNC_INITIALIZED)
+			tty_port_tty_hangup(&brd->ports[a].port, false);
+
 	for (a = 0; a < MAX_PORTS_PER_BOARD; a++)
 		tty_port_destroy(&brd->ports[a].port);
+
 	while (1) {
 		opened = 0;
 		for (a = 0; a < brd->numPorts; a++)
@@ -1365,7 +1361,6 @@ static void moxa_hangup(struct tty_struct *tty)
 
 static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
-	struct tty_struct *tty;
 	unsigned long flags;
 	dcd = !!dcd;
 
@@ -1373,10 +1368,8 @@ static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 	if (dcd != p->DCDState) {
         	p->DCDState = dcd;
         	spin_unlock_irqrestore(&p->port.lock, flags);
-		tty = tty_port_tty_get(&p->port);
-		if (tty && !C_CLOCAL(tty) && !dcd)
-			tty_hangup(tty);
-		tty_kref_put(tty);
+		if (!dcd)
+			tty_port_tty_hangup(&p->port, true);
 	}
 	else
 		spin_unlock_irqrestore(&p->port.lock, flags);
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 4a43ef5d7..74d9a02 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1418,11 +1418,7 @@ static void gsm_dlci_close(struct gsm_dlci *dlci)
 		pr_debug("DLCI %d goes closed.\n", dlci->addr);
 	dlci->state = DLCI_CLOSED;
 	if (dlci->addr != 0) {
-		struct tty_struct  *tty = tty_port_tty_get(&dlci->port);
-		if (tty) {
-			tty_hangup(tty);
-			tty_kref_put(tty);
-		}
+		tty_port_tty_hangup(&dlci->port, false);
 		kfifo_reset(dlci->fifo);
 	} else
 		dlci->gsm->dead = 1;
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 2e5bbdc..d6080c3 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1501,12 +1501,9 @@ static void tty_exit(struct nozomi *dc)
 
 	DBG1(" ");
 
-	for (i = 0; i < MAX_PORT; ++i) {
-		struct tty_struct *tty = tty_port_tty_get(&dc->port[i].port);
-		if (tty && list_empty(&tty->hangup_work.entry))
-			tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	for (i = 0; i < MAX_PORT; ++i)
+		tty_port_tty_hangup(&dc->port[i].port, false);
+
 	/* Racy below - surely should wait for scheduled work to be done or
 	   complete off a hangup method ? */
 	while (dc->open_ttys)
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 1d27003..bbffd7a 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -521,15 +521,10 @@ static void rp_handle_port(struct r_port *info)
 		       (ChanStatus & CD_ACT) ? "on" : "off");
 #endif
 		if (!(ChanStatus & CD_ACT) && info->cd_status) {
-			struct tty_struct *tty;
 #ifdef ROCKET_DEBUG_HANGUP
 			printk(KERN_INFO "CD drop, calling hangup.\n");
 #endif
-			tty = tty_port_tty_get(&info->port);
-			if (tty) {
-				tty_hangup(tty);
-				tty_kref_put(tty);
-			}
+			tty_port_tty_hangup(&info->port, false);
 		}
 		info->cd_status = (ChanStatus & CD_ACT) ? 1 : 0;
 		wake_up_interruptible(&info->port.open_wait);
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index d723d41..2c77fed 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -270,23 +270,6 @@ static void mrdy_assert(struct ifx_spi_device *ifx_dev)
 }
 
 /**
- *	ifx_spi_hangup		-	hang up an IFX device
- *	@ifx_dev: our SPI device
- *
- *	Hang up the tty attached to the IFX device if one is currently
- *	open. If not take no action
- */
-static void ifx_spi_ttyhangup(struct ifx_spi_device *ifx_dev)
-{
-	struct tty_port *pport = &ifx_dev->tty_port;
-	struct tty_struct *tty = tty_port_tty_get(pport);
-	if (tty) {
-		tty_hangup(tty);
-		tty_kref_put(tty);
-	}
-}
-
-/**
  *	ifx_spi_timeout		-	SPI timeout
  *	@arg: our SPI device
  *
@@ -298,7 +281,7 @@ static void ifx_spi_timeout(unsigned long arg)
 	struct ifx_spi_device *ifx_dev = (struct ifx_spi_device *)arg;
 
 	dev_warn(&ifx_dev->spi_dev->dev, "*** SPI Timeout ***");
-	ifx_spi_ttyhangup(ifx_dev);
+	tty_port_tty_hangup(&ifx_dev->tty_port, false);
 	mrdy_set_low(ifx_dev);
 	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
 }
@@ -933,7 +916,7 @@ static irqreturn_t ifx_spi_reset_interrupt(int irq, void *dev)
 		set_bit(MR_INPROGRESS, &ifx_dev->mdm_reset_state);
 		if (!solreset) {
 			/* unsolicited reset  */
-			ifx_spi_ttyhangup(ifx_dev);
+			tty_port_tty_hangup(&ifx_dev->tty_port, false);
 		}
 	} else {
 		/* exited reset */
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 8bb757c..7f38eea 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -233,6 +233,23 @@ void tty_port_hangup(struct tty_port *port)
 EXPORT_SYMBOL(tty_port_hangup);
 
 /**
+ * tty_port_tty_hangup - helper to hang up a tty
+ *
+ * @port: tty port
+ * @check_clocal: hang only ttys with CLOCAL unset?
+ */
+void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
+{
+	struct tty_struct *tty = tty_port_tty_get(port);
+
+	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
+		tty_hangup(tty);
+		tty_kref_put(tty);
+	}
+}
+EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
+
+/**
  * tty_port_tty_wakeup - helper to wake up a tty
  *
  * @port: tty port
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 755766e..27a1874 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -292,7 +292,6 @@ static void acm_ctrl_irq(struct urb *urb)
 {
 	struct acm *acm = urb->context;
 	struct usb_cdc_notification *dr = urb->transfer_buffer;
-	struct tty_struct *tty;
 	unsigned char *data;
 	int newctrl;
 	int retval;
@@ -327,17 +326,12 @@ static void acm_ctrl_irq(struct urb *urb)
 		break;
 
 	case USB_CDC_NOTIFY_SERIAL_STATE:
-		tty = tty_port_tty_get(&acm->port);
 		newctrl = get_unaligned_le16(data);
 
-		if (tty) {
-			if (!acm->clocal &&
-				(acm->ctrlin & ~newctrl & ACM_CTRL_DCD)) {
-				dev_dbg(&acm->control->dev,
-					"%s - calling hangup\n", __func__);
-				tty_hangup(tty);
-			}
-			tty_kref_put(tty);
+		if (!acm->clocal && (acm->ctrlin & ~newctrl & ACM_CTRL_DCD)) {
+			dev_dbg(&acm->control->dev, "%s - calling hangup\n",
+					__func__);
+			tty_port_tty_hangup(&acm->port, false);
 		}
 
 		acm->ctrlin = newctrl;
@@ -1498,15 +1492,9 @@ err_out:
 static int acm_reset_resume(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
-	struct tty_struct *tty;
 
-	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags)) {
-		tty = tty_port_tty_get(&acm->port);
-		if (tty) {
-			tty_hangup(tty);
-			tty_kref_put(tty);
-		}
-	}
+	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags))
+		tty_port_tty_hangup(&acm->port, false);
 
 	return acm_resume(intf);
 }
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 1fd1935..b011478 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -378,7 +378,6 @@ static void	usa26_instat_callback(struct urb *urb)
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
 	struct keyspan_port_private	 	*p_priv;
-	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
 
@@ -421,12 +420,8 @@ static void	usa26_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->gpia_dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (old_dcd_state != p_priv->dcd_state) {
-		tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty))
-			tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	if (old_dcd_state != p_priv->dcd_state)
+		tty_port_tty_hangup(&port->port, true);
 
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -510,7 +505,6 @@ static void	usa28_instat_callback(struct urb *urb)
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
 	struct keyspan_port_private	 	*p_priv;
-	struct tty_struct			*tty;
 	int old_dcd_state;
 	int status = urb->status;
 
@@ -551,12 +545,8 @@ static void	usa28_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
-		tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty))
-			tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
+		tty_port_tty_hangup(&port->port, true);
 
 		/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -642,12 +632,8 @@ static void	usa49_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
-		struct tty_struct *tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty))
-			tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
+		tty_port_tty_hangup(&port->port, true);
 
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -851,7 +837,6 @@ static void	usa90_instat_callback(struct urb *urb)
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
 	struct keyspan_port_private	 	*p_priv;
-	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
 
@@ -880,12 +865,8 @@ static void	usa90_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
-		tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty))
-			tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
+		tty_port_tty_hangup(&port->port, true);
 
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
@@ -953,12 +934,8 @@ static void	usa67_instat_callback(struct urb *urb)
 	p_priv->cts_state = ((msg->hskia_cts) ? 1 : 0);
 	p_priv->dcd_state = ((msg->gpia_dcd) ? 1 : 0);
 
-	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
-		struct tty_struct *tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty))
-			tty_hangup(tty);
-		tty_kref_put(tty);
-	}
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
+		tty_port_tty_hangup(&port->port, true);
 
 	/* Resubmit urb so we continue receiving */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index f7d339d..602d1f3 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1532,13 +1532,8 @@ static void option_instat_callback(struct urb *urb)
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
 
-			if (old_dcd_state && !portdata->dcd_state) {
-				struct tty_struct *tty =
-						tty_port_tty_get(&port->port);
-				if (tty && !C_CLOCAL(tty))
-					tty_hangup(tty);
-				tty_kref_put(tty);
-			}
+			if (old_dcd_state && !portdata->dcd_state)
+				tty_port_tty_hangup(&port->port, true);
 		} else {
 			dev_dbg(dev, "%s: type %x req %x\n", __func__,
 				req_pkt->bRequestType, req_pkt->bRequest);
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index c13f6e7..d66148a 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -628,7 +628,6 @@ static void sierra_instat_callback(struct urb *urb)
 			unsigned char signals = *((unsigned char *)
 					urb->transfer_buffer +
 					sizeof(struct usb_ctrlrequest));
-			struct tty_struct *tty;
 
 			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
 				signals);
@@ -639,11 +638,8 @@ static void sierra_instat_callback(struct urb *urb)
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
 
-			tty = tty_port_tty_get(&port->port);
-			if (tty && !C_CLOCAL(tty) &&
-					old_dcd_state && !portdata->dcd_state)
-				tty_hangup(tty);
-			tty_kref_put(tty);
+			if (old_dcd_state && !portdata->dcd_state)
+				tty_port_tty_hangup(&port->port, true);
 		} else {
 			dev_dbg(&port->dev, "%s: type %x req %x\n",
 				__func__, req_pkt->bRequestType,
diff --git a/include/linux/tty.h b/include/linux/tty.h
index fc056d4..d9b96ff 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -516,6 +516,7 @@ extern int tty_port_carrier_raised(struct tty_port *port);
 extern void tty_port_raise_dtr_rts(struct tty_port *port);
 extern void tty_port_lower_dtr_rts(struct tty_port *port);
 extern void tty_port_hangup(struct tty_port *port);
+extern void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
 extern void tty_port_tty_wakeup(struct tty_port *port);
 extern int tty_port_block_til_ready(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
diff --git a/net/irda/ircomm/ircomm_tty_attach.c b/net/irda/ircomm/ircomm_tty_attach.c
index edab393..a2a508f 100644
--- a/net/irda/ircomm/ircomm_tty_attach.c
+++ b/net/irda/ircomm/ircomm_tty_attach.c
@@ -997,12 +997,8 @@ static int ircomm_tty_state_ready(struct ircomm_tty_cb *self,
 			self->settings.dce = IRCOMM_DELTA_CD;
 			ircomm_tty_check_modem_status(self);
 		} else {
-			struct tty_struct *tty = tty_port_tty_get(&self->port);
 			IRDA_DEBUG(0, "%s(), hanging up!\n", __func__ );
-			if (tty) {
-				tty_hangup(tty);
-				tty_kref_put(tty);
-			}
+			tty_port_tty_hangup(&self->port, false);
 		}
 		break;
 	default:
-- 
1.8.1.4


