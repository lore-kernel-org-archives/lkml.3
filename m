Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3CZRwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:52:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3CZRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:18 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Uhgy0nWHC90A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bXKgILZO8h8A:10 a=tHz9FfFoAAAA:8 a=23663ulKAAAA:8 a=J1Y8HTJGAAAA:8 a=rZYXsCMa-Sbd3yudYT8A:9 a=6O0IECtVFhoA:10 a=HEHkIaOUj3cA:10 a=4N9Db7Z2_RYA:10 a=ravXLicOiB9ZSwPR:21 a=7uma6DYgYM9GYRGU:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.336110953@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Christopher S. Aker" <caker@theshore.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 40/86] xen-netback: cancel the credit timer when taking the vif down
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0040-xen-netback-cancel-the-credit-timer-when-taking-the-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 drivers/net/xen-netback/interface.c |    3 +--
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
1.7.10.4


