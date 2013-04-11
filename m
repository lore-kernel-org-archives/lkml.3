Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161604Ab3DKJmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936115Ab3DKJmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:42:09 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next PATCH 2/2] tuntap: initialize vlan_features
Date: Thu, 11 Apr 2013 17:32:22 +0800
Message-Id: <1365672742-42258-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1365672742-42258-1-git-send-email-jasowang@redhat.com>
References: <1365672742-42258-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vlan_features was zero which prevents vlan GSO packets to be transmitted to
userspace. This is suboptimal so enable this by initialize vlan_features for
tuntap.

Netperf shows better performance of guest receiving since vlan TSO works for
tuntap:

before:
netperf -H 192.168.5.4
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.5.4 ()
port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.01    2786.67

after:
netperf -H 192.168.5.4
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.5.4 ()
port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.00    8085.49

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 29538e6..316c759 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1656,6 +1656,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
 			TUN_USER_FEATURES;
 		dev->features = dev->hw_features;
+		dev->vlan_features = dev->features;
 
 		INIT_LIST_HEAD(&tun->disabled);
 		err = tun_attach(tun, file);
-- 
1.7.1

