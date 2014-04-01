Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaDALwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:52:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaDALRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 076/144] iwlwifi: mvm: don't WARN when statistics are handled late
Date: Tue,  1 Apr 2014 12:14:40 +0100
Message-Id: <1396350948-29910-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 1e9291996c4eedf79883f47ec635235e39d3d6cd upstream.

Since the statistics handler is asynchrous, it can very well
be that we will handle the statistics (hence the RSSI
fluctuation) when we already disassociated.
Don't WARN on this case.

This solves: https://bugzilla.redhat.com/show_bug.cgi?id=1071998

Fixes: 2b76ef13086f ("iwlwifi: mvm: implement reduced Tx power")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index dbd622a..1486767 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -544,8 +544,11 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mutex_lock(&mvm->mutex);
 
-	/* Rssi update while not associated ?! */
-	if (WARN_ON_ONCE(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
+	/*
+	 * Rssi update while not associated - can happen since the statistics
+	 * are handled asynchronously
+	 */
+	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
 		goto out_unlock;
 
 	/* No open connection - reports should be disabled */
-- 
1.9.1

