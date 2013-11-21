Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3KUV4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:56:33 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:32772 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3KUV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:56:30 -0500
From: Chang Xiangzhong <changxiangzhong@gmail.com>
To: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chang Xiangzhong <changxiangzhong@gmail.com>
Subject: [PATCH] net: sctp: find the correct highest_new_tsn in sack
Date: Thu, 21 Nov 2013 22:56:28 +0100
Message-Id: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function sctp_check_transmitted(transport t, ...) would iterate all of
transport->transmitted queue and looking for the highest __newly__ acked tsn.
The original algorithm would depend on the order of the assoc->transport_list
(in function sctp_outq_sack line 1215 - 1226). The result might not be the
expected due to the order of the tranport_list.

Solution: checking if the exising is smaller than the new one before assigning

Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
---
 net/sctp/outqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index ef9e2bb..1b494fa 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1397,7 +1397,8 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 			 */
 			if (!tchunk->tsn_gap_acked) {
 				tchunk->tsn_gap_acked = 1;
-				*highest_new_tsn_in_sack = tsn;
+				if (TSN_lt(*highest_new_tsn_in_sack, tsn))
+					*highest_new_tsn_in_sack = tsn;
 				bytes_acked += sctp_data_size(tchunk);
 				if (!tchunk->transport)
 					migrate_bytes += sctp_data_size(tchunk);
-- 
1.8.4.3

