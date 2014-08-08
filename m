Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbaHHWXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:23:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbaHHUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 255/259] sunvnet: clean up objects created in vnet_new() on vnet_exit()
Date: Fri,  8 Aug 2014 13:41:18 -0700
Message-Id: <1407530482-4483-256-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sowmini Varadhan <sowmini.varadhan@oracle.com>

[ Upstream commit a4b70a07ed12a71131cab7adce2ce91c71b37060 ]

Nothing cleans up the objects created by
vnet_new(), they are completely leaked.

vnet_exit(), after doing the vio_unregister_driver() to clean
up ports, should call a helper function that iterates over vnet_list
and cleans up those objects. This includes unregister_netdevice()
as well as free_netdev().

Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reviewed-by: Karl Volz <karl.volz@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/sun/sunvnet.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 3df5684..398faff 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1083,6 +1083,24 @@ static struct vnet *vnet_find_or_create(const u64 *local_mac)
 	return vp;
 }
 
+static void vnet_cleanup(void)
+{
+	struct vnet *vp;
+	struct net_device *dev;
+
+	mutex_lock(&vnet_list_mutex);
+	while (!list_empty(&vnet_list)) {
+		vp = list_first_entry(&vnet_list, struct vnet, list);
+		list_del(&vp->list);
+		dev = vp->dev;
+		/* vio_unregister_driver() should have cleaned up port_list */
+		BUG_ON(!list_empty(&vp->port_list));
+		unregister_netdev(dev);
+		free_netdev(dev);
+	}
+	mutex_unlock(&vnet_list_mutex);
+}
+
 static const char *local_mac_prop = "local-mac-address";
 
 static struct vnet *vnet_find_parent(struct mdesc_handle *hp,
@@ -1240,7 +1258,6 @@ static int vnet_port_remove(struct vio_dev *vdev)
 
 		kfree(port);
 
-		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
@@ -1268,6 +1285,7 @@ static int __init vnet_init(void)
 static void __exit vnet_exit(void)
 {
 	vio_unregister_driver(&vnet_port_driver);
+	vnet_cleanup();
 }
 
 module_init(vnet_init);
-- 
1.9.1

