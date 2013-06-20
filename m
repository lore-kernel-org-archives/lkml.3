Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3FTJWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:22:23 -0400
Received: from cpsmtp-fia01.kpnxchange.com ([195.121.247.4]:3251 "EHLO
	cpsmtp-fia01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310Ab3FTJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:22:19 -0400
X-Greylist: delayed 840 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2013 05:22:18 EDT
Message-ID: <1371719294.8488.6.camel@virtualbox27>
Subject: [PATCH] tty: n_gsm: improve software flowcontrol
From: Sander Bosma <s.bosma@interay.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 11:08:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Jun 2013 09:09:40.0613 (UTC) FILETIME=[E55FAB50:01CE6D95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a channel got constipated, all messages in the messagequeue were
still sent to the device. This can cause a bufferoverflow in some
devices such as the SIM900 modem. This patch removes all pending
messages belonging to the channel from the messagequeue when a
channel gets constipated. Those messages are stored in a list within
the DLCI. Once the channel is no longer constipated the stored
messages are moved back into the global messagequeue. This
significantly decreases the chance of bufferoverflows happening on
receiving devices.

Signed-off-by: Sander Bosma <s.bosma@interay.com>
---
 drivers/tty/n_gsm.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 4a43ef5d7..0cad08fa 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -152,6 +152,7 @@ struct gsm_dlci {
 	/* Flow control */
 	int throttled;		/* Private copy of throttle state */
 	int constipated;	/* Throttle status for outgoing */
+	struct list_head constipated_list; /* msg's removed from tx queue */
 	/* Packetised I/O */
 	struct sk_buff *skb;	/* Frame being sent */
 	struct sk_buff_head skb_list;	/* Queued frames */
@@ -684,7 +685,8 @@ static void gsm_data_kick(struct gsm_mux *gsm)
 	int skip_sof = 0;
 
 	list_for_each_entry_safe(msg, nmsg, &gsm->tx_list, list) {
-		if (gsm->constipated && msg->addr)
+		if (gsm->constipated && msg->addr ||
+		    gsm->dlci[msg->addr]->constipated)
 			continue;
 		if (gsm->encoding != 0) {
 			gsm->txframe[0] = GSM1_SOF;
@@ -931,7 +933,7 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 	int len;
 	/* Priority ordering: We should do priority with RR of the groups */
 	int i = 1;
-
+	struct tty_struct *tty;
 	while (i < NUM_DLCI) {
 		struct gsm_dlci *dlci;
 
@@ -946,6 +948,13 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 			len = gsm_dlci_data_output(gsm, dlci);
 		else
 			len = gsm_dlci_data_output_framed(gsm, dlci);
+
+		if (len >= 0) {
+			tty = tty_port_tty_get(&dlci->port);
+			if (tty)
+				tty_wakeup(dlci->port.tty);
+		}
+
 		if (len < 0)
 			break;
 		/* DLCI empty - try the next */
@@ -1029,7 +1038,8 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
 	int  mlines = 0;
 	u8 brk = 0;
 	int fc;
-
+	struct gsm_msg *msg, *nmsg;
+	unsigned long flags;
 	/* The modem status command can either contain one octet (v.24 signals)
 	   or two octets (v.24 signals + break signals). The length field will
 	   either be 2 or 3 respectively. This is specified in section
@@ -1047,8 +1057,27 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
 	if (fc && !dlci->constipated) {
 		/* Need to throttle our output on this device */
 		dlci->constipated = 1;
+		spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
+		list_for_each_entry_safe(msg, nmsg, &dlci->gsm->tx_list, list) {
+			list_del(&msg->list);	/* remove from msgqueue */
+			/* add to list of messages which could not be sent
+			   because of constipation */
+			list_add_tail(&msg->list, &dlci->constipated_list);
+			dlci->gsm->tx_bytes -= msg->len;
+		}
+		spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
+
 	} else if (!fc && dlci->constipated) {
 		dlci->constipated = 0;
+		spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
+		list_for_each_entry_safe(msg, nmsg, &dlci->constipated_list,
+					 list) {
+			list_del(&msg->list);	/* remove from msgqueue */
+			/* add to global messagequeue */
+			list_add_tail(&msg->list,  &dlci->gsm->tx_list);
+			dlci->gsm->tx_bytes += msg->len;
+		}
+		spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 		gsm_dlci_data_kick(dlci);
 	}
 
@@ -1640,6 +1669,7 @@ static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 		kfree(dlci);
 		return NULL;
 	}
+	INIT_LIST_HEAD(&dlci->constipated_list);
 
 	skb_queue_head_init(&dlci->skb_list);
 	init_timer(&dlci->t1);
@@ -2956,7 +2986,7 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	struct gsm_mux *gsm;
-
+	struct gsm_msg *msg, *nmsg;
 	if (dlci == NULL)
 		return;
 	if (dlci->state == DLCI_CLOSED)
@@ -2965,6 +2995,12 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 	gsm_destroy_network(dlci);
 	mutex_unlock(&dlci->mutex);
 	gsm = dlci->gsm;
+
+	list_for_each_entry_safe(msg, nmsg, &dlci->constipated_list, list) {
+		list_del(&msg->list);
+		kfree(msg);
+	}
+
 	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
 		goto out;
 	gsm_dlci_begin_close(dlci);
-- 
1.7.9.5



