Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab3FEVgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:36:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab3FEVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 109/127] iwlwifi: mvm: tell firmware to let multicast frames in
Date: Wed,  5 Jun 2013 14:34:36 -0700
Message-Id: <20130605213230.396447402@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 51b6b9e029e81c857f9d8d17060f499cd25febdb upstream.

Without this command, the firmware will filter out all the
multicast frames. Let them all in as for now. Later we will
want to optimize this to save power.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    1 +
 3 files changed, 43 insertions(+)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -165,6 +165,8 @@ enum {
 	REPLY_DEBUG_CMD = 0xf0,
 	DEBUG_LOG_MSG = 0xf7,
 
+	MCAST_FILTER_CMD = 0xd0,
+
 	/* D3 commands/notifications */
 	D3_CONFIG_CMD = 0xd3,
 	PROT_OFFLOAD_CONFIG_CMD = 0xd4,
@@ -951,4 +953,29 @@ struct iwl_set_calib_default_cmd {
 	u8 data[0];
 } __packed; /* PHY_CALIB_OVERRIDE_VALUES_S */
 
+#define MAX_PORT_ID_NUM	2
+
+/**
+ * struct iwl_mcast_filter_cmd - configure multicast filter.
+ * @filter_own: Set 1 to filter out multicast packets sent by station itself
+ * @port_id:	Multicast MAC addresses array specifier. This is a strange way
+ *		to identify network interface adopted in host-device IF.
+ *		It is used by FW as index in array of addresses. This array has
+ *		MAX_PORT_ID_NUM members.
+ * @count:	Number of MAC addresses in the array
+ * @pass_all:	Set 1 to pass all multicast packets.
+ * @bssid:	current association BSSID.
+ * @addr_list:	Place holder for array of MAC addresses.
+ *		IMPORTANT: add padding if necessary to ensure DWORD alignment.
+ */
+struct iwl_mcast_filter_cmd {
+	u8 filter_own;
+	u8 port_id;
+	u8 count;
+	u8 pass_all;
+	u8 bssid[6];
+	u8 reserved[2];
+	u8 addr_list[0];
+} __packed; /* MCAST_FILTERING_CMD_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -657,6 +657,20 @@ static void iwl_mvm_configure_filter(str
 	*total_flags = 0;
 }
 
+static int iwl_mvm_configure_mcast_filter(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif)
+{
+	struct iwl_mcast_filter_cmd mcast_filter_cmd = {
+		.pass_all = 1,
+	};
+
+	memcpy(mcast_filter_cmd.bssid, vif->bss_conf.bssid, ETH_ALEN);
+
+	return iwl_mvm_send_cmd_pdu(mvm, MCAST_FILTER_CMD, CMD_SYNC,
+				    sizeof(mcast_filter_cmd),
+				    &mcast_filter_cmd);
+}
+
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_bss_conf *bss_conf,
@@ -677,6 +691,7 @@ static void iwl_mvm_bss_info_changed_sta
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
 			}
+			iwl_mvm_configure_mcast_filter(mvm, vif);
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 			/* remove AP station now that the MAC is unassoc */
 			ret = iwl_mvm_rm_sta_id(mvm, vif, mvmvif->ap_sta_id);
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -293,6 +293,7 @@ static const char *iwl_mvm_cmd_strings[R
 	CMD(NET_DETECT_PROFILES_CMD),
 	CMD(NET_DETECT_HOTSPOTS_CMD),
 	CMD(NET_DETECT_HOTSPOTS_QUERY_CMD),
+	CMD(MCAST_FILTER_CMD),
 };
 #undef CMD
 


