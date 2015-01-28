Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbbA2DM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:12:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46972 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762217AbbA2Cgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 066/139] iwlwifi: dvm: fix flush support for old firmware
Date: Wed, 28 Jan 2015 14:20:09 -0800
Message-Id: <1422483682-15393-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5a12a07e4495d1e4d79382e05c9d6e8b4d9fa4ec upstream.

Since the commit below, iwldvm sends the FLUSH command to
the firmware. All the devices that use iwldvm have a
firmware that expects the _v3 version of this command,
besides 5150.
5150's latest available firmware still expects a _v2 version
of the FLUSH command.
This means that since the commit below, we had a mismatch for
this specific device only.
This mismatch led to the NMI below:

Loaded firmware version: 8.24.2.2
Start IWL Error Log Dump:
Status: 0x0000004C, count: 5
0x00000004 | NMI_INTERRUPT_WDG
0x000006F4 | uPc
0x000005BA | branchlink1
0x000006F8 | branchlink2
0x000008C2 | interruptlink1
0x00005B02 | interruptlink2
0x00000002 | data1
0x07030000 | data2
0x00000068 | line
0x3E80510C | beacon time
0x728A0EF4 | tsf low
0x0000002A | tsf hi
0x00000000 | time gp1
0x01BDC977 | time gp2
0x00000000 | time gp3
0x00010818 | uCode version
0x00000000 | hw version
0x00484704 | board version
0x00000002 | hcmd
0x2FF23080 | isr0
0x0103E000 | isr1
0x0000001A | isr2
0x1443FCC3 | isr3
0x11800112 | isr4
0x00000068 | isr_pref
0x000000D4 | wait_event
0x00000000 | l2p_control
0x00000007 | l2p_duration
0x00103040 | l2p_mhvalid
0x00000007 | l2p_addr_match
0x00000000 | lmpm_pmg_sel
0x00000000 | timestamp
0x00000200 | flow_handler

This was reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=88961

Fixes: a0855054e59b ("iwlwifi: dvm: drop non VO frames when flushing")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h | 31 +++++++++++--------
 drivers/net/wireless/iwlwifi/dvm/lib.c      | 48 ++++++++++++++---------------
 2 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index ebdac90..e65ac8e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -966,21 +966,21 @@ struct iwl_rem_sta_cmd {
 
 
 /* WiFi queues mask */
-#define IWL_SCD_BK_MSK			cpu_to_le32(BIT(0))
-#define IWL_SCD_BE_MSK			cpu_to_le32(BIT(1))
-#define IWL_SCD_VI_MSK			cpu_to_le32(BIT(2))
-#define IWL_SCD_VO_MSK			cpu_to_le32(BIT(3))
-#define IWL_SCD_MGMT_MSK		cpu_to_le32(BIT(3))
+#define IWL_SCD_BK_MSK			BIT(0)
+#define IWL_SCD_BE_MSK			BIT(1)
+#define IWL_SCD_VI_MSK			BIT(2)
+#define IWL_SCD_VO_MSK			BIT(3)
+#define IWL_SCD_MGMT_MSK		BIT(3)
 
 /* PAN queues mask */
-#define IWL_PAN_SCD_BK_MSK		cpu_to_le32(BIT(4))
-#define IWL_PAN_SCD_BE_MSK		cpu_to_le32(BIT(5))
-#define IWL_PAN_SCD_VI_MSK		cpu_to_le32(BIT(6))
-#define IWL_PAN_SCD_VO_MSK		cpu_to_le32(BIT(7))
-#define IWL_PAN_SCD_MGMT_MSK		cpu_to_le32(BIT(7))
-#define IWL_PAN_SCD_MULTICAST_MSK	cpu_to_le32(BIT(8))
+#define IWL_PAN_SCD_BK_MSK		BIT(4)
+#define IWL_PAN_SCD_BE_MSK		BIT(5)
+#define IWL_PAN_SCD_VI_MSK		BIT(6)
+#define IWL_PAN_SCD_VO_MSK		BIT(7)
+#define IWL_PAN_SCD_MGMT_MSK		BIT(7)
+#define IWL_PAN_SCD_MULTICAST_MSK	BIT(8)
 
-#define IWL_AGG_TX_QUEUE_MSK		cpu_to_le32(0xffc00)
+#define IWL_AGG_TX_QUEUE_MSK		0xffc00
 
 #define IWL_DROP_ALL			BIT(1)
 
@@ -1005,12 +1005,17 @@ struct iwl_rem_sta_cmd {
  *	1: Dump multiple MSDU according to PS, INVALID STA, TTL, TID disable.
  *	2: Dump all FIFO
  */
-struct iwl_txfifo_flush_cmd {
+struct iwl_txfifo_flush_cmd_v3 {
 	__le32 queue_control;
 	__le16 flush_control;
 	__le16 reserved;
 } __packed;
 
+struct iwl_txfifo_flush_cmd_v2 {
+	__le16 queue_control;
+	__le16 flush_control;
+} __packed;
+
 /*
  * REPLY_WEP_KEY = 0x20
  */
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 3d5bdc4..9f2ea1e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -138,38 +138,38 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
  */
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u32 scd_q_msk)
 {
-	struct iwl_txfifo_flush_cmd flush_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_TXFIFO_FLUSH,
-		.len = { sizeof(struct iwl_txfifo_flush_cmd), },
-		.flags = CMD_SYNC,
-		.data = { &flush_cmd, },
+	struct iwl_txfifo_flush_cmd_v3 flush_cmd_v3 = {
+		.flush_control = cpu_to_le16(IWL_DROP_ALL),
+	};
+	struct iwl_txfifo_flush_cmd_v2 flush_cmd_v2 = {
+		.flush_control = cpu_to_le16(IWL_DROP_ALL),
 	};
 
-	memset(&flush_cmd, 0, sizeof(flush_cmd));
+	u32 queue_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
+			    IWL_SCD_BE_MSK | IWL_SCD_BK_MSK | IWL_SCD_MGMT_MSK;
 
-	flush_cmd.queue_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
-				  IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
-				  IWL_SCD_MGMT_MSK;
 	if ((priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
-		flush_cmd.queue_control |= IWL_PAN_SCD_VO_MSK |
-					   IWL_PAN_SCD_VI_MSK |
-					   IWL_PAN_SCD_BE_MSK |
-					   IWL_PAN_SCD_BK_MSK |
-					   IWL_PAN_SCD_MGMT_MSK |
-					   IWL_PAN_SCD_MULTICAST_MSK;
+		queue_control |= IWL_PAN_SCD_VO_MSK | IWL_PAN_SCD_VI_MSK |
+				 IWL_PAN_SCD_BE_MSK | IWL_PAN_SCD_BK_MSK |
+				 IWL_PAN_SCD_MGMT_MSK |
+				 IWL_PAN_SCD_MULTICAST_MSK;
 
 	if (priv->nvm_data->sku_cap_11n_enable)
-		flush_cmd.queue_control |= IWL_AGG_TX_QUEUE_MSK;
+		queue_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	if (scd_q_msk)
-		flush_cmd.queue_control = cpu_to_le32(scd_q_msk);
-
-	IWL_DEBUG_INFO(priv, "queue control: 0x%x\n",
-		       flush_cmd.queue_control);
-	flush_cmd.flush_control = cpu_to_le16(IWL_DROP_ALL);
-
-	return iwl_dvm_send_cmd(priv, &cmd);
+		queue_control = scd_q_msk;
+
+	IWL_DEBUG_INFO(priv, "queue control: 0x%x\n", queue_control);
+	flush_cmd_v3.queue_control = cpu_to_le32(queue_control);
+	flush_cmd_v2.queue_control = cpu_to_le16((u16)queue_control);
+
+	if (IWL_UCODE_API(priv->fw->ucode_ver) > 2)
+		return iwl_dvm_send_cmd_pdu(priv, REPLY_TXFIFO_FLUSH, 0,
+					    sizeof(flush_cmd_v3),
+					    &flush_cmd_v3);
+	return iwl_dvm_send_cmd_pdu(priv, REPLY_TXFIFO_FLUSH, 0,
+				    sizeof(flush_cmd_v2), &flush_cmd_v2);
 }
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv)
-- 
1.9.1

