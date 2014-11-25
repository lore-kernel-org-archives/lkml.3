Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaKYLXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:23:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaKYKmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 135/254] net: skb_fclone_busy() needs to detect orphaned skb
Date: Tue, 25 Nov 2014 10:38:05 +0000
Message-Id: <1416912004-5928-136-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 39bb5e62867de82b269b07df900165029b928359 upstream.

Some drivers are unable to perform TX completions in a bound time.
They instead call skb_orphan()

Problem is skb_fclone_busy() has to detect this case, otherwise
we block TCP retransmits and can freeze unlucky tcp sessions on
mostly idle hosts.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 1f3279ae0c13 ("tcp: avoid retransmits of TCP packets hanging in host queues")
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backport to 3.16 provided by Eric Dumzet ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4e4932b5079b..a8794367cd20 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2082,7 +2082,8 @@ static bool skb_still_in_host_queue(const struct sock *sk,
 	const struct sk_buff *fclone = skb + 1;
 
 	if (unlikely(skb->fclone == SKB_FCLONE_ORIG &&
-		     fclone->fclone == SKB_FCLONE_CLONE)) {
+		     fclone->fclone == SKB_FCLONE_CLONE &&
+		     fclone->sk == sk)) {
 		NET_INC_STATS_BH(sock_net(sk),
 				 LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
 		return true;
-- 
2.1.0

