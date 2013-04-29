Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab3D2TDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:03:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759839Ab3D2TDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Foraker <foraker1@llnl.gov>, Thomas Graf <tgraf@suug.ch>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/34] tcp: Reallocate headroom if it would overflow csum_start
Date: Mon, 29 Apr 2013 12:02:35 -0700
Message-Id: <20130429184704.100769998@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit 50bceae9bd3569d56744882f3012734d48a1d413 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2154,8 +2154,12 @@ int tcp_retransmit_skb(struct sock *sk,
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


