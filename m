Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab3B0AFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:05:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab3BZX7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Christopher S. Aker" <caker@theshore.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/53] xen-netback: cancel the credit timer when taking the vif down
Date: Tue, 26 Feb 2013 15:58:13 -0800
Message-Id: <20130226235624.434440273@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/interface.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -132,6 +132,7 @@ static void xenvif_up(struct xenvif *vif
 static void xenvif_down(struct xenvif *vif)
 {
 	disable_irq(vif->irq);
+	del_timer_sync(&vif->credit_timeout);
 	xen_netbk_deschedule_xenvif(vif);
 	xen_netbk_remove_xenvif(vif);
 }
@@ -362,8 +363,6 @@ void xenvif_disconnect(struct xenvif *vi
 	atomic_dec(&vif->refcnt);
 	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
 
-	del_timer_sync(&vif->credit_timeout);
-
 	if (vif->irq)
 		unbind_from_irqhandler(vif->irq, vif);
 


