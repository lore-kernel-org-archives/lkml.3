Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab3B1Ozg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:55:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079Ab3B1OvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 126/139] bridge: set priority of STP packets
Date: Thu, 28 Feb 2013 14:44:36 +0000
Message-Id: <1362062689-2567-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

commit 547b4e718115eea74087e28d7fa70aec619200db upstream.

Spanning Tree Protocol packets should have always been marked as
control packets, this causes them to get queued in the high prirority
FIFO. As Radia Perlman mentioned in her LCA talk, STP dies if bridge
gets overloaded and can't communicate. This is a long-standing bug back
to the first versions of Linux bridge.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_stp_bpdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index fd30a60..a8aa2d5 100644
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
-- 
1.8.1.2

