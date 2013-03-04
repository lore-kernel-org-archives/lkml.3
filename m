Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3CDDnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60908 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755754Ab3CDDm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:57 -0500
Message-Id: <20130304033719.613593954@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 122/153] bridge: set priority of STP packets
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 547b4e718115eea74087e28d7fa70aec619200db ]

Spanning Tree Protocol packets should have always been marked as
control packets, this causes them to get queued in the high prirority
FIFO. As Radia Perlman mentioned in her LCA talk, STP dies if bridge
gets overloaded and can't communicate. This is a long-standing bug back
to the first versions of Linux bridge.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_stp_bpdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index e16aade..718cbe8 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -16,6 +16,7 @@
 #include <linux/etherdevice.h>
 #include <linux/llc.h>
 #include <linux/slab.h>
+#include <linux/pkt_sched.h>
 #include <net/net_namespace.h>
 #include <net/llc.h>
 #include <net/llc_pdu.h>
@@ -40,6 +41,7 @@ static void br_send_bpdu(struct net_bridge_port *p,
 
 	skb->dev = p->dev;
 	skb->protocol = htons(ETH_P_802_2);
+	skb->priority = TC_PRIO_CONTROL;
 
 	skb_reserve(skb, LLC_RESERVE);
 	memcpy(__skb_put(skb, length), data, length);


