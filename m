Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab3BSSuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807Ab3BSSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 04/81] USB: XHCI: fix memory leak of URB-private data
Date: Tue, 19 Feb 2013 15:48:27 -0300
Message-Id: <1361299784-8830-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 48c3375c5f69b1c2ef3d1051a0009cb9bce0ce24 upstream.

This patch (as1640) fixes a memory leak in xhci-hcd.  The urb_priv
data structure isn't always deallocated in the handle_tx_event()
routine for non-control transfers.  The patch adds a kfree() call so
that all paths end up freeing the memory properly.

This patch should be backported to kernels as old as 2.6.36, that
contain the commit 8e51adccd4c4b9ffcd509d7f2afce0a906139f75 "USB: xHCI:
Introduce urb_priv structure"

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-and-tested-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5530c76..6f3043f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2587,6 +2587,8 @@ cleanup:
 				(trb_comp_code != COMP_STALL &&
 					trb_comp_code != COMP_BABBLE))
 				xhci_urb_free_priv(xhci, urb_priv);
+			else
+				kfree(urb_priv);
 
 			usb_hcd_unlink_urb_from_ep(bus_to_hcd(urb->dev->bus), urb);
 			if ((urb->actual_length != urb->transfer_buffer_length &&
-- 
1.7.9.5

