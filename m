Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3ITTGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:06:17 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54964 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3ITTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:06:14 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Ville Tervo <ville.tervo@nokia.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] Bluetooth: Add hci_h4p driver
Date: Fri, 20 Sep 2013 21:01:50 +0200
Message-Id: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Tervo <ville.tervo@nokia.com>

This driver adding support for Nokia N900 bluetooth hardware

Signed-off-by: Ville Tervo <ville.tervo@nokia.com>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/bluetooth/Kconfig             |   10 +
 drivers/bluetooth/Makefile            |    2 +
 drivers/bluetooth/hci_h4p/Makefile    |    7 +
 drivers/bluetooth/hci_h4p/core.c      | 1085 +++++++++++++++++++++++++++++++++
 drivers/bluetooth/hci_h4p/fw-bcm.c    |  149 +++++
 drivers/bluetooth/hci_h4p/fw-csr.c    |  152 +++++
 drivers/bluetooth/hci_h4p/fw-ti1273.c |  113 ++++
 drivers/bluetooth/hci_h4p/fw.c        |  166 +++++
 drivers/bluetooth/hci_h4p/hci_h4p.h   |  238 ++++++++
 drivers/bluetooth/hci_h4p/uart.c      |  203 ++++++
 include/linux/bluetooth/hci_h4p.h     |   41 ++
 11 files changed, 2166 insertions(+)
 create mode 100644 drivers/bluetooth/hci_h4p/Makefile
 create mode 100644 drivers/bluetooth/hci_h4p/core.c
 create mode 100644 drivers/bluetooth/hci_h4p/fw-bcm.c
 create mode 100644 drivers/bluetooth/hci_h4p/fw-csr.c
 create mode 100644 drivers/bluetooth/hci_h4p/fw-ti1273.c
 create mode 100644 drivers/bluetooth/hci_h4p/fw.c
 create mode 100644 drivers/bluetooth/hci_h4p/hci_h4p.h
 create mode 100644 drivers/bluetooth/hci_h4p/uart.c
 create mode 100644 include/linux/bluetooth/hci_h4p.h

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 11a6104..95155c3 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -242,4 +242,14 @@ config BT_WILINK
 
 	  Say Y here to compile support for Texas Instrument's WiLink7 driver
 	  into the kernel or say M to compile it as module.
+
+config BT_HCIH4P
+	tristate "HCI driver with H4 Nokia extensions"
+	depends on BT && ARCH_OMAP
+	help
+	  Bluetooth HCI driver with H4 extensions.  This driver provides
+	  support for H4+ Bluetooth chip with vendor-specific H4 extensions.
+
+	  Say Y here to compile support for h4 extended devices into the kernel
+	  or say M to compile it as module (hci_h4p).
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 4afae20..a5e6e19 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -30,3 +30,5 @@ hci_uart-$(CONFIG_BT_HCIUART_LL)	+= hci_ll.o
 hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	+= hci_ath.o
 hci_uart-$(CONFIG_BT_HCIUART_3WIRE)	+= hci_h5.o
 hci_uart-objs				:= $(hci_uart-y)
+
+obj-y				+= hci_h4p/
diff --git a/drivers/bluetooth/hci_h4p/Makefile b/drivers/bluetooth/hci_h4p/Makefile
new file mode 100644
index 0000000..f20bd9a
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux Bluetooth HCI device drivers.
+#
+
+obj-$(CONFIG_BT_HCIH4P)		+= hci_h4p.o
+
+hci_h4p-objs := core.o fw.o uart.o fw-csr.o fw-bcm.o fw-ti1273.o
diff --git a/drivers/bluetooth/hci_h4p/core.c b/drivers/bluetooth/hci_h4p/core.c
new file mode 100644
index 0000000..7ed9d4e
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/core.c
@@ -0,0 +1,1085 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2010 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/serial_reg.h>
+#include <linux/skbuff.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/timer.h>
+#include <linux/bluetooth/hci_h4p.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci.h>
+
+#include "hci_h4p.h"
+
+static void hci_h4p_set_clk(struct hci_h4p_info *info, int *clock, int enable)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->clocks_lock, flags);
+	if (enable && !*clock) {
+		NBT_DBG_POWER("Enabling %p\n", clock);
+		clk_prepare_enable(info->uart_fclk);
+		clk_prepare_enable(info->uart_iclk);
+		if (atomic_read(&info->clk_users) == 0)
+			hci_h4p_restore_regs(info);
+		atomic_inc(&info->clk_users);
+	}
+
+	if (!enable && *clock) {
+		NBT_DBG_POWER("Disabling %p\n", clock);
+		if (atomic_dec_and_test(&info->clk_users))
+			hci_h4p_store_regs(info);
+		clk_disable_unprepare(info->uart_fclk);
+		clk_disable_unprepare(info->uart_iclk);
+	}
+
+	*clock = enable;
+	spin_unlock_irqrestore(&info->clocks_lock, flags);
+}
+
+/* Power management functions */
+void hci_h4p_smart_idle(struct hci_h4p_info *info, bool enable)
+{
+	u8 v;
+
+	return;
+
+	v = hci_h4p_inb(info, UART_OMAP_SYSC);
+	v &= ~(UART_OMAP_SYSC_IDLEMASK);
+
+	if (enable)
+		v |= UART_OMAP_SYSC_SMART_IDLE;
+	else
+		v |= UART_OMAP_SYSC_NO_IDLE;
+
+	hci_h4p_outb(info, UART_OMAP_SYSC, v);
+}
+
+static void hci_h4p_disable_tx(struct hci_h4p_info *info)
+{
+	NBT_DBG_POWER("\n");
+
+	if (!info->pm_enabled)
+		return;
+
+	hci_h4p_smart_idle(info, 1);
+
+	info->bt_wakeup(0);
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+	info->tx_enabled = 0;
+}
+
+void hci_h4p_enable_tx(struct hci_h4p_info *info)
+{
+	NBT_DBG_POWER("\n");
+
+	if (!info->pm_enabled)
+		return;
+
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+	info->tx_enabled = 1;
+	hci_h4p_smart_idle(info, 0);
+	info->bt_wakeup(1);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+		     UART_IER_THRI);
+}
+
+static void hci_h4p_disable_rx(struct hci_h4p_info *info)
+{
+	if (!info->pm_enabled)
+		return;
+
+	info->rx_enabled = 0;
+
+	if (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
+		NBT_DBG("data ready postpone autorts");
+		return;
+	}
+
+	if (!(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT)) {
+		NBT_DBG("trasmitter not empty postpone autorts");
+		return;
+	}
+
+	hci_h4p_set_rts(info, info->rx_enabled);
+	__hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+	info->autorts = 0;
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+}
+
+static void hci_h4p_enable_rx(struct hci_h4p_info *info)
+{
+	if (!info->pm_enabled)
+		return;
+
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 1);
+	info->rx_enabled = 1;
+
+	hci_h4p_set_rts(info, 1);
+
+	if (!(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT)) {
+		NBT_DBG("trasmitter not empty postpone autorts");
+		return;
+	}
+
+	if (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
+		NBT_DBG("data ready postpone autorts");
+		return;
+	}
+
+	__hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+	info->autorts = 1;
+}
+
+/* Negotiation functions */
+int hci_h4p_send_alive_packet(struct hci_h4p_info *info)
+{
+	struct hci_h4p_alive_hdr *alive_hdr;
+	struct hci_h4p_alive_msg *alive_cmd;
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	NBT_DBG("Sending alive packet\n");
+
+	skb = bt_skb_alloc(HCI_H4P_ALIVE_HDR_SIZE + HCI_H4P_ALIVE_MSG_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	alive_hdr = (void *) skb_put(skb, HCI_H4P_ALIVE_HDR_SIZE);
+	alive_hdr->dlen = HCI_H4P_ALIVE_MSG_SIZE;
+	alive_cmd = (void *) skb_put(skb, HCI_H4P_ALIVE_MSG_SIZE);
+	alive_cmd->message_id = HCI_H4P_ALIVE_IND_REQ;
+	alive_cmd->unused = 0x00;
+	*skb_push(skb, 1) = H4_ALIVE_PKT;
+
+	skb_queue_tail(&info->txq, skb);
+	spin_lock_irqsave(&info->lock, flags);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+		     UART_IER_THRI);
+	spin_unlock_irqrestore(&info->lock, flags);
+
+	NBT_DBG("Alive packet sent\n");
+
+	return 0;
+}
+
+static void hci_h4p_alive_packet(struct hci_h4p_info *info, struct sk_buff *skb)
+{
+	struct hci_h4p_alive_hdr *alive_hdr = (void *) skb->data;
+	struct hci_h4p_alive_msg *alive_evt;
+
+	if (alive_hdr->dlen > skb->len) {
+		info->init_error = -EPROTO;
+		complete(&info->init_completion);
+		return;
+	}
+
+	alive_evt = (void *) skb_pull(skb, HCI_H4P_ALIVE_HDR_SIZE);
+
+	NBT_DBG("Received alive packet\n");
+	if (alive_evt->message_id != HCI_H4P_ALIVE_IND_RESP) {
+		dev_err(info->dev, "Could not negotiate hci_h4p settings\n");
+		info->init_error = -EINVAL;
+	}
+
+	complete(&info->init_completion);
+	kfree_skb(skb);
+}
+
+static int hci_h4p_send_negotiation(struct hci_h4p_info *info)
+{
+	struct hci_h4p_init_cmd *init_cmd;
+	struct hci_h4p_init_hdr *init_hdr;
+	struct sk_buff *skb;
+	unsigned long flags;
+	int err;
+
+	NBT_DBG("Sending negotiation..\n");
+
+	skb = bt_skb_alloc(HCI_H4P_INIT_HDR_SIZE + HCI_H4P_INIT_CMD_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	init_hdr = (void *)skb_put(skb, HCI_H4P_INIT_HDR_SIZE);
+	init_hdr->dlen = HCI_H4P_INIT_CMD_SIZE;
+	init_cmd = (void *)skb_put(skb, HCI_H4P_INIT_CMD_SIZE);
+	init_cmd->ack = 0x00;
+	init_cmd->baudrate = cpu_to_le16(0x01a1);
+	init_cmd->unused = cpu_to_le16(0x0000);
+	init_cmd->mode = HCI_H4P_MODE;
+	init_cmd->sys_clk = cpu_to_le16(0x9600);
+	init_cmd->unused2 = cpu_to_le16(0x0000);
+	*skb_push(skb, 1) = H4_NEG_PKT;
+
+	hci_h4p_change_speed(info, INIT_SPEED);
+
+	hci_h4p_set_rts(info, 1);
+	info->init_error = 0;
+	init_completion(&info->init_completion);
+	skb_queue_tail(&info->txq, skb);
+	spin_lock_irqsave(&info->lock, flags);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+			UART_IER_THRI);
+	spin_unlock_irqrestore(&info->lock, flags);
+
+	if (!wait_for_completion_interruptible_timeout(&info->init_completion,
+				msecs_to_jiffies(1000)))
+		return -ETIMEDOUT;
+
+	if (info->init_error < 0)
+		return info->init_error;
+
+	/* Change to operational settings */
+	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+	hci_h4p_set_rts(info, 0);
+	hci_h4p_change_speed(info, MAX_BAUD_RATE);
+
+	err = hci_h4p_wait_for_cts(info, 1, 100);
+	if (err < 0)
+		return err;
+
+	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+	init_completion(&info->init_completion);
+	err = hci_h4p_send_alive_packet(info);
+
+	if (err < 0)
+		return err;
+
+	if (!wait_for_completion_interruptible_timeout(&info->init_completion,
+				msecs_to_jiffies(1000)))
+		return -ETIMEDOUT;
+
+	if (info->init_error < 0)
+		return info->init_error;
+
+	NBT_DBG("Negotiation succesful\n");
+	return 0;
+}
+
+static void hci_h4p_negotiation_packet(struct hci_h4p_info *info,
+				       struct sk_buff *skb)
+{
+	struct hci_h4p_init_hdr *init_hdr = (void *) skb->data;
+	struct hci_h4p_init_evt *init_evt;
+
+	if (init_hdr->dlen > skb->len) {
+		kfree_skb(skb);
+		info->init_error = -EPROTO;
+		complete(&info->init_completion);
+		return;
+	}
+
+	init_evt = (void *)skb_pull(skb, HCI_H4P_INIT_HDR_SIZE);
+
+	if (init_evt->ack != HCI_H4P_ACK) {
+		dev_err(info->dev, "Could not negotiate hci_h4p settings\n");
+		info->init_error = -EINVAL;
+	}
+
+	info->man_id = init_evt->man_id;
+	info->ver_id = init_evt->ver_id;
+
+	complete(&info->init_completion);
+	kfree_skb(skb);
+}
+
+/* H4 packet handling functions */
+static int hci_h4p_get_hdr_len(struct hci_h4p_info *info, u8 pkt_type)
+{
+	long retval;
+
+	switch (pkt_type) {
+	case H4_EVT_PKT:
+		retval = HCI_EVENT_HDR_SIZE;
+		break;
+	case H4_ACL_PKT:
+		retval = HCI_ACL_HDR_SIZE;
+		break;
+	case H4_SCO_PKT:
+		retval = HCI_SCO_HDR_SIZE;
+		break;
+	case H4_NEG_PKT:
+		retval = HCI_H4P_INIT_HDR_SIZE;
+		break;
+	case H4_ALIVE_PKT:
+		retval = HCI_H4P_ALIVE_HDR_SIZE;
+		break;
+	case H4_RADIO_PKT:
+		retval = H4_RADIO_HDR_SIZE;
+		break;
+	default:
+		dev_err(info->dev, "Unknown H4 packet type 0x%.2x\n", pkt_type);
+		retval = -1;
+		break;
+	}
+
+	return retval;
+}
+
+static unsigned int hci_h4p_get_data_len(struct hci_h4p_info *info,
+					 struct sk_buff *skb)
+{
+	long retval = -1;
+	struct hci_event_hdr *evt_hdr;
+	struct hci_acl_hdr *acl_hdr;
+	struct hci_sco_hdr *sco_hdr;
+	struct hci_h4p_radio_hdr *radio_hdr;
+	struct hci_h4p_init_hdr *init_hdr;
+	struct hci_h4p_alive_hdr *alive_hdr;
+
+	switch (bt_cb(skb)->pkt_type) {
+	case H4_EVT_PKT:
+		evt_hdr = (struct hci_event_hdr *)skb->data;
+		retval = evt_hdr->plen;
+		break;
+	case H4_ACL_PKT:
+		acl_hdr = (struct hci_acl_hdr *)skb->data;
+		retval = le16_to_cpu(acl_hdr->dlen);
+		break;
+	case H4_SCO_PKT:
+		sco_hdr = (struct hci_sco_hdr *)skb->data;
+		retval = sco_hdr->dlen;
+		break;
+	case H4_RADIO_PKT:
+		radio_hdr = (struct hci_h4p_radio_hdr *)skb->data;
+		retval = radio_hdr->dlen;
+		break;
+	case H4_NEG_PKT:
+		init_hdr = (struct hci_h4p_init_hdr *)skb->data;
+		retval = init_hdr->dlen;
+		break;
+	case H4_ALIVE_PKT:
+		alive_hdr = (struct hci_h4p_alive_hdr *)skb->data;
+		retval = alive_hdr->dlen;
+		break;
+	}
+
+	return retval;
+}
+
+static inline void hci_h4p_recv_frame(struct hci_h4p_info *info,
+				      struct sk_buff *skb)
+{
+
+	if (unlikely(!test_bit(HCI_RUNNING, &info->hdev->flags))) {
+		NBT_DBG("fw_event\n");
+		if (bt_cb(info->rx_skb)->pkt_type == H4_NEG_PKT) {
+			hci_h4p_negotiation_packet(info, info->rx_skb);
+			return;
+		}
+		if (bt_cb(info->rx_skb)->pkt_type == H4_ALIVE_PKT) {
+			hci_h4p_alive_packet(info, info->rx_skb);
+			return;
+		}
+		hci_h4p_parse_fw_event(info, skb);
+	} else {
+		hci_recv_frame(skb);
+		NBT_DBG("Frame sent to upper layer\n");
+	}
+}
+
+static inline void hci_h4p_handle_byte(struct hci_h4p_info *info, u8 byte)
+{
+	switch (info->rx_state) {
+	case WAIT_FOR_PKT_TYPE:
+		bt_cb(info->rx_skb)->pkt_type = byte;
+		info->rx_count = hci_h4p_get_hdr_len(info, byte);
+		if (info->rx_count < 0) {
+			info->hdev->stat.err_rx++;
+			kfree_skb(info->rx_skb);
+			info->rx_skb = NULL;
+		} else {
+			info->rx_state = WAIT_FOR_HEADER;
+		}
+		break;
+	case WAIT_FOR_HEADER:
+		info->rx_count--;
+		*skb_put(info->rx_skb, 1) = byte;
+		if (info->rx_count != 0)
+			break;
+
+		info->rx_count = hci_h4p_get_data_len(info,
+				info->rx_skb);
+		if (info->rx_count > skb_tailroom(info->rx_skb)) {
+			dev_err(info->dev, "Too long frame.\n");
+			info->garbage_bytes = info->rx_count -
+				skb_tailroom(info->rx_skb);
+			kfree_skb(info->rx_skb);
+			info->rx_skb = NULL;
+			break;
+		}
+		info->rx_state = WAIT_FOR_DATA;
+		break;
+	case WAIT_FOR_DATA:
+		info->rx_count--;
+		*skb_put(info->rx_skb, 1) = byte;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	if (info->rx_count == 0) {
+		/* H4+ devices should allways send word aligned
+		 * packets */
+		if (!(info->rx_skb->len % 2))
+			info->garbage_bytes++;
+		hci_h4p_recv_frame(info, info->rx_skb);
+		info->rx_skb = NULL;
+	}
+}
+
+static void hci_h4p_rx(unsigned long data)
+{
+	u8 byte;
+	struct hci_h4p_info *info = (struct hci_h4p_info *)data;
+
+	NBT_DBG("rx woke up\n");
+
+	while (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
+		byte = hci_h4p_inb(info, UART_RX);
+		if (info->garbage_bytes) {
+			info->garbage_bytes--;
+			continue;
+		}
+		if (info->rx_skb == NULL) {
+			info->rx_skb = bt_skb_alloc(HCI_MAX_FRAME_SIZE,
+						    GFP_ATOMIC);
+			if (!info->rx_skb) {
+				dev_err(info->dev,
+					"No memory for new packet\n");
+				return;
+			}
+			info->rx_state = WAIT_FOR_PKT_TYPE;
+			info->rx_skb->dev = (void *)info->hdev;
+		}
+		info->hdev->stat.byte_rx++;
+		NBT_DBG_TRANSFER_NF("0x%.2x  ", byte);
+		hci_h4p_handle_byte(info, byte);
+	}
+
+	if (info->rx_enabled == info->autorts)
+		return;
+
+	if (!(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT))
+		return;
+
+	if (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR)
+		return;
+
+	hci_h4p_set_rts(info, info->rx_enabled);
+	__hci_h4p_set_auto_ctsrts(info, info->rx_enabled, UART_EFR_RTS);
+	info->autorts = info->rx_enabled;
+
+	/* Flush posted write to avoid spurious interrupts */
+	hci_h4p_inb(info, UART_OMAP_SCR);
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+}
+
+static void hci_h4p_tx(unsigned long data)
+{
+	unsigned int sent = 0;
+	struct sk_buff *skb;
+	struct hci_h4p_info *info = (struct hci_h4p_info *)data;
+
+	NBT_DBG("tx woke up\n");
+	NBT_DBG_TRANSFER("data ");
+
+	if (info->autorts != info->rx_enabled) {
+		NBT_DBG("rts unbalanced.. autorts %d rx_enabled %d", info->autorts, info->rx_enabled);
+		if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT &&
+		    !(hci_h4p_inb(info, UART_LSR) & UART_LSR_DR)) {
+			__hci_h4p_set_auto_ctsrts(info, info->rx_enabled,
+							  UART_EFR_RTS);
+			info->autorts = info->rx_enabled;
+			hci_h4p_set_rts(info, info->rx_enabled);
+			hci_h4p_set_clk(info, &info->rx_clocks_en,
+					info->rx_enabled);
+			NBT_DBG("transmitter empty. setinng into balance\n");
+		} else {
+			hci_h4p_outb(info, UART_OMAP_SCR,
+				     hci_h4p_inb(info, UART_OMAP_SCR) |
+				     UART_OMAP_SCR_EMPTY_THR);
+			NBT_DBG("transmitter/receiver was not empty waiting for next irq\n");
+			hci_h4p_set_rts(info, 1);
+			goto finish_tx;
+		}
+	}
+
+	skb = skb_dequeue(&info->txq);
+	if (!skb) {
+		/* No data in buffer */
+		NBT_DBG("skb ready\n");
+		if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
+			hci_h4p_outb(info, UART_IER,
+				     hci_h4p_inb(info, UART_IER) &
+				     ~UART_IER_THRI);
+			hci_h4p_inb(info, UART_OMAP_SCR);
+			hci_h4p_disable_tx(info);
+			NBT_DBG("transmitter was empty. cleaning up\n");
+			return;
+		}
+		hci_h4p_outb(info, UART_OMAP_SCR,
+				hci_h4p_inb(info, UART_OMAP_SCR) |
+				UART_OMAP_SCR_EMPTY_THR);
+		NBT_DBG("transmitter was not empty waiting for next irq\n");
+		goto finish_tx;
+	}
+
+	/* Copy data to tx fifo */
+	while (!(hci_h4p_inb(info, UART_OMAP_SSR) & UART_OMAP_SSR_TXFULL) &&
+	       (sent < skb->len)) {
+		NBT_DBG_TRANSFER_NF("0x%.2x ", skb->data[sent]);
+		hci_h4p_outb(info, UART_TX, skb->data[sent]);
+		sent++;
+	}
+
+	info->hdev->stat.byte_tx += sent;
+	if (skb->len == sent) {
+		kfree_skb(skb);
+	} else {
+		skb_pull(skb, sent);
+		skb_queue_head(&info->txq, skb);
+	}
+
+	hci_h4p_outb(info, UART_OMAP_SCR, hci_h4p_inb(info, UART_OMAP_SCR) &
+						     ~UART_OMAP_SCR_EMPTY_THR);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+						 UART_IER_THRI);
+
+finish_tx:
+	/* Flush posted write to avoid spurious interrupts */
+	hci_h4p_inb(info, UART_OMAP_SCR);
+
+}
+
+static irqreturn_t hci_h4p_interrupt(int irq, void *data)
+{
+	struct hci_h4p_info *info = (struct hci_h4p_info *)data;
+	u8 iir, msr;
+	int ret;
+
+	ret = IRQ_NONE;
+
+	iir = hci_h4p_inb(info, UART_IIR);
+	if (iir & UART_IIR_NO_INT)
+		return IRQ_HANDLED;
+
+	NBT_DBG("In interrupt handler iir 0x%.2x\n", iir);
+
+	iir &= UART_IIR_ID;
+
+	if (iir == UART_IIR_MSI) {
+		msr = hci_h4p_inb(info, UART_MSR);
+		ret = IRQ_HANDLED;
+	}
+	if (iir == UART_IIR_RLSI) {
+		hci_h4p_inb(info, UART_RX);
+		hci_h4p_inb(info, UART_LSR);
+		ret = IRQ_HANDLED;
+	}
+
+	if (iir == UART_IIR_RDI) {
+		hci_h4p_rx((unsigned long)data);
+		ret = IRQ_HANDLED;
+	}
+
+	if (iir == UART_IIR_THRI) {
+		hci_h4p_tx((unsigned long)data);
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
+static irqreturn_t hci_h4p_wakeup_interrupt(int irq, void *dev_inst)
+{
+	struct hci_h4p_info *info = dev_inst;
+	int should_wakeup;
+	struct hci_dev *hdev;
+
+	if (!info->hdev)
+		return IRQ_HANDLED;
+
+	hdev = info->hdev;
+
+	if (!test_bit(HCI_RUNNING, &hdev->flags))
+		return IRQ_HANDLED;
+
+	should_wakeup = info->host_wakeup();
+	NBT_DBG_POWER("gpio interrupt %d\n", should_wakeup);
+
+	/* Check if wee have missed some interrupts */
+	if (info->rx_enabled == should_wakeup)
+		return IRQ_HANDLED;
+
+	if (should_wakeup)
+		hci_h4p_enable_rx(info);
+	else
+		hci_h4p_disable_rx(info);
+
+	return IRQ_HANDLED;
+}
+
+static int hci_h4p_reset(struct hci_h4p_info *info)
+{
+	int err;
+
+	err = hci_h4p_reset_uart(info);
+	if (err < 0) {
+		dev_err(info->dev, "Uart reset failed\n");
+		return err;
+	}
+	hci_h4p_init_uart(info);
+	hci_h4p_set_rts(info, 0);
+
+	info->reset(0);
+	info->bt_wakeup(1);
+	msleep(10);
+	info->reset(1);
+
+	err = hci_h4p_wait_for_cts(info, 1, 100);
+	if (err < 0) {
+		dev_err(info->dev, "No cts from bt chip\n");
+		return err;
+	}
+
+	hci_h4p_set_rts(info, 1);
+
+	return 0;
+}
+
+/* hci callback functions */
+static int hci_h4p_hci_flush(struct hci_dev *hdev)
+{
+	struct hci_h4p_info *info;
+	info = hci_get_drvdata(hdev);
+
+	skb_queue_purge(&info->txq);
+
+	return 0;
+}
+
+static int hci_h4p_hci_open(struct hci_dev *hdev)
+{
+	struct hci_h4p_info *info;
+	int err;
+	struct sk_buff_head fw_queue;
+	unsigned long flags;
+
+	info = hci_get_drvdata(hdev);
+
+	if (test_bit(HCI_RUNNING, &hdev->flags))
+		return 0;
+
+	info->rx_enabled = 1;
+	info->rx_state = WAIT_FOR_PKT_TYPE;
+	info->rx_count = 0;
+	info->garbage_bytes = 0;
+	info->rx_skb = NULL;
+	info->pm_enabled = 0;
+	init_completion(&info->fw_completion);
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 1);
+	skb_queue_head_init(&fw_queue);
+
+	err = hci_h4p_reset(info);
+	if (err < 0)
+		goto err_clean;
+
+	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_CTS | UART_EFR_RTS);
+	info->autorts = 1;
+	err = hci_h4p_send_negotiation(info);
+	if (err < 0)
+		goto err_clean;
+
+	skb_queue_head_init(&fw_queue);
+	err = hci_h4p_read_fw(info, &fw_queue);
+	if (err < 0) {
+		dev_err(info->dev, "Cannot read firmware\n");
+		return err;
+	}
+
+	/* FW image contains also unneeded negoation and alive msgs */
+	skb_dequeue(&fw_queue);
+	skb_dequeue(&fw_queue);
+
+	err = hci_h4p_send_fw(info, &fw_queue);
+	if (err < 0) {
+		dev_err(info->dev, "Sending firmware failed.\n");
+		goto err_clean;
+	}
+
+	info->pm_enabled = 1;
+
+	spin_lock_irqsave(&info->lock, flags);
+	info->rx_enabled = info->host_wakeup();
+	hci_h4p_set_clk(info, &info->rx_clocks_en, info->rx_enabled);
+	spin_unlock_irqrestore(&info->lock, flags);
+
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+
+	set_bit(HCI_RUNNING, &hdev->flags);
+
+	NBT_DBG("hci up and running\n");
+	return 0;
+
+err_clean:
+	hci_h4p_hci_flush(hdev);
+	hci_h4p_reset_uart(info);
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+	info->reset(0);
+	info->bt_wakeup(0);
+	skb_queue_purge(&fw_queue);
+	kfree_skb(info->rx_skb);
+
+	return err;
+}
+
+static int hci_h4p_hci_close(struct hci_dev *hdev)
+{
+	struct hci_h4p_info *info = hci_get_drvdata(hdev);
+
+	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
+		return 0;
+
+	hci_h4p_hci_flush(hdev);
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 1);
+	hci_h4p_reset_uart(info);
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+	hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+	info->reset(0);
+	info->bt_wakeup(0);
+	kfree_skb(info->rx_skb);
+
+	return 0;
+}
+
+static int hci_h4p_hci_send_frame(struct sk_buff *skb)
+{
+	struct hci_h4p_info *info;
+	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
+	int err = 0;
+	unsigned long flags;
+
+	if (!hdev) {
+		printk(KERN_WARNING "hci_h4p: Frame for unknown device\n");
+		return -ENODEV;
+	}
+
+	NBT_DBG("dev %p, skb %p\n", hdev, skb);
+
+	info = hci_get_drvdata(hdev);
+
+	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
+		dev_warn(info->dev, "Frame for non-running device\n");
+		return -EIO;
+	}
+
+	switch (bt_cb(skb)->pkt_type) {
+	case HCI_COMMAND_PKT:
+		hdev->stat.cmd_tx++;
+		break;
+	case HCI_ACLDATA_PKT:
+		hdev->stat.acl_tx++;
+		break;
+	case HCI_SCODATA_PKT:
+		hdev->stat.sco_tx++;
+		break;
+	}
+
+	/* Push frame type to skb */
+	*skb_push(skb, 1) = (bt_cb(skb)->pkt_type);
+	/* We should allways send word aligned data to h4+ devices */
+	if (skb->len % 2) {
+		err = skb_pad(skb, 1);
+		if (!err)
+			*skb_put(skb, 1) = 0x00;
+	}
+	if (err)
+		return err;
+
+	spin_lock_irqsave(&info->lock, flags);
+	skb_queue_tail(&info->txq, skb);
+	hci_h4p_enable_tx(info);
+	spin_unlock_irqrestore(&info->lock, flags);
+
+	return 0;
+}
+
+static int hci_h4p_hci_ioctl(struct hci_dev *hdev, unsigned int cmd,
+			     unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
+
+static int hci_h4p_register_hdev(struct hci_h4p_info *info)
+{
+	struct hci_dev *hdev;
+
+	/* Initialize and register HCI device */
+
+	hdev = hci_alloc_dev();
+	if (!hdev) {
+		dev_err(info->dev, "Can't allocate memory for device\n");
+		return -ENOMEM;
+	}
+	info->hdev = hdev;
+
+	hdev->bus = HCI_UART;
+	hci_set_drvdata(hdev, info);
+
+	hdev->open = hci_h4p_hci_open;
+	hdev->close = hci_h4p_hci_close;
+	hdev->flush = hci_h4p_hci_flush;
+	hdev->send = hci_h4p_hci_send_frame;
+	hdev->ioctl = hci_h4p_hci_ioctl;
+	set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
+
+	SET_HCIDEV_DEV(hdev, info->dev);
+
+	if (hci_register_dev(hdev) < 0) {
+		dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static ssize_t hci_h4p_store_bdaddr(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct hci_h4p_info *info = dev_get_drvdata(dev);
+	unsigned int bdaddr[6];
+	int ret, i;
+
+	ret = sscanf(buf, "%2x:%2x:%2x:%2x:%2x:%2x\n",
+			&bdaddr[0], &bdaddr[1], &bdaddr[2],
+			&bdaddr[3], &bdaddr[4], &bdaddr[5]);
+
+	if (ret != 6)
+		return -EINVAL;
+
+	for (i = 0; i < 6; i++)
+		info->bd_addr[i] = bdaddr[i] & 0xff;
+
+	return count;
+}
+
+static ssize_t hci_h4p_show_bdaddr(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct hci_h4p_info *info = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
+		       info->bd_addr[0], info->bd_addr[1], info->bd_addr[2],
+		       info->bd_addr[3], info->bd_addr[4], info->bd_addr[5]);
+}
+
+static DEVICE_ATTR(bdaddr, S_IRUGO | S_IWUSR, hci_h4p_show_bdaddr,
+		   hci_h4p_store_bdaddr);
+
+static int hci_h4p_sysfs_create_files(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_bdaddr);
+}
+
+static void hci_h4p_sysfs_remove_files(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_bdaddr);
+}
+
+static int hci_h4p_probe(struct platform_device *pdev)
+{
+	struct hci_h4p_platform_data *bt_plat_data;
+	struct hci_h4p_info *info;
+	int err;
+
+	dev_info(&pdev->dev, "Registering HCI H4P device\n");
+	info = kzalloc(sizeof(struct hci_h4p_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->dev = &pdev->dev;
+	info->pm_enabled = 0;
+	info->tx_enabled = 1;
+	info->rx_enabled = 1;
+	info->garbage_bytes = 0;
+	info->tx_clocks_en = 0;
+	info->rx_clocks_en = 0;
+	spin_lock_init(&info->lock);
+	spin_lock_init(&info->clocks_lock);
+	skb_queue_head_init(&info->txq);
+
+	if (pdev->dev.platform_data == NULL) {
+		dev_err(&pdev->dev, "Could not get Bluetooth config data\n");
+		kfree(info);
+		return -ENODATA;
+	}
+
+	bt_plat_data = pdev->dev.platform_data;
+	info->chip_type = 3;
+	info->bt_wakeup = bt_plat_data->bt_wu;
+	info->host_wakeup = bt_plat_data->host_wu;
+	info->reset = bt_plat_data->reset;
+	info->uart_base = bt_plat_data->uart_base;
+	info->host_wakeup_gpio = bt_plat_data->host_wu_gpio;
+
+	NBT_DBG("RESET gpio: %p\n", info->reset);
+	NBT_DBG("BTWU gpio: %p\n", info->bt_wakeup);
+	NBT_DBG("HOSTWU gpio: %p\n", info->host_wakeup);
+
+	info->irq = bt_plat_data->uart_irq;
+	err = request_irq(info->irq, hci_h4p_interrupt, IRQF_DISABLED | IRQF_SHARED,
+			"hci_h4p", info);
+	if (err < 0) {
+		dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n", info->irq);
+		goto cleanup;
+	}
+
+	err = request_irq(gpio_to_irq(info->host_wakeup_gpio),
+			  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
+			  IRQF_TRIGGER_RISING | IRQF_DISABLED,
+			  "hci_h4p_wkup", info);
+	if (err < 0) {
+		dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
+			  gpio_to_irq(info->host_wakeup_gpio));
+		free_irq(info->irq, info);
+		goto cleanup;
+	}
+
+	err = irq_set_irq_wake(gpio_to_irq(info->host_wakeup_gpio), 1);
+	if (err < 0) {
+		dev_err(info->dev, "hci_h4p: unable to set wakeup for IRQ %d\n",
+				gpio_to_irq(info->host_wakeup_gpio));
+		free_irq(info->irq, info);
+		free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
+		goto cleanup;
+	}
+
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+	err = hci_h4p_reset_uart(info);
+	if (err < 0)
+		goto cleanup_irq;
+	hci_h4p_init_uart(info);
+	hci_h4p_set_rts(info, 0);
+	err = hci_h4p_reset(info);
+	hci_h4p_reset_uart(info);
+	if (err < 0)
+		goto cleanup_irq;
+	info->reset(0);
+	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+
+	platform_set_drvdata(pdev, info);
+
+	if (hci_h4p_sysfs_create_files(info->dev) < 0) {
+		dev_err(info->dev, "failed to create sysfs files\n");
+		goto cleanup_irq;
+	}
+
+	if (hci_h4p_register_hdev(info) < 0) {
+		dev_err(info->dev, "failed to register hci_h4p hci device\n");
+		goto cleanup_sysfs;
+	}
+
+	return 0;
+
+cleanup_sysfs:
+	hci_h4p_sysfs_remove_files(info->dev);
+cleanup_irq:
+	free_irq(info->irq, (void *)info);
+	free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
+cleanup:
+	info->reset(0);
+	kfree(info);
+	return err;
+
+}
+
+static int hci_h4p_remove(struct platform_device *pdev)
+{
+	struct hci_h4p_info *info;
+
+	info = platform_get_drvdata(pdev);
+
+	hci_h4p_sysfs_remove_files(info->dev);
+	hci_h4p_hci_close(info->hdev);
+	free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
+	hci_unregister_dev(info->hdev);
+	hci_free_dev(info->hdev);
+	free_irq(info->irq, (void *) info);
+	kfree(info);
+
+	return 0;
+}
+
+static struct platform_driver hci_h4p_driver = {
+	.probe		= hci_h4p_probe,
+	.remove		= hci_h4p_remove,
+	.driver		= {
+		.name	= "hci_h4p",
+	},
+};
+
+static int __init hci_h4p_init(void)
+{
+	int err = 0;
+
+	/* Register the driver with LDM */
+	err = platform_driver_register(&hci_h4p_driver);
+	if (err < 0)
+		printk(KERN_WARNING "failed to register hci_h4p driver\n");
+
+	return err;
+}
+
+static void __exit hci_h4p_exit(void)
+{
+	platform_driver_unregister(&hci_h4p_driver);
+}
+
+module_init(hci_h4p_init);
+module_exit(hci_h4p_exit);
+
+MODULE_ALIAS("platform:hci_h4p");
+MODULE_DESCRIPTION("Bluetooth h4 driver with nokia extensions");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ville Tervo");
+MODULE_FIRMWARE(FW_NAME_CSR);
+MODULE_FIRMWARE(FW_NAME_TI);
+MODULE_FIRMWARE(FW_NAME_BCM);
diff --git a/drivers/bluetooth/hci_h4p/fw-bcm.c b/drivers/bluetooth/hci_h4p/fw-bcm.c
new file mode 100644
index 0000000..56684f8
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw-bcm.c
@@ -0,0 +1,149 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2008 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/serial_reg.h>
+
+#include "hci_h4p.h"
+
+static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info, struct sk_buff *skb)
+{
+	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+	int not_valid;
+	int i;
+
+	not_valid = 1;
+	for (i = 0; i < 6; i++) {
+		if (info->bd_addr[i] != 0x00) {
+			not_valid = 0;
+			break;
+		}
+	}
+
+	if (not_valid) {
+		dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
+		/* When address is not valid, use some random but Nokia MAC */
+		memcpy(info->bd_addr, nokia_oui, 3);
+		get_random_bytes(info->bd_addr + 3, 3);
+	}
+
+	for (i = 0; i < 6; i++)
+		skb->data[9 - i] = info->bd_addr[i];
+
+	return 0;
+}
+
+void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
+{
+	struct sk_buff *fw_skb;
+	int err;
+	unsigned long flags;
+
+	if (skb->data[5] != 0x00) {
+		dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
+			skb->data[5]);
+		info->fw_error = -EPROTO;
+	}
+
+	kfree_skb(skb);
+
+	fw_skb = skb_dequeue(info->fw_q);
+	if (fw_skb == NULL || info->fw_error) {
+		complete(&info->fw_completion);
+		return;
+	}
+
+	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc && fw_skb->len >= 10) {
+		NBT_DBG_FW("Setting bluetooth address\n");
+		err = hci_h4p_bcm_set_bdaddr(info, fw_skb);
+		if (err < 0) {
+			kfree_skb(fw_skb);
+			info->fw_error = err;
+			complete(&info->fw_completion);
+			return;
+		}
+	}
+
+	skb_queue_tail(&info->txq, fw_skb);
+	spin_lock_irqsave(&info->lock, flags);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+			UART_IER_THRI);
+	spin_unlock_irqrestore(&info->lock, flags);
+}
+
+
+int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
+			struct sk_buff_head *fw_queue)
+{
+	struct sk_buff *skb;
+	unsigned long flags, time;
+
+	info->fw_error = 0;
+
+	NBT_DBG_FW("Sending firmware\n");
+
+	time = jiffies;
+
+	info->fw_q = fw_queue;
+	skb = skb_dequeue(fw_queue);
+	if (!skb)
+		return -ENODATA;
+
+	NBT_DBG_FW("Sending commands\n");
+
+	/*
+	 * Disable smart-idle as UART TX interrupts
+	 * are not wake-up capable
+	 */
+	hci_h4p_smart_idle(info, 0);
+
+	/* Check if this is bd_address packet */
+	init_completion(&info->fw_completion);
+	skb_queue_tail(&info->txq, skb);
+	spin_lock_irqsave(&info->lock, flags);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+			UART_IER_THRI);
+	spin_unlock_irqrestore(&info->lock, flags);
+
+	if (!wait_for_completion_timeout(&info->fw_completion,
+				msecs_to_jiffies(2000))) {
+		dev_err(info->dev, "No reply to fw command\n");
+		return -ETIMEDOUT;
+	}
+
+	if (info->fw_error) {
+		dev_err(info->dev, "FW error\n");
+		return -EPROTO;
+	}
+
+	NBT_DBG_FW("Firmware sent in %d msecs\n",
+		   jiffies_to_msecs(jiffies-time));
+
+	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+	hci_h4p_set_rts(info, 0);
+	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+
+	return 0;
+}
diff --git a/drivers/bluetooth/hci_h4p/fw-csr.c b/drivers/bluetooth/hci_h4p/fw-csr.c
new file mode 100644
index 0000000..af880d9
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw-csr.c
@@ -0,0 +1,152 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2008 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/serial_reg.h>
+
+#include "hci_h4p.h"
+
+void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
+{
+	/* Check if this is fw packet */
+	if (skb->data[0] != 0xff) {
+		hci_recv_frame(skb);
+		return;
+	}
+
+	if (skb->data[11] || skb->data[12]) {
+		dev_err(info->dev, "Firmware sending command failed\n");
+		info->fw_error = -EPROTO;
+	}
+
+	kfree_skb(skb);
+	complete(&info->fw_completion);
+}
+
+int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
+			struct sk_buff_head *fw_queue)
+{
+	static const u8 nokia_oui[3] = {0x00, 0x19, 0x4F};
+	struct sk_buff *skb;
+	unsigned int offset;
+	int retries, count, i, not_valid;
+	unsigned long flags;
+
+	info->fw_error = 0;
+
+	NBT_DBG_FW("Sending firmware\n");
+	skb = skb_dequeue(fw_queue);
+
+	if (!skb)
+		return -ENOMSG;
+
+	/* Check if this is bd_address packet */
+	if (skb->data[15] == 0x01 && skb->data[16] == 0x00) {
+		offset = 21;
+		skb->data[offset + 1] = 0x00;
+		skb->data[offset + 5] = 0x00;
+
+		not_valid = 1;
+		for (i = 0; i < 6; i++) {
+			if (info->bd_addr[i] != 0x00) {
+				not_valid = 0;
+				break;
+			}
+		}
+
+		if (not_valid) {
+			dev_info(info->dev, "Valid bluetooth address not found,"
+					" setting some random\n");
+			/* When address is not valid, use some random */
+			memcpy(info->bd_addr, nokia_oui, 3);
+			get_random_bytes(info->bd_addr + 3, 3);
+		}
+
+		skb->data[offset + 7] = info->bd_addr[0];
+		skb->data[offset + 6] = info->bd_addr[1];
+		skb->data[offset + 4] = info->bd_addr[2];
+		skb->data[offset + 0] = info->bd_addr[3];
+		skb->data[offset + 3] = info->bd_addr[4];
+		skb->data[offset + 2] = info->bd_addr[5];
+	}
+
+	for (count = 1; ; count++) {
+		NBT_DBG_FW("Sending firmware command %d\n", count);
+		init_completion(&info->fw_completion);
+		skb_queue_tail(&info->txq, skb);
+		spin_lock_irqsave(&info->lock, flags);
+		hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+							 UART_IER_THRI);
+		spin_unlock_irqrestore(&info->lock, flags);
+
+		skb = skb_dequeue(fw_queue);
+		if (!skb)
+			break;
+
+		if (!wait_for_completion_timeout(&info->fw_completion,
+						 msecs_to_jiffies(1000))) {
+			dev_err(info->dev, "No reply to fw command\n");
+			return -ETIMEDOUT;
+		}
+
+		if (info->fw_error) {
+			dev_err(info->dev, "FW error\n");
+			return -EPROTO;
+		}
+	};
+
+	/* Wait for chip warm reset */
+	retries = 100;
+	while ((!skb_queue_empty(&info->txq) ||
+	       !(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT)) &&
+	       retries--) {
+		msleep(10);
+	}
+	if (!retries) {
+		dev_err(info->dev, "Transmitter not empty\n");
+		return -ETIMEDOUT;
+	}
+
+	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+
+	if (hci_h4p_wait_for_cts(info, 1, 100)) {
+		dev_err(info->dev, "cts didn't deassert after final speed\n");
+		return -ETIMEDOUT;
+	}
+
+	retries = 100;
+	do {
+		init_completion(&info->init_completion);
+		hci_h4p_send_alive_packet(info);
+		retries--;
+	} while (!wait_for_completion_timeout(&info->init_completion, 100) &&
+		 retries > 0);
+
+	if (!retries) {
+		dev_err(info->dev, "No alive reply after speed change\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
diff --git a/drivers/bluetooth/hci_h4p/fw-ti1273.c b/drivers/bluetooth/hci_h4p/fw-ti1273.c
new file mode 100644
index 0000000..d46c3a0
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw-ti1273.c
@@ -0,0 +1,113 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2009 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/serial_reg.h>
+
+#include "hci_h4p.h"
+
+static struct sk_buff_head *fw_q;
+
+void hci_h4p_ti1273_parse_fw_event(struct hci_h4p_info *info,
+			struct sk_buff *skb)
+{
+	struct sk_buff *fw_skb;
+	unsigned long flags;
+
+	if (skb->data[5] != 0x00) {
+		dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
+			skb->data[5]);
+		info->fw_error = -EPROTO;
+	}
+
+	kfree_skb(skb);
+
+	fw_skb = skb_dequeue(fw_q);
+	if (fw_skb == NULL || info->fw_error) {
+		complete(&info->fw_completion);
+		return;
+	}
+
+	hci_h4p_enable_tx(info);
+	skb_queue_tail(&info->txq, fw_skb);
+	spin_lock_irqsave(&info->lock, flags);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+			UART_IER_THRI);
+	spin_unlock_irqrestore(&info->lock, flags);
+}
+
+
+int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
+			struct sk_buff_head *fw_queue)
+{
+	struct sk_buff *skb;
+	unsigned long flags, time;
+
+	info->fw_error = 0;
+
+	NBT_DBG_FW("Sending firmware\n");
+
+	time = jiffies;
+
+	fw_q = fw_queue;
+	skb = skb_dequeue(fw_queue);
+	if (!skb)
+		return -ENODATA;
+
+	NBT_DBG_FW("Sending commands\n");
+	/* Check if this is bd_address packet */
+	init_completion(&info->fw_completion);
+	hci_h4p_enable_tx(info);
+	skb_queue_tail(&info->txq, skb);
+	spin_lock_irqsave(&info->lock, flags);
+	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+			UART_IER_THRI);
+	spin_unlock_irqrestore(&info->lock, flags);
+
+	if (!wait_for_completion_timeout(&info->fw_completion,
+				msecs_to_jiffies(40000))) {
+		dev_err(info->dev, "No reply to fw command\n");
+		return -ETIMEDOUT;
+	}
+
+	if (info->fw_error) {
+		dev_err(info->dev, "FW error\n");
+		return -EPROTO;
+	}
+
+	NBT_DBG_FW("Firmware sent in %d msecs\n",
+		   jiffies_to_msecs(jiffies-time));
+
+	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+	hci_h4p_set_rts(info, 0);
+	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+	if (hci_h4p_wait_for_cts(info, 1, 100)) {
+		dev_err(info->dev,
+			"cts didn't go down after final speed change\n");
+		return -ETIMEDOUT;
+	}
+	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+
+	return 0;
+}
diff --git a/drivers/bluetooth/hci_h4p/fw.c b/drivers/bluetooth/hci_h4p/fw.c
new file mode 100644
index 0000000..b767a12
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw.c
@@ -0,0 +1,166 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005, 2006 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/firmware.h>
+#include <linux/clk.h>
+
+#include <net/bluetooth/bluetooth.h>
+
+#include "hci_h4p.h"
+
+static int fw_pos;
+
+/* Firmware handling */
+static int hci_h4p_open_firmware(struct hci_h4p_info *info,
+				 const struct firmware **fw_entry)
+{
+	int err;
+
+	fw_pos = 0;
+	NBT_DBG_FW("Opening %d/%d firmware\n", info->man_id, info->ver_id);
+	switch (info->man_id) {
+	case BT_CHIP_TI:
+		err = request_firmware(fw_entry, FW_NAME_TI, info->dev);
+		break;
+	case BT_CHIP_CSR:
+		err = request_firmware(fw_entry, FW_NAME_CSR, info->dev);
+		break;
+	case BT_CHIP_BCM:
+		err = request_firmware(fw_entry, FW_NAME_BCM, info->dev);
+		break;
+	default:
+		dev_err(info->dev, "Invalid chip type %d\n", info->man_id);
+		*fw_entry = NULL;
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static void hci_h4p_close_firmware(const struct firmware *fw_entry)
+{
+	release_firmware(fw_entry);
+}
+
+/* Read fw. Return length of the command. If no more commands in
+ * fw 0 is returned. In error case return value is negative.
+ */
+static int hci_h4p_read_fw_cmd(struct hci_h4p_info *info, struct sk_buff **skb,
+			       const struct firmware *fw_entry, gfp_t how)
+{
+	unsigned int cmd_len;
+
+	if (fw_pos >= fw_entry->size)
+		return 0;
+
+	if (fw_pos + 2 > fw_entry->size) {
+		dev_err(info->dev, "Corrupted firmware image 1\n");
+		return -EMSGSIZE;
+	}
+
+	cmd_len = fw_entry->data[fw_pos++];
+	cmd_len += fw_entry->data[fw_pos++] << 8;
+	if (cmd_len == 0)
+		return 0;
+
+	if (fw_pos + cmd_len > fw_entry->size) {
+		dev_err(info->dev, "Corrupted firmware image 2\n");
+		return -EMSGSIZE;
+	}
+
+	*skb = bt_skb_alloc(cmd_len, how);
+	if (!*skb) {
+		dev_err(info->dev, "Cannot reserve memory for buffer\n");
+		return -ENOMEM;
+	}
+	memcpy(skb_put(*skb, cmd_len), &fw_entry->data[fw_pos], cmd_len);
+
+	fw_pos += cmd_len;
+
+	return (*skb)->len;
+}
+
+int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue)
+{
+	const struct firmware *fw_entry = NULL;
+	struct sk_buff *skb = NULL;
+	int err;
+
+	err = hci_h4p_open_firmware(info, &fw_entry);
+	if (err < 0 || !fw_entry)
+		goto err_clean;
+
+	while ((err = hci_h4p_read_fw_cmd(info, &skb, fw_entry, GFP_KERNEL))) {
+		if (err < 0 || !skb)
+			goto err_clean;
+
+		skb_queue_tail(fw_queue, skb);
+	}
+
+err_clean:
+	hci_h4p_close_firmware(fw_entry);
+	return err;
+}
+
+int hci_h4p_send_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue)
+{
+	int err;
+
+	switch (info->man_id) {
+	case BT_CHIP_CSR:
+		err = hci_h4p_bc4_send_fw(info, fw_queue);
+		break;
+	case BT_CHIP_TI:
+		err = hci_h4p_ti1273_send_fw(info, fw_queue);
+		break;
+	case BT_CHIP_BCM:
+		err = hci_h4p_bcm_send_fw(info, fw_queue);
+		break;
+	default:
+		dev_err(info->dev, "Don't know how to send firmware\n");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
+{
+	switch (info->man_id) {
+	case BT_CHIP_CSR:
+		hci_h4p_bc4_parse_fw_event(info, skb);
+		break;
+	case BT_CHIP_TI:
+		hci_h4p_ti1273_parse_fw_event(info, skb);
+		break;
+	case BT_CHIP_BCM:
+		hci_h4p_bcm_parse_fw_event(info, skb);
+		break;
+	default:
+		dev_err(info->dev, "Don't know how to parse fw event\n");
+		info->fw_error = -EINVAL;
+	}
+
+	return;
+}
diff --git a/drivers/bluetooth/hci_h4p/hci_h4p.h b/drivers/bluetooth/hci_h4p/hci_h4p.h
new file mode 100644
index 0000000..ebafd37
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/hci_h4p.h
@@ -0,0 +1,238 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2010 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci.h>
+
+#ifndef __DRIVERS_BLUETOOTH_HCI_H4P_H
+#define __DRIVERS_BLUETOOTH_HCI_H4P_H
+
+#define BT_CHIP_CSR		0x02
+#define BT_CHIP_TI		0x30
+#define BT_CHIP_BCM		0x04
+
+#define FW_NAME_CSR		"bc4fw.bin"
+#define FW_NAME_TI		"ti1273.bin"
+#define FW_NAME_BCM		"bcmfw.bin"
+
+#define UART_SYSC_OMAP_RESET	0x03
+#define UART_SYSS_RESETDONE	0x01
+#define UART_OMAP_SCR_EMPTY_THR	0x08
+#define UART_OMAP_SCR_WAKEUP	0x10
+#define UART_OMAP_SSR_WAKEUP	0x02
+#define UART_OMAP_SSR_TXFULL	0x01
+
+#define UART_OMAP_SYSC_IDLEMODE		0x03
+#define UART_OMAP_SYSC_IDLEMASK		(3 << UART_OMAP_SYSC_IDLEMODE)
+
+#define UART_OMAP_SYSC_FORCE_IDLE	(0 << UART_OMAP_SYSC_IDLEMODE)
+#define UART_OMAP_SYSC_NO_IDLE		(1 << UART_OMAP_SYSC_IDLEMODE)
+#define UART_OMAP_SYSC_SMART_IDLE	(2 << UART_OMAP_SYSC_IDLEMODE)
+
+#define NBT_DBG(fmt, arg...) \
+		pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_FW(fmt, arg...) \
+		pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_POWER(fmt, arg...) \
+		pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_TRANSFER(fmt, arg...) \
+		pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_TRANSFER_NF(fmt, arg...) \
+		pr_debug(fmt "" , ## arg)
+
+#define NBT_DBG_DMA(fmt, arg...) \
+		pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+struct hci_h4p_info {
+	struct hci_dev *hdev;
+	spinlock_t lock;
+
+	void __iomem *uart_base;
+	unsigned long uart_phys_base;
+	int irq;
+	struct device *dev;
+	u8 chip_type;
+	void (*bt_wakeup)(bool enable);
+	bool (*host_wakeup)(void);
+	void (*reset)(bool enable);
+	int host_wakeup_gpio;
+	int man_id;
+	int ver_id;
+
+	struct sk_buff_head fw_queue;
+	struct completion init_completion;
+	struct completion fw_completion;
+	int fw_error;
+	int init_error;
+
+	struct sk_buff_head txq;
+
+	struct sk_buff *rx_skb;
+	long rx_count;
+	unsigned long rx_state;
+	unsigned long garbage_bytes;
+
+	u8 bd_addr[6];
+	struct sk_buff_head *fw_q;
+
+	int pm_enabled;
+	int tx_enabled;
+	int autorts;
+	int rx_enabled;
+
+	int tx_clocks_en;
+	int rx_clocks_en;
+	spinlock_t clocks_lock;
+	struct clk *uart_iclk;
+	struct clk *uart_fclk;
+	atomic_t clk_users;
+	u16 dll;
+	u16 dlh;
+	u16 ier;
+	u16 mdr1;
+	u16 efr;
+};
+
+struct hci_h4p_radio_hdr {
+	__u8 evt;
+	__u8 dlen;
+} __attribute__ ((packed));
+
+
+struct hci_h4p_init_hdr {
+	__u8 dlen;
+} __attribute__ ((packed));
+#define HCI_H4P_INIT_HDR_SIZE 1
+
+struct hci_h4p_init_cmd {
+	__u8 ack;
+	__u16 baudrate;
+	__u16 unused;
+	__u8 mode;
+	__u16 sys_clk;
+	__u16 unused2;
+} __attribute__ ((packed));
+#define HCI_H4P_INIT_CMD_SIZE 10
+
+struct hci_h4p_init_evt {
+	__u8 ack;
+	__u16 baudrate;
+	__u16 unused;
+	__u8 mode;
+	__u16 sys_clk;
+	__u16 unused2;
+	__u8 man_id;
+	__u8 ver_id;
+} __attribute__ ((packed));
+#define HCI_H4P_INIT_EVT_SIZE 12
+
+struct hci_h4p_alive_hdr {
+	__u8 dlen;
+} __attribute__ ((packed));
+#define HCI_H4P_ALIVE_HDR_SIZE 1
+
+struct hci_h4p_alive_msg {
+	__u8 message_id;
+	__u8 unused;
+} __attribute__ ((packed));
+#define HCI_H4P_ALIVE_MSG_SIZE 2
+
+#define MAX_BAUD_RATE		921600
+#define BC4_MAX_BAUD_RATE	3692300
+#define UART_CLOCK		48000000
+#define BT_INIT_DIVIDER		320
+#define BT_BAUDRATE_DIVIDER	384000000
+#define BT_SYSCLK_DIV		1000
+#define INIT_SPEED		120000
+
+#define HCI_H4P_MODE		0x4c
+
+#define HCI_H4P_ACK		0x20
+#define HCI_H4P_NACK		0x40
+#define HCI_H4P_ALIVE_IND_REQ	0x55
+#define HCI_H4P_ALIVE_IND_RESP	0xCC
+
+#define H4_TYPE_SIZE		1
+#define H4_RADIO_HDR_SIZE	2
+
+/* H4+ packet types */
+#define H4_CMD_PKT		0x01
+#define H4_ACL_PKT		0x02
+#define H4_SCO_PKT		0x03
+#define H4_EVT_PKT		0x04
+#define H4_NEG_PKT		0x06
+#define H4_ALIVE_PKT		0x07
+#define H4_RADIO_PKT		0x08
+
+/* TX states */
+#define WAIT_FOR_PKT_TYPE	1
+#define WAIT_FOR_HEADER		2
+#define WAIT_FOR_DATA		3
+
+struct hci_fw_event {
+	struct hci_event_hdr hev;
+	struct hci_ev_cmd_complete cmd;
+	u8 status;
+} __attribute__ ((packed));
+
+int hci_h4p_send_alive_packet(struct hci_h4p_info *info);
+
+void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info,
+				struct sk_buff *skb);
+int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
+			struct sk_buff_head *fw_queue);
+
+void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info,
+				struct sk_buff *skb);
+int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
+			struct sk_buff_head *fw_queue);
+
+void hci_h4p_ti1273_parse_fw_event(struct hci_h4p_info *info,
+				    struct sk_buff *skb);
+int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
+			    struct sk_buff_head *fw_queue);
+
+int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue);
+int hci_h4p_send_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue);
+void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb);
+
+void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offset, u8 val);
+u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset);
+void hci_h4p_set_rts(struct hci_h4p_info *info, int active);
+int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active, int timeout_ms);
+void __hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 which);
+void hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 which);
+void hci_h4p_change_speed(struct hci_h4p_info *info, unsigned long speed);
+int hci_h4p_reset_uart(struct hci_h4p_info *info);
+void hci_h4p_init_uart(struct hci_h4p_info *info);
+void hci_h4p_enable_tx(struct hci_h4p_info *info);
+void hci_h4p_store_regs(struct hci_h4p_info *info);
+void hci_h4p_restore_regs(struct hci_h4p_info *info);
+void hci_h4p_smart_idle(struct hci_h4p_info *info, bool enable);
+
+#endif /* __DRIVERS_BLUETOOTH_HCI_H4P_H */
diff --git a/drivers/bluetooth/hci_h4p/uart.c b/drivers/bluetooth/hci_h4p/uart.c
new file mode 100644
index 0000000..033825f
--- /dev/null
+++ b/drivers/bluetooth/hci_h4p/uart.c
@@ -0,0 +1,203 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005, 2006 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/serial_reg.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+
+#include <linux/io.h>
+
+#include "hci_h4p.h"
+
+inline void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offset, u8 val)
+{
+	__raw_writeb(val, info->uart_base + (offset << 2));
+}
+
+inline u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset)
+{
+	return __raw_readb(info->uart_base + (offset << 2));
+}
+
+void hci_h4p_set_rts(struct hci_h4p_info *info, int active)
+{
+	u8 b;
+
+	b = hci_h4p_inb(info, UART_MCR);
+	if (active)
+		b |= UART_MCR_RTS;
+	else
+		b &= ~UART_MCR_RTS;
+	hci_h4p_outb(info, UART_MCR, b);
+}
+
+int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active,
+			 int timeout_ms)
+{
+	unsigned long timeout;
+	int state;
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
+	for (;;) {
+		state = hci_h4p_inb(info, UART_MSR) & UART_MSR_CTS;
+		if (active) {
+			if (state)
+				return 0;
+		} else {
+			if (!state)
+				return 0;
+		}
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+		msleep(1);
+	}
+}
+
+void __hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 which)
+{
+	u8 lcr, b;
+
+	lcr = hci_h4p_inb(info, UART_LCR);
+	hci_h4p_outb(info, UART_LCR, 0xbf);
+	b = hci_h4p_inb(info, UART_EFR);
+	if (on)
+		b |= which;
+	else
+		b &= ~which;
+	hci_h4p_outb(info, UART_EFR, b);
+	hci_h4p_outb(info, UART_LCR, lcr);
+}
+
+void hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 which)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock, flags);
+	__hci_h4p_set_auto_ctsrts(info, on, which);
+	spin_unlock_irqrestore(&info->lock, flags);
+}
+
+void hci_h4p_change_speed(struct hci_h4p_info *info, unsigned long speed)
+{
+	unsigned int divisor;
+	u8 lcr, mdr1;
+
+	NBT_DBG("Setting speed %lu\n", speed);
+
+	if (speed >= 460800) {
+		divisor = UART_CLOCK / 13 / speed;
+		mdr1 = 3;
+	} else {
+		divisor = UART_CLOCK / 16 / speed;
+		mdr1 = 0;
+	}
+
+	/* Make sure UART mode is disabled */
+	hci_h4p_outb(info, UART_OMAP_MDR1, 7);
+
+	lcr = hci_h4p_inb(info, UART_LCR);
+	hci_h4p_outb(info, UART_LCR, UART_LCR_DLAB);     /* Set DLAB */
+	hci_h4p_outb(info, UART_DLL, divisor & 0xff);    /* Set speed */
+	hci_h4p_outb(info, UART_DLM, divisor >> 8);
+	hci_h4p_outb(info, UART_LCR, lcr);
+
+	/* Make sure UART mode is enabled */
+	hci_h4p_outb(info, UART_OMAP_MDR1, mdr1);
+}
+
+int hci_h4p_reset_uart(struct hci_h4p_info *info)
+{
+	int count = 0;
+
+	/* Reset the  UART */
+	hci_h4p_outb(info, UART_OMAP_SYSC, UART_SYSC_OMAP_RESET);
+	while (!(hci_h4p_inb(info, UART_OMAP_SYSS) & UART_SYSS_RESETDONE)) {
+		if (count++ > 100) {
+			dev_err(info->dev, "hci_h4p: UART reset timeout\n");
+			return -ENODEV;
+		}
+		udelay(1);
+	}
+
+	return 0;
+}
+
+
+void hci_h4p_store_regs(struct hci_h4p_info *info)
+{
+	u16 lcr = 0;
+
+	lcr = hci_h4p_inb(info, UART_LCR);
+	hci_h4p_outb(info, UART_LCR, 0xBF);
+	info->dll = hci_h4p_inb(info, UART_DLL);
+	info->dlh = hci_h4p_inb(info, UART_DLM);
+	info->efr = hci_h4p_inb(info, UART_EFR);
+	hci_h4p_outb(info, UART_LCR, lcr);
+	info->mdr1 = hci_h4p_inb(info, UART_OMAP_MDR1);
+	info->ier = hci_h4p_inb(info, UART_IER);
+}
+
+void hci_h4p_restore_regs(struct hci_h4p_info *info)
+{
+	u16 lcr = 0;
+
+	hci_h4p_init_uart(info);
+
+	hci_h4p_outb(info, UART_OMAP_MDR1, 7);
+	lcr = hci_h4p_inb(info, UART_LCR);
+	hci_h4p_outb(info, UART_LCR, 0xBF);
+	hci_h4p_outb(info, UART_DLL, info->dll);    /* Set speed */
+	hci_h4p_outb(info, UART_DLM, info->dlh);
+	hci_h4p_outb(info, UART_EFR, info->efr);
+	hci_h4p_outb(info, UART_LCR, lcr);
+	hci_h4p_outb(info, UART_OMAP_MDR1, info->mdr1);
+	hci_h4p_outb(info, UART_IER, info->ier);
+}
+
+void hci_h4p_init_uart(struct hci_h4p_info *info)
+{
+	u8 mcr, efr;
+
+	/* Enable and setup FIFO */
+	hci_h4p_outb(info, UART_OMAP_MDR1, 0x00);
+
+	hci_h4p_outb(info, UART_LCR, 0xbf);
+	efr = hci_h4p_inb(info, UART_EFR);
+	hci_h4p_outb(info, UART_EFR, UART_EFR_ECB);
+	hci_h4p_outb(info, UART_LCR, UART_LCR_DLAB);
+	mcr = hci_h4p_inb(info, UART_MCR);
+	hci_h4p_outb(info, UART_MCR, UART_MCR_TCRTLR);
+	hci_h4p_outb(info, UART_FCR, UART_FCR_ENABLE_FIFO |
+			UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT |
+			(3 << 6) | (0 << 4));
+	hci_h4p_outb(info, UART_LCR, 0xbf);
+	hci_h4p_outb(info, UART_TI752_TLR, 0xed);
+	hci_h4p_outb(info, UART_TI752_TCR, 0xef);
+	hci_h4p_outb(info, UART_EFR, efr);
+	hci_h4p_outb(info, UART_LCR, UART_LCR_DLAB);
+	hci_h4p_outb(info, UART_MCR, 0x00);
+	hci_h4p_outb(info, UART_LCR, UART_LCR_WLEN8);
+	hci_h4p_outb(info, UART_IER, UART_IER_RDI | UART_IER_RLSI);
+	hci_h4p_outb(info, UART_OMAP_WER, 0xff);
+	hci_h4p_outb(info, UART_OMAP_SYSC, (0 << 0) | (1 << 2) | (1 << 3));
+}
diff --git a/include/linux/bluetooth/hci_h4p.h b/include/linux/bluetooth/hci_h4p.h
new file mode 100644
index 0000000..ba1d764
--- /dev/null
+++ b/include/linux/bluetooth/hci_h4p.h
@@ -0,0 +1,41 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2010 Nokia Corporation.
+ *
+ * Contact: Roger Quadros <roger.quadros@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+
+/**
+ * struct hci_h4p_platform data - hci_h4p Platform data structure
+ * @uart_base:	UART base address
+ * @uart_irq:	UART Interrupt number
+ * @host_wu:	Function hook determine if Host should wakeup or not.
+ * @bt_wu:	Function hook to enable/disable Bluetooth transmission
+ * @reset:	Function hook to set/clear reset conditiona
+ * @host_wu_gpio:	Gpio used to wakeup host
+ */
+struct hci_h4p_platform_data {
+	void *uart_base;
+	unsigned int uart_irq;
+	bool (*host_wu)(void);
+	void (*bt_wu)(bool);
+	void (*reset)(bool);
+	unsigned int host_wu_gpio;
+};
-- 
1.7.10.4

