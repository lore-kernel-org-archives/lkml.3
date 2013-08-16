Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3HPWjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3HPWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 036/133] xhci: fix null pointer dereference on ring_doorbell_for_active_rings
Date: Fri, 16 Aug 2013 15:32:58 -0700
Message-Id: <1376692475-28413-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit d66eaf9f89502971fddcb0de550b01fa6f409d83 upstream.

in some cases where device is attched to xhci port and do not responding,
for example ath9k_htc with stalled firmware, kernel will
crash on ring_doorbell_for_active_rings.
This patch check if pointer exist before it is used.

This patch should be backported to kernels as old as 2.6.35, that
contain the commit e9df17eb1408cfafa3d1844bfc7f22c7237b31b8 "USB: xhci:
Correct assumptions about number of rings per endpoint"

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2573cf4..3020c71 100644
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
1.8.1.2

