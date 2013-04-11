Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285Ab3DKVSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:18:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab3DKUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:56 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tZliiFN8BDYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bl-D0AqXSQoA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=NATkb4zoVZhRDCigstQA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202609.757063105@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 143/171 ] iwlwifi: dvm: dont send HCMD in restart flow
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0143-iwlwifi-dvm-don-t-send-HCMD-in-restart-flow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 2d5d50ee596361566f7f84300117cba7d7672bc5 ]

There is a race between the restart flow and the workers.
The workers are cancelled after the fw is already killed
and might send HCMD when there is fw to handle them.
Simply check that there is a fw to which the HCMD can be
sent before actually sending it.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlwifi/dvm/lib.c   |    9 +++++++++
 drivers/net/wireless/iwlwifi/dvm/ucode.c |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index bef88c1..f18ecd3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -1263,6 +1263,15 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	}
 
 	/*
+	 * This can happen upon FW ASSERT: we clear the STATUS_FW_ERROR flag
+	 * in iwl_down but cancel the workers only later.
+	 */
+	if (!priv->ucode_loaded) {
+		IWL_ERR(priv, "Fw not loaded - dropping CMD: %x\n", cmd->id);
+		return -EIO;
+	}
+
+	/*
 	 * Synchronous commands from this op-mode must hold
 	 * the mutex, this ensures we don't try to send two
 	 * (or more) synchronous commands at a time.
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 6d8d6dd..6215b16 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -450,6 +450,8 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
+	priv->ucode_loaded = true;
+
 	/*
 	 * This step takes a long time (60-80ms!!) and
 	 * WoWLAN image should be loaded quickly, so
@@ -474,8 +476,6 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
-	priv->ucode_loaded = true;
-
 	return 0;
 }
 
-- 
1.7.10.4


