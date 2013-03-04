Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3CDDnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60955 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755754Ab3CDDnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:04 -0500
Message-Id: <20130304033719.801947791@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Christopher S. Aker" <caker@theshore.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 124/153] xen-netback: cancel the credit timer when taking the vif  down
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 3e55f8b306cf305832a4ac78aa82e1b40e818ece ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netback/interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 5925e0b..8eaf0e2 100644
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
@@ -362,8 +363,6 @@ void xenvif_disconnect(struct xenvif *vif)
 	atomic_dec(&vif->refcnt);
 	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
 
-	del_timer_sync(&vif->credit_timeout);
-
 	if (vif->irq)
 		unbind_from_irqhandler(vif->irq, vif);
 


