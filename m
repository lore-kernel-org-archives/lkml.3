Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3L2DAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:00:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793Ab3L2CJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "Petr Matousek" <pmatouse@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.481234836@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 180/185] net: flow_dissector: fail on evil iph->ihl
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 6f092343855a71e03b8d209815d8c45bf3a27fcd upstream.

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
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: the affected code is in __skb_get_rxhash()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2609,6 +2609,8 @@ ip:
 			goto done;
 
 		ip = (const struct iphdr *) (skb->data + nhoff);
+		if (ip->ihl < 5)
+			goto done;
 		if (ip_is_fragment(ip))
 			ip_proto = 0;
 		else

