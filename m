Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967549Ab3HIB6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967503Ab3HIB6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [ 030/102] iwlwifi: mvm: fix L2P BA ressources leak
Date: Thu,  8 Aug 2013 18:57:06 -0700
Message-Id: <20130809015016.966028400@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 93a426673fbfeae7fa6b27008828e2ac4c08dbee upstream.

We didn't release the Rx AMPDU ressources properly.
This bug led to firmware assert after 16 BA sessions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/sta.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -621,8 +621,12 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *m
 	cmd.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color);
 	cmd.sta_id = mvm_sta->sta_id;
 	cmd.add_modify = STA_MODE_MODIFY;
-	cmd.add_immediate_ba_tid = (u8) tid;
-	cmd.add_immediate_ba_ssn = cpu_to_le16(ssn);
+	if (start) {
+		cmd.add_immediate_ba_tid = (u8) tid;
+		cmd.add_immediate_ba_ssn = cpu_to_le16(ssn);
+	} else {
+		cmd.remove_immediate_ba_tid = (u8) tid;
+	}
 	cmd.modify_mask = start ? STA_MODIFY_ADD_BA_TID :
 				  STA_MODIFY_REMOVE_BA_TID;
 


