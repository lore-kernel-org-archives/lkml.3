Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab3CZRv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:51:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3CZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=WUZ-TEjxVSAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JZQpFJL5AdsA:10 a=1XWaLZrsAAAA:8 a=k3V9e5D3AAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=qimYbbPMN0UA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173612.753687190@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yanko Kaneti <yaneti@declera.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 81/86] ppp: set qdisc_tx_busylock to avoid LOCKDEP splat
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0081-ppp-set-qdisc_tx_busylock-to-avoid-LOCKDEP-splat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0b652fb68c02c1acd0307d3acac4ae7123536031 ]

If a qdisc is installed on a ppp device, its possible to get
a lockdep splat under stress, because nested dev_queue_xmit() can
lock busylock a second time (on a different device, so its a false
positive)

Avoid this problem using a distinct lock_class_key for ppp
devices.

Reported-by: Yanko Kaneti <yaneti@declera.com>
Tested-by: Yanko Kaneti <yaneti@declera.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ppp/ppp_generic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 5c05572..2603b99 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1021,7 +1021,15 @@ ppp_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
+static struct lock_class_key ppp_tx_busylock;
+static int ppp_dev_init(struct net_device *dev)
+{
+	dev->qdisc_tx_busylock = &ppp_tx_busylock;
+	return 0;
+}
+
 static const struct net_device_ops ppp_netdev_ops = {
+	.ndo_init	 = ppp_dev_init,
 	.ndo_start_xmit = ppp_start_xmit,
 	.ndo_do_ioctl   = ppp_net_ioctl,
 };
-- 
1.7.10.4


