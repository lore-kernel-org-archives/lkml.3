Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaABRIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:08:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaABRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:08:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 57/91] xen-netback: fix refcnt unbalance for 3.11 and earlier versions
Date: Thu,  2 Jan 2014 09:04:32 -0800
Message-Id: <1388682306-30859-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

With the introduction of "xen-netback: Don't destroy the netdev until
the vif is shut down" (upstream commit id 279f438e36), vif disconnect
and free are separated. However in the backported verion reference
counting code was not correctly modified, and the reset of vif->tx_irq
was lost. If frontend goes through vif life cycle more than once the
reference counting is skewed.

This patch adds back the missing tx_irq reset line. It also moves
several lines of the reference counting code to vif_free, so the moved
code corresponds to the counterpart in vif_alloc, thus the reference
counting is balanced.

3.12 and onward versions are not affected by this bug, because reference
counting code was removed due to the introduction of 1:1 model.

This pacth should be backported to all stable verions which are lower
than 3.12 and have 279f438e36.

Reported-and-tested-by: Tomasz Wroblewski <tomasz.wroblewski@citrix.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/xen-netback/interface.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index c63cbd0..b3cbaa9 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -363,17 +363,19 @@ void xenvif_disconnect(struct xenvif *vif)
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
-- 
1.8.3.2

