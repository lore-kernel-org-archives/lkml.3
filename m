Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422706Ab3BHA6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:58:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab3BHA6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 25/26] USB: XHCI: fix memory leak of URB-private data
Date: Thu,  7 Feb 2013 16:57:53 -0800
Message-Id: <20130208004631.282601437@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

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


