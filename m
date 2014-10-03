Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaJCVxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:53:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbaJCVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 240/357] iwlwifi: mvm: fix endianity issues with Smart Fifo commands
Date: Fri,  3 Oct 2014 14:30:26 -0700
Message-Id: <20141003212940.717510438@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 86974bff066dd8b98be46d7c7d3aba89034f0833 upstream.

This code was broken on big endian systems. Sparse didn't
catch the bug since the firmware command was not tagged as
little endian.
Fix the bug for big endian systems and tag the field in the
firmware command to prevent such issues in the future.

Fixes: 1f3b0ff8ec ("iwlwifi: mvm: Add Smart FIFO support")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/sf.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1487,14 +1487,14 @@ enum iwl_sf_scenario {
 
 /**
  * Smart Fifo configuration command.
- * @state: smart fifo state, types listed in iwl_sf_sate.
+ * @state: smart fifo state, types listed in enum %iwl_sf_sate.
  * @watermark: Minimum allowed availabe free space in RXF for transient state.
  * @long_delay_timeouts: aging and idle timer values for each scenario
  * in long delay state.
  * @full_on_timeouts: timer values for each scenario in full on state.
  */
 struct iwl_sf_cfg_cmd {
-	enum iwl_sf_state state;
+	__le32 state;
 	__le32 watermark[SF_TRANSIENT_STATES_NUMBER];
 	__le32 long_delay_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
 	__le32 full_on_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -172,7 +172,7 @@ static int iwl_mvm_sf_config(struct iwl_
 			     enum iwl_sf_state new_state)
 {
 	struct iwl_sf_cfg_cmd sf_cmd = {
-		.state = new_state,
+		.state = cpu_to_le32(new_state),
 	};
 	struct ieee80211_sta *sta;
 	int ret = 0;


