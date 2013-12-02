Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3LBUcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:32:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3LBTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3.10 173/173] xen-netback: fix refcnt unbalance for 3.10
Date: Mon,  2 Dec 2013 11:12:36 -0800
Message-Id: <20131202191202.816654348@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

With the introduction of "xen-netback: Don't destroy the netdev until
the vif is shut down" (upstream commit id 279f438e36), vif disconnect
and free are separated. However in the backported version reference
counting code was not correctly modified, and the reset of vif->irq
was lost. If frontend goes through vif life cycle more than once the
reference counting is skewed.

This patch adds back the missing vif->irq reset line. It also moves
several lines of the reference counting code to vif_free, so the moved
code corresponds to the counterpart in vif_alloc, thus the reference
counting is balanced.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/interface.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -365,17 +365,19 @@ void xenvif_disconnect(struct xenvif *vi
 	if (netif_carrier_ok(vif->dev))
 		xenvif_carrier_off(vif);
 
-	atomic_dec(&vif->refcnt);
-	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
-
-	if (vif->irq)
+	if (vif->irq) {
 		unbind_from_irqhandler(vif->irq, vif);
+		vif->irq = 0;
+	}
 
 	xen_netbk_unmap_frontend_rings(vif);
 }
 
 void xenvif_free(struct xenvif *vif)
 {
+	atomic_dec(&vif->refcnt);
+	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
+
 	unregister_netdev(vif->dev);
 
 	free_netdev(vif->dev);


