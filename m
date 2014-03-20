Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbaCTTcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:32:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088AbaCTTcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:06 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 09/11] bluetooth: hci_ldisc: fix deadlock condition
Date: Thu, 20 Mar 2014 14:30:05 -0500
Message-ID: <1395343807-21618-9-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LDISCs shouldn't call tty->ops->write() from within
->write_wakeup().

->write_wakeup() is called with port lock taken and
IRQs disabled, tty->ops->write() will try to acquire
the same port lock and we will deadlock.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Reported-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/bluetooth/hci_ldisc.c | 24 +++++++++++++++++++-----
 drivers/bluetooth/hci_uart.h  |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 6e06f6f..77af52f 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -118,10 +118,6 @@ static inline struct sk_buff *hci_uart_dequeue(struct hci_uart *hu)
 
 int hci_uart_tx_wakeup(struct hci_uart *hu)
 {
-	struct tty_struct *tty = hu->tty;
-	struct hci_dev *hdev = hu->hdev;
-	struct sk_buff *skb;
-
 	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
 		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
 		return 0;
@@ -129,6 +125,22 @@ int hci_uart_tx_wakeup(struct hci_uart *hu)
 
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
 
@@ -153,7 +165,6 @@ restart:
 		goto restart;
 
 	clear_bit(HCI_UART_SENDING, &hu->tx_state);
-	return 0;
 }
 
 static void hci_uart_init_work(struct work_struct *work)
@@ -281,6 +292,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	tty->receive_room = 65536;
 
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
+	INIT_WORK(&hu->write_work, hci_uart_write_work);
 
 	spin_lock_init(&hu->rx_lock);
 
@@ -318,6 +330,8 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 	if (hdev)
 		hci_uart_close(hdev);
 
+	cancel_work_sync(&hu->write_work);
+
 	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 		if (hdev) {
 			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index fffa61f..12df101 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -68,6 +68,7 @@ struct hci_uart {
 	unsigned long		hdev_flags;
 
 	struct work_struct	init_ready;
+	struct work_struct	write_work;
 
 	struct hci_uart_proto	*proto;
 	void			*priv;
-- 
1.9.1.286.g5172cb3

