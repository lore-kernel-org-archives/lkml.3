Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaHDREk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56518 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Kleikamp" <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sowmini Varadhan" <sowmini.varadhan@oracle.com>,
        "Karl Volz" <karl.volz@oracle.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.992797078@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 60/94] sunvnet: clean up objects created in vnet_new()
 on  vnet_exit()
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sun/sunvnet.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index bd08919..5092148 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1089,6 +1089,24 @@ static struct vnet * __devinit vnet_find_or_create(const u64 *local_mac)
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
 
 static struct vnet * __devinit vnet_find_parent(struct mdesc_handle *hp,
@@ -1249,7 +1267,6 @@ static int vnet_port_remove(struct vio_dev *vdev)
 
 		kfree(port);
 
-		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
@@ -1280,6 +1297,7 @@ static int __init vnet_init(void)
 static void __exit vnet_exit(void)
 {
 	vio_unregister_driver(&vnet_port_driver);
+	vnet_cleanup();
 }
 
 module_init(vnet_init);

