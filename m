Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab3GQWyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:54:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab3GQWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 099/145] iwlwifi: pcie: wake the queue if stopped when being unmapped
Date: Wed, 17 Jul 2013 15:47:11 -0700
Message-Id: <1374101277-7915-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8a487b1a7432b20ff3f82387a8ce7555a964b44e upstream.

When the queue is unmapped while it was so loaded that
mac80211's was stopped, we need to wake the queue after
having freed all the packets in the queue.
Not doing so can result in weird stuff like:

* run lots of traffic (mac80211's queue gets stopped)
* RFKILL
* de-assert RFKILL
* no traffic

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index c93a7cd..e4345e3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -581,6 +581,9 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	}
 	txq->active = false;
 	spin_unlock_bh(&txq->lock);
+
+	/* just in case - this queue may have been stopped */
+	iwl_wake_queue(trans, txq);
 }
 
 /*
-- 
1.8.1.2

