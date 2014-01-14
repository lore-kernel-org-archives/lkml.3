Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaANAvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:51:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbaANA2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Templin, Fred L" <Fred.L.Templin@boeing.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 04/77] net: clear local_df when passing skb between namespaces
Date: Mon, 13 Jan 2014 16:27:25 -0800
Message-Id: <20140114002752.627388071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 239c78db9c41a8f524cce60507440d72229d73bc ]

We must clear local_df when passing the skb between namespaces as the
packet is not local to the new namespace any more and thus may not get
fragmented by local rules. Fred Templin noticed that other namespaces
do fragment IPv6 packets while forwarding. Instead they should have send
back a PTB.

The same problem should be present when forwarding DF-IPv4 packets
between namespaces.

Reported-by: Templin, Fred L <Fred.L.Templin@boeing.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3541,6 +3541,7 @@ void skb_scrub_packet(struct sk_buff *sk
 	skb->tstamp.tv64 = 0;
 	skb->pkt_type = PACKET_HOST;
 	skb->skb_iif = 0;
+	skb->local_df = 0;
 	skb_dst_drop(skb);
 	skb->mark = 0;
 	secpath_reset(skb);


