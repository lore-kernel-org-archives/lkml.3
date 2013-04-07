Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934950Ab3DGXcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:32:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46827 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934759Ab3DGXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:32:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neal Cardwell" <ncardwell@google.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.154097199@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [55/74] tcp: undo spurious timeout after SACK reneging
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 7ebe183c6d444ef5587d803b64a1f4734b18c564 ]

On SACK reneging the sender immediately retransmits and forces a
timeout but disables Eifel (undo). If the (buggy) receiver does not
drop any packet this can trigger a false slow-start retransmit storm
driven by the ACKs of the original packets. This can be detected with
undo and TCP timestamps.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 1b1f7af..3124e17 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2265,11 +2265,8 @@ void tcp_enter_loss(struct sock *sk, int how)
 	if (tcp_is_reno(tp))
 		tcp_reset_reno_sack(tp);
 
-	if (!how) {
-		/* Push undo marker, if it was plain RTO and nothing
-		 * was retransmitted. */
-		tp->undo_marker = tp->snd_una;
-	} else {
+	tp->undo_marker = tp->snd_una;
+	if (how) {
 		tp->sacked_out = 0;
 		tp->fackets_out = 0;
 	}

