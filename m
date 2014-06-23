Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaFWIs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:48:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55559 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 099/111] tcp: fix cwnd undo on DSACK in F-RTO
Date: Mon, 23 Jun 2014 10:32:14 +0200
Message-Id: <dc4d3702659539dc9bdebf3bb4cfd4187c1cc9c5.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 0cfa5c07d6d1d7f8e710fc671c5ba1ce85e09fa4 ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp_input.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 068c8fb0d158..0e8af08a98fc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2633,13 +2633,12 @@ static void tcp_process_loss(struct sock *sk, int flag, bool is_dupack)
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
2.0.0

