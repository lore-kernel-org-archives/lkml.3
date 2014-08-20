Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaHTL6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:58:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58982 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Emil Tantilov <emil.s.tantilov@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/104] ixgbe: fix rx-usecs range checks for BQL
Date: Wed, 20 Aug 2014 13:43:40 +0200
Message-Id: <922246ebf3952682d697d7f7f76d11332ee9b58f.1408535000.git.jslaby@suse.cz>
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

commit 2e0103810c6fed6a736c4a3af87b0f5c6bd8cd5b upstream.

This patch resolves an issue where the logic used to detect changes in rx-usecs
was incorrect and was masked by the call to ixgbe_update_rsc().

Setting rx-usecs between 0,2-9 and 1,10 and up requires a reset to allow
ixgbe_configure_tx_ring() to set the correct value for TXDCTL.WTHRESH in
order to avoid Tx hangs with BQL enabled.

Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index e8649abf97c0..2cd86d30508b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2212,13 +2212,13 @@ static int ixgbe_set_coalesce(struct net_device *netdev,
 
 #if IS_ENABLED(CONFIG_BQL)
 	/* detect ITR changes that require update of TXDCTL.WTHRESH */
-	if ((adapter->tx_itr_setting > 1) &&
+	if ((adapter->tx_itr_setting != 1) &&
 	    (adapter->tx_itr_setting < IXGBE_100K_ITR)) {
 		if ((tx_itr_prev == 1) ||
-		    (tx_itr_prev > IXGBE_100K_ITR))
+		    (tx_itr_prev >= IXGBE_100K_ITR))
 			need_reset = true;
 	} else {
-		if ((tx_itr_prev > 1) &&
+		if ((tx_itr_prev != 1) &&
 		    (tx_itr_prev < IXGBE_100K_ITR))
 			need_reset = true;
 	}
-- 
2.0.4

