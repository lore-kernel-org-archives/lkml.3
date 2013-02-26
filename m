Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab3B0AqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:46:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3BZX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yanko Kaneti <yaneti@declera.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 127/150] ppp: set qdisc_tx_busylock to avoid LOCKDEP splat
Date: Tue, 26 Feb 2013 15:56:24 -0800
Message-Id: <20130226235537.342430443@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 303c07db487be59ae9fda10600ea65ca11c21497 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/ppp_generic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1058,7 +1058,15 @@ ppp_get_stats64(struct net_device *dev,
 	return stats64;
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
 	.ndo_start_xmit  = ppp_start_xmit,
 	.ndo_do_ioctl    = ppp_net_ioctl,
 	.ndo_get_stats64 = ppp_get_stats64,


