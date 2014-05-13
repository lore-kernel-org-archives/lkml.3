Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbaEMHzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:55:51 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41896 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaEMHzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:55:48 -0400
X-Google-Original-From: Jon Maxwell <jmaxwell@redhat.com>
From: Jon Maxwell <jmaxwell37@gmail.com>
To: stephen@networkplumber.org
Cc: davem@davemloft.net, makita.toshiaki@lab.ntt.co.jp, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com, jmaxwell37@gmail.com,
        jmaxwell@redhat.com
Subject: [PATCH net] bridge: notify user space of fdb port change
Date: Tue, 13 May 2014 17:55:08 +1000
Message-Id: <1399967708-7283-1-git-send-email-jmaxwell@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Maxwell <jmaxwell37@gmail.com>

There has been a number incidents recently where customers running KVM have 
reported that VM hosts on different Hypervisors are unreachable. Based on 
pcap traces we found that the bridge was broadcasting the ARP request out 
onto the network. However some NICs have an inbuilt switch which on occasions 
were broadcasting the VMs ARP request back through the physical NIC on the 
Hypervisor. This resulted in the bridge changing ports and incorrectly learning
that the VMs mac address was external. As a result the ARP reply was directed 
back onto the external network and VM never updated it's ARP cache. This patch 
will notify the bridge command to identify such port toggling.

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 net/bridge/br_fdb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9203d5a..37742e2 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -507,6 +507,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 					source->dev->name);
 		} else {
 			/* fastpath: update of existing entry */
+			if (source->port_no != fdb->dst->port_no)
+				fdb_notify(br, fdb, RTM_NEWNEIGH);
 			fdb->dst = source;
 			fdb->updated = jiffies;
 			if (unlikely(added_by_user))
-- 
1.8.3.1

