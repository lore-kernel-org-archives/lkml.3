Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3FYS4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:56:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3FYSeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sriram Narasimhan <sriram.narasimhan@hp.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/95] tuntap: forbid changing mq flag for persistent device
Date: Tue, 25 Jun 2013 11:32:47 -0700
Message-Id: <20130625182200.392392501@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1585,6 +1585,10 @@ static int tun_set_iff(struct net *net,
 		else
 			return -EINVAL;
 
+		if (!!(ifr->ifr_flags & IFF_MULTI_QUEUE) !=
+		    !!(tun->flags & TUN_TAP_MQ))
+			return -EINVAL;
+
 		if (tun_not_capable(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);


