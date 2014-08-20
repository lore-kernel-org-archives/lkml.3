Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaHTLwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:52:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58995 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Don Skidmore <donald.c.skidmore@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/104] ixgbevf: cleanup redundant mailbox read failure check
Date: Wed, 20 Aug 2014 13:43:44 +0200
Message-Id: <0e321407ccc1dce9c30151f9da4febe6432f6d38.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Skidmore <donald.c.skidmore@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c7bb417dbb8888cfd20824d54f9af9c92b9ff43d upstream.

Since we are already checking for read failure in check_link we don't need
to do it here. Instead just make sure the watchdog task gets scheduled, if
we are up, and it can be done there. This will better follow igbvf method
of handling a mailbox event and message timeout.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 29 ++---------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index e34c2daac6a0..83544f802032 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -756,37 +756,12 @@ static void ixgbevf_set_itr(struct ixgbevf_q_vector *q_vector)
 static irqreturn_t ixgbevf_msix_other(int irq, void *data)
 {
 	struct ixgbevf_adapter *adapter = data;
-	struct pci_dev *pdev = adapter->pdev;
 	struct ixgbe_hw *hw = &adapter->hw;
-	u32 msg;
-	bool got_ack = false;
 
 	hw->mac.get_link_status = 1;
-	if (!hw->mbx.ops.check_for_ack(hw))
-		got_ack = true;
-
-	if (!hw->mbx.ops.check_for_msg(hw)) {
-		hw->mbx.ops.read(hw, &msg, 1);
 
-		if ((msg & IXGBE_MBVFICR_VFREQ_MASK) == IXGBE_PF_CONTROL_MSG) {
-			mod_timer(&adapter->watchdog_timer,
-				  round_jiffies(jiffies + 1));
-			adapter->link_up = false;
-		}
-
-		if (msg & IXGBE_VT_MSGTYPE_NACK)
-			dev_info(&pdev->dev,
-				 "Last Request of type %2.2x to PF Nacked\n",
-				 msg & 0xFF);
-		hw->mbx.v2p_mailbox |= IXGBE_VFMAILBOX_PFSTS;
-	}
-
-	/* checking for the ack clears the PFACK bit.  Place
-	 * it back in the v2p_mailbox cache so that anyone
-	 * polling for an ack will not miss it
-	 */
-	if (got_ack)
-		hw->mbx.v2p_mailbox |= IXGBE_VFMAILBOX_PFACK;
+	if (!test_bit(__IXGBEVF_DOWN, &adapter->state))
+		mod_timer(&adapter->watchdog_timer, jiffies);
 
 	IXGBE_WRITE_REG(hw, IXGBE_VTEIMS, adapter->eims_other);
 
-- 
2.0.4

