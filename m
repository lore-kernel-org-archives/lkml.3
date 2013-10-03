Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3JCFR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:17:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3JCETB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:19:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Giovanni <giovanni.nervi@yahoo.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 30/57] xhci: Fix oops happening after address device timeout
Date: Wed,  2 Oct 2013 21:08:56 -0700
Message-Id: <20131003040638.664820135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1400,6 +1400,12 @@ static void handle_cmd_completion(struct
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


