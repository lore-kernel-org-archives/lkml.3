Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab3BSSt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:49:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54128 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3BSSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:49:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 01/81] xhci: Fix isoc TD encoding.
Date: Tue, 19 Feb 2013 15:48:24 -0300
Message-Id: <1361299784-8830-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index c3c174d..3bf13f8 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3662,9 +3662,11 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
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
-- 
1.7.9.5

