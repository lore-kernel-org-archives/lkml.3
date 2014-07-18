Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406AbaGRNaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:30:00 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17840 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161129AbaGRNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 099/170] iwlwifi: pcie: try to get ownership several times
Date: Fri, 18 Jul 2014 14:11:44 +0200
Message-Id: <78a97b52b5c8dceaf68bc5129b95c71bb60f7199.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 501fd9895c1d7d8161ed56698ae2fccb10ef14f5 upstream.

Some races with the hardware can happen when we take
ownership of the device. Don't give up after the first try.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 7bdaf06b8f5a..dc875f4befef 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -345,6 +345,7 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
 	int t = 0;
+	int iter;
 
 	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
 
@@ -353,18 +354,23 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 	if (ret >= 0)
 		return 0;
 
-	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_PREPARE);
+	for (iter = 0; iter < 10; iter++) {
+		/* If HW is not ready, prepare the conditions to check again */
+		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_PREPARE);
+
+		do {
+			ret = iwl_pcie_set_hw_ready(trans);
+			if (ret >= 0)
+				return 0;
 
-	do {
-		ret = iwl_pcie_set_hw_ready(trans);
-		if (ret >= 0)
-			return 0;
+			usleep_range(200, 1000);
+			t += 200;
+		} while (t < 150000);
+		msleep(25);
+	}
 
-		usleep_range(200, 1000);
-		t += 200;
-	} while (t < 150000);
+	IWL_DEBUG_INFO(trans, "got NIC after %d iterations\n", iter);
 
 	return ret;
 }
-- 
2.0.0

