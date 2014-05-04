Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaEDV3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 17:29:52 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51382 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaEDV3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 17:29:50 -0400
X-Google-Original-From: Jon Maxwell <jmaxwell@redhat.com>
From: Jon Maxwell <jmaxwell37@gmail.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org, davem@davemloft.net,
        makita.toshiaki@lab.ntt.co.jp, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pirko@redhat.com, jmaxwell@redhat.com
Subject: [PATCH net] bridge: Add port flap detection
Date: Mon,  5 May 2014 07:29:34 +1000
Message-Id: <1399238974-6210-1-git-send-email-jmaxwell@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has been a number incidents recently where customers running KVM have reported that VM hosts on different Hypervisors are unreachable. Based on pcap traces we found that the bridge was broadcasting the ARP request out onto the network. However some NICs have an inbuilt switch which on occasions were broadcasting the VMs ARP request back through the physical NIC on the Hypervisor. This resulted in the bridge flapping ports and incorrectly learning that the VMs mac address was external. As a result the ARP reply was directed back onto the external network and VM never updated it's ARP cache. This patch will detect port flapping and log a message so that this condition can be detected earlier.

Signed-off-by: Jon Maxwell <jmaxwell@redhat.com>
---
 net/bridge/br_fdb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9203d5a..c08607b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -507,6 +507,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 					source->dev->name);
 		} else {
 			/* fastpath: update of existing entry */
+			if (source->port_no != fdb->dst->port_no &&
+				net_ratelimit())
+				br_warn(br, "Port flapping detected source entry dev = %s mac = %pM, port_no = %d\n existing entry dev = %s mac = %pM, port_no = %d\n",
+					source->dev->name,
+					addr, source->port_no,
+					fdb->dst->dev->name, addr,
+					fdb->dst->port_no);
 			fdb->dst = source;
 			fdb->updated = jiffies;
 			if (unlikely(added_by_user))
-- 
1.8.3.1

