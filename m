Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaFDXVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaFDXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 022/228] iwlwifi: mvm: rs: fallback to legacy Tx columns
Date: Wed,  4 Jun 2014 16:20:51 -0700
Message-Id: <20140604232348.807199023@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Shapira <eyal@wizery.com>

commit fd7dbee51b3d98402edb11fec0c93d96476e0ae1 upstream.

Allow switching back to legacy Tx columns so we'll stop doing
HT/VHT in case we're far from the AP. Stop active aggregation when
making a deciding to stay in a legacy column.
Despite having low legacy rates in the LQ table lower entries
it doesn't help much in case we're doing aggregations as the
aggregation was being transmitted in the initial rate of the table.

This should help traffic stalls when far from the AP.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -142,7 +142,7 @@ enum rs_column_mode {
 	RS_MIMO2,
 };
 
-#define MAX_NEXT_COLUMNS 5
+#define MAX_NEXT_COLUMNS 7
 #define MAX_COLUMN_CHECKS 3
 
 typedef bool (*allow_column_func_t) (struct iwl_mvm *mvm,
@@ -214,6 +214,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 	},
 	[RS_COLUMN_LEGACY_ANT_B] = {
@@ -225,6 +227,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 	},
 	[RS_COLUMN_SISO_ANT_A] = {
@@ -236,6 +240,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -250,6 +256,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -265,6 +273,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -281,6 +291,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_MIMO2,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -296,6 +308,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_mimo_allow,
@@ -311,6 +325,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_LEGACY_ANT_B,
 		},
 		.checks = {
 			rs_mimo_allow,
@@ -2032,8 +2048,18 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(&tbl1->rate) && !sta->ht_cap.ht_supported) {
+		if (is_legacy(&tbl1->rate)) {
 			IWL_DEBUG_RATE(mvm, "LQ: STAY in legacy table\n");
+
+			if (tid != IWL_MAX_TID_COUNT) {
+				tid_data = &sta_priv->tid_data[tid];
+				if (tid_data->state != IWL_AGG_OFF) {
+					IWL_DEBUG_RATE(mvm,
+						       "Stop aggregation on tid %d\n",
+						       tid);
+					ieee80211_stop_tx_ba_session(sta, tid);
+				}
+			}
 			rs_set_stay_in_table(mvm, 1, lq_sta);
 		} else {
 		/* If we're in an HT mode, and all 3 mode switch actions


