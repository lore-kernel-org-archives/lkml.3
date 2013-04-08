Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3DHJ7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:59:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935903Ab3DHJwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 085/102] iwlwifi: dvm: don't send HCMD in restart flow
Date: Mon,  8 Apr 2013 10:50:40 +0100
Message-Id: <1365414657-29191-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 2d5d50ee596361566f7f84300117cba7d7672bc5 upstream.

There is a race between the restart flow and the workers.
The workers are cancelled after the fw is already killed
and might send HCMD when there is fw to handle them.
Simply check that there is a fw to which the HCMD can be
sent before actually sending it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5:
  - file rename: dvm/lib.c -> iwl-agn-lib.c
  - file rename: dvm/ucode.c -> iwl-ucode.c
  - adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c | 9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-ucode.c   | 4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c31072d..b3dc9b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1260,6 +1260,15 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index bc40dc6..d67d2b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -425,6 +425,8 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
+	priv->ucode_loaded = true;
+
 	/*
 	 * This step takes a long time (60-80ms!!) and
 	 * WoWLAN image should be loaded quickly, so
@@ -449,8 +451,6 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
-	priv->ucode_loaded = true;
-
 	return 0;
 }
 
-- 
1.8.1.2

