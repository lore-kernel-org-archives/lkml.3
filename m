Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3JNNds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:33:48 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63450 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3JNNdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:33:47 -0400
From: Chang Xiangzhong <changxiangzhong@gmail.com>
To: nhorman@tuxdriver.com, vyasevich@gmail.com
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chang Xiangzhong <changxiangzhong@gmail.com>
Subject: [PATCH] net: sctp: fix a cacc_saw_newack missetting issue
Date: Mon, 14 Oct 2013 15:33:43 +0200
Message-Id: <1381757623-12803-1-git-send-email-changxiangzhong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For for each TSN t being newly acked (Not only cumulatively,
but also SELECTIVELY) cacc_saw_newack should be set to 1.

Signed-off-by: Xiangzhong Chang <changxiangzhong@gmail.com>
---
 net/sctp/outqueue.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 94df758..d86032b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1398,6 +1398,27 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 				forward_progress = true;
 			}
 
+			if (!tchunk->tsn_gap_acked) {
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
+				    sack->num_gap_ack_blocks &&
+				    q->asoc->peer.primary_path->cacc.
+				    changeover_active)
+					transport->cacc.cacc_saw_newack	= 1;
+			}
+
 			if (TSN_lte(tsn, sack_ctsn)) {
 				/* RFC 2960  6.3.2 Retransmission Timer Rules
 				 *
@@ -1411,27 +1432,6 @@ static void sctp_check_transmitted(struct sctp_outq *q,
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
 
 				list_add_tail(&tchunk->transmitted_list,
 					      &q->sacked);
-- 
1.7.9.5

