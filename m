Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab3KHCfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:35:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab3KHCSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Durrant <paul.durrant@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 23/91] xen-netback: Don't destroy the netdev until the vif is shut down
Date: Thu,  7 Nov 2013 18:14:38 -0800
Message-Id: <1383876946-2396-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Durrant <paul.durrant@citrix.com>

[ Upstream commit 279f438e36c0a70b23b86d2090aeec50155034a9 ]

Without this patch, if a frontend cycles through states Closing
and Closed (which Windows frontends need to do) then the netdev
will be destroyed and requires re-invocation of hotplug scripts
to restore state before the frontend can move to Connected. Thus
when udev is not in use the backend gets stuck in InitWait.

With this patch, the netdev is left alone whilst the backend is
still online and is only de-registered and freed just prior to
destroying the vif (which is also nicely symmetrical with the
netdev allocation and registration being done during probe) so
no re-invocation of hotplug scripts is required.

Signed-off-by: Paul Durrant <paul.durrant@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/xen-netback/common.h    |  1 +
 drivers/net/xen-netback/interface.c | 12 ++++++++++--
 drivers/net/xen-netback/xenbus.c    | 17 ++++++++++++-----
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 9d7f172..1a28508 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -115,6 +115,7 @@ struct xenvif *xenvif_alloc(struct device *parent,
 int xenvif_connect(struct xenvif *vif, unsigned long tx_ring_ref,
 		   unsigned long rx_ring_ref, unsigned int evtchn);
 void xenvif_disconnect(struct xenvif *vif);
+void xenvif_free(struct xenvif *vif);
 
 void xenvif_get(struct xenvif *vif);
 void xenvif_put(struct xenvif *vif);
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 221f426..2ef5ec9 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -302,6 +302,9 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	}
 
 	netdev_dbg(dev, "Successfully created xenvif\n");
+
+	__module_get(THIS_MODULE);
+
 	return vif;
 }
 
@@ -367,9 +370,14 @@ void xenvif_disconnect(struct xenvif *vif)
 	if (vif->irq)
 		unbind_from_irqhandler(vif->irq, vif);
 
-	unregister_netdev(vif->dev);
-
 	xen_netbk_unmap_frontend_rings(vif);
+}
+
+void xenvif_free(struct xenvif *vif)
+{
+	unregister_netdev(vif->dev);
 
 	free_netdev(vif->dev);
+
+	module_put(THIS_MODULE);
 }
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 410018c..abe24ff 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -42,7 +42,7 @@ static int netback_remove(struct xenbus_device *dev)
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
-		xenvif_disconnect(be->vif);
+		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
 	kfree(be);
@@ -203,9 +203,18 @@ static void disconnect_backend(struct xenbus_device *dev)
 {
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
+	if (be->vif)
+		xenvif_disconnect(be->vif);
+}
+
+static void destroy_backend(struct xenbus_device *dev)
+{
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+
 	if (be->vif) {
+		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
-		xenvif_disconnect(be->vif);
+		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
 }
@@ -237,14 +246,11 @@ static void frontend_changed(struct xenbus_device *dev,
 	case XenbusStateConnected:
 		if (dev->state == XenbusStateConnected)
 			break;
-		backend_create_xenvif(be);
 		if (be->vif)
 			connect(be);
 		break;
 
 	case XenbusStateClosing:
-		if (be->vif)
-			kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		disconnect_backend(dev);
 		xenbus_switch_state(dev, XenbusStateClosing);
 		break;
@@ -253,6 +259,7 @@ static void frontend_changed(struct xenbus_device *dev,
 		xenbus_switch_state(dev, XenbusStateClosed);
 		if (xenbus_dev_is_online(dev))
 			break;
+		destroy_backend(dev);
 		/* fall through if not online */
 	case XenbusStateUnknown:
 		device_unregister(&dev->dev);
-- 
1.8.1.2

