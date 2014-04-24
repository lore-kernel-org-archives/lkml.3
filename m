Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaDXIxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaDXIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/182] iwlwifi: dvm: take mutex when sending SYNC BT config command
Date: Thu, 24 Apr 2014 09:49:28 +0100
Message-Id: <1398329507-5911-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 82e5a649453a3cf23516277abb84273768a1592b upstream.

There is a flow in which we send the host command in SYNC
mode, but we don't take priv->mutex.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1046495

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 1531a4f..7e61ea9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -252,13 +252,17 @@ static void iwl_bg_bt_runtime_config(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_runtime_config);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
 	/* dont send host command if rf-kill is on */
 	if (!iwl_is_ready_rf(priv))
-		return;
+		goto out;
+
 	iwlagn_send_advance_bt_config(priv);
+out:
+	mutex_unlock(&priv->mutex);
 }
 
 static void iwl_bg_bt_full_concurrency(struct work_struct *work)
-- 
1.9.1

