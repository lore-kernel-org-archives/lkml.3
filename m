Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaIUXdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 19:33:24 -0400
Received: from mout.web.de ([212.227.15.14]:51125 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaIUXdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 19:33:23 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH] bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally generated queries
Date: Mon, 22 Sep 2014 01:32:44 +0200
Message-Id: <1411342364-4791-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:KHKPuKH5cauyZjTHv0+XRBtj8ayXmO2ZY1XrAKTgtoswu8SJSTY
 WwLAWK2xa/HWPQ06BriiGuKy0SfQv3neK3tPBaob9mkGx7Gb9sM8VQ1pjW2KMFgMdGAiFnZ
 +3aeSb6jKbvxYGnpsOan1BUShoTs3YJ9WXomkUVv9ycF65L75VMGNZejlJKwwFJ/5EhkGg+
 NX7F7+C/ZQWh9wLjvCT2Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ebtables on the OUTPUT chain (NF_BR_LOCAL_OUT) would not work as expected
for both locally generated IGMP and MLD queries. The IP header specific
filter options are off by 14 Bytes for netfilter (actual output on
interfaces is fine).

NF_HOOK() expects the skb->data to point to the IP header, not the
ethernet one (while dev_queue_xmit() does not). Luckily there is an
br_dev_queue_push_xmit() helper function already - let's just use that.

Introduced by eb1d16414339a6e113d89e2cca2556005d7ce919
("bridge: Add core IGMP snooping support")

Ebtables example:

$ ebtables -I OUTPUT -p IPv6 -o eth1 --logical-out br0 \
	--log --log-level 6 --log-ip6 --log-prefix="~EBT: " -j DROP

before (broken):

~EBT:  IN= OUT=eth1 MAC source = 02:04:64:a4:39:c2 \
	MAC dest = 33:33:00:00:00:01 proto = 0x86dd IPv6 \
	SRC=64a4:39c2:86dd:6000:0000:0020:0001:fe80 IPv6 \
	DST=0000:0000:0000:0004:64ff:fea4:39c2:ff02, \
	IPv6 priority=0x3, Next Header=2

after (working):

~EBT:  IN= OUT=eth1 MAC source = 02:04:64:a4:39:c2 \
	MAC dest = 33:33:00:00:00:01 proto = 0x86dd IPv6 \
	SRC=fe80:0000:0000:0000:0004:64ff:fea4:39c2 IPv6 \
	DST=ff02:0000:0000:0000:0000:0000:0000:0001, \
	IPv6 priority=0x0, Next Header=0

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7751c92..9d02e6c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -813,10 +813,9 @@ static void __br_multicast_send_query(struct net_bridge *br,
 		return;
 
 	if (port) {
-		__skb_push(skb, sizeof(struct ethhdr));
 		skb->dev = port->dev;
 		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT, skb, NULL, skb->dev,
-			dev_queue_xmit);
+			br_dev_queue_push_xmit);
 	} else {
 		br_multicast_select_own_querier(br, ip, skb);
 		netif_rx(skb);
-- 
1.7.10.4

