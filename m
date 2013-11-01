Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3KAWha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:37:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3KAWEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Durrant <paul.durrant@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3.10 16/54] xen-netback: Dont destroy the netdev until the vif is shut down
Date: Fri,  1 Nov 2013 15:03:44 -0700
Message-Id: <20131101220213.155128792@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Durrant <paul.durrant@citrix.com>

[ upstream commit id: 279f438e36c0a70b23b86d2090aeec50155034a9 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/common.h    |    1 +
 drivers/net/xen-netback/interface.c |   12 ++++++++++--
 drivers/net/xen-netback/xenbus.c    |   17 ++++++++++++-----
 3 files changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -115,6 +115,7 @@ struct xenvif *xenvif_alloc(struct devic
 int xenvif_connect(struct xenvif *vif, unsigned long tx_ring_ref,
 		   unsigned long rx_ring_ref, unsigned int evtchn);
 void xenvif_disconnect(struct xenvif *vif);
+void xenvif_free(struct xenvif *vif);
 
 void xenvif_get(struct xenvif *vif);
 void xenvif_put(struct xenvif *vif);
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -304,6 +304,9 @@ struct xenvif *xenvif_alloc(struct devic
 	}
 
 	netdev_dbg(dev, "Successfully created xenvif\n");
+
+	__module_get(THIS_MODULE);
+
 	return vif;
 }
 
@@ -369,9 +372,14 @@ void xenvif_disconnect(struct xenvif *vi
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
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -42,7 +42,7 @@ static int netback_remove(struct xenbus_
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
-		xenvif_disconnect(be->vif);
+		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
 	kfree(be);
@@ -203,9 +203,18 @@ static void disconnect_backend(struct xe
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
@@ -237,14 +246,11 @@ static void frontend_changed(struct xenb
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
@@ -253,6 +259,7 @@ static void frontend_changed(struct xenb
 		xenbus_switch_state(dev, XenbusStateClosed);
 		if (xenbus_dev_is_online(dev))
 			break;
+		destroy_backend(dev);
 		/* fall through if not online */
 	case XenbusStateUnknown:
 		device_unregister(&dev->dev);


