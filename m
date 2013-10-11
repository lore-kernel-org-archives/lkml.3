Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3JKKnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3JKKnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 041/100] xhci: Fix oops happening after address device timeout
Date: Fri, 11 Oct 2013 11:41:11 +0100
Message-Id: <1381488130-30235-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 284d20552461466b04d6bfeafeb1c47a8891b591 upstream.

When a command times out, the command ring is first aborted,
and then stopped. If the command ring is empty when it is stopped
the stop event will point to next command which is not yet set.
xHCI tries to handle this next event often causing an oops.

Don't handle command completion events on stopped cmd ring if ring is
empty.

This patch should be backported to kernels as old as 3.7, that contain
the commit b92cc66c047ff7cf587b318fe377061a353c120f "xHCI: add aborting
command ring function"

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Reported-by: Giovanni <giovanni.nervi@yahoo.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 36d1290..2c4df52 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1394,6 +1394,12 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 			inc_deq(xhci, xhci->cmd_ring);
 			return;
 		}
+		/* There is no command to handle if we get a stop event when the
+		 * command ring is empty, event->cmd_trb points to the next
+		 * unset command
+		 */
+		if (xhci->cmd_ring->dequeue == xhci->cmd_ring->enqueue)
+			return;
 	}
 
 	switch (le32_to_cpu(xhci->cmd_ring->dequeue->generic.field[3])
-- 
1.8.3.2

