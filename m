Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaLEXhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:37:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaLEW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luciano Coelho <luciano.coelho@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.17 118/122] iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands
Date: Fri,  5 Dec 2014 14:44:52 -0800
Message-Id: <20141205223323.968604402@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <luciano.coelho@intel.com>

commit 5ac6c72e594471acfa5b00210c51d533a73413ad upstream.

Older firmwares do not provide support for the HOT_SPOT_CMD command.
Check for the appropriate TLV flag that declares hotspot support in
the firmware to prevent a firmware assertion failure that can be
triggered from the userspace,

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |    4 +++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   12 +++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -138,9 +138,11 @@ enum iwl_ucode_tlv_api {
 /**
  * enum iwl_ucode_tlv_capa - ucode capabilities
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
+ * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  */
 enum iwl_ucode_tlv_capa {
-	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT		= BIT(0),
+	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
+	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
 };
 
 /* The default calibrate table size if not specified by firmware file */
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2476,9 +2476,15 @@ static int iwl_mvm_roc(struct ieee80211_
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		/* Use aux roc framework (HS20) */
-		ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
-					       vif, duration);
+		if (mvm->fw->ucode_capa.capa[0] &
+		    IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT) {
+			/* Use aux roc framework (HS20) */
+			ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
+						       vif, duration);
+			goto out_unlock;
+		}
+		IWL_ERR(mvm, "hotspot not supported\n");
+		ret = -EINVAL;
 		goto out_unlock;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* handle below */


