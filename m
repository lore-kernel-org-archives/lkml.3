Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaD1Bb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42904 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.332959730@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 45/94] iwlwifi: dvm: take mutex when sending SYNC BT
 config command
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 82e5a649453a3cf23516277abb84273768a1592b upstream.

There is a flow in which we send the host command in SYNC
mode, but we don't take priv->mutex.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1046495

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[bwh: Backported to 3.2:
 - Adjust filename, context
 - mutex is priv->shrd->mutex]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -246,13 +246,17 @@ static void iwl_bg_bt_runtime_config(str
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, bt_runtime_config);
 
+	mutex_lock(&priv->shrd->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-		return;
+		goto out;
 
 	/* dont send host command if rf-kill is on */
 	if (!iwl_is_ready_rf(priv->shrd))
-		return;
+		goto out;
+
 	iwlagn_send_advance_bt_config(priv);
+out:
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static void iwl_bg_bt_full_concurrency(struct work_struct *work)

