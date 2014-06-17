Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966729AbaFQVvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966695AbaFQVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 196/212] xhci: delete endpoints from bandwidth list before freeing whole device
Date: Tue, 17 Jun 2014 14:44:50 -0700
Message-Id: <1403041506-13646-197-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 5dc2808c4729bf080487e61b80ee04e0fdb12a37 upstream.

Lists of endpoints are stored for bandwidth calculation for roothub ports.
Make sure we remove all endpoints from the list before the whole device,
containing its endpoints list_head stuctures, is freed.

This used to be done in the wrong order in xhci_mem_cleanup(),
and triggered an oops in resume from S4 (hibernate).

Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 49b8bd0..4483e6a 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1722,6 +1722,16 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		kfree(cur_cd);
 	}
 
+	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
+	for (i = 0; i < num_ports; i++) {
+		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
+		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
+			struct list_head *ep = &bwt->interval_bw[j].endpoints;
+			while (!list_empty(ep))
+				list_del_init(ep->next);
+		}
+	}
+
 	for (i = 1; i < MAX_HC_SLOTS; ++i)
 		xhci_free_virt_device(xhci, i);
 
@@ -1757,16 +1767,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	if (!xhci->rh_bw)
 		goto no_bw;
 
-	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
-	for (i = 0; i < num_ports; i++) {
-		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
-		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
-			struct list_head *ep = &bwt->interval_bw[j].endpoints;
-			while (!list_empty(ep))
-				list_del_init(ep->next);
-		}
-	}
-
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_tt_bw_info *tt, *n;
 		list_for_each_entry_safe(tt, n, &xhci->rh_bw[i].tts, tt_list) {
-- 
1.9.1

