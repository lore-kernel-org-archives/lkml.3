Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaHTLyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:54:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58988 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Emil Tantilov <emil.s.tantilov@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/104] ixgbe: fix inconsistent clearing of the multicast table
Date: Wed, 20 Aug 2014 13:43:42 +0200
Message-Id: <33c381173045b017bc855cba1eeb25c1ff4a19d9.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Tantilov <emil.s.tantilov@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cf78959c0d7afbde31498afc4212294c28e2c278 upstream.

This patch resolves an issue where the MTA table can be cleared when the
interface is reset while in promisc mode. As result IPv6 traffic between
VFs will be interrupted.

This patch makes the update of the MTA table unconditional to avoid the
inconsistent clearing on reset.

Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index a178a9caa763..8a14f96df1ee 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -3825,14 +3825,6 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 		if (netdev->flags & IFF_ALLMULTI) {
 			fctrl |= IXGBE_FCTRL_MPE;
 			vmolr |= IXGBE_VMOLR_MPE;
-		} else {
-			/*
-			 * Write addresses to the MTA, if the attempt fails
-			 * then we should just turn on promiscuous mode so
-			 * that we can at least receive multicast traffic
-			 */
-			hw->mac.ops.update_mc_addr_list(hw, netdev);
-			vmolr |= IXGBE_VMOLR_ROMPE;
 		}
 		ixgbe_vlan_filter_enable(adapter);
 		hw->addr_ctrl.user_set_promisc = false;
@@ -3849,6 +3841,13 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 		vmolr |= IXGBE_VMOLR_ROPE;
 	}
 
+	/* Write addresses to the MTA, if the attempt fails
+	 * then we should just turn on promiscuous mode so
+	 * that we can at least receive multicast traffic
+	 */
+	hw->mac.ops.update_mc_addr_list(hw, netdev);
+	vmolr |= IXGBE_VMOLR_ROMPE;
+
 	if (adapter->num_vfs)
 		ixgbe_restore_vf_multicasts(adapter);
 
-- 
2.0.4

