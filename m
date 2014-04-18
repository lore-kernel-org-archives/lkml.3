Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaDRJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:32:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45963 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/72] bnx2: Fix shutdown sequence
Date: Fri, 18 Apr 2014 11:22:09 +0200
Message-Id: <1780772eaf8b59271eb612bfbb08251017cd678a.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Chan <mchan@broadcom.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a8d9bc2e9f5d1c5a25e33cec096d2a1652d3fd52 ]

The pci shutdown handler added in:

    bnx2: Add pci shutdown handler
    commit 25bfb1dd4ba3b2d9a49ce9d9b0cd7be1840e15ed

created a shutdown down sequence without chip reset if the device was
never brought up.  This can cause the firmware to shutdown the PHY
prematurely and cause MMIO read cycles to be unresponsive.  On some
systems, it may generate NMI in the bnx2's pci shutdown handler.

The fix is to tell the firmware not to shutdown the PHY if there was
no prior chip reset.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/bnx2.c | 37 ++++++++++++++++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnx2.h |  5 +++++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index e838a3f74b69..8f9e76d2dd8b 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -2490,6 +2490,7 @@ bnx2_fw_sync(struct bnx2 *bp, u32 msg_data, int ack, int silent)
 
 	bp->fw_wr_seq++;
 	msg_data |= bp->fw_wr_seq;
+	bp->fw_last_msg = msg_data;
 
 	bnx2_shmem_wr(bp, BNX2_DRV_MB, msg_data);
 
@@ -3982,8 +3983,23 @@ bnx2_setup_wol(struct bnx2 *bp)
 			wol_msg = BNX2_DRV_MSG_CODE_SUSPEND_NO_WOL;
 	}
 
-	if (!(bp->flags & BNX2_FLAG_NO_WOL))
-		bnx2_fw_sync(bp, BNX2_DRV_MSG_DATA_WAIT3 | wol_msg, 1, 0);
+	if (!(bp->flags & BNX2_FLAG_NO_WOL)) {
+		u32 val;
+
+		wol_msg |= BNX2_DRV_MSG_DATA_WAIT3;
+		if (bp->fw_last_msg || BNX2_CHIP(bp) != BNX2_CHIP_5709) {
+			bnx2_fw_sync(bp, wol_msg, 1, 0);
+			return;
+		}
+		/* Tell firmware not to power down the PHY yet, otherwise
+		 * the chip will take a long time to respond to MMIO reads.
+		 */
+		val = bnx2_shmem_rd(bp, BNX2_PORT_FEATURE);
+		bnx2_shmem_wr(bp, BNX2_PORT_FEATURE,
+			      val | BNX2_PORT_FEATURE_ASF_ENABLED);
+		bnx2_fw_sync(bp, wol_msg, 1, 0);
+		bnx2_shmem_wr(bp, BNX2_PORT_FEATURE, val);
+	}
 
 }
 
@@ -4015,9 +4031,22 @@ bnx2_set_power_state(struct bnx2 *bp, pci_power_t state)
 
 			if (bp->wol)
 				pci_set_power_state(bp->pdev, PCI_D3hot);
-		} else {
-			pci_set_power_state(bp->pdev, PCI_D3hot);
+			break;
+
+		}
+		if (!bp->fw_last_msg && BNX2_CHIP(bp) == BNX2_CHIP_5709) {
+			u32 val;
+
+			/* Tell firmware not to power down the PHY yet,
+			 * otherwise the other port may not respond to
+			 * MMIO reads.
+			 */
+			val = bnx2_shmem_rd(bp, BNX2_BC_STATE_CONDITION);
+			val &= ~BNX2_CONDITION_PM_STATE_MASK;
+			val |= BNX2_CONDITION_PM_STATE_UNPREP;
+			bnx2_shmem_wr(bp, BNX2_BC_STATE_CONDITION, val);
 		}
+		pci_set_power_state(bp->pdev, PCI_D3hot);
 
 		/* No more memory access after this point until
 		 * device is brought back to D0.
diff --git a/drivers/net/ethernet/broadcom/bnx2.h b/drivers/net/ethernet/broadcom/bnx2.h
index 18cb2d23e56b..0eb2a65c35b4 100644
--- a/drivers/net/ethernet/broadcom/bnx2.h
+++ b/drivers/net/ethernet/broadcom/bnx2.h
@@ -6890,6 +6890,7 @@ struct bnx2 {
 
 	u16			fw_wr_seq;
 	u16			fw_drv_pulse_wr_seq;
+	u32			fw_last_msg;
 
 	int			rx_max_ring;
 	int			rx_ring_size;
@@ -7396,6 +7397,10 @@ struct bnx2_rv2p_fw_file {
 #define BNX2_CONDITION_MFW_RUN_NCSI		 0x00006000
 #define BNX2_CONDITION_MFW_RUN_NONE		 0x0000e000
 #define BNX2_CONDITION_MFW_RUN_MASK		 0x0000e000
+#define BNX2_CONDITION_PM_STATE_MASK		 0x00030000
+#define BNX2_CONDITION_PM_STATE_FULL		 0x00030000
+#define BNX2_CONDITION_PM_STATE_PREP		 0x00020000
+#define BNX2_CONDITION_PM_STATE_UNPREP		 0x00010000
 
 #define BNX2_BC_STATE_DEBUG_CMD			0x1dc
 #define BNX2_BC_STATE_BC_DBG_CMD_SIGNATURE	 0x42440000
-- 
1.9.2

