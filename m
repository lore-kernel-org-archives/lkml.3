Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030494AbaGCJnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:43:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030329AbaGCJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yuchung Cheng <ycheng@google.com>, Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 142/198] tcp: fix cwnd undo on DSACK in F-RTO
Date: Thu,  3 Jul 2014 10:19:45 +0100
Message-Id: <1404379241-8590-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

commit 0cfa5c07d6d1d7f8e710fc671c5ba1ce85e09fa4 upstream.

This bug is discovered by an recent F-RTO issue on tcpm list
https://www.ietf.org/mail-archive/web/tcpm/current/msg08794.html

The bug is that currently F-RTO does not use DSACK to undo cwnd in
certain cases: upon receiving an ACK after the RTO retransmission in
F-RTO, and the ACK has DSACK indicating the retransmission is spurious,
the sender only calls tcp_try_undo_loss() if some never retransmisted
data is sacked (FLAG_ORIG_DATA_SACKED).

The correct behavior is to unconditionally call tcp_try_undo_loss so
the DSACK information is used properly to undo the cwnd reduction.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_input.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 723951aec07e..d8e4c81bc114 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2622,13 +2622,12 @@ static void tcp_process_loss(struct sock *sk, int flag, bool is_dupack)
 	bool recovered = !before(tp->snd_una, tp->high_seq);
 
 	if (tp->frto) { /* F-RTO RFC5682 sec 3.1 (sack enhanced version). */
-		if (flag & FLAG_ORIG_SACK_ACKED) {
-			/* Step 3.b. A timeout is spurious if not all data are
-			 * lost, i.e., never-retransmitted data are (s)acked.
-			 */
-			tcp_try_undo_loss(sk, true);
+		/* Step 3.b. A timeout is spurious if not all data are
+		 * lost, i.e., never-retransmitted data are (s)acked.
+		 */
+		if (tcp_try_undo_loss(sk, flag & FLAG_ORIG_SACK_ACKED))
 			return;
-		}
+
 		if (after(tp->snd_nxt, tp->high_seq) &&
 		    (flag & FLAG_DATA_SACKED || is_dupack)) {
 			tp->frto = 0; /* Loss was real: 2nd part of step 3.a */
-- 
1.9.1

