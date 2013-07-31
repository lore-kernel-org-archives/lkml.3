Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab3GaNZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:25:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759630Ab3GaNZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Oleksij Rempel" <linux@rempel-privat.de>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.165609686@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [79/84] xhci: fix null pointer dereference on ring_doorbell_for_active_rings
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -463,7 +463,7 @@ static void ring_doorbell_for_active_rin
 
 	/* A ring has pending URBs if its TD list is not empty */
 	if (!(ep->ep_state & EP_HAS_STREAMS)) {
-		if (!(list_empty(&ep->ring->td_list)))
+		if (ep->ring && !(list_empty(&ep->ring->td_list)))
 			xhci_ring_ep_doorbell(xhci, slot_id, ep_index, 0);
 		return;
 	}

