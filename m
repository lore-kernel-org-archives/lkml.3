Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3EQVho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab3EQVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 058/102] tcp: reset timer after any SYNACK retransmit
Date: Fri, 17 May 2013 14:36:13 -0700
Message-Id: <20130517213250.483791897@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_minisocks.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -583,8 +583,13 @@ struct sock *tcp_check_req(struct sock *
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
 


