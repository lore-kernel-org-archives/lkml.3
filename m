Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3GAUQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:16:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3GAUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/13] net/tg3: Avoid delay during MMIO access
Date: Mon,  1 Jul 2013 13:10:26 -0700
Message-Id: <20130701200523.963352818@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200523.096669485@linuxfoundation.org>
References: <20130701200523.096669485@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit 6d446ec32f169c6a5d9bc90684a8082a6cbe90f6 upstream.

When the EEH error is the result of a fenced host bridge, MMIO accesses
can be very slow (milliseconds) to timeout and return all 1's,
thus causing the driver various timeout loops to take way too long and
trigger soft-lockup warnings (in addition to taking minutes to recover).

It might be worthwhile to check if for any of these cases, ffffffff is
a valid possible value, and if not, bail early since that means the HW
is either gone or isolated. In the meantime, checking that the PCI channel
is offline would be workaround of the problem.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -689,6 +689,9 @@ static int tg3_ape_lock(struct tg3 *tp,
 		status = tg3_ape_read32(tp, gnt + off);
 		if (status == bit)
 			break;
+		if (pci_channel_offline(tp->pdev))
+			break;
+
 		udelay(10);
 	}
 
@@ -1466,6 +1469,9 @@ static void tg3_wait_for_event_ack(struc
 	for (i = 0; i < delay_cnt; i++) {
 		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
 			break;
+		if (pci_channel_offline(tp->pdev))
+			break;
+
 		udelay(8);
 	}
 }
@@ -1636,6 +1642,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 		for (i = 0; i < 200; i++) {
 			if (tr32(VCPU_STATUS) & VCPU_STATUS_INIT_DONE)
 				return 0;
+			if (pci_channel_offline(tp->pdev))
+				return -ENODEV;
+
 			udelay(100);
 		}
 		return -ENODEV;
@@ -1646,6 +1655,15 @@ static int tg3_poll_fw(struct tg3 *tp)
 		tg3_read_mem(tp, NIC_SRAM_FIRMWARE_MBOX, &val);
 		if (val == ~NIC_SRAM_FIRMWARE_MBOX_MAGIC1)
 			break;
+		if (pci_channel_offline(tp->pdev)) {
+			if (!tg3_flag(tp, NO_FWARE_REPORTED)) {
+				tg3_flag_set(tp, NO_FWARE_REPORTED);
+				netdev_info(tp->dev, "No firmware running\n");
+			}
+
+			break;
+		}
+
 		udelay(10);
 	}
 
@@ -3204,6 +3222,8 @@ static int tg3_nvram_write_block_buffere
 		ret = tg3_nvram_exec_cmd(tp, nvram_cmd);
 		if (ret)
 			break;
+		if (pci_channel_offline(tp->pdev))
+			return -EBUSY;
 	}
 	return ret;
 }
@@ -7674,6 +7694,14 @@ static int tg3_stop_block(struct tg3 *tp
 	tw32_f(ofs, val);
 
 	for (i = 0; i < MAX_WAIT_CNT; i++) {
+		if (pci_channel_offline(tp->pdev)) {
+			dev_err(&tp->pdev->dev,
+				"tg3_stop_block device offline, "
+				"ofs=%lx enable_bit=%x\n",
+				ofs, enable_bit);
+			return -ENODEV;
+		}
+
 		udelay(100);
 		val = tr32(ofs);
 		if ((val & enable_bit) == 0)
@@ -7697,6 +7725,13 @@ static int tg3_abort_hw(struct tg3 *tp,
 
 	tg3_disable_ints(tp);
 
+	if (pci_channel_offline(tp->pdev)) {
+		tp->rx_mode &= ~(RX_MODE_ENABLE | TX_MODE_ENABLE);
+		tp->mac_mode &= ~MAC_MODE_TDE_ENABLE;
+		err = -ENODEV;
+		goto err_no_dev;
+	}
+
 	tp->rx_mode &= ~RX_MODE_ENABLE;
 	tw32_f(MAC_RX_MODE, tp->rx_mode);
 	udelay(10);
@@ -7745,6 +7780,7 @@ static int tg3_abort_hw(struct tg3 *tp,
 	err |= tg3_stop_block(tp, BUFMGR_MODE, BUFMGR_MODE_ENABLE, silent);
 	err |= tg3_stop_block(tp, MEMARB_MODE, MEMARB_MODE_ENABLE, silent);
 
+err_no_dev:
 	for (i = 0; i < tp->irq_cnt; i++) {
 		struct tg3_napi *tnapi = &tp->napi[i];
 		if (tnapi->hw_status)


