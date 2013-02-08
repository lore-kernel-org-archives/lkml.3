Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692Ab3BHA71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:59:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab3BHA6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 15/16] xhci: Fix isoc TD encoding.
Date: Thu,  7 Feb 2013 16:58:14 -0800
Message-Id: <20130208004629.780565347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.112511141@linuxfoundation.org>
References: <20130208004627.112511141@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 760973d2a74b93eb1697981f7448f0e62767cfc4 upstream.

An isochronous TD is comprised of one isochronous TRB chained to zero or
more normal TRBs.  Only the isoc TRB has the TBC and TLBPC fields.  The
normal TRBs must set those fields to zeroes.  The code was setting the
TBC and TLBPC fields for both isoc and normal TRBs.  Fix this.

This should be backported to stable kernels as old as 3.0, that contain
the commit b61d378f2da41c748aba6ca19d77e1e1c02bcea5 " xhci 1.0: Set
transfer burst last packet count field."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3613,9 +3613,11 @@ static int xhci_queue_isoc_tx(struct xhc
 		td = urb_priv->td[i];
 		for (j = 0; j < trbs_per_td; j++) {
 			u32 remainder = 0;
-			field = TRB_TBC(burst_count) | TRB_TLBPC(residue);
+			field = 0;
 
 			if (first_trb) {
+				field = TRB_TBC(burst_count) |
+					TRB_TLBPC(residue);
 				/* Queue the isoc TRB */
 				field |= TRB_TYPE(TRB_ISOC);
 				/* Assume URB_ISO_ASAP is set */


