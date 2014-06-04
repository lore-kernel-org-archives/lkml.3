Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaFDXXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaFDXXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 226/228] iwlwifi: mvm: rs: clear per rate stats when aggregation changes
Date: Wed,  4 Jun 2014 16:24:15 -0700
Message-Id: <20140604232355.306073390@linuxfoundation.org>
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

commit b804eeb6649d75caeccbeae9f5623fc7b8bdfdfa upstream.

The per rate stats should be cleared when aggregation state changes
to avoid making rate scale decisions based on throughput figures which
were collected prior to the aggregation state change and are now stale.
While at it make sure any clearing of the per rate stats will get logged.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -519,10 +519,12 @@ static void rs_rate_scale_clear_window(s
 	window->average_tpt = IWL_INVALID_VALUE;
 }
 
-static void rs_rate_scale_clear_tbl_windows(struct iwl_scale_tbl_info *tbl)
+static void rs_rate_scale_clear_tbl_windows(struct iwl_mvm *mvm,
+					    struct iwl_scale_tbl_info *tbl)
 {
 	int i;
 
+	IWL_DEBUG_RATE(mvm, "Clearing up window stats\n");
 	for (i = 0; i < IWL_RATE_COUNT; i++)
 		rs_rate_scale_clear_window(&tbl->win[i]);
 }
@@ -1465,7 +1467,7 @@ static void rs_stay_in_table(struct iwl_
 
 				IWL_DEBUG_RATE(mvm,
 					       "LQ: stay in table clear win\n");
-				rs_rate_scale_clear_tbl_windows(tbl);
+				rs_rate_scale_clear_tbl_windows(mvm, tbl);
 			}
 		}
 
@@ -1473,8 +1475,7 @@ static void rs_stay_in_table(struct iwl_
 		 * bitmaps and stats in active table (this will become the new
 		 * "search" table). */
 		if (lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_STARTED) {
-			IWL_DEBUG_RATE(mvm, "Clearing up window stats\n");
-			rs_rate_scale_clear_tbl_windows(tbl);
+			rs_rate_scale_clear_tbl_windows(mvm, tbl);
 		}
 	}
 }
@@ -1810,6 +1811,7 @@ static void rs_rate_scale_perform(struct
 			       "Aggregation changed: prev %d current %d. Update expected TPT table\n",
 			       prev_agg, lq_sta->is_agg);
 		rs_set_expected_tpt_table(lq_sta, tbl);
+		rs_rate_scale_clear_tbl_windows(mvm, tbl);
 	}
 
 	/* current tx rate */
@@ -2039,7 +2041,7 @@ lq_update:
 		if (lq_sta->search_better_tbl) {
 			/* Access the "search" table, clear its history. */
 			tbl = &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-			rs_rate_scale_clear_tbl_windows(tbl);
+			rs_rate_scale_clear_tbl_windows(mvm, tbl);
 
 			/* Use new "search" start rate */
 			index = tbl->rate.index;
@@ -2303,7 +2305,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm
 	lq_sta->lq.sta_id = sta_priv->sta_id;
 
 	for (j = 0; j < LQ_SIZE; j++)
-		rs_rate_scale_clear_tbl_windows(&lq_sta->lq_info[j]);
+		rs_rate_scale_clear_tbl_windows(mvm, &lq_sta->lq_info[j]);
 
 	lq_sta->flush_timer = 0;
 	lq_sta->last_tx = jiffies;


