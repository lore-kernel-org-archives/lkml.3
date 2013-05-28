Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab3E1V3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:29:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab3E1VZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yuchung Cheng <ycheng@google.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 62/78] tcp: reset timer after any SYNACK retransmit
Date: Tue, 28 May 2013 14:20:11 -0700
Message-Id: <1369776027-17859-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit cd75eff64dae8856afbf6ef0f0ca3c145465d8e0 ]

Linux immediately returns SYNACK on (spurious) SYN retransmits, but
keeps the SYNACK timer running independently. Thus the timer may
fire right after the SYNACK retransmit and causes a SYN-SYNACK
cross-fire burst.

Adopt the fast retransmit/recovery idea in established state by
re-arming the SYNACK timer after the fast (SYNACK) retransmit. The
timer may fire late up to 500ms due to the current SYNACK timer wheel,
but it's OK to be conservative when network is congested. Eric's new
listener design should address this issue.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_minisocks.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index f35f2df..18e230d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -581,8 +581,13 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		 *
 		 * Note that even if there is new data in the SYN packet
 		 * they will be thrown away too.
+		 *
+		 * Reset timer after retransmitting SYNACK, similar to
+		 * the idea of fast retransmit in recovery.
 		 */
-		inet_rtx_syn_ack(sk, req);
+		if (!inet_rtx_syn_ack(sk, req))
+			req->expires = min(TCP_TIMEOUT_INIT << req->num_timeout,
+					   TCP_RTO_MAX) + jiffies;
 		return NULL;
 	}
 
-- 
1.8.1.2

