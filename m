Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3GBLLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:11:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36347 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab3GBLIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 41/50] net/tg3: Avoid delay during MMIO access
Date: Tue,  2 Jul 2013 12:07:29 +0100
Message-Id: <1372763258-20664-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted context
  - inlined changes to tg3_pause_cpu function in function tg3_halt_cpu ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8a0b948..504b4f0 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -689,6 +689,9 @@ static int tg3_ape_lock(struct tg3 *tp, int locknum)
 		status = tg3_ape_read32(tp, gnt + off);
 		if (status == bit)
 			break;
+		if (pci_channel_offline(tp->pdev))
+			break;
+
 		udelay(10);
 	}
 
@@ -1466,6 +1469,9 @@ static void tg3_wait_for_event_ack(struct tg3 *tp)
 	for (i = 0; i < delay_cnt; i++) {
 		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
 			break;
+		if (pci_channel_offline(tp->pdev))
+			break;
+
 		udelay(8);
 	}
 }
@@ -1639,6 +1645,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 		for (i = 0; i < 200; i++) {
 			if (tr32(VCPU_STATUS) & VCPU_STATUS_INIT_DONE)
 				return 0;
+			if (pci_channel_offline(tp->pdev))
+				return -ENODEV;
+
 			udelay(100);
 		}
 		return -ENODEV;
@@ -1649,6 +1658,15 @@ static int tg3_poll_fw(struct tg3 *tp)
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
 
@@ -3305,6 +3323,8 @@ static int tg3_halt_cpu(struct tg3 *tp, u32 offset)
 			tw32(offset + CPU_MODE,  CPU_MODE_HALT);
 			if (tr32(offset + CPU_MODE) & CPU_MODE_HALT)
 				break;
+			if (pci_channel_offline(tp->pdev))
+				return -EBUSY;
 		}
 
 		tw32(offset + CPU_STATE, 0xffffffff);
@@ -3316,6 +3336,8 @@ static int tg3_halt_cpu(struct tg3 *tp, u32 offset)
 			tw32(offset + CPU_MODE,  CPU_MODE_HALT);
 			if (tr32(offset + CPU_MODE) & CPU_MODE_HALT)
 				break;
+			if (pci_channel_offline(tp->pdev))
+				return -EBUSY;
 		}
 	}
 
@@ -7723,6 +7745,14 @@ static int tg3_stop_block(struct tg3 *tp, unsigned long ofs, u32 enable_bit, int
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
@@ -7746,6 +7776,13 @@ static int tg3_abort_hw(struct tg3 *tp, int silent)
 
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
@@ -7794,6 +7831,7 @@ static int tg3_abort_hw(struct tg3 *tp, int silent)
 	err |= tg3_stop_block(tp, BUFMGR_MODE, BUFMGR_MODE_ENABLE, silent);
 	err |= tg3_stop_block(tp, MEMARB_MODE, MEMARB_MODE_ENABLE, silent);
 
+err_no_dev:
 	for (i = 0; i < tp->irq_cnt; i++) {
 		struct tg3_napi *tnapi = &tp->napi[i];
 		if (tnapi->hw_status)
-- 
1.8.1.2

