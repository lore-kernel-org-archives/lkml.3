Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3IKF4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3IKF4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:56:45 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=yQZrFWTO62QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wj3NYT9SzNYA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=NakflunorzeUDPUuxkgA:9 a=ZlKnNJ2b6BcA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042906.447730986@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [085/251] xhci: fix null pointer dereference on ring_doorbell_for_active_rings
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0085-xhci-fix-null-pointer-dereference-on-ring_doorbell_f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

[ Upstream commit d66eaf9f89502971fddcb0de550b01fa6f409d83 ]

in some cases where device is attched to xhci port and do not responding,
for example ath9k_htc with stalled firmware, kernel will
crash on ring_doorbell_for_active_rings.
This patch check if pointer exist before it is used.

This patch should be backported to kernels as old as 2.6.35, that
contain the commit e9df17eb1408cfafa3d1844bfc7f22c7237b31b8 "USB: xhci:
Correct assumptions about number of rings per endpoint"

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8848616..21a01ac 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -434,7 +434,7 @@ static void ring_doorbell_for_active_rings(struct xhci_hcd *xhci,
 
 	/* A ring has pending URBs if its TD list is not empty */
 	if (!(ep->ep_state & EP_HAS_STREAMS)) {
-		if (!(list_empty(&ep->ring->td_list)))
+		if (ep->ring && !(list_empty(&ep->ring->td_list)))
 			xhci_ring_ep_doorbell(xhci, slot_id, ep_index, 0);
 		return;
 	}
-- 
1.7.10.4


