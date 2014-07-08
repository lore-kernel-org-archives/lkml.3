Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaGHTmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:42:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54100 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcel Holtmann" <marcel@holtmann.org>,
        "Huang Shijie" <b32955@freescale.com>,
        "Andreas =?UTF-8?Q?Bie=C3=9Fmann?=" <andreas@biessmann.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Felipe Balbi" <balbi@ti.com>,
        "Peter Hurley" <peter@hurleysoftware.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.710528137@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 002/125] bluetooth: hci_ldisc: fix deadlock condition
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit da64c27d3c93ee9f89956b9de86c4127eb244494 upstream.

LDISCs shouldn't call tty->ops->write() from within
->write_wakeup().

->write_wakeup() is called with port lock taken and
IRQs disabled, tty->ops->write() will try to acquire
the same port lock and we will deadlock.

Acked-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Reported-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Tested-by: Andreas Bießmann <andreas@biessmann.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/hci_ldisc.c | 24 +++++++++++++++++++-----
 drivers/bluetooth/hci_uart.h  |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -120,10 +120,6 @@ static inline struct sk_buff *hci_uart_d
 
 int hci_uart_tx_wakeup(struct hci_uart *hu)
 {
-	struct tty_struct *tty = hu->tty;
-	struct hci_dev *hdev = hu->hdev;
-	struct sk_buff *skb;
-
 	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
 		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
 		return 0;
@@ -131,6 +127,22 @@ int hci_uart_tx_wakeup(struct hci_uart *
 
 	BT_DBG("");
 
+	schedule_work(&hu->write_work);
+
+	return 0;
+}
+
+static void hci_uart_write_work(struct work_struct *work)
+{
+	struct hci_uart *hu = container_of(work, struct hci_uart, write_work);
+	struct tty_struct *tty = hu->tty;
+	struct hci_dev *hdev = hu->hdev;
+	struct sk_buff *skb;
+
+	/* REVISIT: should we cope with bad skbs or ->write() returning
+	 * and error value ?
+	 */
+
 restart:
 	clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
 
@@ -155,7 +167,6 @@ restart:
 		goto restart;
 
 	clear_bit(HCI_UART_SENDING, &hu->tx_state);
-	return 0;
 }
 
 /* ------- Interface to HCI layer ------ */
@@ -274,6 +285,8 @@ static int hci_uart_tty_open(struct tty_
 	hu->tty = tty;
 	tty->receive_room = 65536;
 
+	INIT_WORK(&hu->write_work, hci_uart_write_work);
+
 	spin_lock_init(&hu->rx_lock);
 
 	/* Flush any pending characters in the driver and line discipline. */
@@ -308,6 +321,8 @@ static void hci_uart_tty_close(struct tt
 		if (hdev)
 			hci_uart_close(hdev);
 
+		cancel_work_sync(&hu->write_work);
+
 		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 			if (hdev) {
 				hci_unregister_dev(hdev);
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -64,6 +64,8 @@ struct hci_uart {
 	unsigned long		flags;
 	unsigned long		hdev_flags;
 
+	struct work_struct	write_work;
+
 	struct hci_uart_proto	*proto;
 	void			*priv;
 

