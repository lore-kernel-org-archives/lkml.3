Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3KRSso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:48:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3KRSm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 10/24] xen-netback: transition to CLOSED when removing a VIF
Date: Mon, 18 Nov 2013 10:42:20 -0800
Message-Id: <20131118184222.766362590@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit dc62ccaccfb139d9b04bbc5a2688a4402adbfab3 ]

If a guest is destroyed without transitioning its frontend to CLOSED,
the domain becomes a zombie as netback was not grant unmapping the
shared rings.

When removing a VIF, transition the backend to CLOSED so the VIF is
disconnected if necessary (which will unmap the shared rings etc).

This fixes a regression introduced by
279f438e36c0a70b23b86d2090aeec50155034a9 (xen-netback: Don't destroy
the netdev until the vif is shut down).

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Paul Durrant <Paul.Durrant@citrix.com>
Acked-by: Wei Liu <wei.liu2@citrix.com>
Reviewed-by:  Paul Durrant <paul.durrant@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/xenbus.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -39,11 +39,15 @@ static int connect_rings(struct backend_
 static void connect(struct backend_info *);
 static void backend_create_xenvif(struct backend_info *be);
 static void unregister_hotplug_status_watch(struct backend_info *be);
+static void set_backend_state(struct backend_info *be,
+			      enum xenbus_state state);
 
 static int netback_remove(struct xenbus_device *dev)
 {
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
+	set_backend_state(be, XenbusStateClosed);
+
 	unregister_hotplug_status_watch(be);
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);


