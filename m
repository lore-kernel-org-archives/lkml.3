Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3E2EmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3E2EmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:42:22 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] tuntap: forbid changing mq flag for persistent device
Date: Wed, 29 May 2013 12:32:11 +0800
Message-Id: <1369801931-6856-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently allow changing the mq flag (IFF_MULTI_QUEUE) for a persistent
device. This will result a mismatch between the number the queues in netdev and
tuntap. This is because we only allocate a 1q netdevice when IFF_MULTI_QUEUE was
not specified, so when we set the IFF_MULTI_QUEUE and try to attach more queues
later, netif_set_real_num_tx_queues() may fail which result a single queue
netdevice with multiple sockets attached.

Solve this by disallowing changing the mq flag for persistent device.

Bug was introduced by commit edfb6a148ce62e5e19354a1dcd9a34e00815c2a1
(tuntap: reduce memory using of queues).

Reported-by: Sriram Narasimhan <sriram.narasimhan@hp.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f042b03..89776c5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1585,6 +1585,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		else
 			return -EINVAL;
 
+		if (!!(ifr->ifr_flags & IFF_MULTI_QUEUE) !=
+		    !!(tun->flags & TUN_TAP_MQ))
+			return -EINVAL;
+
 		if (tun_not_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
-- 
1.7.1

