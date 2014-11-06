Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaKFXXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:23:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaKFWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 020/162] macvtap: Fix race between device delete and open.
Date: Thu,  6 Nov 2014 14:34:44 -0800
Message-Id: <1415313426-9622-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 73ffad8..eed7544 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -108,17 +108,15 @@ out:
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
@@ -132,9 +130,7 @@ static int macvtap_set_queue(struct net_device *dev, struct file *file,
 	vlan->numvtaps++;
 	vlan->numqueues++;
 
-out:
-	rtnl_unlock();
-	return err;
+	return 0;
 }
 
 static int macvtap_disable_queue(struct macvtap_queue *q)
@@ -450,11 +446,12 @@ static void macvtap_sock_destruct(struct sock *sk)
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
 
@@ -494,6 +491,7 @@ out:
 	if (dev)
 		dev_put(dev);
 
+	rtnl_unlock();
 	return err;
 }
 
-- 
1.9.1

