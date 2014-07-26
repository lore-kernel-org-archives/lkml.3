Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaGZTvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:51:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaGZTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Karl Volz <karl.volz@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 60/87] sunvnet: clean up objects created in vnet_new() on vnet_exit()
Date: Sat, 26 Jul 2014 12:02:34 -0700
Message-Id: <20140726190216.570388862@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/sunvnet.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1083,6 +1083,24 @@ static struct vnet *vnet_find_or_create(
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
@@ -1240,7 +1258,6 @@ static int vnet_port_remove(struct vio_d
 
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


