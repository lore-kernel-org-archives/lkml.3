Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaJMC1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:27:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaJMC1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 24/37] macvtap: Fix race between device delete and open.
Date: Mon, 13 Oct 2014 04:24:21 +0200
Message-Id: <20141013022401.295243068@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit 40b8fe45d1f094e3babe7b2dc2b71557ab71401d ]

In macvtap device delete and open calls can race and
this causes a list curruption of the vlan queue_list.

The race intself is triggered by the idr accessors
that located the vlan device.  The device is stored
into and removed from the idr under both an rtnl and
a mutex.  However, when attempting to locate the device
in idr, only a mutex is taken.  As a result, once cpu
perfoming a delete may take an rtnl and wait for the mutex,
while another cput doing an open() will take the idr
mutex first to fetch the device pointer and later take
an rtnl to add a queue for the device which may have
just gotten deleted.

With this patch, we now hold the rtnl for the duration
of the macvtap_open() call thus making sure that
open will not race with delete.

CC: Michael S. Tsirkin <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -112,17 +112,15 @@ out:
 	return err;
 }
 
+/* Requires RTNL */
 static int macvtap_set_queue(struct net_device *dev, struct file *file,
 			     struct macvtap_queue *q)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
-	int err = -EBUSY;
 
-	rtnl_lock();
 	if (vlan->numqueues == MAX_MACVTAP_QUEUES)
-		goto out;
+		return -EBUSY;
 
-	err = 0;
 	rcu_assign_pointer(q->vlan, vlan);
 	rcu_assign_pointer(vlan->taps[vlan->numvtaps], q);
 	sock_hold(&q->sk);
@@ -136,9 +134,7 @@ static int macvtap_set_queue(struct net_
 	vlan->numvtaps++;
 	vlan->numqueues++;
 
-out:
-	rtnl_unlock();
-	return err;
+	return 0;
 }
 
 static int macvtap_disable_queue(struct macvtap_queue *q)
@@ -454,11 +450,12 @@ static void macvtap_sock_destruct(struct
 static int macvtap_open(struct inode *inode, struct file *file)
 {
 	struct net *net = current->nsproxy->net_ns;
-	struct net_device *dev = dev_get_by_macvtap_minor(iminor(inode));
+	struct net_device *dev;
 	struct macvtap_queue *q;
-	int err;
+	int err = -ENODEV;
 
-	err = -ENODEV;
+	rtnl_lock();
+	dev = dev_get_by_macvtap_minor(iminor(inode));
 	if (!dev)
 		goto out;
 
@@ -498,6 +495,7 @@ out:
 	if (dev)
 		dev_put(dev);
 
+	rtnl_unlock();
 	return err;
 }
 


