Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161797AbaDPPes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:34:48 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:59435 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161761AbaDPPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:34:46 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 11:34:45 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH] bluetooth:hci_ldisc: add tasklet for deferred TX handling
Date: Wed, 16 Apr 2014 17:25:50 +0200
Message-Id: <1397661950-30408-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a recursive locking scenario when using BCSP connection via
8250 driver. The 8250 driver may tty_wakeup() in interrupt context which
results in hci_uart_tx_wakeup(). This in turn will call uart_write() in the
very same context and therefore will spin_lock() the same lock within the
same context.

Here is the call stack:

---8<---
=============================================
[ INFO: possible recursive locking detected ]
3.4.87-gf1a3cc3 #3 Tainted: G           O
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&port_lock_key){-.-...}, at: [<c023e21c>] uart_write+0x60/0xfc

but task is already holding lock:
 (&port_lock_key){-.-...}, at: [<c0242830>] serial8250_handle_irq+0x24/0x88

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&port_lock_key);
  lock(&port_lock_key);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by swapper/0:
 #0:  (&(&i->lock)->rlock){-.-...}, at: [<c0240f44>] serial8250_interrupt+0x2c/0xc0
 #1:  (&port_lock_key){-.-...}, at: [<c0242830>] serial8250_handle_irq+0x24/0x88

stack backtrace:
[<c0014234>] (unwind_backtrace+0x0/0xec) from [<c0398448>] (dump_stack+0x20/0x24)
[<c0398448>] (dump_stack+0x20/0x24) from [<c006eebc>] (print_deadlock_bug+0xb4/0xe4)
[<c006eebc>] (print_deadlock_bug+0xb4/0xe4) from [<c006f04c>] (check_deadlock.isra.20+0x160/0x18c)
[<c006f04c>] (check_deadlock.isra.20+0x160/0x18c) from [<c0070890>] (validate_chain.isra.24+0x4a4/0x4f0)
[<c0070890>] (validate_chain.isra.24+0x4a4/0x4f0) from [<c00715a0>] (__lock_acquire+0x670/0x740)
[<c00715a0>] (__lock_acquire+0x670/0x740) from [<c0071cb0>] (lock_acquire+0x138/0x15c)
[<c0071cb0>] (lock_acquire+0x138/0x15c) from [<c03a5904>] (_raw_spin_lock_irqsave+0x54/0x68)
[<c03a5904>] (_raw_spin_lock_irqsave+0x54/0x68) from [<c023e21c>] (uart_write+0x60/0xfc)
[<c023e21c>] (uart_write+0x60/0xfc) from [<bf0716d8>] (hci_uart_tx_wakeup+0x9c/0x160 [hci_uart])
[<bf0716d8>] (hci_uart_tx_wakeup+0x9c/0x160 [hci_uart]) from [<bf0717f4>] (hci_uart_tty_wakeup+0x58/0x5c [hci_uart])
[<bf0717f4>] (hci_uart_tty_wakeup+0x58/0x5c [hci_uart]) from [<c02246ec>] (tty_wakeup+0x48/0x68)
[<c02246ec>] (tty_wakeup+0x48/0x68) from [<c023efb0>] (uart_write_wakeup+0x2c/0x30)
[<c023efb0>] (uart_write_wakeup+0x2c/0x30) from [<c0241d0c>] (serial8250_tx_chars+0xf0/0x140)
[<c0241d0c>] (serial8250_tx_chars+0xf0/0x140) from [<c0242878>] (serial8250_handle_irq+0x6c/0x88)
[<c0242878>] (serial8250_handle_irq+0x6c/0x88) from [<c02428c4>] (serial8250_default_handle_irq+0x30/0x34)
[<c02428c4>] (serial8250_default_handle_irq+0x30/0x34) from [<c0240f5c>] (serial8250_interrupt+0x44/0xc0)
[<c0240f5c>] (serial8250_interrupt+0x44/0xc0) from [<c0087c70>] (handle_irq_event_percpu+0xc4/0x2cc)
[<c0087c70>] (handle_irq_event_percpu+0xc4/0x2cc) from [<c0087ec4>] (handle_irq_event+0x4c/0x6c)
[<c0087ec4>] (handle_irq_event+0x4c/0x6c) from [<c008a368>] (handle_edge_irq+0x114/0x14c)
[<c008a368>] (handle_edge_irq+0x114/0x14c) from [<c0087528>] (generic_handle_irq+0x40/0x54)
[<c0087528>] (generic_handle_irq+0x40/0x54) from [<c01f1900>] (gpio_irq_handler+0x168/0x1ac)
[<c01f1900>] (gpio_irq_handler+0x168/0x1ac) from [<c0087528>] (generic_handle_irq+0x40/0x54)
[<c0087528>] (generic_handle_irq+0x40/0x54) from [<c000ed7c>] (handle_IRQ+0x70/0x94)
[<c000ed7c>] (handle_IRQ+0x70/0x94) from [<c000877c>] (omap3_intc_handle_irq+0x64/0x78)
[<c000877c>] (omap3_intc_handle_irq+0x64/0x78) from [<c000df44>] (__irq_svc+0x44/0x78)
--->8---

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
---

It seems at least one other guy had the very same problem with another uart
(mpc52xx): http://www.spinics.net/lists/linux-rt-users/msg09246.html

I wonder, if my approach is right. It is runtime tested with 3.4.87 on our
board and work around the mentioned recursive locking. But I do not know, if
it should be fixed in another way.
If it is right, I'd work some more on it to get the fix mainline.

 drivers/bluetooth/hci_ldisc.c |   49 ++++++++++++++++++++++++++++++++++++-----
 drivers/bluetooth/hci_uart.h  |    2 ++
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index f1fbf4f..4da2f12 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -116,20 +116,37 @@ static inline struct sk_buff *hci_uart_dequeue(struct hci_uart *hu)
 	return skb;
 }
 
-int hci_uart_tx_wakeup(struct hci_uart *hu)
+static void hci_uart_tx_fill(unsigned long data)
 {
-	struct tty_struct *tty = hu->tty;
-	struct hci_dev *hdev = hu->hdev;
+	struct hci_uart *hu = (struct hci_uart *)data;
+	struct tty_struct *tty;
+	struct hci_dev *hdev;
 	struct sk_buff *skb;
 
+	if (!hu) {
+		BT_DBG("%s: no hci_uart", __func__);
+		return;
+	}
+
+	tty = hu->tty;
+	if (!tty) {
+		BT_DBG("%s: no tty", __func__);
+		return;
+	}
+	hdev = hu->hdev;
+	if (!hdev) {
+		BT_DBG("%s: no hdev", __func__);
+		return;
+	}
+
 	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
 		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
-		return 0;
+		return;
 	}
 
-	BT_DBG("");
-
 restart:
+	BT_DBG("%s: restart", __func__);
+
 	clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
 
 	while ((skb = hci_uart_dequeue(hu))) {
@@ -153,6 +170,17 @@ restart:
 		goto restart;
 
 	clear_bit(HCI_UART_SENDING, &hu->tx_state);
+}
+
+int hci_uart_tx_wakeup(struct hci_uart *hu)
+{
+	struct tty_struct *tty = hu->tty;
+	struct hci_dev *hdev = hu->hdev;
+
+	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+
+	tasklet_schedule(&hu->write_tasklet);
+
 	return 0;
 }
 
@@ -223,11 +251,16 @@ static int hci_uart_flush(struct hci_dev *hdev)
 /* Close device */
 static int hci_uart_close(struct hci_dev *hdev)
 {
+	struct hci_uart *hu;
+
 	BT_DBG("hdev %p", hdev);
 
 	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
 		return 0;
 
+	hu = hci_get_drvdata(hdev);
+	tasklet_kill(&hu->write_tasklet);
+
 	hci_uart_flush(hdev);
 	hdev->flush = NULL;
 	return 0;
@@ -428,9 +461,13 @@ static int hci_uart_register_dev(struct hci_uart *hu)
 	if (test_bit(HCI_UART_INIT_PENDING, &hu->hdev_flags))
 		return 0;
 
+	tasklet_init(&hu->write_tasklet,
+		     hci_uart_tx_fill, (unsigned long)hu);
+
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
 		hci_free_dev(hdev);
+		tasklet_kill(&hu->write_tasklet);
 		return -ENODEV;
 	}
 
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index fffa61f..a7f17a8 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -75,6 +75,8 @@ struct hci_uart {
 	struct sk_buff		*tx_skb;
 	unsigned long		tx_state;
 	spinlock_t		rx_lock;
+
+	struct tasklet_struct write_tasklet;
 };
 
 /* HCI_UART proto flag bits */
-- 
1.7.10.4

