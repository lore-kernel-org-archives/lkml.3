Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3JKLEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:04:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab3JKKnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Wolter <wolly84@web.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/100] xhci: Fix race between ep halt and URB cancellation
Date: Fri, 11 Oct 2013 11:41:02 +0100
Message-Id: <1381488130-30235-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Wolter <wolly84@web.de>

commit 526867c3ca0caa2e3e846cb993b0f961c33c2abb upstream.

The halted state of a endpoint cannot be cleared over CLEAR_HALT from a
user process, because the stopped_td variable was overwritten in the
handle_stopped_endpoint() function. So the xhci_endpoint_reset() function will
refuse the reset and communication with device can not run over this endpoint.
https://bugzilla.kernel.org/show_bug.cgi?id=60699

Signed-off-by: Florian Wolter <wolly84@web.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 37cecce..36d1290 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -847,8 +847,12 @@ remove_finished_td:
 		/* Otherwise ring the doorbell(s) to restart queued transfers */
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
-	ep->stopped_td = NULL;
-	ep->stopped_trb = NULL;
+
+	/* Clear stopped_td and stopped_trb if endpoint is not halted */
+	if (!(ep->ep_state & EP_HALTED)) {
+		ep->stopped_td = NULL;
+		ep->stopped_trb = NULL;
+	}
 
 	/*
 	 * Drop the lock and complete the URBs in the cancelled TD list.
-- 
1.8.3.2

