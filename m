Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3KRTCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:02:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3KRSkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Petr Matousek <pmatouse@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 03/25] net: flow_dissector: fail on evil iph->ihl
Date: Mon, 18 Nov 2013 10:40:32 -0800
Message-Id: <20131118184033.111666918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 6f092343855a71e03b8d209815d8c45bf3a27fcd ]

We don't validate iph->ihl which may lead a dead loop if we meet a IPIP
skb whose iph->ihl is zero. Fix this by failing immediately when iph->ihl
is evil (less than 5).

This issue were introduced by commit ec5efe7946280d1e84603389a1030ccec0a767ae
(rps: support IPIP encapsulation).

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


