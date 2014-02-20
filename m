Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaBUADD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:03:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbaBTXyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:54:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.13 75/99] Revert "xhci: Set scatter-gather limit to avoid failed block writes."
Date: Thu, 20 Feb 2014 15:53:10 -0800
Message-Id: <20140220235120.379861609@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1386ff75797a187df324062fb4e929152392da88 upstream.

This reverts commit f2d9b991c549f159dc9ae81f77d8206c790cbfee.

We are ripping out commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e "usb:
xhci: Link TRB must not occur within a USB payload burst" because it's a
hack that caused regressions in the usb-storage and userspace USB
drivers that use usbfs and libusb.  This commit attempted to fix the
issues with that patch.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    4 ++--
 drivers/usb/host/xhci.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4716,8 +4716,8 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	struct device		*dev = hcd->self.controller;
 	int			retval;
 
-	/* Limit the block layer scatter-gather lists to half a segment. */
-	hcd->self.sg_tablesize = TRBS_PER_SEGMENT / 2;
+	/* Accept arbitrarily long scatter-gather lists */
+	hcd->self.sg_tablesize = ~0;
 
 	/* XHCI controllers don't stop the ep queue on short packets :| */
 	hcd->self.no_stop_on_short = 1;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1260,7 +1260,7 @@ union xhci_trb {
  * since the command ring is 64-byte aligned.
  * It must also be greater than 16.
  */
-#define TRBS_PER_SEGMENT	256
+#define TRBS_PER_SEGMENT	64
 /* Allow two commands + a link TRB, along with any reserved command TRBs */
 #define MAX_RSVD_CMD_TRBS	(TRBS_PER_SEGMENT - 3)
 #define TRB_SEGMENT_SIZE	(TRBS_PER_SEGMENT*16)


