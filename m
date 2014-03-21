Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967066AbaCUBWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:22:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385AbaCUADk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.13 035/149] iwlwifi: mvm: dont WARN when statistics are handled late
Date: Thu, 20 Mar 2014 17:03:18 -0700
Message-Id: <20140321000438.179403145@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -871,8 +871,11 @@ void iwl_mvm_bt_rssi_event(struct iwl_mv
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* Rssi update while not associated ?! */
-	if (WARN_ON_ONCE(mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT))
+	/*
+	 * Rssi update while not associated - can happen since the statistics
+	 * are handled asynchronously
+	 */
+	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
 		return;
 
 	/* No BT - reports should be disabled */


