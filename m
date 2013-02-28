Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab3B1Oy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:54:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3B1OvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 128/139] xen-netback: cancel the credit timer when taking the vif down
Date: Thu, 28 Feb 2013 14:44:38 +0000
Message-Id: <1362062689-2567-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 3e55f8b306cf305832a4ac78aa82e1b40e818ece upstream.

If the credit timer is left armed after calling
xen_netbk_remove_xenvif(), then it may fire and attempt to schedule
the vif which will then oops as vif->netbk == NULL.

This may happen both in the fatal error path and during normal
disconnection from the front end.

The sequencing during shutdown is critical to ensure that: a)
vif->netbk doesn't become unexpectedly NULL; and b) the net device/vif
is not freed.

1. Mark as unschedulable (netif_carrier_off()).
2. Synchronously cancel the timer.
3. Remove the vif from the schedule list.
4. Remove it from it netback thread group.
5. Wait for vif->refcnt to become 0.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Reported-by: Christopher S. Aker <caker@theshore.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index b8c5193..221f426 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -132,6 +132,7 @@ static void xenvif_up(struct xenvif *vif)
 static void xenvif_down(struct xenvif *vif)
 {
 	disable_irq(vif->irq);
+	del_timer_sync(&vif->credit_timeout);
 	xen_netbk_deschedule_xenvif(vif);
 	xen_netbk_remove_xenvif(vif);
 }
@@ -363,8 +364,6 @@ void xenvif_disconnect(struct xenvif *vif)
 	atomic_dec(&vif->refcnt);
 	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
 
-	del_timer_sync(&vif->credit_timeout);
-
 	if (vif->irq)
 		unbind_from_irqhandler(vif->irq, vif);
 
-- 
1.8.1.2

