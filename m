Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbbA0Mka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:40:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbbA0MSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 053/126] bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally generated queries
Date: Tue, 27 Jan 2015 12:15:58 +0000
Message-Id: <1422361031-19364-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

commit f0b4eeced518c632210ef2aea44fc92cc9e86cce upstream.

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
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_multicast.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index abfa0b65a111..eb73398dd237 100644
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
2.1.4

