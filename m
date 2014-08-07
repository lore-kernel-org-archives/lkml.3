Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaHGJHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:07:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53371 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaHGJHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:07:37 -0400
Date: Thu, 7 Aug 2014 11:07:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nokia_h4: merge firmware together so that we can
 reduce ammount of exports
Message-ID: <20140807090733.GC24700@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807002532.GB23406@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Merge firmware files to nokia_core, so that we can reduce ammount of
exported functions. Also replace hand-coded check for invalid
bluetooth address with bacmp.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/nokia_h4p/Makefile b/drivers/staging/nokia_h4p/Makefile
index 310b0f2..3398a1c 100644
--- a/drivers/staging/nokia_h4p/Makefile
+++ b/drivers/staging/nokia_h4p/Makefile
@@ -1,6 +1,5 @@
 
 obj-$(CONFIG_BT_NOKIA_H4P)		+= nokia_h4p.o
-nokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o nokia_fw-csr.o \
-		nokia_fw-bcm.o nokia_fw-ti1273.o
+nokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 775e1d0..501be06 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -1191,6 +1191,330 @@ static int hci_h4p_remove(struct platform_device *pdev)
 	return 0;
 }
 
+/* Code specific for BCM firmware -------------------------------- */
+
+static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info,
+				struct sk_buff *skb)
+{
+	int i;
+	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+	int not_valid = !bacmp(info->bd_addr, BDADDR_ANY);
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
+	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc &&
+			fw_skb->len >= 10) {
+		BT_DBG("Setting bluetooth address");
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
+	BT_DBG("Sending firmware");
+
+	time = jiffies;
+
+	info->fw_q = fw_queue;
+	skb = skb_dequeue(fw_queue);
+	if (!skb)
+		return -ENODATA;
+
+	BT_DBG("Sending commands");
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
+	BT_DBG("Firmware sent in %d msecs",
+		   jiffies_to_msecs(jiffies-time));
+
+	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+	hci_h4p_set_rts(info, 0);
+	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+
+	return 0;
+}
+
+/* Code specific for CSR firmware -------------------------------- */
+
+void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
+{
+	/* Check if this is fw packet */
+	if (skb->data[0] != 0xff) {
+		hci_recv_frame(info->hdev, skb);
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
+	BT_DBG("Sending firmware");
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
+		not_valid = !bacmp(info->bd_addr, BDADDR_ANY);
+
+		if (not_valid) {
+			dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
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
+		BT_DBG("Sending firmware command %d", count);
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
+
+/* Code specific for ti1273 firmware ----------------------------- */
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
+	BT_DBG("Sending firmware");
+
+	time = jiffies;
+
+	fw_q = fw_queue;
+	skb = skb_dequeue(fw_queue);
+	if (!skb)
+		return -ENODATA;
+
+	BT_DBG("Sending commands");
+	/* Check if this is bd_address packet */
+	init_completion(&info->fw_completion);
+	hci_h4p_smart_idle(info, 0);
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
+	BT_DBG("Firmware sent in %d msecs",
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
+
+/* Generic code -------------------------------------------------- */
+
 static struct platform_driver hci_h4p_driver = {
 	.probe		= hci_h4p_probe,
 	.remove		= hci_h4p_remove,
diff --git a/drivers/staging/nokia_h4p/nokia_fw-bcm.c b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
deleted file mode 100644
index b55f5ba..0000000
--- a/drivers/staging/nokia_h4p/nokia_fw-bcm.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * This file is part of Nokia H4P bluetooth driver
- *
- * Copyright (C) 2005-2008 Nokia Corporation.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/skbuff.h>
-#include <linux/delay.h>
-#include <linux/serial_reg.h>
-
-#include "hci_h4p.h"
-
-static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info,
-				struct sk_buff *skb)
-{
-	int i;
-	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
-	int not_valid;
-
-	not_valid = 1;
-	for (i = 0; i < 6; i++) {
-		if (info->bd_addr[i] != 0x00) {
-			not_valid = 0;
-			break;
-		}
-	}
-
-	if (not_valid) {
-		dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
-		/* When address is not valid, use some random but Nokia MAC */
-		memcpy(info->bd_addr, nokia_oui, 3);
-		get_random_bytes(info->bd_addr + 3, 3);
-	}
-
-	for (i = 0; i < 6; i++)
-		skb->data[9 - i] = info->bd_addr[i];
-
-	return 0;
-}
-
-void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
-{
-	struct sk_buff *fw_skb;
-	int err;
-	unsigned long flags;
-
-	if (skb->data[5] != 0x00) {
-		dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
-			skb->data[5]);
-		info->fw_error = -EPROTO;
-	}
-
-	kfree_skb(skb);
-
-	fw_skb = skb_dequeue(info->fw_q);
-	if (fw_skb == NULL || info->fw_error) {
-		complete(&info->fw_completion);
-		return;
-	}
-
-	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc &&
-			fw_skb->len >= 10) {
-		BT_DBG("Setting bluetooth address");
-		err = hci_h4p_bcm_set_bdaddr(info, fw_skb);
-		if (err < 0) {
-			kfree_skb(fw_skb);
-			info->fw_error = err;
-			complete(&info->fw_completion);
-			return;
-		}
-	}
-
-	skb_queue_tail(&info->txq, fw_skb);
-	spin_lock_irqsave(&info->lock, flags);
-	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
-			UART_IER_THRI);
-	spin_unlock_irqrestore(&info->lock, flags);
-}
-
-
-int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
-			struct sk_buff_head *fw_queue)
-{
-	struct sk_buff *skb;
-	unsigned long flags, time;
-
-	info->fw_error = 0;
-
-	BT_DBG("Sending firmware");
-
-	time = jiffies;
-
-	info->fw_q = fw_queue;
-	skb = skb_dequeue(fw_queue);
-	if (!skb)
-		return -ENODATA;
-
-	BT_DBG("Sending commands");
-
-	/*
-	 * Disable smart-idle as UART TX interrupts
-	 * are not wake-up capable
-	 */
-	hci_h4p_smart_idle(info, 0);
-
-	/* Check if this is bd_address packet */
-	init_completion(&info->fw_completion);
-	skb_queue_tail(&info->txq, skb);
-	spin_lock_irqsave(&info->lock, flags);
-	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
-			UART_IER_THRI);
-	spin_unlock_irqrestore(&info->lock, flags);
-
-	if (!wait_for_completion_timeout(&info->fw_completion,
-				msecs_to_jiffies(2000))) {
-		dev_err(info->dev, "No reply to fw command\n");
-		return -ETIMEDOUT;
-	}
-
-	if (info->fw_error) {
-		dev_err(info->dev, "FW error\n");
-		return -EPROTO;
-	}
-
-	BT_DBG("Firmware sent in %d msecs",
-		   jiffies_to_msecs(jiffies-time));
-
-	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
-	hci_h4p_set_rts(info, 0);
-	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
-	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
-
-	return 0;
-}
diff --git a/drivers/staging/nokia_h4p/nokia_fw-csr.c b/drivers/staging/nokia_h4p/nokia_fw-csr.c
deleted file mode 100644
index fe6b704..0000000
--- a/drivers/staging/nokia_h4p/nokia_fw-csr.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * This file is part of Nokia H4P bluetooth driver
- *
- * Copyright (C) 2005-2008 Nokia Corporation.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/skbuff.h>
-#include <linux/delay.h>
-#include <linux/serial_reg.h>
-
-#include "hci_h4p.h"
-
-void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
-{
-	/* Check if this is fw packet */
-	if (skb->data[0] != 0xff) {
-		hci_recv_frame(info->hdev, skb);
-		return;
-	}
-
-	if (skb->data[11] || skb->data[12]) {
-		dev_err(info->dev, "Firmware sending command failed\n");
-		info->fw_error = -EPROTO;
-	}
-
-	kfree_skb(skb);
-	complete(&info->fw_completion);
-}
-
-int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
-			struct sk_buff_head *fw_queue)
-{
-	static const u8 nokia_oui[3] = {0x00, 0x19, 0x4F};
-	struct sk_buff *skb;
-	unsigned int offset;
-	int retries, count, i, not_valid;
-	unsigned long flags;
-
-	info->fw_error = 0;
-
-	BT_DBG("Sending firmware");
-	skb = skb_dequeue(fw_queue);
-
-	if (!skb)
-		return -ENOMSG;
-
-	/* Check if this is bd_address packet */
-	if (skb->data[15] == 0x01 && skb->data[16] == 0x00) {
-		offset = 21;
-		skb->data[offset + 1] = 0x00;
-		skb->data[offset + 5] = 0x00;
-
-		not_valid = 1;
-		for (i = 0; i < 6; i++) {
-			if (info->bd_addr[i] != 0x00) {
-				not_valid = 0;
-				break;
-			}
-		}
-
-		if (not_valid) {
-			dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
-			/* When address is not valid, use some random */
-			memcpy(info->bd_addr, nokia_oui, 3);
-			get_random_bytes(info->bd_addr + 3, 3);
-		}
-
-		skb->data[offset + 7] = info->bd_addr[0];
-		skb->data[offset + 6] = info->bd_addr[1];
-		skb->data[offset + 4] = info->bd_addr[2];
-		skb->data[offset + 0] = info->bd_addr[3];
-		skb->data[offset + 3] = info->bd_addr[4];
-		skb->data[offset + 2] = info->bd_addr[5];
-	}
-
-	for (count = 1; ; count++) {
-		BT_DBG("Sending firmware command %d", count);
-		init_completion(&info->fw_completion);
-		skb_queue_tail(&info->txq, skb);
-		spin_lock_irqsave(&info->lock, flags);
-		hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
-							 UART_IER_THRI);
-		spin_unlock_irqrestore(&info->lock, flags);
-
-		skb = skb_dequeue(fw_queue);
-		if (!skb)
-			break;
-
-		if (!wait_for_completion_timeout(&info->fw_completion,
-						 msecs_to_jiffies(1000))) {
-			dev_err(info->dev, "No reply to fw command\n");
-			return -ETIMEDOUT;
-		}
-
-		if (info->fw_error) {
-			dev_err(info->dev, "FW error\n");
-			return -EPROTO;
-		}
-	};
-
-	/* Wait for chip warm reset */
-	retries = 100;
-	while ((!skb_queue_empty(&info->txq) ||
-	       !(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT)) &&
-	       retries--) {
-		msleep(10);
-	}
-	if (!retries) {
-		dev_err(info->dev, "Transmitter not empty\n");
-		return -ETIMEDOUT;
-	}
-
-	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
-
-	if (hci_h4p_wait_for_cts(info, 1, 100)) {
-		dev_err(info->dev, "cts didn't deassert after final speed\n");
-		return -ETIMEDOUT;
-	}
-
-	retries = 100;
-	do {
-		init_completion(&info->init_completion);
-		hci_h4p_send_alive_packet(info);
-		retries--;
-	} while (!wait_for_completion_timeout(&info->init_completion, 100) &&
-		 retries > 0);
-
-	if (!retries) {
-		dev_err(info->dev, "No alive reply after speed change\n");
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/nokia_h4p/nokia_fw-ti1273.c b/drivers/staging/nokia_h4p/nokia_fw-ti1273.c
deleted file mode 100644
index f5500f7..0000000
--- a/drivers/staging/nokia_h4p/nokia_fw-ti1273.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * This file is part of Nokia H4P bluetooth driver
- *
- * Copyright (C) 2009 Nokia Corporation.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/skbuff.h>
-#include <linux/delay.h>
-#include <linux/serial_reg.h>
-
-#include "hci_h4p.h"
-
-static struct sk_buff_head *fw_q;
-
-void hci_h4p_ti1273_parse_fw_event(struct hci_h4p_info *info,
-			struct sk_buff *skb)
-{
-	struct sk_buff *fw_skb;
-	unsigned long flags;
-
-	if (skb->data[5] != 0x00) {
-		dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
-			skb->data[5]);
-		info->fw_error = -EPROTO;
-	}
-
-	kfree_skb(skb);
-
-	fw_skb = skb_dequeue(fw_q);
-	if (fw_skb == NULL || info->fw_error) {
-		complete(&info->fw_completion);
-		return;
-	}
-
-	skb_queue_tail(&info->txq, fw_skb);
-	spin_lock_irqsave(&info->lock, flags);
-	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
-			UART_IER_THRI);
-	spin_unlock_irqrestore(&info->lock, flags);
-}
-
-
-int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
-			struct sk_buff_head *fw_queue)
-{
-	struct sk_buff *skb;
-	unsigned long flags, time;
-
-	info->fw_error = 0;
-
-	BT_DBG("Sending firmware");
-
-	time = jiffies;
-
-	fw_q = fw_queue;
-	skb = skb_dequeue(fw_queue);
-	if (!skb)
-		return -ENODATA;
-
-	BT_DBG("Sending commands");
-	/* Check if this is bd_address packet */
-	init_completion(&info->fw_completion);
-	hci_h4p_smart_idle(info, 0);
-	skb_queue_tail(&info->txq, skb);
-	spin_lock_irqsave(&info->lock, flags);
-	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
-			UART_IER_THRI);
-	spin_unlock_irqrestore(&info->lock, flags);
-
-	if (!wait_for_completion_timeout(&info->fw_completion,
-				msecs_to_jiffies(2000))) {
-		dev_err(info->dev, "No reply to fw command\n");
-		return -ETIMEDOUT;
-	}
-
-	if (info->fw_error) {
-		dev_err(info->dev, "FW error\n");
-		return -EPROTO;
-	}
-
-	BT_DBG("Firmware sent in %d msecs",
-		   jiffies_to_msecs(jiffies-time));
-
-	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
-	hci_h4p_set_rts(info, 0);
-	hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
-	if (hci_h4p_wait_for_cts(info, 1, 100)) {
-		dev_err(info->dev,
-			"cts didn't go down after final speed change\n");
-		return -ETIMEDOUT;
-	}
-	hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
-
-	return 0;
-}

