Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3EGOIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:08:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab3EGNlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/118] tcp: Reallocate headroom if it would overflow csum_start
Date: Tue,  7 May 2013 14:38:18 +0100
Message-Id: <1367933964-1564-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

commit 50bceae9bd3569d56744882f3012734d48a1d413 upstream.

If a TCP retransmission gets partially ACKed and collapsed multiple
times it is possible for the headroom to grow beyond 64K which will
overflow the 16bit skb->csum_start which is based on the start of
the headroom. It has been observed rarely in the wild with IPoIB due
to the 64K MTU.

Verify if the acking and collapsing resulted in a headroom exceeding
what csum_start can cover and reallocate the headroom if so.

A big thank you to Jim Foraker <foraker1@llnl.gov> and the team at
LLNL for helping out with the investigation and testing.

Reported-by: Jim Foraker <foraker1@llnl.gov>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_output.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e0cd660..ae12c92 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2175,8 +2175,12 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 	 */
 	TCP_SKB_CB(skb)->when = tcp_time_stamp;
 
-	/* make sure skb->data is aligned on arches that require it */
-	if (unlikely(NET_IP_ALIGN && ((unsigned long)skb->data & 3))) {
+	/* make sure skb->data is aligned on arches that require it
+	 * and check if ack-trimming & collapsing extended the headroom
+	 * beyond what csum_start can cover.
+	 */
+	if (unlikely((NET_IP_ALIGN && ((unsigned long)skb->data & 3)) ||
+		     skb_headroom(skb) >= 0xFFFF)) {
 		struct sk_buff *nskb = __pskb_copy(skb, MAX_TCP_HEADER,
 						   GFP_ATOMIC);
 		err = nskb ? tcp_transmit_skb(sk, nskb, 0, GFP_ATOMIC) :
-- 
1.8.1.2

