Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015Ab3JPHWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:22:43 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:38617 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3JPHWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:22:39 -0400
From: Chang Xiangzhong <changxiangzhong@gmail.com>
To: vyasevich@gmail.com
Cc: nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chang Xiangzhong <changxiangzhong@gmail.com>
Subject: [PATCH v3] net: sctp: fix a cacc_saw_newack missetting issue
Date: Wed, 16 Oct 2013 09:22:11 +0200
Message-Id: <1381908131-24809-1-git-send-email-changxiangzhong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For for each TSN t being newly acked (Not only cumulatively,
but also SELECTIVELY) cacc_saw_newack should be set to 1.

Signed-off-by: Xiangzhong Chang <changxiangzhong@gmail.com>
---
 net/sctp/outqueue.c |   53 ++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 94df758..da9a778 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1383,19 +1383,38 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 				}
 			}
 
-			/* If the chunk hasn't been marked as ACKED,
-			 * mark it and account bytes_acked if the
-			 * chunk had a valid transport (it will not
-			 * have a transport if ASCONF had deleted it
-			 * while DATA was outstanding).
-			 */
 			if (!tchunk->tsn_gap_acked) {
+				/* If the chunk hasn't been marked as ACKED,
+				 * mark it and account bytes_acked if the
+				 * chunk had a valid transport (it will not
+				 * have a transport if ASCONF had deleted it
+				 * while DATA was outstanding).
+				 */
 				tchunk->tsn_gap_acked = 1;
 				*highest_new_tsn_in_sack = tsn;
 				bytes_acked += sctp_data_size(tchunk);
 				if (!tchunk->transport)
 					migrate_bytes += sctp_data_size(tchunk);
 				forward_progress = true;
+
+				/*
+				 * SFR-CACC algorithm:
+				 * 2) If the SACK contains gap acks
+				 * and the flag CHANGEOVER_ACTIVE is
+				 * set the receiver of the SACK MUST
+				 * take the following action:
+				 *
+				 * B) For each TSN t being acked that
+				 * has not been acked in any SACK so
+				 * far, set cacc_saw_newack to 1 for
+				 * the destination that the TSN was
+				 * sent to.
+				 */
+				if (transport &&
+					sack->num_gap_ack_blocks &&
+					q->asoc->peer.primary_path->cacc.
+					changeover_active)
+					transport->cacc.cacc_saw_newack = 1;
 			}
 
 			if (TSN_lte(tsn, sack_ctsn)) {
@@ -1411,28 +1430,6 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 				restart_timer = 1;
 				forward_progress = true;
 
-				if (!tchunk->tsn_gap_acked) {
-					/*
-					 * SFR-CACC algorithm:
-					 * 2) If the SACK contains gap acks
-					 * and the flag CHANGEOVER_ACTIVE is
-					 * set the receiver of the SACK MUST
-					 * take the following action:
-					 *
-					 * B) For each TSN t being acked that
-					 * has not been acked in any SACK so
-					 * far, set cacc_saw_newack to 1 for
-					 * the destination that the TSN was
-					 * sent to.
-					 */
-					if (transport &&
-					    sack->num_gap_ack_blocks &&
-					    q->asoc->peer.primary_path->cacc.
-					    changeover_active)
-						transport->cacc.cacc_saw_newack
-							= 1;
-				}
-
 				list_add_tail(&tchunk->transmitted_list,
 					      &q->sacked);
 			} else {
-- 
1.7.9.5

