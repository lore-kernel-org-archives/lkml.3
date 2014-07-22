Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaGVWWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:22:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44341 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbaGVWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 015/116] iwlwifi: pcie: try to get ownership several times
Date: Tue, 22 Jul 2014 15:20:26 -0700
Message-Id: <1406067727-19683-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 501fd9895c1d7d8161ed56698ae2fccb10ef14f5 upstream.

Some races with the hardware can happen when we take
ownership of the device. Don't give up after the first try.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index be0f8b9..68335b5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -304,6 +304,7 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
 	int t = 0;
+	int iter;
 
 	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
 
@@ -312,18 +313,23 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
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
1.9.1

