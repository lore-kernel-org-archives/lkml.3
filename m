Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3EJOWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:22:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57256 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab3EJOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.991823579@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [042/118] iwlwifi: dvm: don't send zeroed LQ cmd
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 63b77bf489881747c5118476918cc8c29378ee63 upstream.

When the stations are being restored because of unassoc
RXON, the LQ cmd may not have been initialized because it
is initialized only after association.
Sending zeroed LQ_CMD makes the fw unhappy: it raises
SYSASSERT_2078.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
[move zero_lq and make static const]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -563,6 +563,7 @@ void iwl_clear_ucode_stations(struct iwl
 void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
+	static const struct iwl_link_quality_cmd zero_lq = {};
 	struct iwl_link_quality_cmd lq;
 	unsigned long flags_spin;
 	int i;
@@ -602,7 +603,9 @@ void iwl_restore_stations(struct iwl_pri
 				else
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
-				send_lq = true;
+
+				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+					send_lq = true;
 			}
 			spin_unlock_irqrestore(&priv->shrd->sta_lock,
 					       flags_spin);

