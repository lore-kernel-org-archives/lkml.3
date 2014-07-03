Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbaGCJVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbaGCJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/198] bluetooth: hci_ldisc: fix deadlock condition
Date: Thu,  3 Jul 2014 10:17:32 +0100
Message-Id: <1404379241-8590-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/hci_ldisc.c | 24 +++++++++++++++++++-----
 drivers/bluetooth/hci_uart.h  |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index bc68a440d432..c4d2f0e48685 100644
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
@@ -289,6 +300,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	tty->receive_room = 65536;
 
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
+	INIT_WORK(&hu->write_work, hci_uart_write_work);
 
 	spin_lock_init(&hu->rx_lock);
 
@@ -326,6 +338,8 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 	if (hdev)
 		hci_uart_close(hdev);
 
+	cancel_work_sync(&hu->write_work);
+
 	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 		if (hdev) {
 			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index fffa61ff5cb1..12df101ca942 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -68,6 +68,7 @@ struct hci_uart {
 	unsigned long		hdev_flags;
 
 	struct work_struct	init_ready;
+	struct work_struct	write_work;
 
 	struct hci_uart_proto	*proto;
 	void			*priv;
-- 
1.9.1

