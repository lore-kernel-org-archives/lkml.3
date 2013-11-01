Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3KAHB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:01:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab3KAHB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:01:27 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH net] net: flow_dissector: fail on evil iph->ihl
Date: Fri,  1 Nov 2013 15:01:10 +0800
Message-Id: <1383289270-18952-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't validate iph->ihl which may lead a dead loop if we meet a IPIP
skb whose iph->ihl is zero. Fix this by failing immediately when iph->ihl
is evil (less than 5).

This issue were introduced by commit ec5efe7946280d1e84603389a1030ccec0a767ae
(rps: support IPIP encapsulation).

Cc: Eric Dumazet <edumazet@google.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
This patch is needed for stable.
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 8d7d0dd..143b6fd 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -40,7 +40,7 @@ again:
 		struct iphdr _iph;
 ip:
 		iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
-		if (!iph)
+		if (!iph || iph->ihl < 5)
 			return false;
 
 		if (ip_is_fragment(iph))
-- 
1.8.1.2

