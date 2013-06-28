Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3F1S56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3F1S5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 079/105] tuntap: forbid changing mq flag for persistent device
Date: Fri, 28 Jun 2013 11:51:41 -0700
Message-Id: <1372445527-24414-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 8e6d91ae0917bf934ed86411148f79d904728d51 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 522dc0a..2129cf90 100644
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
1.8.1.2

